import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psit_lite/models/student_timetable.dart';
import 'package:psit_lite/screens/timetable/timetaable_grid.dart';
import 'package:psit_lite/screens/timetable/timetable_orientation.dart';

class TimetableScreen extends StatefulWidget {
  final DateTime dateTime;
  final StudentTimetable timetable;

  const TimetableScreen({
    super.key,
    required this.timetable,
    required this.dateTime,
  });

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  static Orientation? orientation;

  @override
  void initState() {
    super.initState();
    _initializeOrientation();
  }

  Future<void> _initializeOrientation() async {
    final orient = await TimetableOrientation.getOrientation();
    setState(() {
      orientation = orient;
    });
    _updateDeviceOrientation();
  }

  @override
  Widget build(BuildContext context) {
    if (orientation == null) {
      return Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: 'timetable_title',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Timetable',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              AppBar(
                title: Hero(
                  tag: 'timetable_title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text('Timetable', style: theme.textTheme.titleLarge),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () =>
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text('Subject Info'),
                            content:  SingleChildScrollView(
                              child: SubjectInfo(timetable: widget.timetable)
                            )
                          );
                        }),
                    icon: Icon(Icons.info_outline),
                  ),

                  IconButton(
                    onPressed: _toggleOrientation,
                    icon: Icon(
                      orientation == Orientation.portrait
                          ? Icons.stay_current_portrait_outlined
                          : Icons.stay_current_landscape_outlined,
                    ),
                  ),
                ],
              ),
              TimetableGrid(
                initialTimetable: widget.timetable,
                initialDateTime: widget.dateTime,
                orientation: orientation!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleOrientation() async {
    setState(() {
      orientation = orientation == Orientation.portrait
          ? Orientation.landscape
          : Orientation.portrait;
    });
    _updateDeviceOrientation();
    await TimetableOrientation.setOrientation(orientation!);
  }

  void _updateDeviceOrientation() {
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }
}

class SubjectInfo extends StatelessWidget {
  final StudentTimetable timetable;

  const SubjectInfo({super.key, required this.timetable});

  static final subjectInfo = <String, String>{};

  @override
  Widget build(BuildContext context) {
    if (subjectInfo.isEmpty) {
      for (final day in timetable.periods) {
        for (final period in day) {
          if (period != null) {
            subjectInfo[period.subjectCode] = period.subjectName;
          }
        }
      }
    }

    final theme = Theme.of(context);
    final heading = theme.textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );
    final para = theme.textTheme.bodyMedium;

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subjectInfo.entries.map((subject) {
        return Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject.key, style: heading),
            Text(subject.value, style: para,)
          ],
        );
      }).toList()
    );
  }
}
