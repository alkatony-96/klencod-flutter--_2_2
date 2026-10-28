import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _agree = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      _showSnack('يجب الموافقة على سياسة الخصوصية أولاً');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    _showSnack('تم إنشاء الحساب بنجاح ✓', success: true);
    // TODO: انتقل إلى الشاشة الرئيسية بعد ربط الـ Backend
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
                          'إنشاء حساب جديد',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'انضم إلينا لإدارة توزيع المواد الغذائية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),

                        _buildField(
                          controller: _nameCtrl,
                          label: 'اسم الوكيل',
                          hint: 'أدخل اسمك الكامل',
                          icon: Icons.person_outline_rounded,
                          action: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'الاسم مطلوب';
                            }
                            if (v.trim().length < 3) {
                              return 'الاسم قصير جداً';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          controller: _emailCtrl,
                          label: 'البريد الإلكتروني',
                          hint: 'example@email.com',
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          action: TextInputAction.next,
                          focusNode: _emailFocus,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_passFocus),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'البريد الإلكتروني مطلوب';
                            }
                            final regex = RegExp(
                                r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                            if (!regex.hasMatch(v.trim())) {
                              return 'البريد الإلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          controller: _passCtrl,
                          label: 'كلمة السر',
                          hint: '8 أحرف على الأقل',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePass,
                          focusNode: _passFocus,
                          action: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_confirmFocus),
                          onToggleObscure: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'كلمة السر مطلوبة';
                            }
                            if (v.length < 8) {
                              return 'كلمة السر قصيرة (8 أحرف على الأقل)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          controller: _confirmCtrl,
                          label: 'تأكيد كلمة السر',
                          hint: 'أعد إدخال كلمة السر',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscureConfirm,
                          focusNode: _confirmFocus,
                          action: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          onToggleObscure: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'تأكيد كلمة السر مطلوب';
                            }
                            if (v != _passCtrl.text) {
                              return 'كلمتا السر غير متطابقتين';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildPrivacyCheck(),
                        const SizedBox(height: 24),

                        PrimaryButton(
                          label: 'إنشاء الحساب',
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
    TextInputType? keyboardType,
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
            keyboardType: keyboardType,
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

  Widget _buildPrivacyCheck() {
    return GestureDetector(
      onTap: () => setState(() => _agree = !_agree),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: _agree
                  ? const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark])
                  : null,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: _agree
                    ? AppColors.primary
                    : AppColors.glassBorder,
                width: 1.5,
              ),
              boxShadow: _agree
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: _agree
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  fontFamily: 'Cairo',
                ),
                children: [
                  const TextSpan(text: 'أوافق على '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () => _showSnack(
                          'سيتم عرض سياسة الخصوصية هنا'),
                      child: const Text(
                        'سياسة الخصوصية',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' والشروط والأحكام'),
                ],
              ),
            ),
          ),
        ],
      ),
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
          'لديك حساب بالفعل؟ ',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text(
            'تسجيل الدخول',
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