import 'dart:convert';

LatestNews latestNewsFromJson(String str) =>
    LatestNews.fromJson(json.decode(str));
String latestNewsToJson(LatestNews data) => json.encode(data.toJson());

class LatestNews {
  LatestNews({
    String? status,
    num? totalResults,
    List<Results>? results,
    String? nextPage,
  }) {
    _status = status;
    _totalResults = totalResults;
    _results = results;
    _nextPage = nextPage;
  }

  LatestNews.fromJson(dynamic json) {
    _status = json['status'];
    _totalResults = json['totalResults'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(Results.fromJson(v));
      });
    }
    _nextPage = json['nextPage'];
  }
  String? _status;
  num? _totalResults;
  List<Results>? _results;
  String? _nextPage;
  LatestNews copyWith({
    String? status,
    num? totalResults,
    List<Results>? results,
    String? nextPage,
  }) =>
      LatestNews(
        status: status ?? _status,
        totalResults: totalResults ?? _totalResults,
        results: results ?? _results,
        nextPage: nextPage ?? _nextPage,
      );
  String? get status => _status;
  num? get totalResults => _totalResults;
  List<Results>? get results => _results;
  String? get nextPage => _nextPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['totalResults'] = _totalResults;
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    map['nextPage'] = _nextPage;
    return map;
  }
}

Results resultsFromJson(String str) => Results.fromJson(json.decode(str));
String resultsToJson(Results data) => json.encode(data.toJson());

class Results {
  Results({
    String? title,
    String? link,
    List<String>? keywords,
    List<String>? creator,
    dynamic videoUrl,
    String? description,
    String? content,
    String? pubDate,
    String? imageUrl,
    String? sourceId,
    List<String>? category,
    List<String>? country,
    String? language,
  }) {
    _title = title;
    _link = link;
    _keywords = keywords;
    _creator = creator;
    _videoUrl = videoUrl;
    _description = description;
    _content = content;
    _pubDate = pubDate;
    _imageUrl = imageUrl;
    _sourceId = sourceId;
    _category = category;
    _country = country;
    _language = language;
  }

  Results.fromJson(dynamic json) {
    _title = json['title'];
    _link = json['link'];
    _keywords = json['keywords'] != null ? json['keywords'].cast<String>() : [];
    _creator = json['creator'] != null ? json['creator'].cast<String>() : [];
    _videoUrl = json['video_url'];
    _description = json['description'];
    _content = json['content'];
    _pubDate = json['pubDate'];
    _imageUrl = json['image_url'];
    _sourceId = json['source_id'];
    _category = json['category'] != null ? json['category'].cast<String>() : [];
    _country = json['country'] != null ? json['country'].cast<String>() : [];
    _language = json['language'];
  }
  String? _title;
  String? _link;
  List<String>? _keywords;
  List<String>? _creator;
  dynamic _videoUrl;
  String? _description;
  String? _content;
  String? _pubDate;
  String? _imageUrl;
  String? _sourceId;
  List<String>? _category;
  List<String>? _country;
  String? _language;
  Results copyWith({
    String? title,
    String? link,
    List<String>? keywords,
    List<String>? creator,
    dynamic videoUrl,
    String? description,
    String? content,
    String? pubDate,
    String? imageUrl,
    String? sourceId,
    List<String>? category,
    List<String>? country,
    String? language,
  }) =>
      Results(
        title: title ?? _title,
        link: link ?? _link,
        keywords: keywords ?? _keywords,
        creator: creator ?? _creator,
        videoUrl: videoUrl ?? _videoUrl,
        description: description ?? _description,
        content: content ?? _content,
        pubDate: pubDate ?? _pubDate,
        imageUrl: imageUrl ?? _imageUrl,
        sourceId: sourceId ?? _sourceId,
        category: category ?? _category,
        country: country ?? _country,
        language: language ?? _language,
      );
  String? get title => _title;
  String? get link => _link;
  List<String>? get keywords => _keywords;
  List<String>? get creator => _creator;
  dynamic get videoUrl => _videoUrl;
  String? get description => _description;
  String? get content => _content;
  String? get pubDate => _pubDate;
  String? get imageUrl => _imageUrl;
  String? get sourceId => _sourceId;
  List<String>? get category => _category;
  List<String>? get country => _country;
  String? get language => _language;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['link'] = _link;
    map['keywords'] = _keywords;
    map['creator'] = _creator;
    map['video_url'] = _videoUrl;
    map['description'] = _description;
    map['content'] = _content;
    map['pubDate'] = _pubDate;
    map['image_url'] = _imageUrl;
    map['source_id'] = _sourceId;
    map['category'] = _category;
    map['country'] = _country;
    map['language'] = _language;
    return map;
  }
}
