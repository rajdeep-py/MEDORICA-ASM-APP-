class ApiUrl {
  // Base URL - Use 10.0.2.2 for Android Emulator (maps to host machine's localhost)
  // Use 127.0.0.1 or localhost for iOS Simulator
  static const String baseUrl = 'http://10.0.2.2:8000';

  // ASM Auth and Profile Endpoints
  static const String asmLogin = '/onboarding/asm/login';

  // Profile Endpoints
  static String asmGetById(String asmId) => '/onboarding/asm/get-by/$asmId';

  static String asmUpdateById(String asmId) =>
      '/onboarding/asm/update-by/$asmId';

  // Visual Ads Endpoints
  static const String visualAdsGetAll = '/visual-ads/get-all';
  static String visualAdsGetById(String adId) => '/visual-ads/get-by/$adId';

  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  // About Us Endpoints
  static const String aboutUsGetAll = '/about-us/get-all';
}
