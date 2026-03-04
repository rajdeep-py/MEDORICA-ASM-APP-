class ApiUrl {
  // Base URL - Use 10.0.2.2 for Android Emulator (maps to host machine's localhost)
  // Use 127.0.0.1 or localhost for iOS Simulator
  static const String baseUrl = 'http://10.0.2.2:8000';

  // About Us Endpoints
  static const String aboutUsGetAll = '/about-us/get-all';

  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
