import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool checked;
  final void Function(bool?) onChanged;

  const CustomCheckbox({
    required this.label,
    required this.checked,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      padding: const EdgeInsets.all(8),
      child: Checkbox(
        checked: checked,
        onChanged: onChanged,
        content: Text(label),
      ),
    );
  }
}
