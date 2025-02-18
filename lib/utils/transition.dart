import 'package:page_transition/page_transition.dart';

transition({required page, type = PageTransitionType.rightToLeft}) {
  return PageTransition(
    type: type,
    child: page,
  );
}
