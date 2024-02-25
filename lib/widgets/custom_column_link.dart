import 'package:fluent_ui/fluent_ui.dart';

class CustomColumnLink extends StatelessWidget {
  final String label;
  final Color color;
  final Function()? onTap;

  const CustomColumnLink({
    required this.label,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color),
            ),
          ),
          child: Text(
            label,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: color),
          ),
        ),
      ),
    );
  }
}
