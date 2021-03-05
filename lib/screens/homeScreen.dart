import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/main.dart';
import 'dart:convert';
import 'package:todolist_app/model.dart';
import 'package:todolist_app/widgets/TodoItem.dart';
import 'dart:core';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _titleController;
  TextEditingController _descController;
  List<Todo> notes = List<Todo>();
  List<dynamic> stringList = List<dynamic>();
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    stringList = jsonDecode(prefs.getString("notes"));
    if (stringList != null) {
      setState(() {
        stringList.forEach((element) {
          notes.add(Todo.fromJson(element));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todolist App'),
      ),
      body: notes.length == 0
          ? Center(
              child: Text("No Todos,Add to remember task",
                  style: TextStyle(fontSize: 20, letterSpacing: 1.0)))
          : _buildList(notes),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 250.0,
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _titleController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Todo title', hintText: 'eg. Meeting'),
              ),
              new TextField(
                autofocus: true,
                controller: _descController,
                maxLines: 8,
                decoration: new InputDecoration(
                    labelText: 'Todo Description', hintText: 'eg. About Todo'),
              )
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            color: ArchSampleTheme.theme.copyWith().accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Text("Save"),
            onPressed: () {
              if (_titleController.text != null &&
                  _titleController.text != "" &&
                  _descController.text != null &&
                  _descController.text != "") {
                Todo note = Todo(
                    title: _titleController.text,
                    desc: _descController.text,
                    complete: false);
                notes.add(note);
                String jsonNotes = jsonEncode(notes);
                print(jsonNotes);
                prefs.setString("notes", jsonNotes);
                _titleController.clear();
                _descController.clear();
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
    setState(() {
      notes = notes;
    });
  }
}

ListView _buildList(List<Todo> todoList) {
  //   List todos = [];
  // todos.add(Todo(title:'Jack', desc:"Jack",complete:true));
  // todos.add(Todo(title:'Jack', desc:"Jack",complete:true));
  // todos.add(Todo(title:'Jack', desc:"Jack",complete:true));

  return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todoList[index];
        return TodoItem(
          todo: todo,
          onDismissed: (direction) {
            print('dismissed');
          },
        );
      });
}
