import 'package:psit_lite/models/student_data.dart' show StudentData;
import 'package:psit_lite/services/api_service.dart';

class Student {
  static StudentData data = StudentData.fromJson({});

  static void initializeWith({required StudentData? data}) {

    if(data != null) {
      Student.data = data;
      ApiService.setBaseUrl(data.collegeId);
    }
  }
}