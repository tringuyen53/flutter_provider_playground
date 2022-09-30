import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_signin_playground/src/common_widgets/primary_button.dart';
import 'package:provider_signin_playground/src/constants/app_sizes.dart';
import 'package:provider_signin_playground/src/routing/app_router.dart';

class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            gapH32,
            PrimaryButton(
              text: 'Go Home',
              onPressed: () => context.goNamed(AppRoute.account.name),
            )
          ],
        ),
      ),
    );
  }
}
