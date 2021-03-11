import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test1/database/localdb.dart';
import 'package:test1/model/game_model.dart';
import 'package:test1/database/localdb.dart';
import 'package:test1/model/score_model.dart';
import 'package:test1/ui/score_board.dart';
class AddScore extends StatefulWidget {
  @override
  _AddScoreState createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
  final userNameText = TextEditingController();
  final scoreText = TextEditingController();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String userName;
  String score;
  List<String> gameModel = ["Select Game Name"];
  String name;
  int gameID;
  bool isUpdate = false;
  List<GameModel> _list;
  DBHelper dbHelper;
  void getAllGame() async{
  try{
    print("hello");
    _list = await dbHelper.getGame();
    print("$_list");
    setState(() {
      gameModel.add("Select Game");
      gameModel.addAll(_list.map((e) => e.name).toList());
    });
  }
  catch(e){
  print(e);
  return null;
  }


  }
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getAllGame();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Score"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin:
                  EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.black,
                      )),
                  child:gameModel==null ||gameModel.isEmpty?Container()
                  :Container(
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(

                          value: name,
                          isExpanded: true,
                          iconSize: 40,
                          items: gameModel.map((item) {
                            return DropdownMenuItem(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(item),
                              ),
                              value: item,
                            );
                          }).toList(),
                          hint: Text("  Select Game"),
                          onChanged: (String newValue) {
                            setState(() {
                              name = newValue;
                              if(newValue != gameModel[0]){
                                var model = _list.firstWhere((e) =>e.name == name
                                , orElse: ()=> null);
                              }
                            });
                          },
                        )),
                  ),
                ),
                Form(
                  key: _formStateKey,
                  child: Column(
                    children: [
                      Container(

                        child: TextFormField(
                          validator: (value){
                            if (value.isEmpty) {
                              return 'Please Enter Username';
                            }
                            if (value.trim() == "")
                              return "Only Space is Not Valid!!!";
                            return null;
                          },
                          onSaved: (value) {
                            userName = value;
                          },
                          controller: userNameText,
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
                            hintText: 'Enter your User Name',

                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          validator: (value){
                            if (value.isEmpty) {
                              return 'Please Enter Score';
                            }
                            if (value.trim() == "")
                              return "Only Space is Not Valid!!!";
                            return null;
                          },
                          onSaved: (value) {
                            score = value;
                          },
                          controller: scoreText,
                          keyboardType: TextInputType.number,
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
                            hintText: 'Enter your User Score',

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child:ConstrainedBox(
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
                                .addScore(ScoreModel(gameID,name,userName,score))
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
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  ScoreBoard()));
                                        }, child: Text(
                                          'Ok'
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
                            dbHelper.addScore(ScoreModel(null,name,userName,score));
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
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  ScoreBoard()));
                                        }, child: Text(
                                          'Ok'
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
              ],
            ),
          ),
        ),
      ),

    );
  }
}

