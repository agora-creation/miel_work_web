import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;

class FilePickerButton extends StatelessWidget {
  final PlatformFile? value;
  final String defaultValue;
  final Function()? onPressed;

  const FilePickerButton({
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
        CustomIconTextButton(
          label: 'ファイルを選択してください',
          labelColor: kBlackColor,
          backgroundColor: kGrey300Color,
          leftIcon: FontAwesomeIcons.file,
          onPressed: onPressed,
        ),
        value != null ? Text(p.basename(value?.name ?? '')) : Container(),
        value == null && defaultValue != ''
            ? LinkText(
                label: '添付を確認する',
                color: kBlueColor,
                onTap: () => downloadFile(
                  url: defaultValue,
                  name: p.basename(defaultValue),
                ),
              )
            : Container(),
      ],
    );
  }
}
