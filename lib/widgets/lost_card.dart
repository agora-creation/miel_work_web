import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/lost.dart';

class LostCard extends StatelessWidget {
  final LostModel lost;
  final Function()? onTap;

  const LostCard({
    required this.lost,
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
                      lost.itemImage,
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
                            child: Text(lost.itemName),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('発見日'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child:
                                Text(dateText('yyyy/MM/dd', lost.discoveryAt)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('発見場所'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(lost.discoveryPlace),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('発見者'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(lost.discoveryUser),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('備考'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(lost.remarks),
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
