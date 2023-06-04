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

    var data = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      // Return parsed LatestNews object if response is successful
      return LatestNews.fromJson(data);
    } else {
      // Return parsed LatestNews object even if response is unsuccessful
      return LatestNews.fromJson(data);
    }
  }
}
