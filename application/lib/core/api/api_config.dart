class ApiConfig {
  static const String baseUrl = 'YOUR_BASE_URL';
  static const Duration timeout = Duration(seconds: 30);
  
  // API Endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String verifyEmail = '/auth/verify-email';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> getAuthenticatedHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}