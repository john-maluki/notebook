import 'package:flutter/material.dart';
import './screens/note_list.dart';


void main() {
  runApp(MyNote());
}

class MyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NoteKeeper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: NoteList());
  }
}
