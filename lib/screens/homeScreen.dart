import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _titleController;
  TextEditingController _descController;
  Map<String, String> _events;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _events = {};
    _titleController = TextEditingController();
     _descController = TextEditingController();
     initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _events = Map<String, String>.from(
    //       decodeMap(json.decode(prefs.getString("todos") ?? "{}")));
    // });
    print(json.decode(prefs.getString('todos')));
  }

   Map<String, String> encodeMap(Map<String, String> map) {
    Map<String, String> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<String, String> decodeMap(Map<String, String> map) {
    Map<String, String> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todolist App'),
      ),
      // body: Container(
      //   child:Column(children: [
      //    ..._events.values.map((event) => ListTile(
      //       title: Text(User.fromJson(jsonDecode(event[0])).toString()),
      //     ))
      //   ],)
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed:_showAddDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
    
  }
  _showAddDialog() async { 
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content:Container(height: 250.0,
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
              child: Text("Save"),
              //  if (_titleController.text.isEmpty && _descController.text.isEmpty) return;
              onPressed: () {
               // print({'title':_titleController.text,'description':_descController.text});
                if (_events[_titleController.text] != null) {
                  _events[_titleController.text]=_descController.text;
                } else {
                  _events[_titleController.text] = _descController.text;
                }
                // _events[_titleController.text]
                //       .add({'title':_titleController.text,'description':_descController.text});
                print(_events);
                 prefs.setString("todos", json.encode(encodeMap(_events)));
                 print(prefs.getString('todos'));
                Navigator.pop(context);
                _titleController.clear();
              },
            )
          ],
        ));
    
  }
}
