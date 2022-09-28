import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/string_validators.dart';

enum EmailPasswordSignInFormType { signIn, register }

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

///State class for email & password form.
class EmailPasswordSignInState with EmailAndPasswordValidators {
  EmailPasswordSignInState({
    this.formType = EmailPasswordSignInFormType.signIn,
    this.value = const AsyncValue.data(null),
  });

  final EmailPasswordSignInFormType formType;
  final AsyncValue<void> value;

  bool get isLoading => value.isLoading;

  EmailPasswordSignInState copyWith({
    EmailPasswordSignInFormType? formType,
    AsyncValue<void>? value,
  }) {
    return EmailPasswordSignInState(
      formType: formType ?? this.formType,
      value: value ?? this.value,
    );
  }

  @override
  String toString() =>
      'EmailPasswordSignInState(formType: $formType, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailPasswordSignInState &&
        other.formType == formType &&
        other.value == value;
  }

  @override
  int get hashCode => formType.hashCode ^ value.hashCode;
}

extension EmailPasswordSignInStateX on EmailPasswordSignInState {
  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Password (8+ characters';
    } else {
      return 'Password';
    }
  }

  // Getters
  String get primaryButtonText {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Create an account';
    } else {
      return 'Sign in';
    }
  }

  String get secondaryButtonText {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Have an account? Sign in';
    } else {
      return 'Need an account? Register';
    }
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    if (formType == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInFormType.signIn;
    } else {
      return EmailPasswordSignInFormType.register;
    }
  }

  String get errorAlertTitle {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Registration failed';
    } else {
      return 'Sign in failed';
    }
  }

  String get title {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Register';
    } else {
      return 'Sign in';
    }
  }

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password) {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText =
        email.isEmpty ? 'Email can\'t be empty' : 'Invalid email';
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText =
        password.isEmpty ? 'Password can\'t be empty' : 'Password is too short';
    return showErrorText ? errorText : null;
  }
}
