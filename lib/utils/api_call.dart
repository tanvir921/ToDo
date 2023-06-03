import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_assignment/models/latest_news_model.dart';
import 'package:todo_assignment/utils/app_constraints.dart';

class ApiCall {
  static Future<LatestNews> apicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse(AppConstants.BASE_URL),
    );
    //List<dynamic> data = jsonDecode( utf8.decode(response.body.toString() as List<int>));
    var data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return LatestNews.fromJson(data);
    } else {
      return LatestNews.fromJson(data);
    }
  }
}
