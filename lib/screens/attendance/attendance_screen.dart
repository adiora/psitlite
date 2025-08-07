import 'package:flutter/material.dart';
import 'package:psit_lite/services/fetch_service.dart';
import 'package:psit_lite/theme/app_theme.dart';
import 'package:psit_lite/widgets/label_box.dart';
import '../../models/student_attendance.dart';

class AttendanceScreen extends StatefulWidget {
  final AttendanceSummary summary;

  const AttendanceScreen({super.key, required this.summary});

  @override
  State<StatefulWidget> createState() {
    return _AttendanceScreenState();
  }
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = true;
  String? error;
  AttendanceDetails? details;

  late int present;

  @override
  void initState() {
    super.initState();
    present = widget.summary.total - widget.summary.absent;
    _fetchAttendanceDetails();
  }

  Future<void> _fetchAttendanceDetails() async {
    try {
      details = await FetchService.getAttendanceDetails();
      error = null;
    } catch (e) {
      error = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final percent = widget.summary.total == 0? 100 : widget.summary.percent;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Hero(
          tag: 'attendance_title',
          child: Material(
            color: Colors.transparent,
            child: Text('Attendance', style: theme.textTheme.titleLarge),
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 24),
        actions: [
          Tooltip(
            message: 'Rate of increase of percentage',
            child: Text(
              '${((present + 8) / (widget.summary.total + 8) * 100 - percent).toStringAsFixed(2)}%',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: isDark ? Colors.green.shade300 : Colors.green.shade800,
              ),
            ),
          ),

          const SizedBox(width: 8),
          Tooltip(
            message: 'Rate of decrease of percentage',
            child: Text(
              '${(percent - (present) / (widget.summary.total + 8) * 100).toStringAsFixed(2)}%',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 12,
          children: [
            Material(
              color: Colors.transparent,
              child: Hero(
                tag: 'attendance_summary',
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        LabelBox(
                          label: 'Lectures',
                          value: widget.summary.total.toString(),
                          color: theme.colorScheme.tertiaryContainer.withAlpha(
                            150,
                          ),
                        ),
                        LabelBox(
                          label: 'Percent',
                          value: percent.toStringAsFixed(1),
                          color:
                              (isDark
                                      ? AppColors.darkSuccessContainer
                                      : AppColors.lightSuccessContainer)
                                  .withAlpha(150),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        LabelBox(
                          label: 'Absent',
                          value: widget.summary.absent.toString(),
                          color: theme.colorScheme.errorContainer.withAlpha(
                            150,
                          ),
                        ),
                        LabelBox(
                          label: 'OAA',
                          value: widget.summary.oaa.toString(),
                          color: theme.colorScheme.secondaryContainer.withAlpha(
                            150,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                spacing: 4,
                children: [
                  Expanded(
                    child: Text(
                      'Absent Details',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Icon(Icons.square, color: theme.colorScheme.errorContainer),
                  Text('Absent', style: theme.textTheme.labelLarge),
                  Icon(
                    Icons.square,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                  Text('OAA', style: theme.textTheme.labelLarge),
                ],
              ),
            ),

            if (isLoading)
              const LinearProgressIndicator()
            else if (error != null ||
                (details != null && details!.absents.isEmpty)) ...{
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 200,
                ),
                child: error != null
                    ? Text(
                        error!,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      )
                    : Text(
                        'No records found',
                        style: theme.textTheme.bodyLarge,
                      ),
              ),
            } else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  itemCount: details!.absents.length,
                  itemBuilder: (context, index) {
                    final periods = details!.absents[index].periods;

                    return Column(
                      children: [
                        Row(
                          spacing: 16,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              details!.absents[index].date,
                              style: theme.textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: Wrap(
                                spacing: 16,
                                children: List.generate(9, (pIndex) => pIndex)
                                    .where((pIndex) => periods[pIndex] != 0)
                                    .map((pIndex) {
                                      final status = periods[pIndex];
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: status == 1
                                              ? theme.colorScheme.errorContainer
                                              : theme
                                                    .colorScheme
                                                    .secondaryContainer,
                                        ),
                                        child: Text(
                                          (pIndex + 1).toString(),
                                          style: theme.textTheme.labelLarge!
                                              .copyWith(
                                                color: status == 1
                                                    ? theme
                                                          .colorScheme
                                                          .onErrorContainer
                                                    : theme
                                                          .colorScheme
                                                          .onSecondaryContainer,
                                              ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1.5,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
