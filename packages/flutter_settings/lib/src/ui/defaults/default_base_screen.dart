import "package:flutter/material.dart";

/// Default base screen for any availability screen
class DefaultBaseScreen extends StatelessWidget {
  /// Create a base screen
  const DefaultBaseScreen({
    required this.child,
    required this.onBack,
    super.key,
  });

  /// Builder as default option
  static Widget builder(
    BuildContext context,
    VoidCallback onBack,
    Widget child,
  ) =>
      DefaultBaseScreen(
        onBack: onBack,
        child: child,
      );

  /// Content of the page
  final Widget child;

  /// The callback for when the user wants to exit.
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    var isDismissable = parentRoute?.impliesAppBarDismissal ?? false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: isDismissable
            ? BackButton(
                onPressed: onBack,
              )
            : null,
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}
