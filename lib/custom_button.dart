

import 'package:flutter/material.dart';


class ButtonPage extends StatelessWidget {

  Future<void> _handleButtonPressed() async {
    print('------> _handleButtonPressed start');
    await Future<void>.delayed(Duration(seconds: 3));
    print('------> _handleButtonPressed end');
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      child: Text('this is a text button'),
      onPressed: _handleButtonPressed,
    );
  }
}


//typedef FutureCallback = Future<void> Function();

class CustomButton extends StatefulWidget {

  CustomButton({Key key, @required this.onPressed, @required this.child}):super(key: key);

  Future<void> Function() onPressed;

  Widget child;

  @override
  State<StatefulWidget> createState() {
    return CustomButtonState();
  }
}

class CustomButtonState extends State<CustomButton> {

  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {

    return RaisedButton(
      child: widget.child,
      color: Colors.red,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      onPressed: _isDisabled ? null : _handlePress,
    );
  }

  Future<void> _handlePress() async {
    _isDisabled = true;
    setState((){});
    await widget.onPressed();

    _isDisabled = false;
    setState((){});
  }
}