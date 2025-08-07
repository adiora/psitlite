import 'package:flutter/material.dart';
import 'package:psit_lite/env/env.dart';
import 'package:psit_lite/models/announcements.dart';
import 'package:psit_lite/services/api_service.dart';
import 'package:psit_lite/services/fetch_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements', style: theme.textTheme.titleLarge),
      ),
      body: const AnnouncementListView(),
    );
  }
}

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({super.key});

  @override
  State<AnnouncementListView> createState() => _AnnouncementListViewState();
}

class _AnnouncementListViewState extends State<AnnouncementListView> {
  bool isLoading = true;
  String? error;
  List<Announcement> announcementList = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements({bool refresh = false}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetched = await (refresh
          ? ApiService.getAnnouncements()
          : FetchService.getAnnouncements());
      announcementList = fetched.list;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshAnnouncements() async {
    return _fetchAnnouncements(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LinearProgressIndicator();
    }
    if (error != null) {
      final theme = Theme.of(context);
      return Center(
        child: Text(
          error!,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      );
    }
    if (announcementList.isEmpty) {
      return const Center(child: Text('No announcements'));
    }

    return RefreshIndicator(
      onRefresh: _refreshAnnouncements,
      child: ListView.builder(
        itemCount: announcementList.length,
        itemBuilder: (_, index) =>
            AnnouncementChip(announcement: announcementList[index]),
      ),
    );
  }
}

class AnnouncementChip extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementChip({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 5,
      margin: const EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: theme.cardTheme.shape,
      child: InkWell(
        focusColor: theme.colorScheme.primary.withAlpha(48),
        highlightColor: theme.colorScheme.primary.withAlpha(48),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Text(announcement.heading, style: theme.textTheme.bodyMedium),
        ),
        onTap: () async {
          final uri = Uri.parse('${Env.noticeUrl}/${announcement.filename}');
          if (await canLaunchUrl(uri)) {
            launchUrl(uri, mode: LaunchMode.platformDefault);
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Could not open announcement',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }
}
