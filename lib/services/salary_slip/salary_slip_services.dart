import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/salary_slip.dart';
import '../api_url.dart';

class SalarySlipServices {
  SalarySlipServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 25),
              receiveTimeout: const Duration(seconds: 25),
              sendTimeout: const Duration(seconds: 25),
            ),
          ) {
    if (!_dio.interceptors.any((it) => it is PrettyDioLogger)) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          compact: true,
          enabled: kDebugMode,
        ),
      );
    }
  }

  final Dio _dio;

  Future<SalarySlip> downloadSalarySlipByAsmId(String asmId) async {
    final normalizedAsmId = asmId.trim();
    if (normalizedAsmId.isEmpty) {
      throw Exception('ASM ID is required to download salary slip.');
    }

    try {
      final saveDirectory = await _getSaveDirectory();
      final safeAsm = normalizedAsmId.replaceAll(
        RegExp(r'[^a-zA-Z0-9_-]'),
        '_',
      );
      final fileName = '${safeAsm}_salary_slip.pdf';
      final filePath = '${saveDirectory.path}/$fileName';

      await _dio.download(
        ApiUrl.salarySlipDownloadByAsmId(normalizedAsmId),
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Salary slip could not be saved on device.');
      }

      return SalarySlip.fromJson({
        'asm_id': normalizedAsmId,
        'salary_slip_url': ApiUrl.getFullUrl(
          ApiUrl.salarySlipDownloadByAsmId(normalizedAsmId),
        ),
        'local_file_path': filePath,
      });
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (error) {
      final message = error.toString();
      if (message.startsWith('Exception: ')) {
        throw Exception(message.substring('Exception: '.length));
      }
      throw Exception('Unable to download salary slip right now.');
    }
  }

  Future<Directory> _getSaveDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        return dir;
      }
    }

    return getApplicationDocumentsDirectory();
  }

  String _extractErrorMessage(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail.trim();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Request timed out. Please check your connection and try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Please check your connection.';
    }

    return 'Unable to download salary slip right now.';
  }
}
