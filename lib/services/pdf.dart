import 'package:flutter/services.dart';
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
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

const kPdfFontUrl = 'assets/fonts/GenShinGothic-Regular.ttf';

class PdfService {
  Future reportDownload(ReportModel report) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final commonStyle = pw.TextStyle(
      font: ttf,
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(16),
      pageFormat: PdfPageFormat.a3,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '04/02(水)の日報',
              style: commonStyle,
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
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '出勤者',
                          style: commonStyle,
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
                          style: commonStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '営繕ヶ所等',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'クレーム／要望等',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'パンフレット',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '備品発注・入荷',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'その他報告・連絡',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '申送事項',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '最終確認チェック',
                style: commonStyle,
              ),
              pw.SizedBox(height: 16),
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
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'クレーム／要望',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
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
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '取材申込書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
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
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'よさこい広場使用申込書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
        ],
      ),
    ));
    final fileName = '${square.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestFacilityDownload(RequestFacilityModel facility) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '施設使用申込書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
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
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '自転車置き場使用申込書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
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
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '夜間居残り作業申請書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
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
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '店舗工事作業申請書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
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
