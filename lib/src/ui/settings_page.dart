import 'package:flutter/material.dart';
import 'package:flutter_profile/flutter_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.user,
    this.userNameStyle,
    this.settingsTitle = 'Profile',
    this.titleStyle,
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
  final TextStyle? userNameStyle;

  final String settingsTitle;
  final TextStyle? titleStyle;

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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Text(
          settingsTitle,
          style: titleStyle ?? theme.textTheme.titleSmall,
        ),
        SizedBox(height: titleAndImagespacing ?? 0),
        GestureDetector(
          onTap: onProfileView,
          child: Avatar(
            user: user,
          ),
        ),
        SizedBox(height: imageAndNameSpacing ?? 0),
        Text(
          '${user.firstName ?? ''} ${user.lastName ?? ''}',
          style: userNameStyle ?? theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        const Divider(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onProfileEdit,
          child: Container(
            height: editProfileHeight,
            decoration: editProfileDecoration,
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
}
