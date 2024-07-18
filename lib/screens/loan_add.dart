// import 'package:file_picker/file_picker.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:miel_work_web/common/custom_date_time_picker.dart';
// import 'package:miel_work_web/common/functions.dart';
// import 'package:miel_work_web/common/style.dart';
// import 'package:miel_work_web/providers/home.dart';
// import 'package:miel_work_web/providers/loan.dart';
// import 'package:miel_work_web/providers/login.dart';
// import 'package:miel_work_web/widgets/custom_button_sm.dart';
// import 'package:miel_work_web/widgets/custom_text_box.dart';
// import 'package:provider/provider.dart';
//
// class LoanAddScreen extends StatefulWidget {
//   final LoginProvider loginProvider;
//   final HomeProvider homeProvider;
//
//   const LoanAddScreen({
//     required this.loginProvider,
//     required this.homeProvider,
//     super.key,
//   });
//
//   @override
//   State<LoanAddScreen> createState() => _LoanAddScreenState();
// }
//
// class _LoanAddScreenState extends State<LoanAddScreen> {
//   DateTime loanAt = DateTime.now();
//   TextEditingController loanUserController = TextEditingController();
//   TextEditingController loanCompanyController = TextEditingController();
//   TextEditingController loanStaffController = TextEditingController();
//   DateTime returnPlanAt = DateTime.now();
//   TextEditingController itemNameController = TextEditingController();
//   FilePickerResult? itemImageResult;
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
//                 '貸出を追加',
//                 style: TextStyle(fontSize: 16),
//               ),
//               CustomButtonSm(
//                 labelText: '追加する',
//                 labelColor: kWhiteColor,
//                 backgroundColor: kBlueColor,
//                 onPressed: () async {
//                   String? error = await loanProvider.create(
//                     organization: widget.loginProvider.organization,
//                     loanAt: loanAt,
//                     loanUser: loanUserController.text,
//                     loanCompany: loanCompanyController.text,
//                     loanStaff: loanStaffController.text,
//                     returnPlanAt: returnPlanAt,
//                     itemName: itemNameController.text,
//                     itemImageResult: itemImageResult,
//                     loginUser: widget.loginProvider.user,
//                   );
//                   if (error != null) {
//                     if (!mounted) return;
//                     showMessage(context, error, false);
//                     return;
//                   }
//                   if (!mounted) return;
//                   showMessage(context, '貸出を追加しました', true);
//                   Navigator.pop(context);
//                 },
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
//                       withData: true,
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
//                       : Container(
//                           color: kGrey300Color,
//                           width: double.infinity,
//                           height: 150,
//                           child: const Center(
//                             child: Text('写真が選択されていません'),
//                           ),
//                         ),
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
