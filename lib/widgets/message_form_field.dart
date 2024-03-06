import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_icon_button_sm.dart';

class MessageFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function()? galleryPressed;
  final Function()? sendPressed;
  final bool enabled;

  const MessageFormField({
    required this.controller,
    required this.galleryPressed,
    required this.sendPressed,
    this.enabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kGreyColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: enabled
                ? CustomIconButtonSm(
                    icon: FluentIcons.add,
                    iconColor: kWhiteColor,
                    backgroundColor: kCyanColor,
                    onPressed: galleryPressed,
                  )
                : const CustomIconButtonSm(
                    icon: FluentIcons.add,
                    iconColor: kWhiteColor,
                    backgroundColor: kGreyColor,
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextBox(
                controller: controller,
                placeholder: 'メッセージを入力...',
                keyboardType: TextInputType.multiline,
                maxLines: null,
                enabled: enabled,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: enabled
                ? CustomButtonSm(
                    labelText: '送信',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: sendPressed,
                  )
                : const CustomButtonSm(
                    labelText: '送信',
                    labelColor: kWhiteColor,
                    backgroundColor: kGreyColor,
                  ),
          ),
        ],
      ),
    );
  }
}
