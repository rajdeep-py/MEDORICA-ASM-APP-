import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/about_us.dart';
import '../api_url.dart';

class AboutUsService {
  late final Dio _dio;

  AboutUsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Pretty Dio Logger
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  /// Fetch all About Us records
  Future<AboutUs?> fetchAboutUs() async {
    try {
      final response = await _dio.get(ApiUrl.aboutUsGetAll);

      if (response.statusCode == 200 && response.data != null) {
        // API returns a list, get the first item
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return AboutUs.fromJson(data[0]);
        }
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to fetch About Us data: $e');
    }
  }

  /// Handle Dio errors
  String _handleError(DioException error) {
    String errorMessage = '';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Server error: ${error.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;
      default:
        errorMessage = 'Something went wrong. Please try again.';
    }
    
    return errorMessage;
  }
}
