class AttendanceDetails {
  final List<AttendanceRecord> absents;

  AttendanceDetails({required this.absents});

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) {
    final List<dynamic> a = json['A'];

    return AttendanceDetails(
      absents: a.map((e) => AttendanceRecord.fromJson(e)).toList(),
    );
  }
}

class AttendanceRecord {
  final String date;
  List<int> periods;

  AttendanceRecord({required this.date, required this.periods});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    List<int> periods = [];

    for (int i = 1; i <= 9; i++) {
      final p = json['P$i'];
      if(p == '') {
        periods.add(0);
      } else {
        periods.add(p == 'A'? 1 : 2);
      }
    }

    return AttendanceRecord(date: json['TimeStamp'], periods: periods);
  }
}

class AttendanceSummary {
  final int total;
  final int absent;
  final int oaa;
  final double percent;

  AttendanceSummary({
    required this.total,
    required this.absent,
    required this.oaa,
    required this.percent,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> b = json['B'][0];

    return AttendanceSummary(
      total: b['TL'],
      absent: b['AB']-b['DL'],
      oaa: b['DL'],
      percent: double.parse(b['PER'].toString()),
    );
  }
}
