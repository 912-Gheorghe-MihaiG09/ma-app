import 'dart:developer';

import 'package:crud_project/data/data_sources/discount_local_data_source.dart';
import 'package:crud_project/data/data_sources/discount_remote_data_source.dart';
import 'package:crud_project/data/domain/database_action.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/repository/discount_code_repository.dart';

class DiscountCodeRepositoryRemote extends DiscountCodeRepository {
  final DiscountLocalDataSource _localDataSource;
  final DiscountRemoteDataSource _remoteDataSource;

  DiscountCodeRepositoryRemote(this._localDataSource, this._remoteDataSource) {
    _localDataSource.initDatabase().then(
        (_) => syncServer().then((__) => super.databaseInitialized.complete()));
  }

  @override
  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request) async {
    DiscountCode result;
    try {
      result = await _remoteDataSource.addDiscount(request);

    } catch (e) {
      log("$runtimeType addDiscount: $e");
      result = await _localDataSource.addDiscount(request);
    }
    return result;
  }

  @override
  Future<void> deleteDiscount(DiscountCode discountCode) async {
    try {
      return await _remoteDataSource.deleteDiscount(discountCode);
    } catch (e) {
      log("$runtimeType deleteDiscount: $e");
      return await _localDataSource.deleteDiscount(discountCode);
    }
  }

  @override
  Future<DiscountCode?> getDiscount(String discountId) async {
    try {
      return await _remoteDataSource.getDiscount(discountId);
    } catch (e) {
      log("$runtimeType getDiscount: $e");
      return await _localDataSource.getDiscount(discountId);
    }
  }

  @override
  Future<List<DiscountCode>> getDiscounts() async{
    var result;
    try {
      result = await _remoteDataSource.getDiscounts();
      await _localDataSource.deleteDiscountTableData();
      await _localDataSource.addAllDiscounts(result);
    } catch (e) {
      log("$runtimeType getDiscounts: $e");
      result = await _localDataSource.getDiscounts();
    }
    return result;
  }

  @override
  Future<DiscountCode?> updateDiscount(DiscountCode discountCode) async {
    DiscountCode? result;
    try {
      result = await _remoteDataSource.updateDiscount(discountCode);
    } catch (e) {
      log("$runtimeType updateDiscount: $e");
      result = await _localDataSource.updateDiscount(discountCode);
    }
    return result;
  }

  Future<void> syncServer() async {
    List<DatabaseAction> actions = await _localDataSource.getActions();
    try {
      for (DatabaseAction action in actions) {
        switch (action.actionType) {
          case ActionType.add:
            await _remoteDataSource.addDiscount(
                action.discountCode.toCreateRequest());
            break;
          case ActionType.update:
            await _remoteDataSource.updateDiscount(action.discountCode);
            break;
          case ActionType.delete:
            await _remoteDataSource.deleteDiscount(action.discountCode);
            break;
          case ActionType.undefined:
            break;
        }
        await _localDataSource.deleteActions(action);
      }
    } catch (e){
      log("could not sync: $e");
    }
  }
}
