class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'This E-mail is already associated with an account.',
    'OPERATION_NOT_ALLOWED': 'Denied Operation',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Too many Attempts. Please try again later!',
    'EMAIL_NOT_FOUND': 'Email not found',
    'INVALID_PASSWORD': 'Wrong Password',
    'USER_DISABLED': 'This account has been disabled.',
  };

  final String errorMessage;

  AuthException(this.errorMessage);

  @override
  String toString() {
    return errors[errorMessage] ?? 'An error occurred in the process of authentication.';
    
  }
}
