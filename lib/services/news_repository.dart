import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class NewsRepository {
  fetchHttp(url) {
    var client = http.Client();
    return client.get(url);
  }

  parseDescription(description) {
    description = parse(description);
    var txtDescription = parse(description.body.text).documentElement?.text;
    return txtDescription;
  }
}
