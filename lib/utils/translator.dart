import 'package:translator/translator.dart';

final translator = GoogleTranslator();

Future<String> translateToEnglish(String text) async {
  var translation = await translator.translate(text, from: 'id', to: 'en');
  return translation.text;
}
