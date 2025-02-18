class TrainingCategory {
  String? id;
  String? name;
  String? createdDate;
  String? createdBy;
  String? updateBy;
  String? updateDate;

  TrainingCategory({
    this.id,
    this.name,
    this.createdDate,
    this.createdBy,
    this.updateBy,
    this.updateDate,
  });

  factory TrainingCategory.fromJson(Map<String, dynamic> json) {
    return TrainingCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      createdDate: json['createdDate'] as String?,
      createdBy: json['createdBy'] as String?,
      updateBy: json['updateBy'] as String?,
      updateDate: json['updateDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'updateBy': updateBy,
      'updateDate': updateDate,
    };
  }
}