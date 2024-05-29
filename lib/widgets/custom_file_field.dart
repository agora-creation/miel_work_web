import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:path/path.dart' as p;

class CustomFileField extends StatelessWidget {
  final PlatformFile? value;
  final String defaultValue;
  final Function()? onPressed;

  const CustomFileField({
    required this.value,
    required this.defaultValue,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: ButtonState.all(kGrey300Color),
          ),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  FluentIcons.open_file,
                  color: kBlackColor,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  'ファイル選択',
                  style: TextStyle(
                    color: kBlackColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        value != null ? Text(p.basename(value?.name ?? '')) : Container(),
        value == null && defaultValue != '' ? Text(defaultValue) : Container(),
      ],
    );
  }
}
