class ReportRepairModel {
  String _id = '';
  String title = '';
  String time = '';
  String deal = '';

  String get id => _id;

  ReportRepairModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    title = data['title'] ?? '';
    time = data['time'] ?? '';
    deal = data['deal'] ?? '';
  }

  ReportRepairModel.addMap(Map data) {
    _id = data['id'];
    title = data['title'];
    time = data['time'];
    deal = data['deal'];
  }

  Map toMap() => {
        'id': _id,
        'title': title,
        'time': time,
        'deal': deal,
      };
}
