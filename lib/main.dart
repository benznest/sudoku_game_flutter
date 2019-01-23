import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUDOKU Game',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'SUDOKU Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const double RADIUS_CORNER = 12;
  static const int CORNER_NONE = 0;
  static const int CORNER_TOP_LEFT = 1;
  static const int CORNER_TOP_RIGHT = 2;
  static const int CORNER_BOTTOM_LEFT = 3;
  static const int CORNER_BOTTOM_RIGHT = 4;


  /// Theme game
  Color colorBorder = Colors.pink[600];
  Color colorBackground = Colors.yellow[100];
  Color colorBackground2 = Colors.yellow[200];

  Color colorBackgroundSubTable1 = Colors.pink[100];
  Color colorBackgroundSubTable2 = Colors.pink[200];
  Color colorBackgroundNumberTab = Colors.pink[400];
  Color colorTextNumber = Colors.white;
  Color colorBackgroundNumberBox = Colors.yellow[700];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(constraints: BoxConstraints.expand(),
            color: colorBackground,
            child: Column(children: <Widget>[
              Expanded(child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: colorBorder,
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
                                    buildSubTable(CORNER_TOP_LEFT, colorBackgroundSubTable1),
                                    buildSubTable(CORNER_NONE, colorBackgroundSubTable2),
                                    buildSubTable(CORNER_TOP_RIGHT, colorBackgroundSubTable1),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    buildSubTable(CORNER_NONE, colorBackgroundSubTable2),
                                    buildSubTable(CORNER_NONE, colorBackgroundSubTable1),
                                    buildSubTable(CORNER_NONE, colorBackgroundSubTable2),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    buildSubTable(CORNER_BOTTOM_LEFT, colorBackgroundSubTable1),
                                    buildSubTable(CORNER_NONE, colorBackgroundSubTable2),
                                    buildSubTable(CORNER_BOTTOM_RIGHT, colorBackgroundSubTable1),
                                  ],
                                )
                              ]),
                        )
                      ]
                  )
              )),
              Container(padding: EdgeInsets.all(12), color: colorBackgroundNumberTab,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildNumberListTab()))
            ])
        )
    );
  }

  Container buildSubTable(int corner, Color color) {
    int cornerRow1 = CORNER_NONE;
    int cornerRow2 = CORNER_NONE;
    int cornerRow3 = CORNER_NONE;

    if (corner == CORNER_TOP_LEFT) {
      cornerRow1 = CORNER_TOP_LEFT;
    } else if (corner == CORNER_TOP_RIGHT) {
      cornerRow1 = CORNER_TOP_RIGHT;
    } else if (corner == CORNER_BOTTOM_LEFT) {
      cornerRow3 = CORNER_BOTTOM_LEFT;
    } else if (corner == CORNER_BOTTOM_RIGHT) {
      cornerRow3 = CORNER_BOTTOM_RIGHT;
    }

    return Container(
        padding: EdgeInsets.all(1),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildRowChannel(cornerRow1, color)),
              Row(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildRowChannel(cornerRow2, color)),
              Row(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildRowChannel(cornerRow3, color))
            ]));
  }

  List<Widget> buildRowChannel(int corner, Color color) {
    List<Widget> listWidget = List();
    for (int col = 0; col < 3; col++) {
      double tlRadius = corner == CORNER_TOP_LEFT && col == 0 ? RADIUS_CORNER : 0;
      double trRadius = corner == CORNER_TOP_RIGHT && col == 2 ? RADIUS_CORNER : 0;
      double blRadius = corner == CORNER_BOTTOM_LEFT && col == 0 ? RADIUS_CORNER : 0;
      double brRadius = corner == CORNER_BOTTOM_RIGHT && col == 2 ? RADIUS_CORNER : 0;
      Widget widget = buildChannel(
          corner,
          col,
          tlRadius,
          trRadius,
          blRadius,
          brRadius,
          color);
      listWidget.add(widget);
    }
    return listWidget;
  }

  Widget buildChannel(int row,
      int col,
      double tlRadius,
      double trRadius,
      double blRadius,
      double brRadius,
      Color color) =>
      GestureDetector(onTap: () {},
          child: Container(
            margin: EdgeInsets.all(1),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(tlRadius),
                    topRight: Radius.circular(trRadius),
                    bottomLeft: Radius.circular(blRadius),
                    bottomRight: Radius.circular(brRadius)
                )),
          ));

  List<Widget> buildNumberListTab() {
    List<Widget> listWidget = List();
    for (int i = 0; i <= 9; i++) {
      Widget widget = Container(
          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(color: colorBackgroundNumberBox,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Text("$i", style: TextStyle(
              fontSize: 20,
              color: colorTextNumber)));
      listWidget.add(widget);
    }
    return listWidget;
  }

}