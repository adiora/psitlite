import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:psit_lite/models/student.dart';
import 'package:psit_lite/services/cache_service.dart';
import 'package:psit_lite/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> performPostLogout() async {
  () async {
    await CacheService.clearProfileImage();
    await SharedPreferences.getInstance()
      ..clear()
      ..setBool(
        'isDarkMode',
        ThemeController.themeMode.value == ThemeMode.dark,
      );
    Student.initializeWith(data: null);
  }();
}

Future<void> performPostLogin(
  String collegeId,
  String gender,
  String userId,
  String semester,
) async {
  if (kReleaseMode) {
    await FirebaseAnalytics.instance.setUserId(id: Student.data.userId);
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'institute',
      value: collegeId == '1' ? 'PSIT' : 'CHE',
    );
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'gender',
      value: gender,
    );
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'year',
      value: ((int.parse(Student.data.semester) + 1) / 2).toInt().toString(),
    );
  }
}
