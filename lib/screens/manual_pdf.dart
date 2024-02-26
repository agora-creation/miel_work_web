import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ManualPdfScreen extends StatefulWidget {
  final File file;

  const ManualPdfScreen({
    required this.file,
    super.key,
  });

  @override
  State<ManualPdfScreen> createState() => _ManualPdfScreenState();
}

class _ManualPdfScreenState extends State<ManualPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        ),
      ),
      content: SfPdfViewer.network(widget.file.path),
    );
  }
}
