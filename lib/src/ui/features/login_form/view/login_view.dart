import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_planner/src/ui/features/login_form/cubit/login_cubit.dart';

import '../../../../ui/widgets/snackbar.dart';
import '../../../widgets/typography/btn.dart';
import '../../../widgets/typography/form_field.dart';
import '../../../widgets/typography/text_field.dart';
import '../cubit/login_state.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.read<LoginCubit>().navigate(context);
        }
        if (state.errorMessage != null) {
          AppSnackBar.show(
            message: state.errorMessage!,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'GameNight',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 40),
                          Form(
                            // key: _formKey,
                            child: Column(
                              children: [
                                CustomFormField(
                                  fieldName: 'username',
                                  controller: _usernameController,
                                  hintText: 'Username..',
                                  errorText:
                                      context.read<LoginCubit>().getFieldError(
                                            'username',
                                            state.isUsernameValid,
                                            state.username,
                                          ),
                                  onChanged: (value) => context
                                      .read<LoginCubit>()
                                      .updateUsername(value),
                                  onTouched: () => context
                                      .read<LoginCubit>()
                                      .fieldTouched('username'),
                                ),
                                SizedBox(height: 20),
                                CustomFormField(
                                  fieldName: 'password',
                                  controller: _passwordController,
                                  hintText: 'Password..',
                                  obscureText: true,
                                  errorText:
                                      context.read<LoginCubit>().getFieldError(
                                            'password',
                                            state.isPasswordValid,
                                            state.password,
                                          ),
                                  onChanged: (value) => context
                                      .read<LoginCubit>()
                                      .updatePassword(value),
                                  onTouched: () => context
                                      .read<LoginCubit>()
                                      .fieldTouched('password'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          GradientPrimaryBtn(
                            text: Text(
                              'Log In',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                            onPressed: state.isSubmitting || !state.isValid
                                ? null
                                : () => context.read<LoginCubit>().signIn(),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: StyledLink(
                              text: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Don’t have an account? ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    TextSpan(
                                      text: 'Sign up',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
