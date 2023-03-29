import 'package:calculator_app/ShuntingYard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(top: 30),
          child: Text("Calculator", style: TextStyle(color: Color.fromARGB(249, 255, 17, 1), fontSize: 30))
          ),
      ),
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg.jpg'))),
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          MainContent(),        
        ]),
      ),
      drawer: Drawer(backgroundColor: Color.fromARGB(255, 46, 46, 46),),
    );
  }
}

class MainContent extends StatelessWidget {
  double wdt = 95;
  double hgt = 70;

  bool isOperator(String str)
  {
    if (str == '+' || str == '-' || str == '/' || str == '*' || str == '.')
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    String tfval = "";

    return Column( children: <Widget>[
      SizedBox(
        height: 80,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color.fromARGB(255, 46, 46, 46),
          child: TextField(
            controller: _controller,
            readOnly: true,
            style: TextStyle(color: Colors.white, fontSize: 50),
            textAlign: TextAlign.end,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalButton(wdt: wdt, hgt: hgt, val: "C", 
          fnc: () {_controller.text = tfval = "";}),
          CalButton(wdt: wdt, hgt: hgt, val: "<-", 
          fnc: () {if (tfval.length != 0) tfval = tfval.substring(0, tfval.length-1);_controller.text = tfval;}),
          CalButton(wdt: wdt, hgt: hgt, val: ".", 
          fnc: () {if (!tfval.isEmpty && !isOperator(tfval[tfval.length-1]))_controller.text = tfval += ".";}
          
          ),
          CalButton(wdt: wdt, hgt: hgt, val: "+", 
          fnc: () 
          {if (!tfval.isEmpty && !isOperator(tfval[tfval.length-1])){_controller.text = tfval += "+";}

          }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        CalButton(wdt: wdt, hgt: hgt, val: "1", 
        fnc: () {_controller.text = tfval += "1"; }),
        CalButton(wdt: wdt, hgt: hgt, val: "2", 
        fnc: () {_controller.text = tfval += "2";}),
        CalButton(wdt: wdt, hgt: hgt, val: "3", 
        fnc: () {_controller.text = tfval += "3";}),
        CalButton(wdt: wdt, hgt: hgt, val: "-", 
        fnc: () {if (!tfval.isEmpty && !isOperator(tfval[tfval.length-1])) _controller.text = tfval += "-";}),
      ],),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalButton(wdt: wdt, hgt: hgt, val: "4", 
          fnc: () {_controller.text = tfval += "4";}),
          CalButton(wdt: wdt, hgt: hgt, val: "5", 
          fnc: () {_controller.text = tfval += "5";}),
          CalButton(wdt: wdt, hgt: hgt, val: "6", 
          fnc: () {_controller.text = tfval += "6";}),
          CalButton(wdt: wdt, hgt: hgt, val: "*", 
          fnc: () {if(!tfval.isEmpty && !isOperator(tfval[tfval.length-1])) _controller.text = tfval += "*";}),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalButton(wdt: wdt, hgt: hgt, val: "7", 
          fnc: () {_controller.text = tfval += "7";}),
          CalButton(wdt: wdt, hgt: hgt, val: "8", 
          fnc: () {_controller.text = tfval += "8";}),
          CalButton(wdt: wdt, hgt: hgt, val: "9", 
          fnc: () {_controller.text = tfval += "9";}),
          CalButton(wdt: wdt, hgt: hgt, val: "/", 
          fnc: () {if(!tfval.isEmpty && !isOperator(tfval[tfval.length-1])) _controller.text = tfval += "/";}),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalButton(wdt: wdt, hgt: hgt, val: "0", 
          fnc: () {_controller.text = tfval += "0";}),
          CalButton(wdt: wdt, hgt: hgt, val: "(", 
          fnc: () {_controller.text = tfval += "(";}),
          CalButton(wdt: wdt, hgt: hgt, val: ")",  
          fnc: () {_controller.text = tfval += ")";}),
          CalButton(wdt: wdt, hgt: hgt, val: "=", 
          fnc: () {
            ShuntingYard shuntingYard = new ShuntingYard();
            try
            {
              if (shuntingYard.intfixToRpn(tfval) == -1)
              {
                _controller.text = "Error";
                return;
              }
              _controller.text = shuntingYard.intfixToRpn(tfval).toString();
            }
            catch(e)
            {
              _controller.text = "Error";
            }
          }),
        ],
      ),

        ]),
      )
      
    ]);
  }
}

// Prebuild Widgets
class CalButton extends StatelessWidget {
  CalButton({
    required this.wdt,
    required this.hgt,
    required this.val,
    required this.fnc,
  });

  final double wdt;
  final double hgt;
  final String val;
  final Function()? fnc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wdt,
      height: hgt,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 46, 46, 46)),
        child: Text(val, style: TextStyle(fontSize: 30, color: Color.fromARGB(249, 255, 17, 1)),),
        onPressed: fnc,
      ),
    );
  }
}

