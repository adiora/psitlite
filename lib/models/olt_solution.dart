class OltQuestion {
  final String question;
  final String markedAnser;
  final String correctAnswer;
  final bool isCorrect;

  const OltQuestion({
    required this.question,
    required this.markedAnser,
    required this.correctAnswer,
    required this.isCorrect,
  });
}

class OltSolution {
  final String testID;
  final List<OltQuestion> questions;

  const OltSolution({required this.testID, required this.questions});

  factory OltSolution.fromJson(List<dynamic> json, {required String testID}) {
    json = json[0];
    List<OltQuestion> questions = [];

    for (var entry in json) {
      questions.add(
        OltQuestion(
          question: entry['Question'],
          markedAnser: entry['Answer_Text'],
          correctAnswer: entry['Correct_Answer'],
          isCorrect: entry['IsCorrect'] == 1? true : false,
        ),
      );
    }

    return OltSolution(testID: testID, questions: questions);
  }
}
