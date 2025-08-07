class Period {
  final int periodNumber;
  final String room;
  final String empName;
  final String subjectCode;
  final String subjectName;
  final bool isLab;

  Period({
    required this.periodNumber,
    required this.room,
    required this.empName,
    required this.subjectCode,
    required this.subjectName,
    required this.isLab,
  });
}


class StudentTimetable {
  StudentTimetable({required this.periods});

  // This implementation was adding all periods as a single period
  // could be assigned to multiple teachers and rooms.
  // Changed it due to Timetable screen redesign to show only
  // only 1 period info. Future design may change.

  // final List<List<List<Period>>> timetable;

  // factory StudentTimetable.fromJson(List<dynamic> json) {
  //   List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(json);
  //   List<List<List<Period>>> timetable = List.generate(
  //     6,
  //     (_) => List.generate(8, (_) => []),
  //   );

  //   for (var entry in list) {
  //     final dayIndex = entry['TT_Day'] - 1;
  //     final periodIndex = entry['TT_Period'] - 1;

  //     final period = Period(
  //       room: entry['Room'].toString(),
  //       empName: entry['EmpName'].toString(),
  //       subjectCode: entry['Subject_Code'].toString(),
  //       isLab: (entry['IsLab'] == 0) ? false : true,
  //     );

  //     timetable[dayIndex][periodIndex].add(period);
  //   }

  //   return StudentTimetable(timetable: timetable);
  // }
  final List<List<Period?>> periods;

  factory StudentTimetable.fromJson({
    required List<dynamic> json,
  }) {
    List<List<Period?>> periods = List.generate(
      6,
      (_) => List<Period?>.filled(8, null, growable: false),
      growable: false,
    );

    for (var entry in json) {
      final dayIndex = entry['TT_Day'] - 1;
      final periodIndex = entry['TT_Period'] - 1;

      periods[dayIndex][periodIndex] = Period(
        periodNumber: periodIndex,
        room: entry['Room'].toString(),
        empName: entry['EmpName'].toString(),
        subjectCode: entry['Subject_Code'].toString(),
        subjectName: entry['Subject'].toString(),
        isLab: entry['IsLab'] != 0,
      );
    }

    return StudentTimetable(periods: periods);
  }
}