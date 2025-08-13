import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const _updateCacheKey = 'update_info';
  static const _skipUntilKey = 'skipUntil';
  static const _lastCheckKey = 'lastChecked';
  static const _checkInterval = 24 * 60 * 60 * 1000; // 1 Day interval

  static Future<void> checkAndPromptUpdate(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    final prefs = await SharedPreferences.getInstance();

    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Skip if user decided to update later.
    final skipUntil = prefs.getInt(_skipUntilKey);
    if (skipUntil != null && currentTime < skipUntil) return;

    Map<String, dynamic>? data;
    final cached = prefs.getString(_updateCacheKey);
    if (cached != null) {
      data = jsonDecode(cached);
      // After an update, remove the key
      if (data != null && currentVersion == data['latest_version']) {
        prefs.remove(_updateCacheKey);
        return;
      }
    } else {
      // Skip if we checked for update recently.
      final lastChecked = prefs.getInt(_lastCheckKey);
      if (lastChecked != null && currentTime < lastChecked + _checkInterval) {
        return;
      }

      try {
        final doc = await FirebaseFirestore.instance
            .collection('meta')
            .doc('latest')
            .get();
        if (!doc.exists) {
          return; // No update available or misconfiguration in firebase (depends on implementation)
        }

        prefs.setInt(_lastCheckKey, currentTime);
        data = doc.data();
      } catch (_) {}
    }

    if (data == null || !context.mounted) return;

    final latest = data['latest_version'] ?? currentVersion;
    final minRequired = data['min_required_version'] ?? currentVersion;
    final updateLink = data['update_link'] ?? '';
    final updateText = data['updateText'] ?? '';
    final belowMinText = data['belowMinText'] ?? '';
    final aboveMinText = data['aboveMinText'] ?? '';

    final isBelowMin = _compareVersions(currentVersion, minRequired) < 0;
    final isBelowLatest = _compareVersions(currentVersion, latest) < 0;

    if (!isBelowMin && !isBelowLatest) return;

    // Cache update for later
    prefs.setString(_updateCacheKey, jsonEncode(data));

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: !isBelowMin,
      builder: (ctx) {
        final theme = Theme.of(ctx);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🚀 Update Available', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyLarge,
                  children: [
                    const TextSpan(text: "Upgrading "),
                    TextSpan(
                      text: currentVersion,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " → "),
                    TextSpan(
                      text: latest,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                updateText,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                isBelowMin
                    ? belowMinText
                    : aboveMinText,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            if (!isBelowMin)
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  prefs.setInt(
                    _skipUntilKey,
                    DateTime.now().millisecondsSinceEpoch + _checkInterval,
                  );
                },
                child: const Text("Later", style: TextStyle(fontSize: 15)),
              ),
            ElevatedButton(
              onPressed: () async {
                if (updateLink.isNotEmpty) {
                  final uri = Uri.parse(updateLink);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }
              },
              child: const Text("Update Now"),
            ),
          ],
        );
      },
    );
  }

  static int _compareVersions(String v1, String v2) {
    final a = v1.split('.').map(int.parse).toList();
    final b = v2.split('.').map(int.parse).toList();
    for (var i = 0; i < 3; i++) {
      final diff = (a.length > i ? a[i] : 0) - (b.length > i ? b[i] : 0);
      if (diff != 0) return diff;
    }
    return 0;
  }
}
