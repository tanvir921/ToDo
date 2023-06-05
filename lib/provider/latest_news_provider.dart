import 'package:flutter/material.dart';
import 'package:todo_assignment/models/latest_news_model.dart';
import 'package:todo_assignment/utils/api_call.dart';

class LatestNewsProvider extends ChangeNotifier {
  LatestNews? latestNews;

  Future<void> fetchLatestNews() async {
    latestNews = await ApiCall.apicall();
    notifyListeners();
  }
}
