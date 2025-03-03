class EnvironmentVariables {
  static const String apiKey = String.fromEnvironment('AZURE_CHAT_BOT_SECRET_KEY', defaultValue: '');
}
