import 'package:flutter/material.dart';
import 'package:flutter_profile/flutter_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.user,
    this.settingsTitle = 'Profile',
    this.logoutText = 'Log out',
    this.editProfileText = 'Edit profile',
    this.editProfileIcon,
    this.editProfileHeight,
    this.profileSuffixIcon,
    this.titleAndImagespacing,
    this.imageAndNameSpacing,
    this.extraSettings = const [],
    this.onProfileEdit,
    this.onProfileView,
    this.onLogout,
    this.editProfileDecoration,
    super.key,
  });

  final User user;

  final String settingsTitle;

  final String logoutText;

  final Widget? editProfileIcon;
  final Widget? profileSuffixIcon;
  final BoxDecoration? editProfileDecoration;
  final double? editProfileHeight;

  final double? titleAndImagespacing;
  final double? imageAndNameSpacing;

  final String editProfileText;

  final List<Widget> extraSettings;

  final VoidCallback? onProfileEdit;
  final VoidCallback? onProfileView;

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(settingsTitle),
          SizedBox(height: titleAndImagespacing ?? 0),
          GestureDetector(
            onTap: onProfileView,
            child: Avatar(
              user: user,
            ),
          ),
          SizedBox(height: imageAndNameSpacing ?? 0),
          Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
          const SizedBox(height: 20),
          const Divider(),
          GestureDetector(
            onTap: onProfileEdit,
            child: Container(
              height: editProfileHeight,
              decoration: editProfileDecoration ??
                  const BoxDecoration(
                    color: Colors.transparent,
                  ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  editProfileIcon ?? const Icon(Icons.person_2_outlined),
                  Text(editProfileText),
                  const Spacer(),
                  profileSuffixIcon ?? const Icon(Icons.arrow_forward_ios),
                  const SizedBox(width: 20),
                ],
              ),
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
