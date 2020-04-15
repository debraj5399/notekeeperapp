class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  String _time;

  Note(this._title, this._date, this._time, this._priority, [this._description]);
  Note.withId(this._id, this._title, this._date, this._time, this._priority,
      [this._description]);

  int get id => _id;
  int get priority => _priority;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  String get time => _time;

  set title(String newTitle) {
    if (newTitle.length>=1 && newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length >= 1) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority == 1 || newPriority == 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set time(String newTime) {
    this._time = newTime;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['time'] = _time;
    map['priority'] = _priority;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._time = map['time'];
    this._priority = map['priority'];
  }
}
