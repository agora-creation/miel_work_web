import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_conference.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_conference_detail.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplyConferenceSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<ApplyConferenceModel> conferences;

  ApplyConferenceSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.conferences,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = conferences.map<DataGridRow>((conference) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: conference.id,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = kWhiteColor;
    }
    List<Widget> cells = [];
    ApplyConferenceModel conference = conferences.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    String createdAtText = dateText('yyyy/MM/dd HH:mm', conference.createdAt);
    String approvedAtText = '';
    if (conference.approval == 1) {
      approvedAtText = dateText('yyyy/MM/dd HH:mm', conference.createdAt);
    }
    cells.add(CustomColumnLabel(createdAtText));
    cells.add(CustomColumnLabel(conference.createdUserName));
    cells.add(CustomColumnLabel(conference.title));
    cells.add(CustomColumnLabel(conference.approvalText()));
    cells.add(CustomColumnLabel(approvedAtText));
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '詳細',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ApplyConferenceDetailScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                conference: conference,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButtonSm(
          labelText: 'PDF印刷',
          labelColor: kBlackColor,
          backgroundColor: kRed200Color,
          onPressed: () async =>
              await PdfService().applyConferenceDownload(conference),
        ),
      ],
    ));
    return DataGridRowAdapter(color: backgroundColor, cells: cells);
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(
      String value,
      EdgeInsets padding,
      Alignment alignment,
    ) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value, softWrap: false),
      );
    }

    widget = buildCell(
      summaryValue,
      const EdgeInsets.all(4),
      Alignment.centerLeft,
    );
    return widget;
  }

  void updateDataSource() {
    notifyListeners();
  }
}
