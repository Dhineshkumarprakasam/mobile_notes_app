class dataModel {
  int? id;
  String? title;
  String? content;
  String? time;

  dataModel(this.id, this.title, this.content, this.time);

  dataMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['content'] = content;
    map['time'] = time;
    return map;
  }
}
