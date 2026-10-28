import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passFocus = FocusNode();

  bool _obscurePass = true;
  bool _loading = false;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passCtrl.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    _showSnack('تم تسجيل الدخول ✓', success: true);
    // TODO: انتقل للشاشة الرئيسية بعد ربط الـ Backend
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            success ? AppColors.primaryDark : const Color(0xFFB00020),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'أهلاً بعودتك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'سجّل دخولك للمتابعة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 40),

                        _buildField(
                          controller: _identifierCtrl,
                          label: 'البريد الإلكتروني أو اسم المستخدم',
                          hint: 'example@email.com',
                          icon: Icons.person_outline_rounded,
                          action: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passFocus),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'هذا الحقل مطلوب';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          controller: _passCtrl,
                          label: 'كلمة السر',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePass,
                          focusNode: _passFocus,
                          action: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          onToggleObscure: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'كلمة السر مطلوبة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () =>
                                _showSnack('استعادة كلمة السر قريباً'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'هل نسيت كلمة السر؟',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        PrimaryButton(
                          label: 'تسجيل الدخول',
                          isLoading: _loading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 24),

                        _buildDivider(),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: SocialButton(
                                icon: FontAwesomeIcons.google,
                                label: 'Google',
                                iconColor: AppColors.googleRed,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SocialButton(
                                icon: FontAwesomeIcons.facebookF,
                                label: 'Facebook',
                                iconColor: AppColors.facebookBlue,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        _buildBottomLink(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    FocusNode? focusNode,
    TextInputAction? action,
    void Function(String)? onSubmitted,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassContainer(
          borderRadius: 16,
          blur: 20,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscure,
            textInputAction: action,
            onFieldSubmitted: onSubmitted,
            validator: validator,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 15),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppColors.textMuted, fontSize: 14),
              prefixIcon: Icon(icon,
                  color: AppColors.primaryLight, size: 20),
              suffixIcon: onToggleObscure != null
                  ? IconButton(
                      onPressed: onToggleObscure,
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4, vertical: 18),
              errorStyle: const TextStyle(
                color: Color(0xFFFF8A80),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child: Container(
          height: 1,
          color: AppColors.glassBorder,
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'أو',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
            child: Container(
          height: 1,
          color: AppColors.glassBorder,
        )),
      ],
    );
  }

  Widget _buildBottomLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ليس لديك حساب؟ ',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignupScreen()),
            );
          },
          child: const Text(
            'إنشاء حساب',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}