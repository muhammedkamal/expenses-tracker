import 'package:flutter/material.dart';

import 'package:expenses_tracker/models/transction.dart';
import 'package:expenses_tracker/widgets/transction_item.dart';

class TransctionList extends StatelessWidget {
  final List<Transction> transctions;
  final Function deleteTx;
  const TransctionList(this.transctions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transctions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'There is Now Transctions Yet!',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraints.maxHeight * .7,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              Transction transction = transctions[index];
              return TransctionItem(
                deleteTx: deleteTx,
                transction: transction,
              );
            },
            itemCount: transctions.length,
          );
  }
}

/* Card(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "${transctions[index].amount.toStringAsFixed(2)} \$",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transctions[index].title,
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            DateFormat.yMMMd().format(transctions[index].date),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ) */
