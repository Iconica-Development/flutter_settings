import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_settings/src/ui/dynamic/admin/namespaced_dynamic_settings_admin_screen.dart";
import "package:flutter_settings/src/util/scope.dart";

/// Initial screen for editing dynamic settings for all configured namespaces
class DynamicSettingsAdminScreen extends HookWidget {
  ///
  const DynamicSettingsAdminScreen({
    required this.onExit,
    super.key,
  });

  ///
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    var scope = DynamicSettingsScope.of(context);

    useEffect(
      () {
        scope.popHandler.add(onExit);
        return () => scope.popHandler.remove(onExit);
      },
      [onExit],
    );

    return scope.options.baseScreenBuilder(
      context,
      onExit,
      const _NamespacesOvervieww(),
    );
  }
}

class _NamespacesOvervieww extends StatelessWidget {
  const _NamespacesOvervieww();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var service = DynamicSettingsScope.of(context).service;

    var header = Row(
      children: [
        Expanded(
          child: Text(
            "Namespaces",
            style: theme.textTheme.headlineLarge,
          ),
        ),
        IconButton.filled(
          onPressed: () async {
            await service.createNamespace("dynamic_settings");
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ).copyWith(bottom: 0),
      child: Column(
        children: [
          header,
          const SizedBox(height: 40),
          const Expanded(
            child: _NamespaceTable(),
          ),
        ],
      ),
    );
  }
}

class _NamespaceTable extends HookWidget {
  const _NamespaceTable();

  @override
  Widget build(BuildContext context) {
    var scope = DynamicSettingsScope.of(context);
    var service = scope.service;

    var namespaceStream = useMemoized(
      () => service.getNamespaces(),
      [scope.service],
    );

    var namespacesSnapshot = useStream(namespaceStream);

    if (namespacesSnapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (namespacesSnapshot.hasError) {
      return Text(namespacesSnapshot.error!.toString());
    }

    var data = namespacesSnapshot.data;
    assert(data != null, "Data should never be null here!");

    return Table(
      columnWidths: const {
        1: FixedColumnWidth(300),
      },
      children: [
        const TableRow(
          children: [
            Text("Namespace"),
            Text("Options"),
          ],
        ),
        for (var item in data!)
          TableRow(
            children: [
              Text(item.namespace),
              Wrap(
                runAlignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  IconButton(
                    onPressed: () async {
                      await service.deleteNamespace(item.namespace);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      unawaited(
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NamespacedDynamicSettingsAdminScreen(
                              namespace: item.namespace,
                              onExit: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_document),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
