import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expenses_tracker/models/transction.dart';
import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/new_transction.dart';
import 'package:expenses_tracker/widgets/transctions_list.dart';

void main() {
  // this is a lazy work but you may need this
  /*  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          headline4: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.amber,
          ),
          bodyText1: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.amber,
          ),
          bodyText2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
          ),
        ),
        appBarTheme: AppBarTheme(
            textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transction> _userTransctions = [
    Transction(
      id: 't1',
      title: 'new shoes',
      date: DateTime.now(),
      amount: 25.5,
    ),
    Transction(
      id: 't2',
      title: 'grocy',
      date: DateTime.now(),
      amount: 50.5,
    ),
  ];
  List<Transction> get _recentTransctions {
    return _userTransctions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transction(
      amount: txAmount,
      title: txTitle,
      date: choosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransctions.add(newTx);
    });
  }

  void _showNewTransctionCard(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransction),
          );
        });
  }

  void _deleteTransction(String transctionId) {
    setState(() {
      _userTransctions.removeWhere((tx) => tx.id == transctionId);
    });
  }

  List<Widget> _buildLandscape(
      {MediaQueryData mediaQuery, AppBar appBar, Widget txList}) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransctions),
            )
          : txList
    ];
  }

  List<Widget> _buildPortrait({
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txList,
  }) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransctions),
      ),
      txList,
    ];
  }

  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? iosAppBar(context) : androidAppBar(context);
    Container txList(BuildContext context, AppBar appBar) {
      return Container(
        child: TransctionList(_userTransctions, _deleteTransction),
        height: (mediaQuery.size.height -
                mediaQuery.padding.top -
                appBar.preferredSize.height) *
            .7,
      );
    }

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscape(
                  mediaQuery: mediaQuery,
                  appBar: appBar,
                  txList: txList(context, appBar)),
            if (!isLandscape)
              ..._buildPortrait(
                  mediaQuery: mediaQuery,
                  appBar: appBar,
                  txList: txList(context, appBar)),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _showNewTransctionCard(context),
                  ),
          );
  }

  AppBar androidAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showNewTransctionCard(context),
        ),
      ],
    );
  }

  CupertinoNavigationBar iosAppBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: const Icon(CupertinoIcons.add),
            onTap: () => _showNewTransctionCard(context),
          ),
        ],
      ),
    );
  }
}
