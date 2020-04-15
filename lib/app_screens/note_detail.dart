import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notekeeper/app_screens/note_detail.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  static var _priorities = ['High', 'Low'];
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  _NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
              onPressed: () {
                moveToLastScreen();
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: titleController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter Some Title';
                      }
                    },
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                            _save();
                            }
                          });
                        },
                      )),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// CONVERT STRING TO INT
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

// CONVERT INT TO STRING
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

// UPDATE TITLE
  void updateTitle() {
    note.title = titleController.text;
  }

// UPDATE DESCRIPTION
  void updateDescription() {
    note.description = descriptionController.text;
  }

// SAVE TO DATABASE
  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().add_jm().format(DateTime.now());
    int result;
    if (note.id != null) {
      if (note.title == null) {
        _showAlertDialog('Status', 'TITLE CANNOT BE NULL');
      } else {
        result = await helper.updateNote(note);
      }
    } else {
      if (note.title == null) {
        _showAlertDialog('Status', 'TITLE CANNOT BE NULL');
      } else {
        result = await helper.insertNote(note);
      }
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Succesfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

// DELETE NOTE
  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note Was Deleted');
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Succesfully');
    } else {
      _showAlertDialog('Status', 'Error Occured While Deleting Note');
    }
  }

// ALERT DIALOG METHOD
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

// LAST SCREEN NAVIGATION
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
