import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_signin_playground/src/exceptions/app_exception.dart';
import 'package:provider_signin_playground/src/features/authencation/domain/app_user.dart';
import 'package:provider_signin_playground/src/features/authencation/domain/fake_app_user.dart';
import 'package:provider_signin_playground/src/utils/delay.dart';
import 'package:provider_signin_playground/src/utils/in_memory_store.dart';

class AuthRepository {
  AuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  final List<FakeAppUser> _users = [];

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    // check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw const AppException.emailAlreadyInUse();
      }
    }
    // minimum password length requirement
    if (password.length < 8) {
      throw const AppException.userNotFound();
    }
    // create new user
    _createNewUser(email, password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    // check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw const AppException.emailAlreadyInUse();
      }
    }
    // minimum password length requirement
    if (password.length < 8) {
      throw const AppException.userNotFound();
    }
    // create new user
    _createNewUser(email, password);
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email, String password) {
    // create new user
    final user = FakeAppUser(
      uid: email.split('').reversed.join(),
      email: email,
      password: password,
    );
    // register it
    _users.add(user);
    // update the auth state
    _authState.value = user;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
