import 'dart:io';

import 'package:dio/dio.dart';
import 'package:crud_project/data/exceptions/network_exception.dart' as network;

abstract class ApiService {
  final String baseUrl = "http://localhost:3000";
  final Dio dio;

  ApiService(
      this.dio,
      ) {
    initDioOptions();
  }

  initDioOptions() async {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

}