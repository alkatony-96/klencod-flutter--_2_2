import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/glass_container.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // ⚠️ استبدل الرقم برقم المطور الفعلي
  static const String _developerPhone = '9647700000000';

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/$_developerPhone?text=${Uri.encodeComponent("مرحباً، أحتاج مساعدة في تطبيق وكالتي")}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // تجاهل بصمت
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 40),

                  // 🔸 الشعار + الاسم
                  Column(
                    children: [
                      const AppLogo(size: 150, glass: true),
                      const SizedBox(height: 32),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Colors.white,
                            AppColors.primaryLight,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'وكالتي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'لتوزيع المواد الغذائية',
                          style: TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 🔸 الأزرار
                  Column(
                    children: [
                      PrimaryButton(
                        label: 'إنشاء حساب جديد',
                        icon: Icons.person_add_alt_1_rounded,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: 'تسجيل الدخول',
                        icon: Icons.login_rounded,
                        outlined: true,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // زر التواصل مع المطور
                      _DeveloperButton(onTap: _openWhatsApp),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeveloperButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DeveloperButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: GlassContainer(
        borderRadius: 14,
        blur: 16,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        fillColor: AppColors.whatsappGreen.withOpacity(0.08),
        border: Border.all(
          color: AppColors.whatsappGreen.withOpacity(0.25),
          width: 1,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.support_agent_rounded,
                    color: AppColors.whatsappGreen, size: 20),
                SizedBox(width: 8),
                Text(
                  'تواصل مع المطور',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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