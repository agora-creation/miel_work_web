import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/stock.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/stock.dart';
import 'package:miel_work_web/screens/stock_source.dart';
import 'package:miel_work_web/services/stock.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StockScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const StockScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  StockService stockService = StockService();
  int searchCategory = 0;

  void _getCategory() async {
    searchCategory = await getPrefsInt('category') ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    String searchCategoryText = '一般在庫';
    if (searchCategory == 1) {
      searchCategoryText = '資産';
    }
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '在庫品一覧',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CustomIconTextButton(
                      label: 'カテゴリ検索: $searchCategoryText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SearchCategoryDialog(
                          getCategory: _getCategory,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomIconTextButton(
                  label: '在庫品を追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddStockDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stockService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  category: searchCategory,
                ),
                builder: (context, snapshot) {
                  List<StockModel> stocks = [];
                  if (snapshot.hasData) {
                    stocks = stockService.generateList(data: snapshot.data);
                  }
                  return CustomDataGrid(
                    source: StockSource(
                      context: context,
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      stocks: stocks,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'category',
                        label: const CustomColumnLabel('カテゴリ'),
                        width: 150,
                      ),
                      GridColumn(
                        columnName: 'number',
                        label: const CustomColumnLabel('管理No'),
                        width: 150,
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: const CustomColumnLabel('品名'),
                        width: 300,
                      ),
                      GridColumn(
                        columnName: 'quantity',
                        label: const CustomColumnLabel('現在の在庫数'),
                      ),
                      GridColumn(
                        columnName: 'edit',
                        label: const CustomColumnLabel('操作'),
                        width: 200,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchCategoryDialog extends StatefulWidget {
  final Function() getCategory;

  const SearchCategoryDialog({
    required this.getCategory,
    super.key,
  });

  @override
  State<SearchCategoryDialog> createState() => _SearchCategoryDialogState();
}

class _SearchCategoryDialogState extends State<SearchCategoryDialog> {
  int category = 0;

  void _getCategory() async {
    category = await getPrefsInt('category') ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            RadioListTile(
              title: const Text('一般在庫'),
              value: 0,
              groupValue: category,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  category = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('資産'),
              value: 1,
              groupValue: category,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  category = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kSearchColor,
          onPressed: () async {
            await setPrefsInt('category', category);
            widget.getCategory();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddStockDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const AddStockDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  StockService stockService = StockService();
  int category = 0;
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '999');

  void _init() async {
    category = await getPrefsInt('category') ?? 0;
    numberController.text = await stockService.getLastNumber(
      organizationId: widget.loginProvider.organization?.id,
    );
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FormLabel(
            'カテゴリ',
            child: DropdownButton<int>(
              isExpanded: true,
              value: category,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text('一般在庫'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('資産'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  category = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '管理No',
            child: CustomTextField(
              controller: numberController,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '品名',
            child: CustomTextField(
              controller: nameController,
              textInputType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          category == 0
              ? FormLabel(
                  '最初の在庫数',
                  child: CustomTextField(
                    controller: quantityController,
                    textInputType: TextInputType.number,
                    maxLines: 1,
                  ),
                )
              : Container(),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await stockProvider.create(
              organization: widget.loginProvider.organization,
              category: category,
              number: numberController.text,
              name: nameController.text,
              quantity: int.parse(quantityController.text),
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫品が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
