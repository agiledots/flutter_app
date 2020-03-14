

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';




class StreamButtonPage extends StatelessWidget {

  Future<void> _handleButtonPressed() async {
    print('------> StreamButtonPage#_handleButtonPressed start');
    await Future<void>.delayed(Duration(seconds: 3));
    print('------> StreamButtonPage#_handleButtonPressed end');
  }

  @override
  Widget build(BuildContext context) {
    return StreamButton(
      child: Text('this is a text button'),
      onPressed: _handleButtonPressed,
    );
  }
}


class StreamButtonBloc implements Bloc {

  StreamController<bool> _streamController = StreamController<bool>();

  Stream get value => _streamController.stream;

  Future<void> handleState(bool state) async {
    _streamController.sink.add(state);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}

//typedef FutureCallback = Future<void> Function();

class StreamButton extends StatelessWidget {

  StreamButton({Key key, @required this.onPressed, @required this.child}):super(key: key);

  Future<void> Function() onPressed;

  Widget child;

  StreamButtonBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = StreamButtonBloc();

    return BlocProvider(
      creator: (context, bag) => _bloc,
      child: StreamBuilder(
        stream: _bloc.value,
        initialData: true,
        builder: (context, snapshot) {
          return RaisedButton(
            child: child,
            color: Colors.red,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            onPressed: snapshot.data ? _handlePress : null ,
          );
        }
      ),
    );
  }

  Future<void> _handlePress() async {
    _bloc.handleState(false);
    await onPressed();
    _bloc.handleState(true);
  }
}