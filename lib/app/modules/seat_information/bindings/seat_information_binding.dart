import 'package:mytrb/app/modules/seat_information/controllers/seat_information_controller.dart';
import 'package:mytrb/app/modules/training/controllers/training_controller.dart';
import 'package:get/get.dart';

class SeatInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeatInformationController>(() => SeatInformationController());
    Get.lazyPut<TrainingController>(() => TrainingController());
  }
}
