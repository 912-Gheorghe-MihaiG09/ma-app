import 'package:dio/dio.dart';

abstract class ApiService {
  final String discountCodeUrl = "/api/discount";
  final String baseUrl = "http://34.16.171.85:8080";
  final Dio dio;

  ApiService(
      this.dio,
      ) {
    initDioOptions();
  }

  initDioOptions() async {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
  }
}