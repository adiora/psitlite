import 'package:flutter/material.dart';
import 'package:psit_lite/models/student.dart';
import 'package:psit_lite/models/student_timetable.dart';
import 'package:psit_lite/screens/timetable/timetable_constants.dart';
import 'package:psit_lite/screens/timetable/timetable_screen.dart';
import 'package:psit_lite/services/fetch_service.dart';
import 'package:psit_lite/widgets/error_refresh_box.dart';
import 'package:psit_lite/widgets/shimmer_box.dart';

final DateTime now = DateTime.now();

class TimetableSection extends StatefulWidget {
  const TimetableSection({super.key});

  @override
  State<TimetableSection> createState() => _TimetableSectionState();
}

class _TimetableSectionState extends State<TimetableSection> {
  StudentTimetable? timetable;
  String error = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (Student.data.semester != '1' && Student.data.semester != '2') {
      periodTimes[4] = '13:25\n14:15';
    }

    _fetchTimetable();
  }

  Future<void> _fetchTimetable() async {
    setState(() {
      isLoading = true;
    });

    String pad(int n) => n.toString().padLeft(2, '0');
    final date = '${pad(now.month)}/${pad(now.day)}/${now.year}';

    try {
      timetable = await FetchService.getTimetable(date: date);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          title: Material(
            color: Colors.transparent,
            child: Hero(
              tag: 'timetable_title',
              child: Text(
                'Today\'s Timetable',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          trailing: isLoading || timetable == null
              ? null
              : Icon(Icons.navigate_next, color: theme.colorScheme.secondary,),
          onTap: isLoading || timetable == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TimetableScreen(timetable: timetable!, dateTime: now),
                    ),
                  );
                },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Text(
            weekdays[now.weekday - 1],
            style: theme.textTheme.titleMedium,
          ),
        ),

        if (isLoading)
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(4, 8, 4, 10),
            child: Column(
              spacing: 16,
              children: List.generate(4, (_) {
                return ShimmerBox(height: 60);
              }),
            ),
          )
        else if (timetable == null)
          Center(
            child: ErrorRefreshBox(
              errorMessage: 'Coudn\'t fetch timetable\n$error',
              onRefresh: _fetchTimetable,
            ),
          )
        else if (now.hour > 16 ||
            now.weekday == DateTime.sunday ||
            timetable!.periods[now.weekday - 1].every((period) => period == null))
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Center(
              child: Text(
                'zzz... no classes',
                style: theme.textTheme.titleLarge,
              ),
            ),
          )
        else
          SizedBox(
            height: 305,
            child: _PeriodView(
              initialPage: now.hour < 13 ? 0 : 1,
              periods: timetable!.periods[now.weekday - 1],
            ),
          ),
      ],
    );
  }
}

class _PeriodView extends StatelessWidget {
  final int initialPage;
  final List<Period?> periods;

  const _PeriodView({required this.initialPage, required this.periods});

  @override
  Widget build(BuildContext context) {

    final nonNullPeriods = periods.whereType<Period>().toList();

    return PageView.builder(
      controller: PageController(initialPage: initialPage),
      itemCount: nonNullPeriods.length > 4? 2 : 1,
      itemBuilder: (context, pageIndex) {
        final start = pageIndex * 4;
        final end = start + 4 > nonNullPeriods.length? nonNullPeriods.length : start + 4;
        return Column(
          children: [
          for(int i = start; i < end; ++i)
          _PeriodRow(period: nonNullPeriods[i])
          ],
        );
      },
    );
  }
}

class _PeriodRow extends StatelessWidget {
  final Period period;
  
  const _PeriodRow({required this.period});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int periodIndex = period.periodNumber;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: period.isLab
                  ? theme.colorScheme.primary.withAlpha(180)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Text(
              'P${periodIndex + 1}',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: period.isLab
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),

          Text(periodTimes[periodIndex], style: theme.textTheme.bodyMedium),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(period.subjectCode, style: theme.textTheme.bodyLarge),
                Text(period.empName, style: theme.textTheme.bodyMedium),
                Text(period.room, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
