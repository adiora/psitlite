import 'package:flutter/material.dart';
import 'package:psit_lite/services/fetch_service.dart';
import 'package:psit_lite/theme/app_theme.dart';
import 'package:psit_lite/widgets/error_refresh_box.dart';
import 'package:psit_lite/widgets/label_box.dart';
import 'package:psit_lite/widgets/shimmer_box.dart';
import 'attendance_screen.dart';
import '../../models/student_attendance.dart';

class AttendanceSection extends StatefulWidget {
  const AttendanceSection({super.key});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  String error = '';
  bool isLoading = true;
  AttendanceSummary? summary;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() {
      isLoading = true;
    });

    try {
      summary = await FetchService.getAttendanceSummary();
      error = '';
    } catch (e) {
      error = e.toString();
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 0,
          ),
          title: Hero(
            tag: 'attendance_title',
            child: Material(
              color: Colors.transparent,
              child: Text('Attendance', style: theme.textTheme.titleLarge),
            ),
          ),
          trailing: isLoading || summary == null
              ? null
              : Icon(
                  Icons.navigate_next,
                  color: theme.colorScheme.secondary,
                ),
          onTap: isLoading || summary == null
              ? null
              : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AttendanceScreen(summary: summary!),
                  ),
                ),
        ),
        Material(
          color: Colors.transparent,
          child: isLoading
              ? Column(
                  spacing: 8,
                  children: List.generate(
                    2,
                    (_) => Row(
                      spacing: 8,
                      children: List.generate(
                        2,
                        (_) => const Expanded(child: ShimmerBox(height: 65)),
                      ),
                    ),
                  ),
                )
              : summary == null
              ? ErrorRefreshBox(
                  errorMessage: 'Couldn\'t fetch attendance\n$error',
                  onRefresh: _fetchAttendance,
                )
              : Hero(
                  tag: 'attendance_summary',
                  child: Column(
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          LabelBox(
                            label: 'Lectures',
                            value: summary!.total.toString(),
                            color: theme.colorScheme.tertiaryContainer
                                .withAlpha(150),
                          ),
                          LabelBox(
                            label: 'Percent',
                            value: (summary!.total == 0 ? 100 : summary!.percent).toStringAsFixed(
                              1,
                            ),
                            color:
                                (isDark
                                        ? AppColors.darkSuccessContainer
                                        : AppColors.lightSuccessContainer)
                                    .withAlpha(150),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8, // Using spacing property
                        children: [
                          LabelBox(
                            label: 'Absent',
                            value: summary!.absent.toString(),
                            color: theme.colorScheme.errorContainer.withAlpha(
                              150,
                            ),
                          ),
                          LabelBox(
                            label: 'OAA',
                            value: summary!.oaa.toString(),
                            color: theme.colorScheme.secondaryContainer
                                .withAlpha(150),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
