import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:todolist_app/model.dart';

class TodoItem extends StatefulWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Todo todo;

  TodoItem({
     this.onDismissed,
    this.onTap,
    this.onCheckboxChanged,
     this.todo,
  });
  @override
  _TodoItemState createState() => new _TodoItemState();

}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      leading: Checkbox(
    
        value: widget.todo.complete,
        onChanged: widget.onCheckboxChanged,
      ),
      title: Text(
        widget.todo.title,
       
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        widget.todo.desc,
  
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead,
      ),
      trailing: Wrap(
    spacing: 12, // space between two icons
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.share),
       onPressed: () {
                    Share.share(widget.todo.desc, subject: 'Look what I made!');
                  },
      ),// icon-1
      
      IconButton(
        icon: Icon(Icons.notification_important),
       onPressed: () => showTimePicker(context: context, initialTime: TimeOfDay.now()),
      ),// icon-2
    ],
  ), 
    );
  }
}

  
