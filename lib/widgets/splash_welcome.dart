import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'main.dart';
import 'widgets.dart';
import 'login_screen.dart';

// ============================================================
// 🔸 SignupScreen
// ============================================================
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
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          success ? AppColors.primaryDark : const Color(0xFFB00020),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('إنشاء حساب جديد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            )),
                        const SizedBox(height: 6),
                        const Text('انضم إلينا لإدارة توزيع المواد الغذائية',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 14)),
                        const SizedBox(height: 32),
                        _field(
                          controller: _nameCtrl,
                          label: 'اسم الوكيل',
                          hint: 'أدخل اسمك الكامل',
                          icon: Icons.person_outline_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'الاسم مطلوب';
                            }
                            if (v.trim().length < 3) return 'الاسم قصير جداً';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _field(
                          controller: _emailCtrl,
                          label: 'البريد الإلكتروني',
                          hint: 'example@email.com',
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'البريد مطلوب';
                            }
                            final regex =
                                RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                            if (!regex.hasMatch(v.trim())) {
                              return 'البريد غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _field(
                          controller: _passCtrl,
                          label: 'كلمة السر',
                          hint: '8 أحرف على الأقل',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePass,
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
                        _field(
                          controller: _confirmCtrl,
                          label: 'تأكيد كلمة السر',
                          hint: 'أعد إدخال كلمة السر',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscureConfirm,
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
                        GestureDetector(
                          onTap: () => setState(() => _agree = !_agree),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: _agree
                                      ? const LinearGradient(colors: [
                                          AppColors.primary,
                                          AppColors.primaryDark
                                        ])
                                      : null,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: _agree
                                        ? AppColors.primary
                                        : AppColors.glassBorder,
                                    width: 1.5,
                                  ),
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
                                    children: const [
                                      TextSpan(text: 'أوافق على '),
                                      TextSpan(
                                        text: 'سياسة الخصوصية',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                          decoration:
                                              TextDecoration.underline,
                                          decorationColor: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(text: ' والشروط والأحكام'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'إنشاء الحساب',
                          isLoading: _loading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 24),
                        const AppDivider(label: 'أو'),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('لديك حساب بالفعل؟ ',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 14)),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              ),
                              child: const Text('تسجيل الدخول',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          ],
                        ),
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

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              )),
        ),
        GlassContainer(
          borderRadius: 16,
          blur: 20,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.textMuted, fontSize: 14),
              prefixIcon: Icon(icon, color: AppColors.primaryLight, size: 20),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
              errorStyle:
                  const TextStyle(color: Color(0xFFFF8A80), fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}