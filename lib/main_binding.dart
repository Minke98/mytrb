import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';
import 'package:mytrb/app/Repository/contact_repository.dart';
import 'package:mytrb/app/Repository/exam_repository.dart';
import 'package:mytrb/app/Repository/faq_repository.dart';
import 'package:mytrb/app/Repository/instructor_repository.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';
import 'package:mytrb/app/Repository/news_repository.dart';
import 'package:mytrb/app/Repository/profile_repository.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/sync_repository.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Repository yang sering digunakan langsung diinisialisasi
    Get.put<UserRepository>(UserRepository());
    Get.put<AppRepository>(AppRepository());
    Get.put<SignRepository>(SignRepository());
    Get.put<SyncRepository>(SyncRepository());

    // Repository lain hanya dibuat saat dibutuhkan
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(), fenix: true);
    Get.lazyPut<ChatRepository>(() => ChatRepository(), fenix: true);
    Get.lazyPut<ContactRepository>(() => ContactRepository(), fenix: true);
    Get.lazyPut<ExamRepository>(() => ExamRepository(), fenix: true);
    Get.lazyPut<FaqRepository>(() => FaqRepository(), fenix: true);
    Get.lazyPut<InstructorRepository>(() => InstructorRepository(),
        fenix: true);
    Get.lazyPut<LogBookRepository>(() => LogBookRepository(), fenix: true);
    Get.lazyPut<NewsRepository>(() => NewsRepository(), fenix: true);
    Get.lazyPut<ReportRepository>(() => ReportRepository(), fenix: true);
    Get.lazyPut<SyncRepository>(() => SyncRepository(), fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
  }
}
