// import 'package:file_picker/file_picker.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:miel_work_web/common/custom_date_time_picker.dart';
// import 'package:miel_work_web/common/functions.dart';
// import 'package:miel_work_web/common/style.dart';
// import 'package:miel_work_web/models/loan.dart';
// import 'package:miel_work_web/providers/home.dart';
// import 'package:miel_work_web/providers/loan.dart';
// import 'package:miel_work_web/providers/login.dart';
// import 'package:miel_work_web/widgets/custom_button_lg.dart';
// import 'package:miel_work_web/widgets/custom_button_sm.dart';
// import 'package:miel_work_web/widgets/custom_text_box.dart';
// import 'package:provider/provider.dart';
// import 'package:signature/signature.dart';
//
// class LoanModScreen extends StatefulWidget {
//   final LoginProvider loginProvider;
//   final HomeProvider homeProvider;
//   final LoanModel loan;
//
//   const LoanModScreen({
//     required this.loginProvider,
//     required this.homeProvider,
//     required this.loan,
//     super.key,
//   });
//
//   @override
//   State<LoanModScreen> createState() => _LoanModScreenState();
// }
//
// class _LoanModScreenState extends State<LoanModScreen> {
//   DateTime loanAt = DateTime.now();
//   TextEditingController loanUserController = TextEditingController();
//   TextEditingController loanCompanyController = TextEditingController();
//   TextEditingController loanStaffController = TextEditingController();
//   DateTime returnPlanAt = DateTime.now();
//   TextEditingController itemNameController = TextEditingController();
//   FilePickerResult? itemImageResult;
//
//   @override
//   void initState() {
//     super.initState();
//     loanAt = widget.loan.loanAt;
//     loanUserController.text = widget.loan.loanUser;
//     loanCompanyController.text = widget.loan.loanCompany;
//     loanStaffController.text = widget.loan.loanStaff;
//     returnPlanAt = widget.loan.returnPlanAt;
//     itemNameController.text = widget.loan.itemName;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final loanProvider = Provider.of<LoanProvider>(context);
//     return ScaffoldPage(
//       padding: EdgeInsets.zero,
//       header: Container(
//         decoration: kHeaderDecoration,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const Icon(FluentIcons.chevron_left),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               const Text(
//                 '貸出を編集',
//                 style: TextStyle(fontSize: 16),
//               ),
//               Row(
//                 children: [
//                   CustomButtonSm(
//                     labelText: '削除する',
//                     labelColor: kWhiteColor,
//                     backgroundColor: kRedColor,
//                     onPressed: () async {
//                       String? error = await loanProvider.delete(
//                         loan: widget.loan,
//                       );
//                       if (error != null) {
//                         if (!mounted) return;
//                         showMessage(context, error, false);
//                         return;
//                       }
//                       if (!mounted) return;
//                       showMessage(context, '貸出を削除しました', true);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   const SizedBox(width: 4),
//                   CustomButtonSm(
//                     labelText: '入力内容を保存',
//                     labelColor: kWhiteColor,
//                     backgroundColor: kBlueColor,
//                     onPressed: () async {
//                       String? error = await loanProvider.update(
//                         organization: widget.loginProvider.organization,
//                         loan: widget.loan,
//                         loanAt: loanAt,
//                         loanUser: loanUserController.text,
//                         loanCompany: loanCompanyController.text,
//                         loanStaff: loanStaffController.text,
//                         returnPlanAt: returnPlanAt,
//                         itemName: itemNameController.text,
//                         itemImageResult: itemImageResult,
//                         loginUser: widget.loginProvider.user,
//                       );
//                       if (error != null) {
//                         if (!mounted) return;
//                         showMessage(context, error, false);
//                         return;
//                       }
//                       if (!mounted) return;
//                       showMessage(context, '貸出を編集しました', true);
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       content: Container(
//         color: kWhiteColor,
//         padding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 200,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: InfoLabel(
//                       label: '貸出日',
//                       child: Button(
//                         child: Padding(
//                           padding: const EdgeInsets.all(3),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(dateText('yyyy/MM/dd', loanAt)),
//                               const Icon(FluentIcons.calendar),
//                             ],
//                           ),
//                         ),
//                         onPressed: () async {
//                           await CustomDateTimePicker().picker(
//                             context: context,
//                             init: loanAt,
//                             title: '貸出日を選択',
//                             onChanged: (value) {
//                               setState(() {
//                                 loanAt = value;
//                               });
//                             },
//                             datetime: false,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(child: Container()),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: InfoLabel(
//                       label: '貸出先',
//                       child: CustomTextBox(
//                         controller: loanUserController,
//                         placeholder: '',
//                         keyboardType: TextInputType.text,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: InfoLabel(
//                       label: '貸出先(会社)',
//                       child: CustomTextBox(
//                         controller: loanCompanyController,
//                         placeholder: '',
//                         keyboardType: TextInputType.text,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: InfoLabel(
//                       label: '対応スタッフ',
//                       child: CustomTextBox(
//                         controller: loanStaffController,
//                         placeholder: '',
//                         keyboardType: TextInputType.text,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: InfoLabel(
//                       label: '返却予定日',
//                       child: Button(
//                         child: Padding(
//                           padding: const EdgeInsets.all(3),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(dateText('yyyy/MM/dd', returnPlanAt)),
//                               const Icon(FluentIcons.calendar),
//                             ],
//                           ),
//                         ),
//                         onPressed: () async {
//                           await CustomDateTimePicker().picker(
//                             context: context,
//                             init: returnPlanAt,
//                             title: '返却予定日を選択',
//                             onChanged: (value) {
//                               setState(() {
//                                 returnPlanAt = value;
//                               });
//                             },
//                             datetime: false,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               InfoLabel(
//                 label: '品名',
//                 child: CustomTextBox(
//                   controller: itemNameController,
//                   placeholder: '',
//                   keyboardType: TextInputType.text,
//                   maxLines: 1,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               InfoLabel(
//                 label: '添付写真',
//                 child: GestureDetector(
//                   onTap: () async {
//                     final result = await FilePicker.platform.pickFiles(
//                       type: FileType.image,
//                     );
//                     setState(() {
//                       itemImageResult = result;
//                     });
//                   },
//                   child: itemImageResult != null
//                       ? Image.memory(
//                           itemImageResult!.files.first.bytes!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                         )
//                       : widget.loan.itemImage != ''
//                           ? Image.network(
//                               widget.loan.itemImage,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                             )
//                           : Container(
//                               color: kGrey300Color,
//                               width: double.infinity,
//                               height: 150,
//                               child: const Center(
//                                 child: Text('写真が選択されていません'),
//                               ),
//                             ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               CustomButtonLg(
//                 labelText: '返却する',
//                 labelColor: kBlackColor,
//                 backgroundColor: kOrange300Color,
//                 onPressed: () => showDialog(
//                   context: context,
//                   builder: (context) => ReturnLoanDialog(
//                     loginProvider: widget.loginProvider,
//                     homeProvider: widget.homeProvider,
//                     loan: widget.loan,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ReturnLoanDialog extends StatefulWidget {
//   final LoginProvider loginProvider;
//   final HomeProvider homeProvider;
//   final LoanModel loan;
//
//   const ReturnLoanDialog({
//     required this.loginProvider,
//     required this.homeProvider,
//     required this.loan,
//     super.key,
//   });
//
//   @override
//   State<ReturnLoanDialog> createState() => _ReturnLoanDialogState();
// }
//
// class _ReturnLoanDialogState extends State<ReturnLoanDialog> {
//   DateTime returnAt = DateTime.now();
//   TextEditingController returnUserController = TextEditingController();
//   SignatureController signImageController = SignatureController(
//     penStrokeWidth: 1,
//     penColor: kBlackColor,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final loanProvider = Provider.of<LoanProvider>(context);
//     return ContentDialog(
//       constraints: const BoxConstraints(maxWidth: 800),
//       title: const Text(
//         'この貸出を返却する',
//         style: TextStyle(fontSize: 18),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InfoLabel(
//               label: '返却日',
//               child: Button(
//                 child: Padding(
//                   padding: const EdgeInsets.all(3),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(dateText('yyyy/MM/dd', returnAt)),
//                       const Icon(FluentIcons.calendar),
//                     ],
//                   ),
//                 ),
//                 onPressed: () async {
//                   await CustomDateTimePicker().picker(
//                     context: context,
//                     init: returnAt,
//                     title: '返却日を選択',
//                     onChanged: (value) {
//                       setState(() {
//                         returnAt = value;
//                       });
//                     },
//                     datetime: false,
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             InfoLabel(
//               label: '返却スタッフ',
//               child: CustomTextBox(
//                 controller: returnUserController,
//                 placeholder: '',
//                 keyboardType: TextInputType.text,
//                 maxLines: 1,
//               ),
//             ),
//             const SizedBox(height: 8),
//             InfoLabel(
//               label: '署名',
//               child: Signature(
//                 controller: signImageController,
//                 backgroundColor: kWhiteColor,
//                 width: 800,
//                 height: 200,
//               ),
//             ),
//             CustomButtonSm(
//               labelText: '書き直す',
//               labelColor: kBlackColor,
//               backgroundColor: kGrey300Color,
//               onPressed: () => signImageController.clear(),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         CustomButtonSm(
//           labelText: 'キャンセル',
//           labelColor: kWhiteColor,
//           backgroundColor: kGreyColor,
//           onPressed: () => Navigator.pop(context),
//         ),
//         CustomButtonSm(
//           labelText: '返却する',
//           labelColor: kWhiteColor,
//           backgroundColor: kRedColor,
//           onPressed: () async {
//             String? error = await loanProvider.updateReturn(
//               organization: widget.loginProvider.organization,
//               loan: widget.loan,
//               returnAt: returnAt,
//               returnUser: returnUserController.text,
//               signImageController: signImageController,
//               loginUser: widget.loginProvider.user,
//             );
//             if (error != null) {
//               if (!mounted) return;
//               showMessage(context, error, false);
//               return;
//             }
//             if (!mounted) return;
//             showMessage(context, '返却しました', true);
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//         ),
//       ],
//     );
//   }
// }
