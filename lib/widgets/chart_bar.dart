import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount, spendingPrecentage;
  String _fixedShapedAmount(double spendingAmount) {
    if (spendingAmount >= 1000000000)
      return (spendingAmount / 1000000000).toStringAsFixed(0) + 'B';
    else if (spendingAmount >= 1000000)
      return (spendingAmount / 1000000).toStringAsFixed(0) + 'M';
    else if (spendingAmount >= 1000)
      return (spendingAmount / 1000).toStringAsFixed(0) + 'K';
    else
      return (spendingAmount).toStringAsFixed(2);
  }

  ChartBar({this.label, this.spendingAmount, this.spendingPrecentage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Column(
        children: [
          Container(
            height: constrains.maxHeight * .15,
            child: FittedBox(
              child: Text(
                '${_fixedShapedAmount(spendingAmount)}\$',
              ),
            ),
          ),
          SizedBox(
            height: constrains.maxHeight * .05,
          ),
          Container(
            height: constrains.maxHeight * .6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPrecentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constrains.maxHeight * .05,
          ),
          Container(
            height: constrains.maxHeight * .15,
            child: FittedBox(
              child: Text(
                label,
              ),
            ),
          ),
        ],
      );
    });
  }
}
