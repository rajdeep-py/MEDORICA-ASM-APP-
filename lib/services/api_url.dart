class ApiUrl {
  // Base URL - Use 10.0.2.2 for Android Emulator (maps to host machine's localhost)
  // Use 127.0.0.1 or localhost for iOS Simulator
  static const String baseUrl = 'http://10.0.2.2:8000';

  // ASM Auth
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

  // Distributor Endpoints
  static const String distributorGetAll = '/distributor/get-all';
  static String distributorGetById(String distId) =>
      '/distributor/get-by/$distId';

  // ASM Attendance Endpoints
  static const String asmAttendancePost = '/attendance/asm/post';
  static String asmAttendanceGetByAsmId(String asmId) =>
      '/attendance/asm/get-by/$asmId';

  // Team Endpoints
  static String teamGetByAsmId(String asmId) => '/team/get-by-asm/$asmId';

  // ASM Doctor Network Endpoints
  static const String doctorNetworkAsmPost = '/doctor-network/asm/post';
  static String doctorNetworkGetByAsmId(String asmId) =>
      '/doctor-network/asm/get-by-asm/$asmId';
  static String doctorNetworkGetByAsmAndDoctorId(
    String asmId,
    String doctorId,
  ) => '/doctor-network/asm/get-by/$asmId/$doctorId';
  static String doctorNetworkUpdateByAsmAndDoctorId(
    String asmId,
    String doctorId,
  ) => '/doctor-network/asm/update-by/$asmId/$doctorId';
  static String doctorNetworkDeleteByDoctorId(String doctorId) =>
      '/doctor-network/asm/delete-by/$doctorId';
}
