import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psit_lite/models/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  
  static final _statsDoc = FirebaseFirestore.instance
      .collection('about')
      .doc('stats');
  static var _userDoc = FirebaseFirestore.instance
      .collection('about')
      .doc('stats')
      .collection('users')
      .doc(Student.data.sId);

  static Map<String, bool> userStats = {'visited': false, 'liked': false};
  
  static void instantiate() {
    if(_userDoc.id == Student.data.sId) return;

    userStats['visited'] = false;
    userStats['liked'] = false;
    _userDoc = FirebaseFirestore.instance
      .collection('about')
      .doc('stats') 
      .collection('users')
      .doc(Student.data.sId);
  }

  static Future<Map<String, int>> fetchStats() async {
    final snapshot = await _statsDoc.get();
    final data = snapshot.data();
    return {'likes': data?['likes'] ?? 0, 'visits': data?['visits'] ?? 0};
  }

  static Future<Map<String, bool>> fetchUserStats() async {
    if (userStats['visited'] == true) return userStats;

    final prefs = await SharedPreferences.getInstance();
    final visited = prefs.getBool('visited')?? false;
    
    if(visited) {
      final liked = prefs.getBool('liked')?? false;
      userStats['visited'] = true;
      userStats['liked'] = liked;
      return userStats;
    }
    else {
      final snapshot = await _userDoc.get();
      if(snapshot.exists) {
        userStats['visited'] = true;
        userStats['liked'] = snapshot.data()?['liked'] ?? false;
        await prefs.setBool('visited', true);
        await prefs.setBool('liked', userStats['liked']!);
        return userStats;
      }
    }

    if(!(userStats['visited'] ?? false)) setVisited();

    return userStats;
  }

  static Future<void> setVisited() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('visited', true);

    await _userDoc.set({'liked': userStats['liked']});
    await _statsDoc.update({'visits': FieldValue.increment(1)});
  }

  static Future<void> like() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('liked', true);

    await _statsDoc.update({'likes': FieldValue.increment(1)});
    await _userDoc.update({'liked': true});
    userStats['liked'] = true;
  }

  static Future<void> dislike() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('liked', false);

    await _statsDoc.update({'likes': FieldValue.increment(-1)});
    await _userDoc.update({'liked': false});
    userStats['liked'] = false;
  }
}
