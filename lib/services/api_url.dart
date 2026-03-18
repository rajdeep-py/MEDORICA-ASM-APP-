class ApiUrl {
    
  // Default base URL for physical devices on the same LAN as the backend.
  static const String _defaultBaseUrl = 'http://10.0.2.2:8000';

  // Override at runtime if needed:
  // flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
  // flutter run --dart-define=API_BASE_URL=http://<your-laptop-lan-ip>:8000
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    final normalized = fromEnv.trim();
    return normalized.isEmpty ? _defaultBaseUrl : normalized;
  }

  // ASM Auth
  static const String asmLogin = '/onboarding/asm/login';

  // ASM App Update Endpoints
  static const String asmAppUpdateDownloadLatest = '/asm-app-updates/download/latest';

  // Profile Endpoints
  static String asmGetById(String asmId) => '/onboarding/asm/get-by/$asmId';

  static String asmUpdateById(String asmId) =>
      '/onboarding/asm/update-by/$asmId';

  // Visual Ads Endpoints
  static const String visualAdsGetAll = '/visual-ads/get-all';
  static String visualAdsGetById(String adId) => '/visual-ads/get-by/$adId';

  // Notification Endpoints
  static const String notificationsGetAllAsm = '/notifications/get-all/asm';

  // Salary Slip Endpoints
  static String salarySlipDownloadByAsmId(String asmId) =>
      '/salary-slip/asm/download-by-asm/$asmId';

  // Monthly Plan Endpoints
  static const String monthlyPlanPost = '/monthly-plan/post';
  static const String monthlyPlanGetAll = '/monthly-plan/get-all';
  static String monthlyPlanGetById(int planId) =>
      '/monthly-plan/get-by/$planId';
  static String monthlyPlanGetByMrId(String mrId) =>
      '/monthly-plan/get-by-mr/$mrId';
  static String monthlyPlanGetByMrIdAndDate(String mrId, DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '/monthly-plan/get-by-mr/$mrId/date/$y-$m-$d';
  }

  static String monthlyPlanUpdateById(int planId) => '/monthly-plan/update/$planId';
  static String monthlyPlanDeleteById(int planId) => '/monthly-plan/delete/$planId';

  // ASM Monthly Target Endpoints (GET)
  static const String monthlyTargetAsmGetAll = '/monthly-target/asm/get-all';
  static String monthlyTargetAsmGetByAsmId(String asmId) =>
      '/monthly-target/asm/get-by-asm/$asmId';
  static String monthlyTargetAsmGetByAsmYearMonth(
    String asmId,
    int year,
    int month,
  ) => '/monthly-target/asm/get-by/$asmId/$year/$month';

  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    final trimmed = endpoint.trim();
    if (trimmed.isEmpty) {
      return baseUrl;
    }

    // If already absolute, normalize common malformed case:
    // http://host:portuploads/... -> http://host:port/uploads/...
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      if (trimmed.startsWith(baseUrl)) {
        final suffix = trimmed.substring(baseUrl.length);
        if (suffix.isNotEmpty && !suffix.startsWith('/')) {
          return '$baseUrl/$suffix';
        }
      }
      return trimmed;
    }

    final normalized = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$baseUrl$normalized';
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

  // ASM Chemist Shop Network Endpoints
  static const String chemistShopPost = '/chemist-shop/asm/post';
  static String chemistShopGetByAsmId(String asmId) =>
      '/chemist-shop/asm/get-by-asm/$asmId';
  static String chemistShopGetByAsmAndShopId(String asmId, String shopId) =>
      '/chemist-shop/asm/get-by/$asmId/$shopId';
  static String chemistShopUpdateByAsmAndShopId(String asmId, String shopId) =>
      '/chemist-shop/asm/update-by/$asmId/$shopId';
  static String chemistShopDeleteByAsmAndShopId(String asmId, String shopId) =>
      '/chemist-shop/asm/delete-by/$asmId/$shopId';

  // ASM Appointment Endpoints
  static const String appointmentAsmPost = '/appointment/asm/post';
  static String appointmentGetByAsmId(String asmId) =>
      '/appointment/asm/get-by-asm/$asmId';
  static String appointmentGetById(String appointmentId) =>
      '/appointment/asm/get-by/$appointmentId';
  static String appointmentUpdateById(String appointmentId) =>
      '/appointment/asm/update-by/$appointmentId';
  static String appointmentDeleteById(String appointmentId) =>
      '/appointment/asm/delete-by/$appointmentId';

  // ASM Order Endpoints
  static String orderAsmPostByAsmId(String asmId) =>
      '/order/asm/post-by/$asmId';
  static const String orderAsmGetAll = '/order/asm/get-all';
  static String orderAsmGetByAsmId(String asmId) =>
      '/order/asm/get-by-asm/$asmId';
  static String orderAsmGetByAsmAndOrderId(String asmId, String orderId) =>
      '/order/asm/get-by/$asmId/$orderId';
  static String orderAsmUpdateByOrderId(String orderId) =>
      '/order/asm/update-by/$orderId';
  static String orderAsmDeleteByOrderId(String orderId) =>
      '/order/asm/delete-by/$orderId';

  // Gift Inventory Endpoints
  static const String giftInventoryGetAll = '/gift-inventory/get-all';

  // ASM Gift Application Endpoints
  static const String asmGiftApplicationPost = '/gift-application/asm/post';
  static String asmGiftApplicationGetByAsmId(String asmId) => '/gift-application/asm/get-by-asm/$asmId';
  static String asmGiftApplicationUpdateByAsmAndRequestId(String asmId, int requestId) => '/gift-application/asm/update-by/$asmId/$requestId';
  static String asmGiftApplicationDeleteByRequestId(int requestId) => '/gift-application/asm/delete-by/$requestId';
}
