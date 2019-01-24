import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUDOKU Game',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'SUDOKU Game'),
    );
  }
}

const double RADIUS_CORNER = 12;
const int VALUE_NONE = 0;

const int COUNT_ROW_SUB_TABLE = 3;
const int COUNT_COL_SUB_TABLE = 3;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SudokuSubTable {
  int indexRowInTable;
  int indexColInTable;
  List<List<int>> subTable;

  SudokuSubTable({this.indexRowInTable, this.indexColInTable});

  init() {
    subTable = List();
    for (int row = 1; row <= COUNT_ROW_SUB_TABLE; row++) {
      List<int> list = List();
      for (int col = 1; col <= COUNT_COL_SUB_TABLE; col++) {
        list.add(0);
      }
      subTable.add(list);
    }
  }

  int randomNumber() {
    Random r = Random();
    return r.nextInt(10);
  }
}

class SudokuTable {
  List<List<SudokuSubTable>> table;

  init() {
    table = List();
    for (int row = 0; row < COUNT_ROW_SUB_TABLE; row++) {
      List<SudokuSubTable> list = List();
      for (int col = 0; col < COUNT_COL_SUB_TABLE; col++) {
        SudokuSubTable subTable =
            SudokuSubTable(indexRowInTable: row, indexColInTable: col);
        subTable.init();
        list.add(subTable);
      }
      table.add(list);
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  /// Theme game
  ///
  Color colorBorderTable = Colors.white;
  Color colorBackgroundApp = Colors.blue[100];
  Color colorBackgroundChannelEmpty1 = Color(0xffe3e3e3);
  Color colorBackgroundChannelEmpty2 = Colors.white30;
  Color colorBackgroundNumberTab = Colors.white;
  Color colorTextNumber = Colors.white;
  Color colorBackgroundChannelValue = Colors.blue[700];

  SudokuTable sudokuTable;

  @override
  void initState() {
    initSudokuTable();
    super.initState();
  }

  void initSudokuTable() {
    sudokuTable = SudokuTable();
    sudokuTable.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            color: colorBackgroundApp,
            child: Column(children: <Widget>[
//              Container(
//                padding: EdgeInsets.only(top: 20),
//                constraints: BoxConstraints.expand(height: 120),
//                color: Colors.white,
//                child: Center(
//                    child: Text("",
//                        style: TextStyle(
//                          color: Colors.blue[700],
//                            fontSize: 36,
//                            fontWeight: FontWeight.bold))),
//                margin: EdgeInsets.only(bottom: 16),
//              ),
              Expanded(
                  child: Center(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: colorBorderTable,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.all(6),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                buildSubTable(sudokuTable.table[0][0],
                                    colorBackgroundChannelEmpty1),
                                buildSubTable(sudokuTable.table[0][1],
                                    colorBackgroundChannelEmpty2),
                                buildSubTable(sudokuTable.table[0][2],
                                    colorBackgroundChannelEmpty1),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                buildSubTable(sudokuTable.table[1][0],
                                    colorBackgroundChannelEmpty2),
                                buildSubTable(sudokuTable.table[1][1],
                                    colorBackgroundChannelEmpty1),
                                buildSubTable(sudokuTable.table[1][2],
                                    colorBackgroundChannelEmpty2),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                buildSubTable(sudokuTable.table[2][0],
                                    colorBackgroundChannelEmpty1),
                                buildSubTable(sudokuTable.table[2][1],
                                    colorBackgroundChannelEmpty2),
                                buildSubTable(sudokuTable.table[2][2],
                                    colorBackgroundChannelEmpty1),
                              ],
                            )
                          ]),
                    )
                  ]))),
              Container(
                  padding: EdgeInsets.all(12),
                  color: colorBackgroundNumberTab,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildNumberListTab()))
            ])));
  }

  Container buildSubTable(SudokuSubTable subTable, Color color) {
    return Container(
        padding: EdgeInsets.all(1),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRowChannel(subTable, 0, color)),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRowChannel(subTable, 1, color)),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRowChannel(subTable, 2, color))
        ]));
  }

  List<Widget> buildRowChannel(
      SudokuSubTable subTable, int rowChannel, Color color) {
    List<int> dataRowChanel = subTable.subTable[rowChannel];
    List<Widget> listWidget = List();
    for (int col = 0; col < 3; col++) {
      Widget widget = buildChannel(rowChannel, dataRowChanel[col], color,
          onNumberAccept: (data) {
        setState(() {
          sudokuTable.table[subTable.indexRowInTable][subTable.indexColInTable]
              .subTable[rowChannel][col] = data;
        });
      }, onRemove: () {
        setState(() {
          sudokuTable.table[subTable.indexRowInTable][subTable.indexColInTable]
              .subTable[rowChannel][col] = VALUE_NONE;
        });
      });
      listWidget.add(widget);
    }
    return listWidget;
  }

  Widget buildChannel(int rowChannel, int value, Color color,
      {Function(int) onNumberAccept, Function() onRemove}) {
    if (value == 0) {
      return DragTarget(builder: (BuildContext context, List<int> candidateData,
          List<dynamic> rejectedData) {
        return buildChannelEmpty();
      }, onWillAccept: (data) {
        return data >= 0 && data <= 9;
      }, onAccept: (data) {
        onNumberAccept(data);
      });
    } else {
      return Draggable(
        child: buildChannelValue(value),
        feedback: Material(
            type: MaterialType.transparency, child: buildChannelValue(value)),
        childWhenDragging: buildChannelEmpty(),
        onDragCompleted: () {
          onRemove();
        },
        data: value,
      );
    }
  }

  Container buildChannelEmpty() {
    return Container(
      margin: EdgeInsets.all(1),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: colorBackgroundChannelEmpty1,
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }

  Widget buildChannelValue(int value) {
    return Container(
      margin: EdgeInsets.all(1),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: colorBackgroundChannelValue,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Center(
          child: Text(value.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900))),
    );
  }

  List<Widget> buildNumberListTab() {
    List<Widget> listWidget = List();
    for (int i = 1; i <= 9; i++) {
      Widget widget = buildNumberBoxWithDraggable(i);
      listWidget.add(widget);
    }
    return listWidget;
  }

  Widget buildNumberBoxWithDraggable(int i) {
    return Draggable(
      child: buildNumberBox(i),
      feedback:
          Material(type: MaterialType.transparency, child: buildNumberBox(i)),
      data: i,
    );
  }

  Container buildNumberBox(int i) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: colorBackgroundChannelValue,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Text("$i",
            style: TextStyle(
                fontSize: 24,
                color: colorTextNumber,
                fontWeight: FontWeight.w900)));
  }
}
