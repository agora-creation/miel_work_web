import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/loan.dart';

class LoanCard extends StatelessWidget {
  final LoanModel loan;
  final Function()? onTap;

  const LoanCard({
    required this.loan,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 500,
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      loan.itemImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Table(
                    border: TableBorder.all(color: kBlackColor),
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('品名'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(loan.itemName),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('貸出日'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(dateText('yyyy/MM/dd', loan.loanAt)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('貸出先'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(loan.loanUser),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('貸出先(会社)'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(loan.loanCompany),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('対応スタッフ'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(loan.loanStaff),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('返却予定日'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child:
                                Text(dateText('yyyy/MM/dd', loan.returnPlanAt)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
