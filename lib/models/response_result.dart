class ResponseResult {
  int? resultCount;
  List<dynamic> results;

  ResponseResult.fromJson(Map<String, dynamic> json)
      : resultCount = json['resultCount'],
        results = json['results'];

  Map<String, dynamic> toJson() {
    return {
      'resultCount': resultCount,
      'results': results,
    };
  }
}