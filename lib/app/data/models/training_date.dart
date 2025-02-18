class TrainingDate {
  String? id;
  String? trainingId;
  String? date;
  String? createdDate;
  String? createdBy;
  String? updateBy;
  String? updateDate;

  TrainingDate({
    this.id,
    this.trainingId,
    this.date,
    this.createdDate,
    this.createdBy,
    this.updateBy,
    this.updateDate,
  });

  factory TrainingDate.fromJson(Map<String, dynamic> json) {
    return TrainingDate(
      id: json['id'] as String?,
      trainingId: json['trainingId'] as String?,
      date: json['date'] as String?,
      createdDate: json['createdDate'] as String?,
      createdBy: json['createdBy'] as String?,
      updateBy: json['updateBy'] as String?,
      updateDate: json['updateDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainingId': trainingId,
      'date': date,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'updateBy': updateBy,
      'updateDate': updateDate,
    };
  }
}