class Announcements {
  final List<Announcement> list;

  const Announcements({required this.list});

  factory Announcements.fromJson(List<dynamic> json) {
    List<Announcement> announcements = [];

    for (var entry in json) {
      announcements.add(
        Announcement(
          heading: entry['Name'].toString(),
          filename: entry['filename'].toString(),
        ),
      );
    }

    return Announcements(list: announcements);
  }
}

class Announcement {
  final String heading;
  final String filename;

  const Announcement({required this.heading, required this.filename});
}
