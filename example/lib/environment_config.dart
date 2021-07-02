
///
/// @description get dart define
/// @author waitwalker
/// @time 2021/6/30 16:58
///
class EnvironmentConfig {
  /// External defined compilation parameters
  /// Client: APP_SOCKET=Client
  /// Server: APP_SOCKET=Server
  static const APP_SOCKET = String.fromEnvironment("APP_SOCKET", defaultValue: "Client");
}