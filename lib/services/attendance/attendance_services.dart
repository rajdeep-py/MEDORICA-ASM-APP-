import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/attendance.dart';
import '../api_url.dart';

class AttendanceServices {
  AttendanceServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 30),
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
  final DateFormat _dateOnlyFormatter = DateFormat('yyyy-MM-dd');
  
  // Fetch all attendance records for a given ASM ID
  Future<List<Attendance>> fetchAttendanceByAsmId(String asmId) async {
    try {
      final response = await _dio.get(ApiUrl.asmAttendanceGetByAsmId(asmId));
      final data = response.data;
      if (data is! List) {
        throw Exception(
          'Invalid attendance list response received from server.',
        );
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(Attendance.fromJson)
          .map(_normalizeSelfiePaths)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load attendance right now.');
    }
  }
  
  // Fetch today's attendance record for a given ASM ID
  Future<Attendance?> fetchTodaysAttendance({required String asmId}) async {
    final records = await fetchAttendanceByAsmId(asmId);
    final today = DateUtils.dateOnly(DateTime.now());

    for (final record in records) {
      if (DateUtils.dateOnly(record.date) == today) {
        return record;
      }
    }

    return null;
  }

  // Post new attendance record
  Future<Attendance> postAttendance({
    required String asmId,
    required DateTime attendanceDate,
    String attendanceStatus = 'present',
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInSelfiePath,
    String? checkOutSelfiePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'asm_id': asmId,
        'attendance_date': _dateOnlyFormatter.format(attendanceDate),
        'attendance_status': attendanceStatus,
        if (checkInTime != null) 'check_in_time': checkInTime.toIso8601String(),
        if (checkOutTime != null)
          'check_out_time': checkOutTime.toIso8601String(),
      });

      final checkInSelfie = await _buildSelfieFile(checkInSelfiePath);
      if (checkInSelfie != null) {
        formData.files.add(MapEntry('check_in_selfie', checkInSelfie));
      }

      final checkOutSelfie = await _buildSelfieFile(checkOutSelfiePath);
      if (checkOutSelfie != null) {
        formData.files.add(MapEntry('check_out_selfie', checkOutSelfie));
      }

      final response = await _dio.post(
        ApiUrl.asmAttendancePost,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid attendance response received from server.');
      }

      return _normalizeSelfiePaths(Attendance.fromJson(data));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to submit attendance right now.');
    }
  }

  // Update existing attendance record
  Future<Attendance> updateAttendance({
    required String asmId,
    required int attendanceId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInSelfiePath,
    String? checkOutSelfiePath,
    String? attendanceStatus,
  }) async {
    try {
      final formData = FormData.fromMap({
        'attendance_status': ?attendanceStatus,
        if (checkInTime != null) 'check_in_time': checkInTime.toIso8601String(),
        if (checkOutTime != null)
          'check_out_time': checkOutTime.toIso8601String(),
      });

      final checkInSelfie = await _buildSelfieFile(checkInSelfiePath);
      if (checkInSelfie != null) {
        formData.files.add(MapEntry('check_in_selfie', checkInSelfie));
      }

      final checkOutSelfie = await _buildSelfieFile(checkOutSelfiePath);
      if (checkOutSelfie != null) {
        formData.files.add(MapEntry('check_out_selfie', checkOutSelfie));
      }

      final response = await _dio.put(
        '/attendance/asm/update-by/$asmId/$attendanceId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid attendance update response from server.');
      }

      return _normalizeSelfiePaths(Attendance.fromJson(data));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to update attendance right now.');
    }
  }

  Future<MultipartFile?> _buildSelfieFile(String? filePath) async {
    if (filePath == null || filePath.trim().isEmpty) {
      return null;
    }

    final trimmedPath = filePath.trim();
    final file = File(trimmedPath);
    if (!await file.exists()) {
      return null;
    }

    final fileName = trimmedPath.split(Platform.pathSeparator).last;
    return MultipartFile.fromFile(trimmedPath, filename: fileName);
  }

  Attendance _normalizeSelfiePaths(Attendance attendance) {
    return attendance.copyWith(
      checkInPhotoPath: _normalizePath(attendance.checkInPhotoPath),
      checkOutPhotoPath: _normalizePath(attendance.checkOutPhotoPath),
    );
  }

  String? _normalizePath(String? path) {
    if (path == null || path.trim().isEmpty) {
      return null;
    }

    final trimmed = path.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (trimmed.startsWith('/')) {
      return ApiUrl.getFullUrl(trimmed);
    }

    return ApiUrl.getFullUrl('/$trimmed');
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

    return 'Something went wrong while talking to the server.';
  }
}
