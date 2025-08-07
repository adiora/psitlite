import 'package:flutter/material.dart';
import 'package:psit_lite/screens/announcements_screen.dart';
import 'package:psit_lite/screens/bottom_sheet.dart';
import 'package:psit_lite/screens/marks/marks_screen.dart';
import 'package:psit_lite/screens/marks/oltmarks_screen.dart';
import 'package:psit_lite/screens/timetable/timetable_section.dart';
import 'attendance/attendance_section.dart';
import '../widgets/background_shape.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Image.asset(theme.brightness == Brightness.light? 'assets/icon_dark.png' : 'assets/icon_light.png', width: 48, height: 48),
              const SizedBox(width: 8,),
              Text('Dashboard', style: theme.textTheme.titleLarge),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnnouncementScreen(),
              ),
            ),
            icon: Icon(Icons.notifications_outlined),
            color: theme.colorScheme.secondary,
          ),
          IconButton(
            color: theme.colorScheme.secondary,
            icon: Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const ModalBottomSheet(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const BackgroundShape(),
          SafeArea(
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AttendanceSection(),
                    const TimetableSection(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'marks_title',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Marks',
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'View Marks',
                            style: theme.textTheme.titleMedium,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.secondary,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return const MarksScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(
                            'View OLT Marks',
                            style: theme.textTheme.titleMedium,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.secondary,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 0,
                          ),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return const OltScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
