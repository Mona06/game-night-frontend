import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';

import '../../../../ui/widgets/snackbar.dart';
import '../../../widgets/typography/btn.dart';
import '../../../widgets/typography/form_field.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          AppSnackBar.show(
            message: 'Registration completed successfully',
            type: SnackBarType.success,
          );
          Navigator.pushReplacementNamed(context, '/login');
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
                          CustomFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            errorText:
                                context.read<RegisterCubit>().getFieldError(
                                      'email',
                                      state.isEmailValid,
                                      state.email,
                                    ),
                            onChanged: (value) => context
                                .read<RegisterCubit>()
                                .updateEmail(value),
                            fieldName: 'email',
                            onTouched: () => context
                                .read<RegisterCubit>()
                                .fieldTouched('email'),
                          ),
                          SizedBox(height: 16),
                          CustomFormField(
                            controller: _usernameController,
                            hintText: 'Username',
                            errorText:
                                context.read<RegisterCubit>().getFieldError(
                                      'username',
                                      state.isUsernameValid,
                                      state.username,
                                    ),
                            onChanged: (value) => context
                                .read<RegisterCubit>()
                                .updateUsername(value),
                            fieldName: 'username',
                            onTouched: () => context
                                .read<RegisterCubit>()
                                .fieldTouched('username'),
                          ),
                          SizedBox(height: 16),
                          CustomFormField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: true,
                            errorText:
                                context.read<RegisterCubit>().getFieldError(
                                      'password',
                                      state.isPasswordValid,
                                      state.password,
                                    ),
                            onChanged: (value) => context
                                .read<RegisterCubit>()
                                .updatePassword(value),
                            fieldName: 'password',
                            onTouched: () => context
                                .read<RegisterCubit>()
                                .fieldTouched('password'),
                          ),
                          SizedBox(height: 16),
                          CustomFormField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: true,
                            errorText:
                                context.read<RegisterCubit>().getFieldError(
                                      'confirmPassword',
                                      state.isConfirmPasswordValid,
                                      state.confirmPassword,
                                    ),
                            onChanged: (value) => context
                                .read<RegisterCubit>()
                                .updateConfirmPassword(value),
                            fieldName: 'confirmPassword',
                            onTouched: () => context
                                .read<RegisterCubit>()
                                .fieldTouched('confirmPassword'),
                          ),
                          SizedBox(height: 40),
                          GradientPrimaryBtn(
                            text: Text(
                              'Sign Up',
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
                                : () =>
                                    context.read<RegisterCubit>().submitForm(),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: StyledLink(
                              text: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Already have an account? ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    TextSpan(
                                      text: 'Log in',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
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
