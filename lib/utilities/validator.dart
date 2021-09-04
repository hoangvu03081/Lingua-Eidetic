abstract class StringValidator {
  String isValid(String value);
}

/// If the [String] returned is empty => no error
/// Else there are some errors:
///   1. Empty mail
///   2. Not valid mail OR mail don't pass the [regExp]
class EmailValidator implements StringValidator {
  @override
  String isValid(String mail) {
    if (mail.isEmpty) return 'Email must not be empty';

    RegExp regExp = new RegExp(
      r'^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$',
      caseSensitive: false,
    );
    if (regExp.hasMatch(mail)) return '';

    return 'Email is not valid';
  }
}

/// If the [String] returned is empty => no error
/// Else there are some errors:
///   1. Empty password
///   2. Has special characters
///   3. Not valid password: less than 6 characters
class PasswordValidator extends StringValidator {
  @override
  String isValid(String password) {
    if (password.isEmpty) return 'Password must not be empty';

    RegExp regExp = new RegExp(r'\W+', caseSensitive: false);
    if (regExp.hasMatch(password))
      return 'Password must has no special characters.';

    regExp = new RegExp(r'^\w{6,}$', caseSensitive: false);
    if (regExp.hasMatch(password)) return '';

    return 'Password must be at least 6 characters';
  }
}

class ValidatorError {
  String _emailError = '';
  String _passwordError = '';

  String get emailError => _emailError;

  String get passwordError => _passwordError;

  void setEmailError(String emailError) {
    _emailError = emailError;
  }

  void setPasswordError(String passwordError) {
    _passwordError = passwordError;
  }

  @override
  String toString() {
    return 'errors: { \n\temail: $_emailError, \n\tpassword: $_passwordError\n}';
  }
}

class EmailPasswordValidator {
  EmailPasswordValidator(String mail, String password) {
    validateEmail(mail);
    validatePassword(password);
  }

  final EmailValidator mail = EmailValidator();
  final PasswordValidator password = PasswordValidator();
  final ValidatorError errors = ValidatorError();

  void validateEmail(String mail) {
    errors.setEmailError(this.mail.isValid(mail));
  }

  void validatePassword(String password) {
    errors.setPasswordError(this.password.isValid(password));
  }
}
