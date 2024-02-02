import 'package:flutter/material.dart';
import 'package:flutter_profile/flutter_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.user,
    this.settingsTitle = 'Profile',
    this.logoutText = 'Log out',
    this.editProfileText = 'Edit profile',
    this.editProfileIcon,
    this.extraSettings = const [],
    this.onProfileEdit,
    this.onProfileView,
    this.onLogout,
    super.key,
  });

  final User user;

  final String settingsTitle;

  final String logoutText;

  final Widget? editProfileIcon;
  final String editProfileText;

  final List<Widget> extraSettings;

  final VoidCallback? onProfileEdit;
  final VoidCallback? onProfileView;

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(settingsTitle),
          GestureDetector(
            onTap: onProfileView,
            child: Avatar(
              user: user,
            ),
          ),
          Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
          const SizedBox(height: 20),
          const Divider(),
          GestureDetector(
            onTap: onProfileEdit,
            child: Row(
              children: [
                const SizedBox(width: 20),
                editProfileIcon ?? const Icon(Icons.person_2_outlined),
                Text(editProfileText),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const Divider(),
          ...extraSettings,
          const Spacer(),
          if (onLogout != null) ...[
            TextButton(
              onPressed: onLogout,
              child: Text(
                logoutText,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ],
      );
}
