class GameModel {
  int id;
  String name;
  GameModel(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return map;
  }

  GameModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}