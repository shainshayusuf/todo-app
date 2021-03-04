import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
    Todo({
        this.title,
        this.desc,
        this.complete
    });

    String title;
    String desc;
    bool complete;

    factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"],
        desc: json["desc"],
        complete: json['complete']
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "desc": desc,
        "complete":complete
    };
}