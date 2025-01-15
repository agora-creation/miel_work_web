import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class CustomDateTimePicker {
  Future picker({
    required BuildContext context,
    required DateTimePickerType pickerType,
    required DateTime init,
    required String title,
    required Function(DateTime) onChanged,
  }) async {
    await showBoardDateTimePicker(
      context: context,
      pickerType: pickerType,
      initialDate: init,
      minimumDate: kFirstDate,
      maximumDate: kLastDate,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages.ja(),
        showDateButton: false,
        boardTitle: title,
      ),
      radius: 8,
      onChanged: onChanged,
    );
  }
}
