import 'package:flutter/foundation.dart';
import '../models/about_us.dart';
import '../services/about_us/about_us_services.dart';

class AboutUsNotifier extends ChangeNotifier {
  final AboutUsService _aboutUsService = AboutUsService();
  
  AboutUs? _aboutUs;
  bool _isLoading = false;
  String? _error;

  AboutUs? get aboutUs => _aboutUs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AboutUsNotifier() {
    _loadAboutUs();
  }

  Future<void> _loadAboutUs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _aboutUs = await _aboutUsService.fetchAboutUs();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _aboutUs = null;
      debugPrint('Error loading About Us: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadAboutUs();
  }
}