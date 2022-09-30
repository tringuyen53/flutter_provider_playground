import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_signin_playground/src/features/authencation/data/auth_repository.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/account/account_screen.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/sign_in_screen.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/sign_in_state.dart';
import 'package:provider_signin_playground/src/features/home/home_screen.dart';
import 'package:provider_signin_playground/src/routing/go_router_refresh_stream.dart';
import 'package:provider_signin_playground/src/routing/not_found_screen.dart';

enum AppRoute {
  signIn,
  home,
  account,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
        if (state.location == '/account') {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/account',
        name: AppRoute.account.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const AccountScreen(),
        ),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const EmailPasswordSignInScreen(
            formType: EmailPasswordSignInFormType.signIn,
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
