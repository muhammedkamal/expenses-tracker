import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expenses_tracker/models/transction.dart';

class TransctionItem extends StatelessWidget {
  final Transction transction;
  final Function deleteTx;
  const TransctionItem({this.deleteTx, this.transction});
  String _fixedShapedAmount(double spendingAmount) {
    if (spendingAmount >= 1000000000)
      return (spendingAmount / 1000000000).toStringAsFixed(2) + 'B';
    else if (spendingAmount >= 1000000)
      return (spendingAmount / 1000000).toStringAsFixed(2) + 'M';
    else if (spendingAmount >= 1000)
      return (spendingAmount / 1000).toStringAsFixed(2) + 'K';
    else
      return (spendingAmount).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                "${_fixedShapedAmount(transction.amount)} \$",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        title: Text(
          transction.title,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.left,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transction.date),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                label: const Text('Delete'),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => deleteTx(transction.id),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => deleteTx(transction.id),
              ),
      ),
    );
  }
}
