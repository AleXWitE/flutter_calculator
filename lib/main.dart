import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: CalculatorApp(title: 'Flutter Calculator App'),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  CalculatorApp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  var x = -1;
  var y = -1;
  String operator = "";
  var result = "";
  String _emptyX = "";
  String _emptyY = "";
  List<String> items = [
    "C", "CE", "0", "/",
    "7", "8", "9", "*",
    "4", "5", "6", "-",
    "1", "2", "3", "+"
  ];

  _CalculateResult(int _x, String _operator, int _y) {
    var _result;
    switch (_operator) {
      case '+':
        _result = _x + _y;
        break;
      case '-':
        _result = _x - _y;
        break;
      case '*':
        _result = _x * _y;
        break;
      case '/':
        if (_x == 0)
          _result = 0;
        else if (_y == 0)
          _result = double.infinity;
        else
          _result = _x / _y;
        break;
    }
    setState(() {
      result = _result.toString();
    });
  }

  _onPressedResult() {
    int _x = x;
    if (y == -1)
      y = x;
    else
      y = int.parse(result);

    int _result = int.parse(result);
    if (_x == -1 || _x == 0)
      setState(() {});
    else if (_x != -1 || _x != 0) {
      setState(() {
        y = _result;
      });
    }
    if(operator == "")
      setState(() {
        _x = int.parse(result);
        x = _x;
        operator = "*";
        y = x;
      });

    _CalculateResult(_x, operator, y);
  }

  _onCleanResult() {
    setState(() {
      result = "";
    });
  }

  _onPressedOperator(String _operator) {
    setState(() {
      if (result != "") {
        if (x == -1 && y == -1)
          x = int.parse(result);
        else if (x != -1 && y == -1)
          y = int.parse(result);
        else
          x = int.parse(result);
      }
      if (x != 1 && y != -1) y = -1;
      result = "";
      operator = _operator;
    });
  }

  _onPressedButton(int value) {
    if (result != "0" && y != -1)
      setState(() {
        _onReset();
      });

    if (result == "0")
      setState(() {
        result = "";
      });

    setState(() {
      result = result.toString() + value.toString();
    });
  }

  _onReset() {
    setState(() {
      x = -1;
      y = -1;
      result = "";
      operator = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
        ),),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 5.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              x == -1 ? "\n$_emptyX" : "\n$x",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              "$operator",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 22.0,
                              ),
                            ),
                            Text(
                              y == -1 ? "$_emptyY" : "$y",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 8,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          result == "" ? result = "0" : result,
                          style: TextStyle(fontSize: 35.0, color: Colors.black),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400]
                ),
                child: Divider(
                  color: Colors.black,
                  thickness: 2.0,
                ),
              )),
          Expanded(
            flex: 11,
            child: GridView.count(
              physics: BouncingScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (var i in items)
                    ClipOval(
                      child: MaterialButton(
                        elevation: 5.0,
                        color: Colors.grey[200],
                        onPressed: () => i == "C"
                            ? _onReset()
                            : i == "CE"
                                ? _onCleanResult()
                                : i == "/" || i == "*" || i == "-" || i == "+"
                                    ? _onPressedOperator(i)
                                    : _onPressedButton(int.parse(i)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style:
                                  TextStyle(fontSize: 23.0, color: Colors.black),
                              text: i),
                        ),
                      ),
                    )
                ]),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: MaterialButton(
          elevation: 5.0,
          color: Colors.grey[400],
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          onPressed: () => _onPressedResult(),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(fontSize: 25.0, color: Colors.black),
                text: "="),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
