
class Discipline {

  final String _colId = 'id';
  final String _colName = 'name';

  int _id;
  String _name;

  Discipline(this._id, this._name);

  Discipline.fromMap(Map<String, dynamic> map) {
    this._id = map[_colId];
    this._name = map[_colName];
  }

  int get id => _id;
  String get name => _name;

  set name(String newName) => this._name = newName;

  toMap() {

    Map map = Map<String, dynamic>();
    if (_id != null)
      map[_colId] = _id;

    map[_colName] = _name;

    return map;
  }

}