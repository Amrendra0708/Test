import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test1/database/localdb.dart';
import 'package:test1/model/game_model.dart';
import 'package:test1/database/localdb.dart';
import 'package:test1/ui/score.dart';
import 'package:test1/ui/score_board.dart';
class AddGame extends StatefulWidget {
  @override
  _AddGameState createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  bool _loading = false;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<GameModel>> gameModel;
  String _gameName;
  bool isUpdate = false;
  int gameID;
  DBHelper dbHelper;
  final _gamenameController = TextEditingController();
  refreshGameList() {
    setState(() {
      gameModel = dbHelper.getGame();
    });
  }
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshGameList();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Game"
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formStateKey,
                  child: Container(

                    child: TextFormField(
                      validator: (value){
                        if (value.isEmpty) {
                          return 'Please Enter Game Name';
                        }
                        if (value.trim() == "")
                          return "Only Space is Not Valid!!!";
                        return null;
                      },
                      onSaved: (value) {
                        _gameName = value;
                      },
                      controller: _gamenameController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color:Colors.black
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color:Colors.black
                            ),
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color:Colors.black
                            ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.gamepad_sharp,
                            color:Colors.black
                          ),
                          hintText: 'Enter your Game Name',

                         ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child:_loading?Center(
                    child: CircularProgressIndicator(),
                )
                        :ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: double.infinity
                    ),
                    child: RaisedButton(
                      child: Text("Add",style: TextStyle(
                        color: Colors.white
                      ),),
                      color: Colors.blueGrey,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: (){
                        if (isUpdate) {
                          if (_formStateKey.currentState.validate()) {
                            _formStateKey.currentState.save();
                            dbHelper
                                .add(GameModel(gameID,_gameName))
                                .then((data) {
                              setState(() {
                                isUpdate = false;
                              });
                            });
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                              builder: (BuildContext ctx){
                                  return AlertDialog(
                                    title: Text("Record Added Successfully"),
                                    actions: [
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        color: Colors.blue,
                                        onPressed: (){
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                  new AddGame()),
                                                  (Route<dynamic> route) =>
                                              false);
                                        }, child: Text(
                                          'Later'
                                      ),
                                      ),
                                    ],
                                  );

                              }
                            );
                          }
                        } else {
                          if (_formStateKey.currentState.validate()) {
                            _formStateKey.currentState.save();
                            dbHelper.add(GameModel(null, _gameName));
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext ctx){
                                  return AlertDialog(
                                    title: Text("Record Added Successfully"),
                                    actions: [
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        color: Colors.blue,
                                        onPressed: (){
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                  context) =>
                                                  new AddGame()),
                                                  (Route<dynamic> route) =>
                                              false);
                                        }, child: Text(
                                          'Later'
                                      ),
                                      ),
                                    ],
                                  );

                                }
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child:_loading?Center(
                    child: CircularProgressIndicator(),
                  )
                      :ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: double.infinity
                    ),
                    child: RaisedButton(
                      child: Text("Add Score",style: TextStyle(
                          color: Colors.white
                      ),),
                      color: Colors.blueGrey,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                AddScore()));

                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child:_loading?Center(
                    child: CircularProgressIndicator(),
                  )
                      :ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: double.infinity
                    ),
                    child: RaisedButton(
                      child: Text("Score Board",style: TextStyle(
                          color: Colors.white
                      ),),
                      color: Colors.blueGrey,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                ScoreBoard()));

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: gameModel,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return generateList(snapshot.data);
                      }
                      if (snapshot.data == null || snapshot.data.length == 0) {
                        return Text('No Data Found');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  SingleChildScrollView generateList(List<GameModel> gameModelList) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('No.'),
            ),
            DataColumn(
              label: Text('Name'),
            )
          ],
          rows: gameModelList
              .map(
                (student) => DataRow(
              cells: [
                DataCell(
                  Text(student.id.toString()),
                  onTap: () {
                    setState(() {
                      isUpdate = true;
                      gameID = student.id;
                    });
                    _gamenameController.text = student.name;
                  },
                ),
                DataCell(
                  Text(student.name),
                  onTap: () {
                    setState(() {
                      isUpdate = true;
                      gameID = student.id;
                    });
                    _gamenameController.text = student.name;
                  },
                ),

              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
