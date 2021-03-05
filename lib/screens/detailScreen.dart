import 'package:flutter/material.dart';
import 'package:todolist_app/model.dart';

class DetailScreen extends StatelessWidget {
  final Todo todo;

  const DetailScreen({Key key, this.todo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Todo'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24.0),
              child: Text(
                todo.title,
                style: TextStyle(fontSize: 20.0, letterSpacing: 2.0),
              ),
            ),
            Container(
              padding: EdgeInsets.all(24.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      todo.desc,
                      style: TextStyle(fontSize: 15.0, letterSpacing: 2.0),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
