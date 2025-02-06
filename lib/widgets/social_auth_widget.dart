import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
