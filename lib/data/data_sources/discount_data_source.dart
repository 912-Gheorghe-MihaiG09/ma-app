import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';

abstract class DiscountDataSource{
  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request);

  Future<List<DiscountCode>> getDiscounts();

  Future<DiscountCode?> getDiscount(String discountId);

  Future<DiscountCode?> updateDiscount(DiscountCode discountCode);

  Future<void> deleteDiscount(DiscountCode discountCode);
}