import 'package:get/get.dart';

class TaskItem {
  String uc;
  String ucSubCompetency;
  String? taskName;
  String? category;
  String? createdAt;
  String? updatedAt;
  RxBool checked; // RxBool untuk reaktifitas
  int isApproved;
  int isLectApproved;
  String instTime;
  String initNote;
  bool isAttachmentSaved;
  String? url;
  String? appInstLocalPhoto;
  String? appInstComment;
  String? appInstName;
  String? appInstPhoto;
  String? localPhoto;
  String? attPhoto;
  String? appLectName;
  String? appLectComment;
  String? appLectPhoto;

  TaskItem({
    required this.uc,
    required this.ucSubCompetency,
    this.taskName,
    this.category,
    this.createdAt,
    this.updatedAt,
    required bool checked, // Gunakan bool untuk inputan
    required this.isApproved,
    required this.isLectApproved,
    required this.instTime,
    required this.initNote,
    required this.isAttachmentSaved,
    this.url,
    this.appInstLocalPhoto,
    this.appInstComment,
    this.appInstName,
    this.appInstPhoto,
    this.localPhoto,
    this.attPhoto,
    this.appLectName,
    this.appLectComment,
    this.appLectPhoto,
  }) : checked = checked.obs; // Konversi ke RxBool

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      uc: map['uc'] ?? '',
      ucSubCompetency: map['uc_sub_competency'] ?? '',
      taskName: map['task_name'],
      category: map['category'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      checked:
          (map['isChecked'] ?? 0) == 1, // Konversi ke bool sebelum ke RxBool
      isApproved: map['status'] ?? 0,
      isLectApproved: map['lect_status'] ?? 0,
      instTime: map['instTime'] ?? "",
      initNote: map['note'] ?? "",
      isAttachmentSaved: map['local_photo'] != null ||
          map['url'] != null ||
          map['att_photo'] != null,
      url: map['url'],
      appInstLocalPhoto: map['app_inst_local_photo'],
      appInstComment: map['app_inst_comment'],
      appInstName: map['app_inst_name'],
      appInstPhoto: map['app_inst_photo'],
      localPhoto: map['local_photo'],
      attPhoto: map['att_photo'],
      appLectName: map['app_lect_name'],
      appLectComment: map['app_lect_comment'],
      appLectPhoto: map['app_lect_photo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uc": uc,
      "uc_sub_competency": ucSubCompetency,
      "task_name": taskName,
      "category": category,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "isChecked": checked.value ? 1 : 0, // Konversi dari RxBool ke int
      "status": isApproved,
      "lect_status": isLectApproved,
      "instTime": instTime,
      "note": initNote,
      "local_photo": localPhoto,
      "url": url,
      "att_photo": attPhoto,
      "app_inst_local_photo": appInstLocalPhoto,
      "app_inst_comment": appInstComment,
      "app_inst_name": appInstName,
      "app_inst_photo": appInstPhoto,
      "app_lect_name": appLectName,
      "app_lect_comment": appLectComment,
      "app_lect_photo": appLectPhoto,
    };
  }
}
