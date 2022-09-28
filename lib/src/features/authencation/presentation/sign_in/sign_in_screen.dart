import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_signin_playground/src/common_widgets/custom_get_button.dart';
import 'package:provider_signin_playground/src/common_widgets/primary_button.dart';
import 'package:provider_signin_playground/src/common_widgets/responsive_scrollable_card.dart';
import 'package:provider_signin_playground/src/constants/app_sizes.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/sign_in_controller.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/sign_in_state.dart';
import 'package:provider_signin_playground/src/features/authencation/presentation/sign_in/string_validators.dart';
import 'package:provider_signin_playground/src/utils/async_value_ui.dart';

class EmailPasswordSignInScreen extends StatelessWidget {
  const EmailPasswordSignInScreen({super.key, required this.formType});
  final EmailPasswordSignInFormType formType;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: EmailPasswordSignInContents(formType: formType),
    );
  }
}

/// A widget for email & password authentication, supporting the following:
/// - sign in
/// - register (create an account)
class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents({
    super.key,
    this.onSignedIn,
    required this.formType,
  });
  final VoidCallback? onSignedIn;

  final EmailPasswordSignInFormType formType;
  @override
  ConsumerState<EmailPasswordSignInContents> createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  var _submitted = false;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(EmailPasswordSignInState state) async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(
          emailPasswordSignInControllerProvider(widget.formType).notifier);
      final success = await controller.submit(email, password);
      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete(EmailPasswordSignInState state) {
    if (!state.canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(EmailPasswordSignInState state) {
    if (!state.canSubmitPassword(password)) {
      _node.previousFocus();
      return;
    }
    _submit(state);
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    ref
        .read(emailPasswordSignInControllerProvider(widget.formType).notifier)
        .updateFormType(formType);
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInControllerProvider(widget.formType)
          .select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state =
        ref.watch(emailPasswordSignInControllerProvider(widget.formType));
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              gapH8,
              //Email field
              TextFormField(
                key: EmailPasswordSignInScreen.emailKey,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'test@test.com',
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    !_submitted ? null : state.emailErrorText(email ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(state),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(
                      editingValidator: EmailEditingRegexValidator()),
                ],
              ),
              gapH8,
              //Password field
              TextFormField(
                key: EmailPasswordSignInScreen.passwordKey,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: state.passwordLabelText,
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => !_submitted
                    ? null
                    : state.passwordErrorText(password ?? ''),
              ),
              gapH8,
              PrimaryButton(
                text: state.primaryButtonText,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : () => _submit(state),
              ),
              gapH8,
              CustomTextButton(
                text: state.secondaryButtonText,
                onPressed: state.isLoading
                    ? null
                    : () => _updateFormType(state.secondaryActionFormType),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
