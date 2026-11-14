import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/core/widgets/app_button.dart';
import 'package:rehla/core/widgets/app_text_feild.dart';
import 'package:rehla/features/auth/cubit/auth_cubit.dart';
import 'package:rehla/features/auth/cubit/auth_states.dart';
import 'package:rehla/features/auth/models/signup_user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('كلمات المرور غير متطابقة'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final userModel = SignupUserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      context.read<AuthCubit>().signup(userModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
            child: BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                if (state is AuthSignupSucessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إنشاء الحساب بنجاح!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.go(RouteNames.home);
                } else if (state is AuthErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoadingState;

                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppStrings.createAccountTitle,
                          style: AppTextStyles.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.createAccountSubtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        AppTextField(
                          controller: _nameController,
                          hintText: AppStrings.nameHint,
                          labelText: AppStrings.nameLabel,
                          type: AppTextFieldType.text,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال الاسم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _emailController,
                          hintText: AppStrings.emailHint,
                          labelText: AppStrings.emailLabel,
                          type: AppTextFieldType.email,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'البريد الإلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _phoneController,
                          hintText: AppStrings.phoneHint,
                          labelText: AppStrings.phoneLabel,
                          type: AppTextFieldType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال رقم الهاتف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          hintText: AppStrings.passwordHint,
                          labelText: AppStrings.passwordLabel,
                          type: AppTextFieldType.password,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hintText: AppStrings.confirmPasswordHint,
                          labelText: AppStrings.confirmPasswordLabel,
                          type: AppTextFieldType.password,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى تأكيد كلمة المرور';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : AppMainButton(
                                txt: AppStrings.register,
                                onPressed: () => _onRegisterPressed(context),
                              ),
                        const SizedBox(height: 32),
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
                                    ..onTap =
                                        () => context.go(RouteNames.login),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
