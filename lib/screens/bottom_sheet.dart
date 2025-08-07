import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:psit_lite/models/student.dart';
import 'package:psit_lite/screens/login_screen.dart';
import 'package:psit_lite/services/fetch_service.dart';
import 'package:psit_lite/theme/theme.dart';
import 'package:psit_lite/utils/util.dart';
import 'package:psit_lite/widgets/liked_widget.dart';
import 'package:psit_lite/widgets/shimmer_box.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  bool isLoading = true;
  Image? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    Uint8List? imageBytes;
    try {
      imageBytes = await FetchService.getProfileImage();
    } catch (_) {}

    setState(() {
      isLoading = false;
      _profileImage = imageBytes == null
          ? null
          : Image.memory(imageBytes, scale: 8, fit: BoxFit.fill);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.horizontal_rule, color: Colors.grey),
          const SizedBox(height: 8),
          Row(
            spacing: 16,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: isLoading
                    ? SizedBox(width: 46, child: ShimmerBox(height: 58))
                    : _profileImage ?? Icon(Icons.error_outline, size: 48),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Student.data.name, style: theme.textTheme.titleMedium),
                    Text(
                      Student.data.userId,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return Column(children: [Text('University Roll No.')]);
                    },
                  );
                },

                child: TextButton(
                  onPressed: () => showStudentDetailsDialog(context),
                  child: Text(
                    'More',
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: ThemeController.themeMode.value == ThemeMode.dark,
              onChanged: (value) {
                ThemeController.toggleTheme();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => showAppAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              await performPostLogout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> showAppAboutDialog(BuildContext context) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String appName = packageInfo.appName;
    final String version = packageInfo.version;

    if (!context.mounted) return;

    final theme = Theme.of(context);

    showAboutDialog(
      context: context,
      applicationName: appName,
      applicationVersion: 'v$version',
      applicationIcon: Image.asset(
        theme.brightness == Brightness.light
            ? 'assets/icon_dark.png'
            : 'assets/icon_light.png',
        width: 64,
        height: 64,
      ),
      applicationLegalese: '© 2025 adiora',
      children: [
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              const TextSpan(
                text:
                    'PSiT Lite is a lightweight app to check your attendance, timetable, marks, and more with a clean interface.\n\n'
                    'This app is unofficial and not affiliated with PSIT. It accesses data from the official ERP system for your convenience.\n\n'
                    'I do not collect any personal information through this app.\n\n'
                    'For sugesstions or issues, feel free to reach out to me at ',
              ),
              TextSpan(
                text: 'support@psitlite.space',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('mailto:support@psitlite.space'));
                  },
              ),
              const TextSpan(text: '\n\nVisit '),
              TextSpan(
                text: 'PSiT Lite',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('https://psitlite.space'));
                  },
              ),

              const TextSpan(text: ' for more.'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const LikedWidget(),
      ],
    );
  }

  Future<void> showStudentDetailsDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final heading = theme.textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );
    final para = theme.textTheme.bodyMedium;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Student Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text('University Roll No:', style: heading),
              Text(Student.data.userId, style: para),
              const SizedBox(height: 12),
              Text('Library Code:', style: heading),
              Text(Student.data.sId, style: para),
              const SizedBox(height: 12),
              Text('Name:', style: heading),
              Text(Student.data.name, style: para),
              const SizedBox(height: 12),
              Text('Section:', style: heading),
              Text(Student.data.section, style: para),
              const SizedBox(height: 12),
              Text('Date of Birth:', style: heading),
              Text(Student.data.dob, style: para),
              const SizedBox(height: 12),
              Text('Phone:', style: heading),
              Text(Student.data.phone, style: para),
              const SizedBox(height: 12),
              Text('Email:', style: heading),
              Text(Student.data.email, style: para),
              const SizedBox(height: 12),
              Text('Temp Address:', style: heading),
              Text(Student.data.tempAddress, style: para),
              const SizedBox(height: 12),
              Text('Permanent Address:', style: heading),
              Text(Student.data.permanentAddress, style: para),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
