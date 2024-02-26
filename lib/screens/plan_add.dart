import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';

class PlanAddScreen extends StatefulWidget {
  const PlanAddScreen({super.key});

  @override
  State<PlanAddScreen> createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
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
              const Text(
                '予定の追加',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: const Center(child: Text('日時と件名、スタッフを設定する')),
      ),
    );
  }
}
