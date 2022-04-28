import 'package:dio/dio.dart';

class API {
  final Dio dio;
  static final API _api = API._internal(Dio(
    BaseOptions(
      baseUrl: 'https://itunes.apple.com'
    ),
  ));

  factory API() => _api;

  API._internal(this.dio);
}