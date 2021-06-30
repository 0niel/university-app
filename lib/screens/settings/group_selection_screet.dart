import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSelectionScreen extends StatefulWidget {
  GroupSelectionScreen({Key key}) : super(key: key);

  @override
  _GroupSelectionScreenState createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Выбор группы',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
