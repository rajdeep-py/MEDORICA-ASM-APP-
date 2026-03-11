import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/doctor.dart';
import '../api_url.dart';

class DoctorNetworkServices {
  DoctorNetworkServices({Dio? dio})
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

  Future<List<Doctor>> fetchDoctorsByAsmId(String asmId) async {
    try {
      final response = await _dio.get(ApiUrl.doctorNetworkGetByAsmId(asmId));
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid doctor list response received from server.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(Doctor.fromJson)
          .toList();
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load doctors right now.');
    }
  }

  Future<Doctor> fetchDoctorByAsmAndDoctorId({
    required String asmId,
    required String doctorId,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrl.doctorNetworkGetByAsmAndDoctorId(asmId, doctorId),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid doctor response received from server.');
      }

      return Doctor.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load doctor details right now.');
    }
  }

  Future<Doctor> createDoctor({
    required String asmId,
    required Doctor doctor,
    String? doctorPhotoPath,
  }) async {
    try {
      final formData = await _buildDoctorFormData(
        asmId: asmId,
        doctor: doctor,
        includeRequired: true,
        doctorPhotoPath: doctorPhotoPath,
      );

      final response = await _dio.post(
        ApiUrl.doctorNetworkAsmPost,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid doctor create response from server.');
      }

      return Doctor.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to create doctor right now.');
    }
  }

  Future<Doctor> updateDoctorByAsmAndDoctorId({
    required String asmId,
    required String doctorId,
    required Doctor doctor,
    String? doctorPhotoPath,
  }) async {
    try {
      final formData = await _buildDoctorFormData(
        asmId: asmId,
        doctor: doctor,
        includeRequired: false,
        doctorPhotoPath: doctorPhotoPath,
      );

      final response = await _dio.put(
        ApiUrl.doctorNetworkUpdateByAsmAndDoctorId(asmId, doctorId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid doctor update response from server.');
      }

      return Doctor.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to update doctor right now.');
    }
  }

  Future<void> deleteDoctorByDoctorId(String doctorId) async {
    try {
      await _dio.delete(ApiUrl.doctorNetworkDeleteByDoctorId(doctorId));
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to delete doctor right now.');
    }
  }

  Future<FormData> _buildDoctorFormData({
    required String asmId,
    required Doctor doctor,
    required bool includeRequired,
    String? doctorPhotoPath,
  }) async {
    final map = <String, dynamic>{
      if (includeRequired) 'asm_id': asmId,
      if (includeRequired || doctor.name.trim().isNotEmpty)
        'doctor_name': doctor.name.trim(),
      if (includeRequired || doctor.phoneNumber.trim().isNotEmpty)
        'doctor_phone_no': doctor.phoneNumber.trim(),
      if (doctor.specialization.trim().isNotEmpty)
        'doctor_specialization': doctor.specialization.trim(),
      if (doctor.qualification.trim().isNotEmpty)
        'doctor_qualification': doctor.qualification.trim(),
      if (doctor.experience.trim().isNotEmpty)
        'doctor_experience': doctor.experience.trim(),
      if (doctor.description.trim().isNotEmpty)
        'doctor_description': doctor.description.trim(),
      if (doctor.email.trim().isNotEmpty) 'doctor_email': doctor.email.trim(),
      if (doctor.address.trim().isNotEmpty)
        'doctor_address': doctor.address.trim(),
      if (doctor.birthday != null)
        'doctor_birthday': doctor.birthday!.toIso8601String().split('T').first,
      if (doctor.chambers.isNotEmpty)
        'doctor_chambers': jsonEncode(
          doctor.chambers.map((chamber) => chamber.toJson()).toList(),
        ),
    };

    final formData = FormData.fromMap(map);
    final file = await _buildPhotoFile(doctorPhotoPath);
    if (file != null) {
      formData.files.add(MapEntry('doctor_photo', file));
    }

    return formData;
  }

  Future<MultipartFile?> _buildPhotoFile(String? path) async {
    if (path == null || path.trim().isEmpty) {
      return null;
    }

    final file = File(path.trim());
    if (!await file.exists()) {
      return null;
    }

    final name = path.trim().split(Platform.pathSeparator).last;
    return MultipartFile.fromFile(path.trim(), filename: name);
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
