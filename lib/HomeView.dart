

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBloc implements Bloc{

  StreamController _streamController = StreamController();

  Stream get value => _streamController.stream;

  Future<void> handleStream() async {
    print('---------------> handleStream');

    await Future.delayed(const Duration(seconds: 2));

    final data = DateTime.now().toIso8601String();
//     _streamController.sink.add(data);
    _streamController.addError("error...");
  }

  Future<String> handleFuture() async {
    print('---------------> handleFuture');
    await Future.delayed(const Duration(seconds: 2));
    final data = DateTime.now().toIso8601String();
    return data;
  }


  @override
  void dispose() {
    _streamController.close();
  }
}


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      creator: (context, blocCreatorBag) => HomeBloc(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {

  HomeBloc _bloc;

  @override
  Widget build(BuildContext context) {

    _bloc = BlocProvider.of<HomeBloc>(context);

    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: _bloc.handleStream,
            child: Text('StreamBuilder Button'),
            textColor: Colors.blueAccent,
          ),

          Container(
            child: StreamBuilder(
              stream: _bloc.value,
              builder: (context, snapshot) {
                print('---------------> StreamBuilder#builder  ${snapshot.connectionState}');

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('没有Stream');
                  case ConnectionState.waiting:
                    return Text('等待数据...');
                  case ConnectionState.active:
                    return Text('active: ${snapshot.data}');
                  case ConnectionState.done:
                    return Text('Stream已关闭');
                }

                return Text('');
              },
            ),
          ),

          Divider(color: Colors.red, height: 2.0,),

          Container(
            child: FutureBuilder(
              future: _bloc.handleFuture(),
              builder: (context, snapshot){
                print('---------------> FutureBuilder#builder  ${snapshot.connectionState}');

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('没有Future');
                  case ConnectionState.waiting:
                    return Text('等待数据...');
                  case ConnectionState.active:
                    return Text('active: ${snapshot.data}');
                  case ConnectionState.done:
                    return Text('Future已关闭: ${snapshot.data}');
                }

                return Text('');
              },
            )

          )




        ],
      ),
    );
  }
}