class ApiConstants {
  // Production Render API URL from the verified MERN project
  static const String defaultBaseUrl = 'https://mern-todo-pro.onrender.com/api';
  
  // Local Development URLs (for emulator / local testing)
  static const String localAndroidEmulatorUrl = 'http://10.0.2.2:5000/api';
  static const String localIosSimulatorUrl = 'http://localhost:5000/api';
  
  // Connection Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
