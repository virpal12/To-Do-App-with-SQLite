
import 'package:fetch_get/app_database.dart';

class Notes_Model {
  int ? id;
  String title;
  String desc;

  Notes_Model({this.id, required this.title, required this.desc});

  factory Notes_Model.fromMap(Map<String, dynamic> map){
    return Notes_Model(id: map[DbHelper.Column_id],
        title: map[DbHelper.Column_Title],
        desc: map[DbHelper.Column_Desc]);
  }

  Map<String, dynamic> toMap() {
    return { DbHelper.Column_id: id,
      DbHelper.Column_Title: title,
      DbHelper.Column_Desc: desc,
    };
  }
}