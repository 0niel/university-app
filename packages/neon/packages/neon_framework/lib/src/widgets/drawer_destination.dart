import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

@internal
class NeonNavigationDestination {
  const NeonNavigationDestination({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.notificationCount,
  });

  final String label;
  final Widget Function({double? size, Color color}) icon;
  final Widget? selectedIcon;
  final BehaviorSubject<int>? notificationCount;
}

@internal
extension NavigationDestinationExtension on NavigationDestination {
  static NavigationDestination fromNeonDestination(NeonNavigationDestination neonDestination) => NavigationDestination(
        label: neonDestination.label,
        icon: neonDestination.icon(),
        selectedIcon: neonDestination.selectedIcon,
      );
}

@internal
extension NavigationRailDestinationExtension on NavigationRailDestination {
  static NavigationRailDestination fromNeonDestination(NeonNavigationDestination neonDestination) {
    final iconWidget = StreamBuilder(
      stream: neonDestination.notificationCount,
      initialData: 0,
      builder: (context, snapshot) {
        final colorScheme = Theme.of(context).colorScheme;

        final color = snapshot.requireData > 0 ? colorScheme.primary : colorScheme.onBackground;

        final icon = Container(
          margin: const EdgeInsets.all(5),
          child: neonDestination.icon(color: color),
        );

        if (snapshot.requireData <= 0) {
          return icon;
        }

        final notificationIndicator = Builder(
          builder: (context) {
            final style = TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            );

            return Text(
              snapshot.requireData.toString(),
              style: style,
            );
          },
        );

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            icon,
            notificationIndicator,
          ],
        );
      },
    );

    return NavigationRailDestination(
      label: Text(neonDestination.label),
      icon: iconWidget,
      selectedIcon: neonDestination.selectedIcon,
    );
  }
}

@internal
extension NavigationDrawerDestinationExtension on NavigationDrawerDestination {
  static NavigationDrawerDestination fromNeonDestination(NeonNavigationDestination neonDestination) {
    final labelWidget = StreamBuilder(
      stream: neonDestination.notificationCount,
      initialData: 0,
      builder: (context, snapshot) {
        final label = Text(neonDestination.label);

        if (snapshot.requireData <= 0) {
          return label;
        }

        final notificationIndicator = Padding(
          padding: const EdgeInsets.only(left: 12, right: 24),
          child: Builder(
            builder: (context) {
              final style = TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );

              return Text(
                snapshot.requireData.toString(),
                style: style,
              );
            },
          ),
        );

        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              label,
              notificationIndicator,
            ],
          ),
        );
      },
    );

    return NavigationDrawerDestination(
      label: labelWidget,
      icon: neonDestination.icon(),
      selectedIcon: neonDestination.selectedIcon,
    );
  }
}

@internal
extension TabExtension on Tab {
  static Tab fromNeonDestination(NeonNavigationDestination neonDestination) => Tab(
        text: neonDestination.label,
        icon: neonDestination.icon(),
      );
}
