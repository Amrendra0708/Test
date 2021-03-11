import 'package:flutter/material.dart';
import 'package:test1/database/localdb.dart';
import 'package:test1/model/score_model.dart';

class ScoreBoard extends StatefulWidget {
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  DBHelper dbHelper;
  Future<List<ScoreModel>> scoreModel;
  refreshGameList() {
    setState(()  {
      scoreModel =  dbHelper.getScore();
    });
  }
  @override
  void initState() {
    dbHelper =DBHelper();
    refreshGameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ScoreBoard"),
        ),
        body: Container(
          margin:EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: scoreModel,
                    builder: (context, snapshot){
                    if(snapshot.hasData){
                      return generateList(snapshot.data);
                    }
                    if (snapshot.data == null || snapshot.data.length == 0) {
                      return Text('No Data Found');
                    }
                    return CircularProgressIndicator();
                    }
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
  SingleChildScrollView generateList(List<ScoreModel> scoreModelList) {
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
              label: Text('Game'),
            ),
            DataColumn(
              label: Text('User'),
            ),
            DataColumn(
              label: Text('Score'),
            )
          ],
          rows: scoreModelList
              .map(
                (scoremodel) => DataRow(
              cells: [
                DataCell(
                  Text(scoremodel.id.toString()),
                ),
                DataCell(
                  Text(scoremodel.gameName),

                ),
                DataCell(
                  Text(scoremodel.userName==null?"No Name":scoremodel.userName),

                ),
                DataCell(
                  Text(scoremodel.score.toString()),

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
