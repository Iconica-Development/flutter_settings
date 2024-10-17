import "dart:async";

import "package:flutter/material.dart";

///
class DefaultPrimaryButton extends StatelessWidget {
  ///
  const DefaultPrimaryButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultPrimaryButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) =>
      FilledButton(onPressed: onPressed, child: child);
}

/// a secondary button with a an outlined border
class DefaultSecondaryButton extends StatelessWidget {
  ///
  const DefaultSecondaryButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultSecondaryButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) =>
      OutlinedButton(onPressed: onPressed, child: child);
}

/// The default big text button used in the component when no custom
/// button is provided. This button is used as a teritary button
class DefaultBigTextButton extends StatelessWidget {
  ///
  const DefaultBigTextButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultBigTextButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            fontSize: 16,
          ),
        ),
        child: child,
      );
}

///
class DefaultBigTextButtonWrapper extends StatelessWidget {
  ///
  const DefaultBigTextButtonWrapper({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  final Widget? child;

  ///
  final FutureOr<void> Function()? onPressed;

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget? child,
  ) =>
      DefaultBigTextButtonWrapper(onPressed: onPressed, child: child);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: child,
        ),
      );
}

/// The default small text button used in the component when no custom
/// button is provided. This button is used as a smaller variant of the
/// tertiary button
class DefaultSmallTextButton extends StatelessWidget {
  ///
  const DefaultSmallTextButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultSmallTextButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
          ),
          overlayColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        child: child,
      );
}
