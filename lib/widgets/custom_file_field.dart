import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:path/path.dart' as p;

class CustomFileField extends StatelessWidget {
  final PlatformFile? value;
  final String defaultValue;
  final Function()? onTap;

  const CustomFileField({
    required this.value,
    required this.defaultValue,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kGrey600Color,
        width: double.infinity,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ファイル選択',
                style: TextStyle(
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value != null
                  ? Text(
                      p.basename(value?.name ?? ''),
                      style: const TextStyle(color: kWhiteColor),
                    )
                  : Container(),
              value == null && defaultValue != ''
                  ? Text(
                      defaultValue,
                      style: const TextStyle(color: kWhiteColor),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
