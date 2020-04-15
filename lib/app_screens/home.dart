import 'package:flutter/material.dart';
import 'package:notekeeper/app_screens/note_list.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteKeeper App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: NoteList(),
    );
  }
}