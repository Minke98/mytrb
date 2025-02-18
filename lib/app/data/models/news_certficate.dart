class NewsCertificate {
  String? id;
  String? url;
  String? title;
  String? text;
  String? createTime;
  String? uc;
  String? file;
  String? category;
  bool isRead;

  NewsCertificate({
    this.id,
    this.url,
    this.title,
    this.text,
    this.createTime,
    this.uc,
    this.file,
    this.category,
    this.isRead = false,
  });

  // Method to convert from JSON
  factory NewsCertificate.fromJson(Map<String, dynamic> json) {
    return NewsCertificate(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      text: json['text'],
      createTime: json['create_time'],
      uc: json['uc'],
      file: json['file'],
      category: json['category'],
      isRead: json['isRead'] ?? false,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'text': text,
      'create_time': createTime,
      'uc': uc,
      'file': file,
      'category': category,
      'isRead': isRead,
    };
  }

  // Method to create a copy of the News object with modified properties
  NewsCertificate copyWith({
    String? id,
    String? url,
    String? title,
    String? text,
    DateTime? createTime,
    String? uc,
    String? file,
    String? category,
    bool? isRead,
  }) {
    return NewsCertificate(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      text: text ?? this.text,
      createTime: this.createTime,
      uc: uc ?? this.uc,
      file: file ?? this.file,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }
}
