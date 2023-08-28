class Note {
  late String id;
  late String title;
  late String description;
  late String important;
  late String creationData;

  late String endData;
  late String status;

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['info'];
    id = map['id'];
    important = map['important'];
    creationData = map['creationData'];
    endData = map['endData'];
    status = map['status'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['info'] = description;
    map['id'] = id;
    map['important'] = important;
    map['creationData'] = creationData;
    map['endData'] = endData;
    map['status'] = status;

    return map;
  }
}
