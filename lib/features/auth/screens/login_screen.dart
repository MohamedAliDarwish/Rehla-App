import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/core/widgets/app_button.dart';
import 'package:rehla/core/widgets/app_text_feild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // close keyboard
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: .center,
              children: [
                SizedBox(height: 30),
                Text(
                  AppStrings.welcomeBack,
                  style: AppTextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),

                Text(
                  AppStrings.loginTitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 150),

                AppTextField(
                  controller: _emailController,
                  hintText: AppStrings.emailHint,
                  labelText: AppStrings.emailLabel,
                  type: AppTextFieldType.email,
                ),

                SizedBox(height: 16),
                AppTextField(
                  controller: _passController,
                  hintText: AppStrings.passwordHint,
                  labelText: AppStrings.passwordLabel,
                  type: AppTextFieldType.password,
                ),

                SizedBox(height: 50), // 24
                // Forget Password
                // Align(
                //   alignment: AlignmentDirectional.centerEnd,
                //   child: TextButton(
                //     onPressed: () {},
                //     child: Text(
                //       AppStrings.forgotPassword,
                //       style: AppTextStyles.bodyMedium.copyWith(
                //         color: AppColors.primary,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                AppMainButton(
                  txt: AppStrings.login,
                  onPressed: () {
                    //Login loig
                  },
                ),

                SizedBox(height: 40),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(text: "؟   "),
                        TextSpan(
                          text: AppStrings.register,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go(RouteNames.register),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * 
RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.register,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go(RouteNames.register),
                        ),
                      ],
                    ),
                  ), 
 
 */
