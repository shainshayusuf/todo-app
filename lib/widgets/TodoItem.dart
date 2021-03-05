import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:todolist_app/model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  DateTime _notificationTime;
  String _notificationTimeString;
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
          ), // icon-1

          IconButton(
              icon: Icon(Icons.notification_important),
              onPressed: () {
                _notificationTimeString =
                    DateFormat('HH:mm').format(DateTime.now());
                showModalBottomSheet(
                  useRootNavigator: true,
                  context: context,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              FlatButton(
                                onPressed: () async {
                                  var selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (selectedTime != null) {
                                    final now = DateTime.now();
                                    var selectedDateTime = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        selectedTime.hour,
                                        selectedTime.minute);
                                    _notificationTime = selectedDateTime;
                                    setModalState(() {
                                      _notificationTimeString =
                                          DateFormat('HH:mm')
                                              .format(selectedDateTime);
                                    });
                                  }
                                },
                                child: Text(
                                  _notificationTimeString,
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Click on above text to change time',
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 2.0),
                              ),
                              SizedBox(height: 20.0),
                              FloatingActionButton.extended(
                                onPressed: setReminder,
                                icon: Icon(Icons.alarm),
                                label: Text('Set  Reminder'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }), // icon-2
        ],
      ),
    );
    
  }
  void setReminder() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, 'Office', 'title',
        _notificationTime, platformChannelSpecifics);
      Navigator.pop(context);
    }
  
}
