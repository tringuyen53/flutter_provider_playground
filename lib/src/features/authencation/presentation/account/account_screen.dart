import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_signin_playground/src/common_widgets/action_text_button.dart';
import 'package:provider_signin_playground/src/common_widgets/alert_dialogs.dart';
import 'package:provider_signin_playground/src/common_widgets/responsive_center.dart';
import 'package:provider_signin_playground/src/constants/app_sizes.dart';
import 'package:provider_signin_playground/src/features/authencation/data/auth_repository.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/account/account_screen_controller.dart';
import 'package:provider_signin_playground/src/utils/async_value_ui.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading
            ? const CircularProgressIndicator()
            : const Text('Account'),
        actions: [
          ActionTextButton(
            text: 'Logout',
            onPressed: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Are you sure?',
                      cancelActionText: 'Cancel',
                      defaultActionText: 'Logout',
                    );
                    if (logout == true) {
                      ref
                          .read(accountScreenControllerProvider.notifier)
                          .signOut();
                    }
                  },
          ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: UserDataTable(),
      ),
    );
  }
}

class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleSmall!;
    final user = ref.watch(authStateChangesProvider).value;
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Field',
            style: style,
          ),
        ),
      ],
      rows: [
        _makeDataRow(
          'uid',
          user?.uid ?? '',
          style,
        ),
        _makeDataRow(
          'email',
          user?.email ?? '',
          style,
        ),
      ],
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
