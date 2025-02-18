class Training {
  String? id;
  String? categoryId;
  String? name;
  String? duration;
  String? cost;
  String? quota;
  String? remainingSeats;
  String? status;
  String? createdDate;
  String? createdBy;
  String? updateBy;
  String? updateDate;

  Training({
    this.id,
    this.categoryId,
    this.name,
    this.duration,
    this.cost,
    this.quota,
    this.remainingSeats,
    this.status,
    this.createdDate,
    this.createdBy,
    this.updateBy,
    this.updateDate,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] as String?,
      categoryId: json['categoryId'] as String?,
      name: json['name'] as String?,
      duration: json['duration'] as String?,
      cost: json['cost'] as String?,
      quota: json['quota'] as String?,
      remainingSeats: json['remainingSeats'] as String?,
      status: json['status'] as String?,
      createdDate: json['createdDate'] as String?,
      createdBy: json['createdBy'] as String?,
      updateBy: json['updateBy'] as String?,
      updateDate: json['updateDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'duration': duration,
      'cost': cost,
      'quota': quota,
      'remainingSeats': remainingSeats,
      'status': status,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'updateBy': updateBy,
      'updateDate': updateDate,
    };
  }
}