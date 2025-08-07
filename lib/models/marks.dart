class Mark {
  final String subject;
  final double marks;

  Mark({required this.subject, required this.marks});
}

class Marks {
  final List<Mark> markList;

  Marks({required this.markList});

  factory Marks.fromJson(List<dynamic> json) {
    List<Mark> marks = [];

    for (Map<String, dynamic> map in json) {
      for (var entry in map.entries) {
        if (entry.key != 'Student_Id' &&
            entry.key != 'RollNo' &&
            entry.key != 'Student_Name') {
          marks.add(Mark(subject: entry.key, marks: double.parse(entry.value.toString())));
        }
      }
    }

    return Marks(markList: marks);
  }
}
