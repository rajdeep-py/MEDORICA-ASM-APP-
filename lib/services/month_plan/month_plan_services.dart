import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/month_plan.dart';
import '../api_url.dart';

class MonthPlanServices {
  MonthPlanServices({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrl.baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 20),
              headers: const {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
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

  Future<MonthPlanEntry> createMonthlyPlan(
    MonthlyPlanCreatePayload payload,
  ) async {
    try {
      final response = await _dio.post(
        ApiUrl.monthlyPlanPost,
        data: payload.toJson(),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid monthly plan response received from server.');
      }

      final entries = MonthPlanEntry.listFromMonthlyPlanJson(data);
      for (final entry in entries) {
        if (entry.memberId == payload.mrId) {
          return entry;
        }
      }

      if (entries.isNotEmpty) {
        return entries.first;
      }

      throw Exception(
        'Created plan response did not include member plan data.',
      );
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to create monthly plan right now.');
    }
  }

  Future<List<MonthPlanEntry>> fetchAllMonthlyPlans() async {
    try {
      final response = await _dio.get(ApiUrl.monthlyPlanGetAll);
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid monthly plan list response from server.');
      }

      final flattened = <MonthPlanEntry>[];
      for (final item in data.whereType<Map<String, dynamic>>()) {
        flattened.addAll(MonthPlanEntry.listFromMonthlyPlanJson(item));
      }

      flattened.sort((a, b) => b.date.compareTo(a.date));
      return flattened;
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load monthly plans right now.');
    }
  }

  Future<List<MonthPlanEntry>> fetchMonthlyPlansByMrId(String mrId) async {
    try {
      final response = await _dio.get(ApiUrl.monthlyPlanGetByMrId(mrId));
      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid monthly plan list response from server.');
      }

      final entries = data
          .whereType<Map<String, dynamic>>()
          .map(MonthPlanEntry.fromMrDayPlanJson)
          .toList();
      entries.sort((a, b) => b.date.compareTo(a.date));
      return entries;
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load monthly plans right now.');
    }
  }

  Future<MonthPlanEntry?> fetchMonthlyPlanByMrIdAndDate({
    required String mrId,
    required DateTime date,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrl.monthlyPlanGetByMrIdAndDate(mrId, date),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid monthly plan response from server.');
      }

      return MonthPlanEntry.fromMrDayPlanJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to load monthly plan right now.');
    }
  }

  Future<void> deleteMonthlyPlan(int planId) async {
    try {
      final response = await _dio.delete(ApiUrl.monthlyPlanDeleteById(planId));
      final data = response.data;
      if (data is! Map<String, dynamic> && data is! String) {
        throw Exception('Invalid delete response from server.');
      }
      // Optionally check detail in response
      return;
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to delete monthly plan right now.');
    }
  }

  Future<MonthPlanEntry> updateMonthlyPlan(int planId, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put(
        ApiUrl.monthlyPlanUpdateById(planId),
        data: payload,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid update response from server.');
      }
      return MonthPlanEntry.fromMrDayPlanJson(data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    } catch (_) {
      throw Exception('Unable to update monthly plan right now.');
    }
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
