import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimetableOrientation {
  static Future<Orientation> getOrientation() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('isTimetableLandscape') ?? false)
        ? Orientation.landscape
        : Orientation.portrait;
  }

  static Future<void> setOrientation(Orientation orientation) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(
      'isTimetableLandscape',
      orientation == Orientation.landscape ? true : false,
    );
  }
}
