// import 'package:file_picker/file_picker.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:miel_work_web/common/custom_date_time_picker.dart';
// import 'package:miel_work_web/common/functions.dart';
// import 'package:miel_work_web/common/style.dart';
// import 'package:miel_work_web/models/lost.dart';
// import 'package:miel_work_web/providers/home.dart';
// import 'package:miel_work_web/providers/login.dart';
// import 'package:miel_work_web/providers/lost.dart';
// import 'package:miel_work_web/widgets/custom_button_lg.dart';
// import 'package:miel_work_web/widgets/custom_button_sm.dart';
// import 'package:miel_work_web/widgets/custom_text_box.dart';
// import 'package:provider/provider.dart';
// import 'package:signature/signature.dart';
//
// class LostModScreen extends StatefulWidget {
//   final LoginProvider loginProvider;
//   final HomeProvider homeProvider;
//   final LostModel lost;
//
//   const LostModScreen({
//     required this.loginProvider,
//     required this.homeProvider,
//     required this.lost,
//     super.key,
//   });
//
//   @override
//   State<LostModScreen> createState() => _LostModScreenState();
// }
//
// class _LostModScreenState extends State<LostModScreen> {
//   DateTime discoveryAt = DateTime.now();
//   TextEditingController discoveryPlaceController = TextEditingController();
//   TextEditingController discoveryUserController = TextEditingController();
//   TextEditingController itemNameController = TextEditingController();
//   FilePickerResult? itemImageResult;
//   TextEditingController remarksController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     discoveryAt = widget.lost.discoveryAt;
//     discoveryPlaceController.text = widget.lost.discoveryPlace;
//     discoveryUserController.text = widget.lost.discoveryUser;
//     itemNameController.text = widget.lost.itemName;
//     remarksController.text = widget.lost.remarks;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final lostProvider = Provider.of<LostProvider>(context);
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
//                 '落とし物を編集',
//                 style: TextStyle(fontSize: 16),
//               ),
//               Row(
//                 children: [
//                   CustomButtonSm(
//                     labelText: '削除する',
//                     labelColor: kWhiteColor,
//                     backgroundColor: kRedColor,
//                     onPressed: () async {
//                       String? error = await lostProvider.delete(
//                         lost: widget.lost,
//                       );
//                       if (error != null) {
//                         if (!mounted) return;
//                         showMessage(context, error, false);
//                         return;
//                       }
//                       if (!mounted) return;
//                       showMessage(context, '落とし物を削除しました', true);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   const SizedBox(width: 4),
//                   CustomButtonSm(
//                     labelText: '入力内容を保存',
//                     labelColor: kWhiteColor,
//                     backgroundColor: kBlueColor,
//                     onPressed: () async {
//                       String? error = await lostProvider.update(
//                         organization: widget.loginProvider.organization,
//                         lost: widget.lost,
//                         discoveryAt: discoveryAt,
//                         discoveryPlace: discoveryPlaceController.text,
//                         discoveryUser: discoveryUserController.text,
//                         itemName: itemNameController.text,
//                         itemImageResult: itemImageResult,
//                         remarks: remarksController.text,
//                         loginUser: widget.loginProvider.user,
//                       );
//                       if (error != null) {
//                         if (!mounted) return;
//                         showMessage(context, error, false);
//                         return;
//                       }
//                       if (!mounted) return;
//                       showMessage(context, '落とし物を編集しました', true);
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
//                       label: '発見日',
//                       child: Button(
//                         child: Padding(
//                           padding: const EdgeInsets.all(3),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(dateText('yyyy/MM/dd', discoveryAt)),
//                               const Icon(FluentIcons.calendar),
//                             ],
//                           ),
//                         ),
//                         onPressed: () async {
//                           await CustomDateTimePicker().picker(
//                             context: context,
//                             init: discoveryAt,
//                             title: '発見日を選択',
//                             onChanged: (value) {
//                               setState(() {
//                                 discoveryAt = value;
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
//                       label: '発見場所',
//                       child: CustomTextBox(
//                         controller: discoveryPlaceController,
//                         placeholder: '',
//                         keyboardType: TextInputType.text,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: InfoLabel(
//                       label: '発見者',
//                       child: CustomTextBox(
//                         controller: discoveryUserController,
//                         placeholder: '',
//                         keyboardType: TextInputType.text,
//                         maxLines: 1,
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
//                       : widget.lost.itemImage != ''
//                           ? Image.network(
//                               widget.lost.itemImage,
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
//               const SizedBox(height: 8),
//               InfoLabel(
//                 label: '備考',
//                 child: CustomTextBox(
//                   controller: remarksController,
//                   placeholder: '',
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 10,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               CustomButtonLg(
//                 labelText: '返却する',
//                 labelColor: kBlackColor,
//                 backgroundColor: kOrange300Color,
//                 onPressed: () => showDialog(
//                   context: context,
//                   builder: (context) => ReturnLostDialog(
//                     loginProvider: widget.loginProvider,
//                     homeProvider: widget.homeProvider,
//                     lost: widget.lost,
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
// class ReturnLostDialog extends StatefulWidget {
//   final LoginProvider loginProvider;
//   final HomeProvider homeProvider;
//   final LostModel lost;
//
//   const ReturnLostDialog({
//     required this.loginProvider,
//     required this.homeProvider,
//     required this.lost,
//     super.key,
//   });
//
//   @override
//   State<ReturnLostDialog> createState() => _ReturnLostDialogState();
// }
//
// class _ReturnLostDialogState extends State<ReturnLostDialog> {
//   DateTime returnAt = DateTime.now();
//   TextEditingController returnUserController = TextEditingController();
//   SignatureController signImageController = SignatureController(
//     penStrokeWidth: 1,
//     penColor: kBlackColor,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final lostProvider = Provider.of<LostProvider>(context);
//     return ContentDialog(
//       constraints: const BoxConstraints(maxWidth: 800),
//       title: const Text(
//         'この落とし物を返却する',
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
//             String? error = await lostProvider.updateReturn(
//               organization: widget.loginProvider.organization,
//               lost: widget.lost,
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
