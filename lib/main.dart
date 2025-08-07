import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:psit_lite/firebase_options.dart';
import 'package:psit_lite/models/student.dart';
import 'package:psit_lite/models/student_data.dart';
import 'package:psit_lite/services/cache_service.dart';
import 'package:psit_lite/services/fetch_service.dart';
import 'package:psit_lite/services/update_service.dart';
import 'package:psit_lite/theme/theme.dart';
import 'package:psit_lite/theme/app_theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await ThemeController.setInitialTheme();
  StudentData? data;

  data = await FetchService.getStudentDetails();
  if (data != null) {
    Student.initializeWith(data: data);
  }

  runApp(
    ValueListenableBuilder(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: _RootInitializer(
            child: data == null ? const LoginScreen() : const DashboardScreen(),
          ),
        );
      },
    ),
  );
}

class _RootInitializer extends StatefulWidget {
  final Widget child;
  const _RootInitializer({required this.child});

  @override
  State<_RootInitializer> createState() => _RootInitializerState();
}

class _RootInitializerState extends State<_RootInitializer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkAndPromptUpdate(context);
      CacheService.clearOldCache();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
