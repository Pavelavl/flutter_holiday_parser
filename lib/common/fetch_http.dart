import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

fetchHttp(url) {
  var client = http.Client();
  return client.get(Uri.parse(url));
}

parseDescription(description) {
  description = parse(description);
  var textDescription = parse(description.body.text).documentElement?.text;
  return textDescription;
}
