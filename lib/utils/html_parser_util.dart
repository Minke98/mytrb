import 'package:html/parser.dart' as htmlparse;
import 'package:html_unescape/html_unescape.dart';

class HtmlParserUtil {
  static String parseHtmlString(String htmlString) {
  var unescape = HtmlUnescape();
  String decodedHtml = unescape.convert(htmlString);

  // Parse HTML dan ambil teks bersih
  var document = htmlparse.parse(decodedHtml);
  return document.body?.text ?? '';
}
}
