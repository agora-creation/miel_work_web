import 'package:fluent_ui/fluent_ui.dart';

class CustomTabView extends StatelessWidget {
  final List<Tab> tabs;
  final int currentIndex;
  final Function(int) onChanged;

  const CustomTabView({
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabView(
      tabs: tabs,
      currentIndex: currentIndex,
      onChanged: onChanged,
      tabWidthBehavior: TabWidthBehavior.equal,
      closeButtonVisibility: CloseButtonVisibilityMode.never,
    );
  }
}
