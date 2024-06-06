import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:devshouse/widgets/drawer/info_row.dart';
import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const CustomDrawerHeader({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    String avatarImage = _getAvatarImage(userData?['gender']);
    return Container(
      padding: const EdgeInsets.only(
          top: 48.0, bottom: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(avatarImage),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 10),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                '${userData?['f_name']} ${userData?['l_name'] ?? ''}',
                textStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                speed: const Duration(milliseconds: 70),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 10),
          InfoRow(
            icon: Icons.lightbulb_outline,
            label: 'Theme',
            value: userData?['theme'] ?? '',
            iconColor: Colors.amber.shade400,
          ),
          InfoRow(
            icon: Icons.table_chart,
            label: 'Table',
            value: '${userData?['table_number']}',
            iconColor: Colors.lightGreenAccent.shade400,
          ),
          InfoRow(
            icon: Icons.group,
            label: 'Team',
            value: '${userData?['team_name']}',
            iconColor: Colors.blue.shade400,
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white54, thickness: 1.0),
        ],
      ),
    );
  }

  String _getAvatarImage(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'assets/5024509.png';
      case 'female':
        return 'assets/3270999.png';
      default:
        return 'assets/5024509.png';
    }
  }
}
