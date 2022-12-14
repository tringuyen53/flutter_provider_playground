import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_signin_playground/src/features/authencation/domain/app_user.dart';
import 'package:provider_signin_playground/src/routing/app_router.dart';

enum PopupMenuOption {
  signIn,
  account,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({super.key, this.user});
  final AppUser? user;

  // * Keys for testing using find.byKey()
  static const signInKey = Key('menuSignIn');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  key: accountKey,
                  value: PopupMenuOption.account,
                  child: Text('Account'),
                ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  key: signInKey,
                  value: PopupMenuOption.signIn,
                  child: Text('Sign In'),
                ),
              ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.signIn:
            context.pushNamed(AppRoute.signIn.name);
            break;
          case PopupMenuOption.account:
            context.pushNamed(AppRoute.account.name);
            break;
        }
      },
    );
  }
}