/// Global application settings coming from the environment files.
class ApplicationSettings {
  /// The environment that we are using.
  static Environments get environment {
    const String env = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    switch (env) {
      case 'development':
        return Environments.development;
      case 'staging':
        return Environments.staging;
      case 'production':
        return Environments.production;
      default:
        throw UnsupportedError(
          'The ENVIRONMENT \'$env\' is not supported. Valid values are \'development\', \'staging\' or \'production\'.',
        );
    }
  }

  /// Base url for the backend.
  static String get baseUrl {
    const baseUrl =  String.fromEnvironment(
      'BASE_URL',
    );
    return baseUrl;
  }
}

enum Environments {
  development,
  staging,
  production,
}
