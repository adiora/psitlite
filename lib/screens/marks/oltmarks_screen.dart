import 'package:flutter/material.dart';
import 'package:psit_lite/models/olt_report.dart';
import 'package:psit_lite/screens/marks/oltsolution_screen.dart';
import 'package:psit_lite/services/api_service.dart';
import 'package:psit_lite/services/fetch_service.dart';

class OltScreen extends StatefulWidget {
  const OltScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OltScreenState();
}

class _OltScreenState extends State<OltScreen> {
  bool isLoading = true;
  String? error;
  List<OltDetail> oltList = [];

  @override
  void initState() {
    super.initState();
    _fetchOltReport();
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _fetchOltReport({bool refresh = false}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final report = await (refresh
          ? ApiService.getOltReport()
          : FetchService.getOltReport());
      oltList = report.list;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshOltReport() async {
    oltList = [];
    return _fetchOltReport(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('OLT ', style: theme.textTheme.titleLarge),
            Hero(
              tag: 'marks_title',
              child: Material(
                color: Colors.transparent,
                child: Text('Marks', style: theme.textTheme.titleLarge),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: _refreshOltReport,
              child: oltList.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height/2 - 48),
                        Center(
                          child: error == null
                              ? Text(
                                  'No OLT Marks found',
                                  style: theme.textTheme.bodyLarge,
                                )
                              : Text(
                                  error!,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: oltList.length,
                      itemBuilder: (_, index) {
                        final olt = oltList[index];
                        final total = olt.correct + olt.incorrect;
                        final percentage = (olt.correct / total * 100)
                            .toStringAsFixed(1);

                        return Card(
                          elevation: 5,
                          margin: EdgeInsetsGeometry.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          clipBehavior: Clip.antiAlias,
                          shape: theme.cardTheme.shape,
                          child: InkWell(
                            focusColor: theme.colorScheme.primary.withAlpha(48),
                            highlightColor: theme.colorScheme.primary.withAlpha(
                              48,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatDate(olt.date),
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(
                                          color: theme
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    olt.testName,
                                    style: theme.textTheme.labelLarge!.copyWith(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _infoTile(
                                        'Questions',
                                        '$total',
                                        Colors.blue,
                                        theme,
                                      ),

                                      _infoTile(
                                        'Correct',
                                        '${olt.correct}',
                                        Colors.green,
                                        theme,
                                      ),
                                      _infoTile(
                                        'Incorrect',
                                        '${olt.incorrect}',
                                        Colors.red,
                                        theme,
                                      ),
                                      _infoTile(
                                        'Percent',
                                        '$percentage%',
                                        Colors.teal,
                                        theme,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OltSolutionScreen(olt: olt),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Widget _infoTile(String label, String value, Color color, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
