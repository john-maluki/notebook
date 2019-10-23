import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';
import '../utils/database_helper.dart';
import './note_details.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB Clicked');
          navigateToDetails(Note('','', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext ctx, int index) {
        return Card(
          color: Colors.white,
          elevation: 0.6,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[index].priority),
              child: getPriorityIcon(this.noteList[index].priority),
            ),
            title: Text(
              this.noteList[index].title,
              style: textStyle,
            ),
            subtitle: Text(
              this.noteList[index].date,
              style: textStyle,
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(ctx, this.noteList[index]);
              },
            ),
            onTap: () {
              debugPrint('ListStyle tapped');
              navigateToDetails(Note('', '', 2), 'Edit Note');
            },
          ),
        );
      },
    );
  }

  //Return the priority Color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  //Return the priority Icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    var result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
    }
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetails(Note note, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(note, title);
    }));
  }

  updateListView() {
    final Future<Database> dbFuture = databaseHelper.initialializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNodeList();
      noteListFuture.then((noteList) {
        setState(() {
         this.noteList = noteList;
         this.count = noteList.length; 
        });
      });
    });
  }
}
