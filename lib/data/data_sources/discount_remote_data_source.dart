import 'package:crud_project/data/data_sources/discount_data_source.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/service/discount_service.dart';

class DiscountRemoteDataSource extends DiscountDataSource{
  final DiscountService _discountService;

  DiscountRemoteDataSource(this._discountService);

  @override
  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request) {
    return _discountService.addDiscount(request);
  }

  @override
  Future<void> deleteDiscount(DiscountCode discountCode) {
    return _discountService.deleteDiscount(discountCode.id.toString());
  }

  @override
  Future<DiscountCode?> getDiscount(String discountId) {
    return _discountService.getDiscount(discountId.toString());
  }

  @override
  Future<List<DiscountCode>> getDiscounts() {
    return _discountService.getDiscounts();
  }

  @override
  Future<DiscountCode?> updateDiscount(DiscountCode discountCode) {
    return _discountService.updateDiscount(discountCode);
  }
}