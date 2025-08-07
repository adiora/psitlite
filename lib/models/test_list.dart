class Test {
  final String id;
  final String name;
  final int maxMarks;

  const Test({required this.id, required this.name, required this.maxMarks});
}

class TestList {
  List<Test> tests;

  TestList({required this.tests});

  factory TestList.fromJson(List<dynamic> json) {
    List<Test> tests = [];
    for (var test in json) {
      Test t = Test(
        id: test['Id'].toString(),
        name: test['Name'].toString(),
        maxMarks: test['Name'].toString() == 'PU'? 70 : test['MaxMarks'],
      );
      tests.add(t);
    }

    return TestList(tests: tests);
  }
}
