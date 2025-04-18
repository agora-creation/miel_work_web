import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/models/report.dart';
import 'package:miel_work_web/models/request_const.dart';
import 'package:miel_work_web/models/request_cycle.dart';
import 'package:miel_work_web/models/request_facility.dart';
import 'package:miel_work_web/models/request_interview.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/models/request_square.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

const kPdfFontUrl = 'assets/fonts/GenShinGothic-Regular.ttf';

class PdfService {
  Future reportDownload(ReportModel report) async {
    List<int> visitor1DayAlls = [0, 0, 0];
    List<int> visitor1YearAlls = [0, 0, 0];
    visitor1DayAlls = await ReportService().getVisitorAll(
      organizationId: report.organizationId,
      day: DateTime(
        report.createdAt.year,
        report.createdAt.month,
        report.createdAt.day,
      ).subtract(const Duration(days: 1)),
    );
    visitor1YearAlls = await ReportService().getVisitorAll(
      organizationId: report.organizationId,
      day: DateTime(
        report.createdAt.year - 1,
        report.createdAt.month,
        report.createdAt.day,
      ),
    );
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 14,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 12,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a3,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${dateText('MM月dd日(E)', report.createdAt)}の日報',
            style: titleStyle,
          ),
          pw.SizedBox(height: 8),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '出勤者',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.FlexColumnWidth(2),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '名前',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '時間帯',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            ...report.reportWorkers.map((reportWorker) {
                              return pw.TableRow(
                                children: [
                                  pw.Text(
                                    reportWorker.name,
                                    style: bodyStyle,
                                  ),
                                  pw.Text(
                                    reportWorker.time,
                                    style: bodyStyle,
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        pw.Text(
                          '出勤者(警備員)',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.FlexColumnWidth(2),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '名前',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '時間帯',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            ...report.reportWorkersGuardsman
                                .map((reportWorker) {
                              return pw.TableRow(
                                children: [
                                  pw.Text(
                                    reportWorker.name,
                                    style: bodyStyle,
                                  ),
                                  pw.Text(
                                    reportWorker.time,
                                    style: bodyStyle,
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        pw.Text(
                          '出勤者(清掃員)',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.FlexColumnWidth(2),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '名前',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '時間帯',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            ...report.reportWorkersGarbageman
                                .map((reportWorker) {
                              return pw.TableRow(
                                children: [
                                  pw.Text(
                                    reportWorker.name,
                                    style: bodyStyle,
                                  ),
                                  pw.Text(
                                    reportWorker.time,
                                    style: bodyStyle,
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          '入場者数',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                            2: pw.FlexColumnWidth(1),
                            3: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '12:30',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '20:00',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '22:00',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'お城下広場',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor1_12}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor1_20}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor1_22}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'いごっそう',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor2_12}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor2_20}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor2_22}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '自由広場',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor3_12}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor3_20}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor3_22}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '東通路',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor4_12}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor4_20}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor4_22}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'バルコーナー',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor5_12}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor5_20}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor5_22}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '合計',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor1_12 + report.reportVisitor.floor2_12 + report.reportVisitor.floor3_12 + report.reportVisitor.floor4_12 + report.reportVisitor.floor5_12}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor1_20 + report.reportVisitor.floor2_20 + report.reportVisitor.floor3_20 + report.reportVisitor.floor4_20 + report.reportVisitor.floor5_20}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.reportVisitor.floor1_22 + report.reportVisitor.floor2_22 + report.reportVisitor.floor3_22 + report.reportVisitor.floor4_22 + report.reportVisitor.floor5_22}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '前日合計\n※自動取得',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${visitor1DayAlls[0]}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${visitor1DayAlls[1]}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${visitor1DayAlls[2]}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '前年合計\n※自動取得',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${visitor1YearAlls[0]}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${visitor1YearAlls[1]}',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${visitor1YearAlls[2]}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'コインロッカー',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                            2: pw.IntrinsicColumnWidth(),
                            3: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '連続使用',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.use ? '有' : '',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '忘れ物',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.lost ? '有' : '',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'ロッカー番号',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.number,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '連続使用日数',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.days,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '金額',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.price,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '備考',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.remarks,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '回収',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportLocker.recovery,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '予定',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1),
                            1: pw.IntrinsicColumnWidth(),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '内容',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '時間帯',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            ...report.reportPlans.map((reportPlan) {
                              return pw.TableRow(
                                children: [
                                  pw.Text(
                                    reportPlan.title,
                                    style: bodyStyle,
                                  ),
                                  pw.Text(
                                    reportPlan.time,
                                    style: bodyStyle,
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'メールチェック',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                            2: pw.IntrinsicColumnWidth(),
                            3: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '時間',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '名前',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '時間',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '名前',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '10:30',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.mail10,
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '12:00',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.mail12,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '18:00',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.mail18,
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '22:00',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.mail22,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          '警戒チェック',
                          style: bodyStyle,
                        ),
                        pw.Text(
                          '19:45～',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '状態',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.warning19State,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '対処',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.warning19Deal,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '23:00～',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '状態',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.warning23State,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '対処',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  report.reportCheck.warning23Deal,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          '立替金',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          columnWidths: const {
                            0: pw.IntrinsicColumnWidth(),
                            1: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '立替',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.advancePayment1}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '現金',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.advancePayment2}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '合計',
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  '${report.advancePayment1 + report.advancePayment2}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '営繕ヶ所等',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '内容',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '対処',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  ...report.reportRepairs.map((reportRepair) {
                    return pw.TableRow(
                      children: [
                        pw.Text(
                          reportRepair.title,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportRepair.deal,
                          style: bodyStyle,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'クレーム／要望等',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '内容',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '対処',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  ...report.reportProblems.map((reportProblem) {
                    return pw.TableRow(
                      children: [
                        pw.Text(
                          reportProblem.title,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportProblem.deal,
                          style: bodyStyle,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'パンフレット',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '種別',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '内容',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '部数',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  ...report.reportPamphlets.map((reportPamphlet) {
                    return pw.TableRow(
                      children: [
                        pw.Text(
                          reportPamphlet.type,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportPamphlet.title,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportPamphlet.price,
                          style: bodyStyle,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '備品発注・入荷',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '種別',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '品名',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '業者',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '納期',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '納入数',
                        style: bodyStyle,
                      ),
                      pw.Text(
                        '発注者',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  ...report.reportEquipments.map((reportEquipment) {
                    return pw.TableRow(
                      children: [
                        pw.Text(
                          reportEquipment.type,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportEquipment.name,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportEquipment.vendor,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportEquipment.deliveryDate,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportEquipment.deliveryNum,
                          style: bodyStyle,
                        ),
                        pw.Text(
                          reportEquipment.client,
                          style: bodyStyle,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'その他報告・連絡',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        report.remarks,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '申送事項',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        report.agenda,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${report.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future problemDownload(ProblemModel problem) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 12,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'クレーム／要望',
              style: titleStyle,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text(
                              '報告日時',
                              style: bodyStyle,
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Text(
                              dateText('yyyy/MM/dd HH:mm', problem.createdAt),
                              style: bodyStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text(
                              '対応項目',
                              style: bodyStyle,
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Text(
                              problem.type,
                              style: bodyStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'タイトル',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  problem.title,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '対応者',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  problem.picName,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '相手の名前',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  problem.targetName,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '相手の年齢',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  problem.targetAge,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '相手の連絡先',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  problem.targetTel,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '相手の連絡先',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  problem.targetAddress,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '詳細',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        problem.details,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '対応状態',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: problem.states.map((state) {
                      return pw.Text(
                        state,
                        style: bodyStyle,
                      );
                    }).toList(),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '同じような注意(対応)をした回数',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        problem.count.toString(),
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${problem.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestInterviewDownload(RequestInterviewModel interview) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '取材申込書',
              style: titleStyle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申込者情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込会社名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.companyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込担当者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.companyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込担当者メールアドレス',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.companyUserEmail,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込担当者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.companyUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '媒体名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.mediaName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '番組・雑誌名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.programName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '出演者情報',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.castInfo,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '特集内容・備考',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.featureContent,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        'OA・掲載予定日',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.publishedAt,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '取材当日情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '取材予定日時',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedAtPending
                            ? '未定'
                            : '${dateText('yyyy年MM月dd日 HH:mm', interview.interviewedStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', interview.interviewedEndedAt)}',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '取材担当者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '取材担当者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '席の予約',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedReserved ? '必要' : '',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '取材店舗',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedShopName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        'いらっしゃる人数',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedVisitors,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '取材内容・備考',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.interviewedContent,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              interview.location
                  ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ロケハン情報',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'ロケハン予定日時',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.locationAtPending
                                      ? '未定'
                                      : '${dateText('yyyy年MM月dd日 HH:mm', interview.locationStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', interview.locationEndedAt)}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'ロケハン担当者名',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.locationUserName,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'ロケハン担当者電話番号',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.locationUserTel,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'いらっしゃる人数',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.locationVisitors,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'ロケハン内容・備考',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.locationContent,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : pw.Text(
                      'ロケハンなし',
                      style: bodyStyle,
                    ),
              pw.SizedBox(height: 8),
              interview.insert
                  ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'インサート撮影情報',
                          style: bodyStyle,
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '撮影予定日時',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedAtPending
                                      ? '未定'
                                      : '${dateText('yyyy年MM月dd日 HH:mm', interview.insertedStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', interview.insertedEndedAt)}',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '撮影担当者名',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedUserName,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '撮影担当者電話番号',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedUserTel,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '席の予約',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedReserved ? '必要' : '',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '撮影店舗',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedShopName,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  'いらっしゃる人数',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedVisitors,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  '撮影内容・備考',
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Text(
                                  interview.insertedContent,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : pw.Text(
                      'インサート撮影なし',
                      style: bodyStyle,
                    ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        'その他連絡事項',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        interview.remarks,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${interview.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestSquareDownload(RequestSquareModel square) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'よさこい広場使用申込書',
              style: titleStyle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申込者情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込会社名(又は店名)',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.companyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込担当者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.companyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込担当者メールアドレス',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.companyUserEmail,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '申込担当者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.companyUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '住所',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.companyAddress,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '使用者情報 (申込者情報と異なる場合のみ)',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用会社名(又は店名)',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.useCompanyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.useCompanyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '使用情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用予定日時',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.useAtPending
                            ? '未定'
                            : '${dateText('yyyy年MM月dd日 HH:mm', square.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', square.useEndedAt)}',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用区分',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          square.useFull
                              ? pw.Text(
                                  '全面使用',
                                  style: bodyStyle,
                                )
                              : pw.Container(),
                          square.useChair
                              ? pw.Column(
                                  children: [
                                    pw.Text(
                                      '折りたたみイス：${square.useChairNum}脚',
                                      style: bodyStyle,
                                    ),
                                    pw.Text(
                                      '150円(税抜)／1脚・1日',
                                      style: bodyStyle,
                                    ),
                                  ],
                                )
                              : pw.Container(),
                          square.useDesk
                              ? pw.Column(
                                  children: [
                                    pw.Text(
                                      '折りたたみ机：${square.useDeskNum}台',
                                      style: bodyStyle,
                                    ),
                                    pw.Text(
                                      '300円(税抜)／1台・1日',
                                      style: bodyStyle,
                                    ),
                                  ],
                                )
                              : pw.Container(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用内容',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        square.useContent,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${square.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestFacilityDownload(RequestFacilityModel facility) async {
    int useAtDaysPrice = 0;
    if (!facility.useAtPending) {
      int useAtDays =
          facility.useEndedAt.difference(facility.useStartedAt).inDays;
      int price = 1200;
      useAtDaysPrice = price * useAtDays;
    }
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '施設使用申込書',
              style: titleStyle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申込者情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        facility.companyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        facility.companyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者メールアドレス',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        facility.companyUserEmail,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        facility.companyUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '旧梵屋跡の倉庫を使用します (貸出面積：約12㎡)',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用予定日時',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        facility.useAtPending
                            ? '未定'
                            : '${dateText('yyyy年MM月dd日 HH:mm', facility.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', facility.useEndedAt)}',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用料合計(税抜)',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '${NumberFormat("#,###").format(useAtDaysPrice)}円',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${facility.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestCycleDownload(RequestCycleModel cycle) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '自転車置き場使用申込書',
              style: titleStyle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申込者情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        cycle.companyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        cycle.companyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用者メールアドレス',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        cycle.companyUserEmail,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '使用者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        cycle.companyUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '住所',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        cycle.companyAddress,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${cycle.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestOvertimeDownload(RequestOvertimeModel overtime) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '夜間居残り作業申請書',
              style: titleStyle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申請者情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        overtime.companyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        overtime.companyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者メールアドレス',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        overtime.companyUserEmail,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        overtime.companyUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '作業情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '作業予定日時',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        overtime.useAtPending
                            ? '未定'
                            : '${dateText('yyyy年MM月dd日 HH:mm', overtime.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', overtime.useEndedAt)}',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '作業内容',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        overtime.useContent,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${overtime.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestConstDownload(RequestConstModel requestConst) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '店舗工事作業申請書',
              style: titleStyle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申請者情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.companyName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.companyUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者メールアドレス',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.companyUserEmail,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '店舗責任者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.companyUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '工事施工情報',
                style: bodyStyle,
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '工事施工会社名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.constName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '工事施工代表者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.constUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '工事施工代表者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.constUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '当日担当者名',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.chargeUserName,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '当日担当者電話番号',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.chargeUserTel,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '施工予定日時',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.constAtPending
                            ? '未定'
                            : '${dateText('yyyy年MM月dd日 HH:mm', requestConst.constStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', requestConst.constEndedAt)}',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '施工内容',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.constContent,
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '騒音',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.noise ? '有' : '無',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              requestConst.noise
                  ? pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4),
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey),
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text(
                                '騒音対策',
                                style: bodyStyle,
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Text(
                                requestConst.noiseMeasures,
                                style: bodyStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : pw.Container(),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '粉塵',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.dust ? '有' : '無',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              requestConst.dust
                  ? pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4),
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey),
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text(
                                '粉塵対策',
                                style: bodyStyle,
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Text(
                                requestConst.dustMeasures,
                                style: bodyStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : pw.Container(),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        '火気の使用',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        requestConst.fire ? '有' : '無',
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ],
              ),
              requestConst.fire
                  ? pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4),
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey),
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text(
                                '火気対策',
                                style: bodyStyle,
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Text(
                                requestConst.fireMeasures,
                                style: bodyStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : pw.Container(),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${requestConst.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future applyDownload(ApplyModel apply) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    String approvalUserNameText = '';
    if (apply.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel approvalUser in apply.approvalUsers) {
        if (approvalUserNameText != '') approvalUserNameText += '\n';
        approvalUserNameText +=
            '${dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt)}に『${approvalUser.userName}』が承認';
      }
    }
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '${apply.type}書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申請日時: ${dateText('yyyy/MM/dd HH:mm', apply.createdAt)}',
                style: pw.TextStyle(
                  font: ttf,
                  color: PdfColors.grey,
                  fontSize: 10,
                ),
              ),
              pw.Text(
                '申請番号: ${apply.number}',
                style: pw.TextStyle(
                  font: ttf,
                  color: PdfColors.grey,
                  fontSize: 10,
                ),
              ),
              pw.Text(
                '申請者: ${apply.createdUserName}',
                style: pw.TextStyle(
                  font: ttf,
                  color: PdfColors.grey,
                  fontSize: 10,
                ),
              ),
              apply.approval == 1
                  ? pw.Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', apply.approvedAt)}',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                      ),
                    )
                  : pw.Container(),
              apply.approval == 1
                  ? pw.Text(
                      '承認番号: ${apply.approvalNumber}',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                      ),
                    )
                  : pw.Container(),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            columnWidths: const {
              0: pw.FixedColumnWidth(80),
              1: pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '承認者一覧',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    height: 80,
                  ),
                  _generateCell(
                    label: approvalUserNameText,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 80,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '件名',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 12,
                    ),
                  ),
                  _generateCell(
                    label: apply.title,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 12,
                    ),
                    color: PdfColors.white,
                  ),
                ],
              ),
              if (apply.type == '稟議')
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    _generateCell(
                      label: '金額',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                      ),
                    ),
                    _generateCell(
                      label: '¥ ${apply.formatPrice()}',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                      ),
                      color: PdfColors.white,
                    ),
                  ],
                ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '内容',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    height: 450,
                  ),
                  _generateCell(
                    label: apply.content,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 450,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '承認理由',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: apply.approvalReason,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 50,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '否決理由',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: apply.reason,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${apply.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future userDownload(UserModel user) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final androidByteData =
        await rootBundle.load('assets/images/qr_android.png');
    final androidUint8List = androidByteData.buffer.asUint8List(
      androidByteData.offsetInBytes,
      androidByteData.lengthInBytes,
    );
    final androidImage = pw.MemoryImage(androidUint8List);
    final iosByteData = await rootBundle.load('assets/images/qr_ios.png');
    final iosUint8List = iosByteData.buffer.asUint8List(
      iosByteData.offsetInBytes,
      iosByteData.lengthInBytes,
    );
    final iosImage = pw.MemoryImage(iosUint8List);

    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'ひろめWORKのはじめ方',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '${user.name} 様へ',
                  style: pw.TextStyle(
                    font: ttf,
                    color: PdfColors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'アプリをインストールしよう！',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 16,
            ),
          ),
          pw.Text(
            '以下のQRコードからアプリストアにアクセスできます。',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 12,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            columnWidths: const {
              0: pw.FlexColumnWidth(),
              1: pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.Center(
                    child: _generateCell(
                      label: 'Android',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Center(
                    child: _generateCell(
                      label: 'iOS',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.Center(
                    child: pw.Image(androidImage),
                  ),
                  pw.Center(
                    child: pw.Image(iosImage),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'インストールが終わったら、以下を入力してログインしよう！',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            columnWidths: const {
              0: pw.FixedColumnWidth(100),
              1: pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: 'メールアドレス',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                  ),
                  _generateCell(
                    label: user.email,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: 'パスワード',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                  ),
                  _generateCell(
                    label: user.password,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '一度ログインすると、あなたのスマホにログイン情報が残り、次回以降ログインする必要はありません。',
            style: pw.TextStyle(
              color: PdfColors.red,
              font: ttf,
              fontSize: 10,
            ),
          ),
          pw.Text(
            'ただスマホを変えた場合は、再度ログインが必要になります。',
            style: pw.TextStyle(
              color: PdfColors.red,
              font: ttf,
              fontSize: 10,
            ),
          ),
        ],
      ),
    ));
    final fileName = '${user.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  pw.Widget _generateCell({
    required String label,
    required pw.TextStyle style,
    PdfColor? color,
    double? width,
    double? height,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(label, style: style),
      color: color,
      width: width,
      height: height,
    );
  }

  Future _pdfWebDownload({
    required pw.Document pdf,
    required String fileName,
  }) async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..download = fileName;
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
