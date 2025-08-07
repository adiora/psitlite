import 'dart:typed_data';

import 'package:psit_lite/models/announcements.dart';
import 'package:psit_lite/models/marks.dart';
import 'package:psit_lite/models/olt_report.dart';
import 'package:psit_lite/models/student_attendance.dart';
import 'package:psit_lite/models/student_data.dart';
import 'package:psit_lite/models/student_timetable.dart';
import 'package:psit_lite/models/test_list.dart';
import 'package:psit_lite/models/olt_solution.dart';
import 'package:psit_lite/services/api_service.dart';
import 'package:psit_lite/services/cache_service.dart';

class FetchService {
  static Future<StudentData?> getStudentDetails() async {
    return CacheService.getCachedStudentDetails();
  }

  static Future<AttendanceSummary> getAttendanceSummary() async {
    AttendanceSummary? summary = await CacheService.getCachedAttendanceSummary();

    summary ??= await ApiService.getAttendanceSummary();
    return summary;
  }

  static Future<AttendanceDetails> getAttendanceDetails() async {
    AttendanceDetails? details = await CacheService.getCachedAttendanceDetails();

    details ??= await ApiService.getAttendanceDetails();
    return details;
  }

  static Future<StudentTimetable> getTimetable({required String date}) async {
    StudentTimetable? timetable = await CacheService.getCachedTimetable(
      date: date,
    );

    timetable ??= await ApiService.getTimetable(date: date);
    return timetable;
  }

  static Future<Uint8List?> getProfileImage() async {
    Uint8List? imageBytes = await CacheService.getCachedProfileImage();

    imageBytes ??= await ApiService.getProfileImage();
    return imageBytes;
  }

  static Future<TestList> getTestList() async {
    TestList? testList = await CacheService.getCachedTestList();

    testList ??= await ApiService.getTestList();
    return testList;
  }

  static Future<Marks> getMarks(String testID) async {
    Marks? marks = await CacheService.getCachedMarks(testID: testID);

    marks ??= await ApiService.getMarks(testID: testID);
    return marks;
  }

  static Future<Announcements> getAnnouncements() async {
    Announcements? announcements = await CacheService.getCachedAnnouncements();

    announcements ??= await ApiService.getAnnouncements();
    return announcements;
  }

    static Future<OltReport> getOltReport() async {
    OltReport? oltReport = await CacheService.getCachedOltReport();

    oltReport ??= await ApiService.getOltReport();
    return oltReport;
  }

  static Future<OltSolution> getOltSolution(String testID) async {
    OltSolution? oltSolution = await CacheService.getCachedOltSolution(testID: testID);

    oltSolution ??= await ApiService.getOltSolution(testID: testID);
    return oltSolution;
  }
}
