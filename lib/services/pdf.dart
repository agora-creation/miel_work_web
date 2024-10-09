import 'package:flutter/services.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_interview.dart';
import 'package:miel_work_web/models/request_square.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

const kPdfFontUrl = 'assets/fonts/GenShinGothic-Regular.ttf';

class PdfService {
  Future requestInterviewDownload(RequestInterviewModel interview) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    String approvalUserNameText = '';
    if (interview.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel approvalUser in interview.approvalUsers) {
        if (approvalUserNameText != '') approvalUserNameText += '\n';
        approvalUserNameText +=
            '${dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt)}に『${approvalUser.userName}』が承認';
      }
    }
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(8),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '取材申込',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申請日時: ${dateText('yyyy/MM/dd HH:mm', interview.createdAt)}',
                style: pw.TextStyle(
                  font: ttf,
                  color: PdfColors.grey,
                  fontSize: 8,
                ),
              ),
              interview.approval == 1
                  ? pw.Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', interview.approvedAt)}',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                      ),
                    )
                  : pw.Container(),
            ],
          ),
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
                    label: '承認者一覧',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 60,
                  ),
                  _generateCell(
                    label: approvalUserNameText,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 60,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
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
                    label: '会社名',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.companyName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '担当者',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label:
                        '${interview.companyUserName} (EMAIL:${interview.companyUserEmail}) (TEL:${interview.companyUserTel})',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '媒体名',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.mediaName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '番組・雑誌名',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.programName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '出演者情報',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.castInfo,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '特集内容・備考',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: interview.featureContent,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
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
                    label: 'OA・掲載予定日',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.featureContent,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '取材当日情報',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 8,
            ),
          ),
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
                    label: '予定日時',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.interviewedAt,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '担当者',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label:
                        '${interview.interviewedUserName} (TEL:${interview.interviewedUserTel})',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '取材時間',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.interviewedTime,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '席の予約',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.interviewedReserved ? '必要' : '',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '取材店舗',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.interviewedShopName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '訪問人数',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.interviewedVisitors,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '取材内容・備考',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: interview.interviewedContent,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'ロケハン情報',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 8,
            ),
          ),
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
                    label: '予定日時',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.locationAt,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '担当者',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label:
                        '${interview.locationUserName} (TEL:${interview.locationUserTel})',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '訪問人数',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.locationVisitors,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: 'ロケハン内容・備考',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: interview.locationContent,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'インサート撮影情報',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 8,
            ),
          ),
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
                    label: '予定日時',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.insertedAt,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '担当者',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label:
                        '${interview.insertedUserName} (TEL:${interview.insertedUserTel})',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '撮影時間',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.insertedTime,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '席の予約',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.insertedReserved ? '必要' : '',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '取材店舗',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.insertedShopName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '訪問人数',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: interview.insertedVisitors,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '撮影内容・備考',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: interview.insertedContent,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
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
                    label: 'その他連絡事項',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: interview.remarks,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
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
    final fileName = '${interview.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestSquareDownload(RequestSquareModel square) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    String approvalUserNameText = '';
    if (square.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel approvalUser in square.approvalUsers) {
        if (approvalUserNameText != '') approvalUserNameText += '\n';
        approvalUserNameText +=
            '${dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt)}に『${approvalUser.userName}』が承認';
      }
    }
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(8),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'よさこい広場使用申込',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '申請日時: ${dateText('yyyy/MM/dd HH:mm', square.createdAt)}',
                style: pw.TextStyle(
                  font: ttf,
                  color: PdfColors.grey,
                  fontSize: 8,
                ),
              ),
              square.approval == 1
                  ? pw.Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', square.approvedAt)}',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                      ),
                    )
                  : pw.Container(),
            ],
          ),
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
                    label: '承認者一覧',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 60,
                  ),
                  _generateCell(
                    label: approvalUserNameText,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 60,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
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
                    label: '申込会社名(又は店名)',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: square.companyName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '申込担当者',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label:
                        '${square.companyUserName} (EMAIL:${square.companyUserEmail}) (TEL:${square.companyUserTel})',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '住所',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: square.companyAddress,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '使用者情報(上記と異なる場合のみ入力)',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 8,
            ),
          ),
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
                    label: '使用会社名(又は店名)',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: square.useName,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '使用担当者',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: '${square.useUserName} (TEL:${square.useUserTel})',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '使用情報',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 8,
            ),
          ),
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
                    label: '使用期間',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: square.usePeriod,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '使用時間帯',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: square.useTimezone,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '使用区分',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 20,
                  ),
                  _generateCell(
                    label: '',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 20,
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  _generateCell(
                    label: '使用内容',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: square.useContent,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    color: PdfColors.white,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 4),
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
                    label: 'その他連絡事項',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
                    ),
                    height: 50,
                  ),
                  _generateCell(
                    label: square.remarks,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 8,
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
    final fileName = '${square.id}.pdf';
    await _pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future requestFacilityDownload() async {}

  Future requestCycleDownload() async {}

  Future requestOvertimeDownload() async {}

  Future requestConstDownload() async {}

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
