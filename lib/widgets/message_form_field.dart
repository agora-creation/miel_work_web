import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/widgets/custom_icon_button.dart';

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
                    ? CustomIconButton(
                        icon: FontAwesomeIcons.file,
                        iconColor: kWhiteColor,
                        backgroundColor: kCyanColor,
                        onPressed: filePressed,
                      )
                    : const CustomIconButton(
                        icon: FontAwesomeIcons.file,
                        iconColor: kWhiteColor,
                        backgroundColor: kGreyColor,
                      ),
                const SizedBox(width: 4),
                enabled
                    ? CustomIconButton(
                        icon: FontAwesomeIcons.photoFilm,
                        iconColor: kWhiteColor,
                        backgroundColor: kCyanColor,
                        onPressed: galleryPressed,
                      )
                    : const CustomIconButton(
                        icon: FontAwesomeIcons.photoFilm,
                        iconColor: kWhiteColor,
                        backgroundColor: kGreyColor,
                      ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: messagePressed,
                child: const Text('メッセージを入力...'),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
