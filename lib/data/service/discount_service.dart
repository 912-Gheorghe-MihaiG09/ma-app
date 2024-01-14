import 'dart:convert';
import 'dart:developer';

import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/service/api_service.dart';

class DiscountService extends ApiService{
  DiscountService(super.dio);

  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request) async {
    final response = await dio.post(discountCodeUrl,
        data: request.toJson);
    log(response.toString());
    return DiscountCode.fromJson(jsonDecode(response.toString()));
  }

  Future<List<DiscountCode>> getDiscounts() async {
    final response = await dio.get(discountCodeUrl);
    return DiscountCode.listFromJson(response.data);
  }

  Future<DiscountCode> getDiscount(String discountId) async {
    final response = await dio.get(
      "$discountCodeUrl/$discountId",
    );
    log(response.toString());
    return DiscountCode.fromJson(jsonDecode(response.toString()));
  }

  Future<DiscountCode> updateDiscount(DiscountCode discountCode) async {
    final response = await dio
        .put("$discountCodeUrl/${discountCode.id}", queryParameters: discountCode.toJson());
    log(response.toString());
    return DiscountCode.fromJson(jsonDecode(response.toString()));
  }

  Future<void> deleteDiscount(String discountId) async {
    var response = await dio.delete(
      "$discountCodeUrl/$discountId",
    );
    log(response.toString());
  }
}