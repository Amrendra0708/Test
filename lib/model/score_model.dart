class ScoreModel {
  int id;
  String gameName;
  dynamic userName;
  dynamic score;
  ScoreModel(this.id, this.gameName,this.userName,this.score);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'gamename': gameName,
      'username' : userName,
      'score' :score
    };
    return map;
  }

  ScoreModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    gameName = map['gamename'];
    score = map['score'];
  }
}