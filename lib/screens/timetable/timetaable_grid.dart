import 'package:flutter/material.dart';
import 'package:psit_lite/models/student_timetable.dart';
import 'package:psit_lite/screens/timetable/timetable_constants.dart';
import 'package:psit_lite/services/fetch_service.dart';

class TimetableGrid extends StatefulWidget {
  final DateTime initialDateTime;
  final StudentTimetable initialTimetable;
  final Orientation orientation;

  const TimetableGrid({
    super.key,
    required this.initialTimetable,
    required this.initialDateTime,
    required this.orientation,
  });

  @override
  State<TimetableGrid> createState() => _TimetableGridState();
}

class _TimetableGridState extends State<TimetableGrid> {
  late DateTime dateTime;
  late List<List<Period?>> periods;
  late int dayCount;
  late int lunchIndex;

  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    dateTime = widget.initialDateTime;
    periods = widget.initialTimetable.periods;
    _updateDayAndLunchIndex();
  }

  void _updateDayAndLunchIndex() {
    dayCount = periods[5][0] == null ? 5 : 6;
    lunchIndex = periodTimes[4] == '12:35\n13:25' ? 4 : 3;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LinearProgressIndicator();
    }

    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    if (error.isNotEmpty) {
      final theme = Theme.of(context);
      return Container(
        alignment: Alignment.bottomCenter,
        height: size.height / 2,
        child: Text(error, style: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.error
        )));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: widget.orientation == Orientation.portrait
          ? PortraitTable(
              dateTime: dateTime,
              periods: periods,
              dayCount: dayCount,
              lunchIndex: lunchIndex,
              onDateSelected: _onDateSelected,
              size: size,
            )
          : LandscapeTable(
              dateTime: dateTime,
              periods: periods,
              dayCount: dayCount,
              lunchIndex: lunchIndex,
              onDateSelected: _onDateSelected,
              size: size,
            ),
    );
  }

  Future<void> _onDateSelected(DateTime picked) async {
    if (picked.month == dateTime.month && picked.day == dateTime.day) return;

    setState(() => isLoading = true);
    try {
      final date = '${_pad(picked.month)}/${_pad(picked.day)}/${picked.year}';
      final timetable = await FetchService.getTimetable(date: date);
      setState(() {
        periods = timetable.periods;
        dateTime = picked;
        isLoading = false;
        _updateDayAndLunchIndex();
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}

const double minCellHeight = 60;

class PortraitTable extends StatelessWidget {
  final DateTime dateTime;
  final List<List<Period?>> periods;
  final int dayCount;
  final int lunchIndex;
  final Future<void> Function(DateTime) onDateSelected;
  final Size size;

  const PortraitTable({
    super.key,
    required this.dateTime,
    required this.periods,
    required this.dayCount,
    required this.lunchIndex,
    required this.onDateSelected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final height = size.height / 11.7;

    final cellHeight = minCellHeight > height ? minCellHeight : height;

    return Table(
      border: TableBorder.all(color: color.outline),
      columnWidths: {0: FixedColumnWidth(80)},
      defaultColumnWidth: FixedColumnWidth(120),
      children: [
        TableRow(
          children: [
            SelectDateCell(dateTime: dateTime, onDateSelected: onDateSelected, cellHeight: cellHeight * 0.8,),
            for (int dayIndex = 0; dayIndex < dayCount; ++dayIndex)
              DayCell(dayIndex: dayIndex, cellHeight: cellHeight * 0.8),
          ],
        ),
        for (
          int periodIndex = 0;
          periodIndex < periodTimes.length;
          ++periodIndex
        ) ...[
          TableRow(
            children: [
              PeriodTimeCell(
                time: periodTimes[periodIndex],
                cellHeight: cellHeight,
              ),
              for (int dayIndex = 0; dayIndex < dayCount; ++dayIndex)
                SubjectCell(
                  period: periods[dayIndex][periodIndex],
                  cellHeight: cellHeight,
                ),
            ],
          ),
          if (periodIndex == 1 || periodIndex == 5)
            _buildTableRow(
              theme,
              span: dayCount + 1,
              text: 'Break',
              height: cellHeight * 0.4,
              backgroundColor: color.surfaceContainerHighest,
            ),
          if (periodIndex == lunchIndex)
            _buildTableRow(
              theme,
              span: dayCount + 1,
              text: 'Lunch',
              height: cellHeight * 0.6,
              backgroundColor: color.primaryContainer,
            ),
        ],
      ],
    );
  }

  TableRow _buildTableRow(
    ThemeData theme, {
    required int span,
    required String text,
    required double height,
    required Color backgroundColor,
  }) {
    final color = theme.colorScheme;
    final textTheme = theme.textTheme;

    return TableRow(
      children: [
        Container(
          height: height,
          alignment: Alignment.center,
          color: backgroundColor,
          child: Text(
            text,
            style: textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: color.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        for (int i = 1; i < span; ++i)
          Container(height: height, color: backgroundColor),
      ],
    );
  }
}

class LandscapeTable extends StatelessWidget {
  final DateTime dateTime;
  final List<List<Period?>> periods;
  final int dayCount;
  final int lunchIndex;
  final Future<void> Function(DateTime) onDateSelected;
  final Size size;

  const LandscapeTable({
    super.key,
    required this.dateTime,
    required this.periods,
    required this.dayCount,
    required this.lunchIndex,
    required this.onDateSelected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final height = size.height / 6;

    final cellHeight = minCellHeight > height ? minCellHeight : height;

    return Table(
      border: TableBorder.all(color: color.outline),
      columnWidths: {
        0: FixedColumnWidth(80),
        3: FixedColumnWidth(24),
        lunchIndex + 3: FixedColumnWidth(36),
        9: FixedColumnWidth(24),
      },
      defaultColumnWidth: const FixedColumnWidth(120),
      children: [
        TableRow(
          children: [
            SelectDateCell(dateTime: dateTime, onDateSelected: onDateSelected, cellHeight: cellHeight * 0.8,),
            for (
              int periodIndex = 0;
              periodIndex < periodTimes.length;
              ++periodIndex
            ) ...[
              PeriodTimeCell(
                time: periodTimesLandscape[periodIndex],
                cellHeight: cellHeight * 0.8,
              ),

              if (periodIndex == 1 ||
                  periodIndex == 5 ||
                  periodIndex == lunchIndex)
                Container(
                  height: cellHeight * 0.8,
                  alignment: Alignment.center,
                  color: periodIndex == lunchIndex
                      ? color.primaryContainer
                      : color.surfaceContainerHighest,
                  child: Text(
                    periodIndex == lunchIndex ? 'L' : 'B',
                    style: theme.textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ],
        ),
        for (int dayIndex = 0; dayIndex < dayCount; ++dayIndex)
          TableRow(
            children: [
              DayCell(dayIndex: dayIndex, cellHeight: cellHeight),
              for (
                int periodIndex = 0;
                periodIndex < periodTimes.length;
                ++periodIndex
              ) ...[
                SubjectCell(
                  period: periods[dayIndex][periodIndex],
                  cellHeight: cellHeight,
                ),

                if (periodIndex == 1 ||
                    periodIndex == 5 ||
                    periodIndex == lunchIndex)
                  Container(
                    height: cellHeight,
                    color: periodIndex == lunchIndex
                        ? color.primaryContainer
                        : color.surfaceContainerHighest,
                  ),
              ],
            ],
          ),
      ],
    );
  }
}

class SelectDateCell extends StatelessWidget {
  final DateTime dateTime;
  final Future<void> Function(DateTime) onDateSelected;
  final double cellHeight;

  const SelectDateCell({
    super.key,
    required this.dateTime,
    required this.onDateSelected,
    required this.cellHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cellHeight,
      alignment: Alignment.center,
      child: TextButton(
        style: Theme.of(context).textButtonTheme.style!.copyWith(
          padding: WidgetStatePropertyAll(EdgeInsetsGeometry.zero),
        ),
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: dateTime.subtract(const Duration(days: 364)),
            lastDate: dateTime.add(const Duration(days: 364)),
          );
          if (picked != null) onDateSelected(picked);
        },
        child: Text(
          textAlign: TextAlign.center,
          'Select\n${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${(dateTime.year % 100).toString().padLeft(2, '0')}',
        ),
      ),
    );
  }
}

class DayCell extends StatelessWidget {
  final int dayIndex;
  final double cellHeight;

  const DayCell({super.key, required this.dayIndex, required this.cellHeight});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      height: cellHeight,
      alignment: Alignment.center,
      color: color.primaryContainer,
      child: Text(
        weekdaydAbbr[dayIndex],
        style: text.labelLarge!.copyWith(
          color: color.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PeriodTimeCell extends StatelessWidget {
  final String time;
  final double cellHeight;

  const PeriodTimeCell({
    super.key,
    required this.time,
    required this.cellHeight,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.center,
      height: cellHeight,
      color: color.surfaceContainerHighest,
      child: Text(
        time,
        style: text.labelLarge!.copyWith(
          color: color.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SubjectCell extends StatelessWidget {
  final Period? period;
  final double cellHeight;

  const SubjectCell({
    super.key,
    required this.period,
    required this.cellHeight,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (period == null) {
      return Container(height: cellHeight, color: color.surface);
    }

    return Container(
      height: cellHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      color: period!.isLab ? color.tertiaryContainer : color.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            period!.subjectCode,
            style: text.labelLarge!.copyWith(
              color: period!.isLab
                  ? color.onTertiaryContainer
                  : color.onSurface,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            period!.empName,
            style: text.labelMedium!.copyWith(
              color: period!.isLab
                  ? color.onTertiaryContainer.withAlpha(180)
                  : color.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            period!.room,
            style: text.labelMedium!.copyWith(
              color: period!.isLab
                  ? color.onTertiaryContainer.withAlpha(180)
                  : color.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
