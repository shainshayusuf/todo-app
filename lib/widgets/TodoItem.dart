import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:todolist_app/model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.todo.title),
      onDismissed: widget.onDismissed,
      background: Container(color: Colors.red),
      child: ListTile(
        onTap: widget.onTap,
        leading: Checkbox(
          value: widget.todo.complete,
          onChanged: widget.onCheckboxChanged,
        ),
        title: Text(
          widget.todo.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          widget.todo.desc,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailing: Wrap(
          spacing: -10, // space between two icons
          children: <Widget>[
            IconButton(
              iconSize: 15.0,
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(widget.todo.desc, subject: 'Look what I made!');
              },
            ), // icon-1

            IconButton(
                iconSize: 15.0,
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
                                  style: TextStyle(
                                      fontSize: 15, letterSpacing: 2.0),
                                ),
                                SizedBox(height: 20.0),
                                FloatingActionButton.extended(
                                  onPressed: scheduleNotification,
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
      ),
    );
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime = _notificationTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        random.nextInt(100),
        'Reminder',
        widget.todo.title,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    Navigator.pop(context);
  }
}
