import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
    Todo({
        this.title,
        this.desc,
    });

    String title;
    String desc;

    factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"],
        desc: json["desc"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "desc": desc,
    };
}