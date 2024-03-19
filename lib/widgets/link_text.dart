import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';

class LinkText extends StatelessWidget {
  final String label;
  final Color color;
  final Function()? onTap;
  final bool enabled;

  const LinkText({
    required this.label,
    required this.color,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: enabled
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: color),
                ),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? color : kGreyColor,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
      ),
    );
  }
}
