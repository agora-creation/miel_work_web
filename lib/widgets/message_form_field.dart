import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/widgets/custom_icon_button_sm.dart';

class MessageFormField extends StatelessWidget {
  final Function()? messagePressed;
  final Function()? filePressed;
  final Function()? galleryPressed;
  final bool enabled;

  const MessageFormField({
    required this.messagePressed,
    required this.filePressed,
    required this.galleryPressed,
    required this.enabled,
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
            child: Row(
              children: [
                enabled
                    ? CustomIconButtonSm(
                        icon: FluentIcons.page_add,
                        iconColor: kWhiteColor,
                        backgroundColor: kCyanColor,
                        onPressed: filePressed,
                      )
                    : const CustomIconButtonSm(
                        icon: FluentIcons.page_add,
                        iconColor: kWhiteColor,
                        backgroundColor: kGreyColor,
                      ),
                const SizedBox(width: 4),
                enabled
                    ? CustomIconButtonSm(
                        icon: FluentIcons.photo2_add,
                        iconColor: kWhiteColor,
                        backgroundColor: kCyanColor,
                        onPressed: galleryPressed,
                      )
                    : const CustomIconButtonSm(
                        icon: FluentIcons.photo2_add,
                        iconColor: kWhiteColor,
                        backgroundColor: kGreyColor,
                      ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextBox(
                placeholder: 'メッセージを入力...',
                readOnly: true,
                onTap: messagePressed,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
