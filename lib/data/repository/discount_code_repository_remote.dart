import 'package:crud_project/data/data_sources/discount_local_data_source.dart';
import 'package:crud_project/data/data_sources/discount_remote_data_source.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/repository/discount_code_repository.dart';

class DiscountCodeRepositoryRemote extends DiscountCodeRepository{
  final DiscountLocalDataSource _localDataSource;
  final DiscountRemoteDataSource _remoteDataSource;

  DiscountCodeRepositoryRemote(this._localDataSource, this._remoteDataSource){
    super.databaseInitialized.complete();
  }

  @override
  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request) {
    return _remoteDataSource.addDiscount(request);
  }

  @override
  Future<void> deleteDiscount(DiscountCode discountCode) {
    return _remoteDataSource.deleteDiscount(discountCode);
  }

  @override
  Future<DiscountCode?> getDiscount(String discountId) {
    return _remoteDataSource.getDiscount(discountId);
  }

  @override
  Future<List<DiscountCode>> getDiscounts() {
    return _remoteDataSource.getDiscounts();
  }

  @override
  Future<DiscountCode?> updateDiscount(DiscountCode discountCode) {
    return _remoteDataSource.updateDiscount(discountCode);
  }

}