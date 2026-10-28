import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'main.dart';

// ============================================================
// 🔸 GlassContainer
// ============================================================
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? fillColor;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 24,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.fillColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fillColor ?? AppColors.glassFill,
              borderRadius: BorderRadius.circular(borderRadius),
              border:
                  border ?? Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 🔸 GradientBackground
// ============================================================
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundDark,
            AppColors.backgroundMid,
            AppColors.backgroundLight,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -size.height * 0.15,
            right: -size.width * 0.25,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.35),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.2,
            left: -size.width * 0.3,
            child: Container(
              width: size.width,
              height: size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primaryLight.withValues(alpha: 0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ============================================================
// 🔸 AppLogo
// ============================================================
class AppLogo extends StatelessWidget {
  final double size;
  final bool glass;
  const AppLogo({super.key, this.size = 100, this.glass = false});
  @override
  Widget build(BuildContext context) {
    final core = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.shopping_basket_rounded,
          color: Colors.white, size: size * 0.5),
    );
    if (!glass) return core;
    return GlassContainer(
      borderRadius: size / 2 + 14,
      padding: const EdgeInsets.all(14),
      blur: 20,
      child: core,
    );
  }
}

// ============================================================
// 🔸 PrimaryButton
// ============================================================
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
    this.height = 58,
  });

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(
                outlined ? AppColors.primary : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon,
                    color: outlined ? AppColors.primary : Colors.white,
                    size: 20),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: TextStyle(
                  color: outlined ? AppColors.primary : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );

    if (outlined) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: GlassContainer(
          borderRadius: 18,
          blur: 20,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(18),
              child: Center(child: content),
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(child: content),
        ),
      ),
    );
  }
}

// ============================================================
// 🔸 SocialButton
// ============================================================
class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback? onPressed;
  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: GlassContainer(
        borderRadius: 16,
        blur: 20,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 10),
                  Text(label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 🔸 ThreeDotsLoader
// ============================================================
class ThreeDotsLoader extends StatefulWidget {
  final Color color;
  final double dotSize;
  const ThreeDotsLoader({
    super.key,
    this.color = AppColors.primary,
    this.dotSize = 14,
  });
  @override
  State<ThreeDotsLoader> createState() => _ThreeDotsLoaderState();
}

class _ThreeDotsLoaderState extends State<ThreeDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final phase = (_controller.value + i * 0.18) % 1.0;
          final wave = math.sin(phase * math.pi * 2);
          final translateY = -8.0 * math.max(0, wave);
          final scale = 0.85 + 0.15 * math.max(0, wave);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Transform.translate(
              offset: Offset(0, translateY),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// 🔸 AppDivider
// ============================================================
class AppDivider extends StatelessWidget {
  final String label;
  const AppDivider({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.glassBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
        ),
        Expanded(child: Container(height: 1, color: AppColors.glassBorder)),
      ],
    );
  }
}