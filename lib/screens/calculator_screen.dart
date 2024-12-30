import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String result = "0";

  void append(String value) {
    setState(() {
      if (result == "0") {
        result = value;
      } else {
        result += value;
      }
    });
  }

  void clear(String value) {
    setState(() {
      result = "0";
    });
  }

  void calculate(String value) {
    setState(() {
      try {
        result = (int.parse(result)).toString();
      } catch (e) {
        result = 'Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(result, style: const TextStyle(fontSize: 50)),
          Row(
            children: [
              CalculatorButton('1', append),
              CalculatorButton('2', append),
              CalculatorButton('3', append),
              CalculatorButton('C', clear),
            ],
          ),
          Row(
            children: [
              CalculatorButton('4', append),
              CalculatorButton('5', append),
              CalculatorButton('6', append),
              CalculatorButton('=', calculate),
            ],
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String value;
  final Function(String) onPressed;

  const CalculatorButton(this.value, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onPressed(value),
        child: Text(value, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
