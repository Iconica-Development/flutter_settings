import "package:flutter/material.dart";
import "package:flutter_settings/src/util/scope.dart";

/// An admin view for editing the settings in a single namespace
class NamespacedDynamicSettingsAdminScreen extends StatelessWidget {
  /// Create an admin view for the given namespace
  const NamespacedDynamicSettingsAdminScreen({
    required this.namespace,
    required this.onExit,
    super.key,
  });

  /// The current namespace being edited
  final String namespace;

  /// The
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    var scope = DynamicSettingsScope.of(context);
    var options = scope.options;

    return options.baseScreenBuilder(
      context,
      onExit,
      CustomScrollView(
        slivers: [
          for (int i = 0; i < 10; i++) ...[
            SliverMainAxisGroup(
              slivers: [
                SliverAppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  title: Text("Group $i"),
                  pinned: true,
                ),
                SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    title: Text("Setting $index"),
                  ),
                ),
                SliverAppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  title: Text("Subgroup $i"),
                  pinned: true,
                ),
                SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    title: Text("Setting $index"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
