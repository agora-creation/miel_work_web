import 'package:flutter/services.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/apply_conference.dart';
import 'package:miel_work_web/models/apply_proposal.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

const kPdfFontUrl = 'assets/fonts/GenShinGothic-Regular.ttf';

class PdfService {
  Future applyProposalDownload(ApplyProposalModel proposal) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    String approvalUserNameText = '';
    if (proposal.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel approvalUser in proposal.approvalUsers) {
        if (approvalUserNameText != '') approvalUserNameText += ',';
        approvalUserNameText += approvalUser.userName;
        approvalUserNameText +=
            '(${dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt)})';
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
              '稟議書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 16,
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
                  '提出日時: ${dateText('yyyy/MM/dd HH:mm', proposal.createdAt)}',
                  style: pw.TextStyle(
                    font: ttf,
                    color: PdfColors.grey,
                    fontSize: 12,
                  ),
                ),
                proposal.approval
                    ? pw.Text(
                        '承認日時: ${dateText('yyyy/MM/dd HH:mm', proposal.approvedAt)}',
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.grey,
                          fontSize: 12,
                        ),
                      )
                    : pw.Container(),
                pw.Text(
                  '作成者: ${proposal.createdUserName}',
                  style: pw.TextStyle(
                    font: ttf,
                    color: PdfColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
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
                    width: 20,
                    height: 100,
                  ),
                  _generateCell(
                    label: approvalUserNameText,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 100,
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
                      fontSize: 10,
                    ),
                    width: 20,
                  ),
                  _generateCell(
                    label: proposal.title,
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
                    label: '金額',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    width: 20,
                  ),
                  _generateCell(
                    label: '¥ ${proposal.formatPrice()}',
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
                    label: '内容',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    width: 20,
                    height: 500,
                  ),
                  _generateCell(
                    label: proposal.content,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 500,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future applyConferenceDownload(ApplyConferenceModel conference) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    String approvalUserNameText = '';
    if (conference.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel approvalUser in conference.approvalUsers) {
        if (approvalUserNameText != '') approvalUserNameText += ',';
        approvalUserNameText += approvalUser.userName;
        approvalUserNameText +=
            '(${dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt)})';
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
              '協議書',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 16,
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
                  '提出日時: ${dateText('yyyy/MM/dd HH:mm', conference.createdAt)}',
                  style: pw.TextStyle(
                    font: ttf,
                    color: PdfColors.grey,
                    fontSize: 12,
                  ),
                ),
                conference.approval
                    ? pw.Text(
                        '承認日時: ${dateText('yyyy/MM/dd HH:mm', conference.approvedAt)}',
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors.grey,
                          fontSize: 12,
                        ),
                      )
                    : pw.Container(),
                pw.Text(
                  '作成者: ${conference.createdUserName}',
                  style: pw.TextStyle(
                    font: ttf,
                    color: PdfColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
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
                    width: 20,
                    height: 100,
                  ),
                  _generateCell(
                    label: approvalUserNameText,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 100,
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
                      fontSize: 10,
                    ),
                    width: 20,
                  ),
                  _generateCell(
                    label: conference.title,
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
                    label: '内容',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    width: 20,
                    height: 500,
                  ),
                  _generateCell(
                    label: conference.content,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                    color: PdfColors.white,
                    height: 500,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    final fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.pdf';
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
      padding: const pw.EdgeInsets.all(8),
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
