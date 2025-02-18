class Announcement {
  String? id;
  String? title;
  String? content;
  DateTime? createdDate;
  String? createdBy;

  Announcement({
    this.id,
    this.title,
    this.content,
    this.createdDate,
    this.createdBy,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdDate: DateTime.parse(json['createdDate']),
      createdBy: json['createdBy'],
    );
  }
}
