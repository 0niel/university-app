import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_page/presentation/bloc/news_bloc.dart';
import 'package:news_page/presentation/bloc/news_bloc_event.dart';
import 'package:news_page/presentation/pages/news_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
