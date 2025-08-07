import 'package:flutter/material.dart';
import 'package:psit_lite/models/marks.dart';
import 'package:psit_lite/models/test_list.dart';
import 'package:psit_lite/services/api_service.dart';
import 'package:psit_lite/services/fetch_service.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  bool isLoadingTestList = true;
  bool isLoadingMarks = false;
  String errorTestList = '';
  String errorMarks = '';
  TestList? testList;
  Marks? marks;
  Test? selectedTest;

  @override
  void initState() {
    super.initState();
    _fetchTestList();
  }

  Future<void> _fetchTestList() async {
    try {
      final fetched = await FetchService.getTestList();
      setState(() {
        testList = fetched;
        errorTestList = '';
        isLoadingTestList = false;
      });
    } catch (e) {
      setState(() {
        errorTestList = e.toString();
        isLoadingTestList = false;
      });
    }
  }

  Future<void> _fetchMarks(String testID, {bool refresh = false}) async {
    setState(() {
      isLoadingMarks = true;
      errorMarks = '';
    });

    try {
      final fetched = await (refresh
          ? ApiService.getMarks(testID: testID)
          : FetchService.getMarks(testID));
      setState(() {
        marks = fetched;
        isLoadingMarks = false;
      });
    } catch (e) {
      setState(() {
        errorMarks = e.toString();
        isLoadingMarks = false;
      });
    }
  }

  Future<void> _refreshMarks() {
    return _fetchMarks(selectedTest!.id, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'marks_title',
          child: Material(
            color: Colors.transparent,
            child: Text('Marks', style: theme.textTheme.titleLarge),
          ),
        ),
      ),
      body: isLoadingTestList
          ? const LinearProgressIndicator()
          : errorTestList.isNotEmpty
          ? _buildError(errorTestList, theme)
          : testList!.tests.isEmpty
          ? Center(
              child: Text(
                'No tests found',
                style: theme.textTheme.bodyLarge
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshMarks,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 8,
                      children: testList!.tests.map((test) {
                        return ChoiceChip(
                          elevation: 2,
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          label: SizedBox(
                            width: 50,
                            child: Text(
                              test.name,
                              style: theme.textTheme.labelLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          selected: selectedTest == test,
                          onSelected: (_) {
                            setState(() {
                              selectedTest = test;
                            });
                            _fetchMarks(test.id);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  if (isLoadingMarks)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(),
                    )
                  else if (errorMarks.isNotEmpty)
                    _buildError(errorMarks, theme)
                  else if (selectedTest != null && marks != null)
                    Expanded(
                      child: marks!.markList.isEmpty
                          ? Center(
                              child: Text(
                                'No marks found',
                                style: theme.textTheme.bodyLarge,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              itemCount: marks!.markList.length,
                              itemBuilder: (context, index) {
                                return MarksCard(
                                  test: selectedTest!,
                                  mark: marks!.markList[index],
                                );
                              },
                            ),
                    )
                  else
                    const Row(),
                ],
              ),
            ),
    );
  }

  Widget _buildError(String text, ThemeData theme) {
    return Center(
      child: Text(
        text,
        style: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}

class MarksCard extends StatelessWidget {
  final Test test;
  final Mark mark;

  const MarksCard({super.key, required this.test, required this.mark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAbsent = mark.marks == -1;

    return Card(
      elevation: 4,
      shadowColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mark.subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isAbsent
                      ? 'Absent'
                      : '${mark.marks % 1 == 0 ? mark.marks.toInt() : mark.marks}/${test.maxMarks}',
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: isAbsent ? 0 : (mark.marks / test.maxMarks),
              minHeight: 8,
              color: isAbsent
                  ? Colors.grey
                  : theme.colorScheme.primary.withAlpha(128),
            ),
          ],
        ),
      ),
    );
  }
}
