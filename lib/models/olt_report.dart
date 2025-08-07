class OltDetail {
  final int testId;
  final String testName;
  final int correct;
  final int incorrect;
  final DateTime date;

  const OltDetail({
    required this.testId,
    required this.testName,
    required this.correct,
    required this.incorrect,
    required this.date,
  });
}

class OltReport {
  final List<OltDetail> list;

  const OltReport({required this.list});

  factory OltReport.fromJson(List<dynamic> json) {
    List<OltDetail> list = [];

    for (var test in json) {
      list.add(
        OltDetail(
          testId: test['Test_Id'],
          testName: test['Test_Name'],
          correct: double.parse(test['A_Correct']).toInt(),
          incorrect: double.parse(test['A_InCorrect']).toInt(),
          date: DateTime.parse('${test['Active_TimeStamp']}'.toString()),
        ),
      );
    }

    return OltReport(list: list);
  }
}
