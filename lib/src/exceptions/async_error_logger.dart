import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_signin_playground/src/exceptions/app_exception.dart';
import 'package:provider_signin_playground/src/exceptions/error_logger.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/sign_in_state.dart';

class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final errorLogger = container.read(errorLoggerProvider);
    final error = _findError(newValue);
    if (error != null) {
      if (error.error is AppException) {
        errorLogger.logAppException(error.error as AppException);
      } else {
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is EmailPasswordSignInState && value.value is AsyncError) {
      return value.value as AsyncError;
    } else if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
