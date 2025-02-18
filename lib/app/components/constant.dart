// ignore_for_file: constant_identifier_names

enum ConnectionType {
  wifi,
  mobile,
}

const String SIGN_IMAGE_FOLDER = "sign";
const String SIGN_PROFILE_FOLDER = "profile";
const String REPORT_FOTO_FOLDER = "report";
const String APPROVAL_FOTO_FOLDER = "approval";
const String LOG_APPROVAL_FOTO_FOLDER = "logapproval";
const String TASK_APPROVAL_FOTO_FOLDER = "taskapproval";
const String TASK_CHECKLIST_URL_FOLDER = "urltaskchecklist";
const String UK = "VmYq3s6v9y\$B&E)H@McQfTjWnZr4u7w!";
const String TASK_CHECKLIST_NEW_FOTO_FOLDER = "taskchecklist";

class Approval {
  final String text;
  final int value;

  const Approval({required this.text, required this.value});
}

const List<Approval> REPORTLOGINSAPPROVAL = [
  Approval(text: "Not Approved Yet", value: 0),
  Approval(text: "Approved", value: 1),
  Approval(text: "Revision", value: 2)
];

const List<Approval> REPORTLOGLECTAPPROVAL = [
  Approval(text: "Not Approved Yet", value: 0),
  Approval(text: "Approved", value: 1),
  Approval(text: "Rejected", value: 2)
];
