import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff181A20),
            title: Text("Новости"),
          ),
          backgroundColor: Color(0xff181A20),
          body: BlocProvider(
              create: (context) => NewsBloc()..add(NewsInitital()),
              child: NewsPage())),
    );
  }
}
