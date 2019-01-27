import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:catalogue/app_data.dart';
import 'package:catalogue/database/discipline_list_database.dart';
import 'package:catalogue/objects/discipline.dart';

class HomePage extends StatefulWidget {

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DisciplineListDb _disciplineListDb = DisciplineListDb();
  List _itemList = List<Discipline>();
  int _count = 0;

  TextEditingController _newDisciplineController = TextEditingController();

  _HomePageState() {

  }

  @override
  Widget build(BuildContext context) {

    _initData();
    return Scaffold(

      appBar: AppBar(

          title: Text(homePageName),
          actions: <Widget>[

            IconButton(

              icon: Icon(Icons.add),
              onPressed: () {
                debugPrint('adding discipline');
                _addDiscipline();
              },

            ),

          ],

      ),
      body: ListView.builder(
          itemCount: _count,
          itemBuilder: (BuildContext context, int position) {

            return GestureDetector(
              onTap: () {
                debugPrint('Pressed card $position');
              },
              child: Card(

              color: cardBackground,
              elevation: cardElevation,

              child: ListTile(

                leading: CircleAvatar(

                  backgroundColor: circleAvatarBackground,
                  child: Icon(circleAvatarIcon),
                ),

                title: Text(_itemList[position].name),
                subtitle: Text('Dummy subtitle'),

                trailing: GestureDetector(

                  child: Icon(Icons.delete, color: Colors.red,),
                  onTap: _deleteDiscipline(position),

                ),

              ),

            ),
            );

          }
      ),

    );
  }

  _initData() async {

    final Future<Database> db = _disciplineListDb.initDatabase();
    db.then((database) {

      var disciplineList = _disciplineListDb.getDisciplineList();
      disciplineList.then((disciplineList) {

        setState(() {

          if (disciplineList.length > 0) {
          this._itemList = disciplineList;
          this._count = disciplineList.length;

          } else {
            _itemList.add(Discipline(null, 'No disciplines'));
            _count = 1;
          }

        });

      });

    });

  }

  _addDiscipline() {

    return showDialog(

        context: context,
        builder: (BuildContext context) {

          return AlertDialog(

            title: Text(addDiscipline),
            content: ListView(

              children: <Widget>[

                TextField(

                  controller: _newDisciplineController,
                  decoration: InputDecoration(

                    labelText: labelDiscipline,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),

                  ),

                ),

                MaterialButton(

                  color: Theme.of(context).primaryColorDark,
                  child: Text('Save'),
                  onPressed: () {

                    if (_newDisciplineController.text != null) {
                      if (_disciplineListDb.insertDiscipline(_newDisciplineController.text) != 0)
                        _showToast('Success!');
                      else
                        _showToast('Fail!');

                      _initData();
                    }

                  },

                ),

              ],

            ),

          );

        }

    );

  }

  _deleteDiscipline(int position) {
    _disciplineListDb.deleteDiscipline(_itemList[position].id);

      _itemList.removeAt(position);
      _count--;

  }

  _showToast(String message) {

    Fluttertoast.showToast(

        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        backgroundColor: Colors.blue,

    );

  }

}
