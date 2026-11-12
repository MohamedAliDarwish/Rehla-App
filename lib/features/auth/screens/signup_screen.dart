import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/core/widgets/app_button.dart';
import 'package:rehla/core/widgets/app_text_feild.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primary,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(AppStrings.register),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.createAccountTitle,
                  style: AppTextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  AppStrings.createAccountSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                // const ProfileAvatarPicker(),
                // SizedBox(height: 32),
                AppTextField(
                  hintText: AppStrings.nameHint,
                  labelText: AppStrings.nameLabel,
                  type: AppTextFieldType.text,
                ),

                SizedBox(height: 16),
                AppTextField(
                  hintText: AppStrings.emailHint,
                  labelText: AppStrings.emailLabel,
                  type: AppTextFieldType.email,
                ),

                SizedBox(height: 16),
                AppTextField(
                  hintText: AppStrings.phoneHint,
                  labelText: AppStrings.phoneLabel,
                  type: AppTextFieldType.phone,
                ),

                SizedBox(height: 16),
                AppTextField(
                  hintText: AppStrings.passwordHint,
                  labelText: AppStrings.passwordLabel,
                  type: AppTextFieldType.password,
                ),
                SizedBox(height: 16),

                AppTextField(
                  hintText: AppStrings.confirmPasswordHint,
                  labelText: AppStrings.confirmPasswordLabel,
                  type: AppTextFieldType.password,
                ),
                SizedBox(height: 32),

                AppMainButton(
                  txt: AppStrings.register,
                  onPressed: () {
                    context.go(RouteNames.home);
                  },
                ),

                SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.alreadyHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.login,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go(RouteNames.login),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
