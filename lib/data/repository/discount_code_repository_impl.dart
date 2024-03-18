import 'dart:async';

import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/repository/discount_code_repository.dart';

class DiscountCodeRepositoryImpl extends DiscountCodeRepository {
  late List<DiscountCode> _discountCodes;
  int latestId = 11;

  DiscountCodeRepositoryImpl() {
    _discountCodes = DiscountCode.getPopulation();
    super.databaseInitialized.complete();
  }

  @override
  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    DiscountCode code = DiscountCode(
        id: latestId,
        code: request.code,
        description: request.description,
        webSite: request.webSite,
        siteType: request.siteType,
        expirationDate: request.expirationDate,
        creator: request.creator);

    _discountCodes.insert(0, code);
    latestId++;

    return code;
  }

  @override
  Future<void> deleteDiscount(DiscountCode discountCode) async {
    await Future.delayed(const Duration(seconds: 1));
    _discountCodes.remove(discountCode);
  }

  @override
  Future<DiscountCode?> getDiscount(String discountId) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return _discountCodes
          .firstWhere((element) => element.id.toString() == discountId);
    } on StateError {
      return null;
    }
  }

  @override
  Future<List<DiscountCode>> getDiscounts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _discountCodes;
  }

  @override
  Future<DiscountCode?> updateDiscount(DiscountCode discountCode) async {
    await Future.delayed(const Duration(seconds: 1));
    for (int i = 0; i < _discountCodes.length; i++) {
      if (_discountCodes[i].id == discountCode.id) {
        _discountCodes[i] = discountCode;
        return _discountCodes[i];
      }
    }
    return null;
  }

  @override
  Future<List<DiscountCode>> getDiscountsByAvailability(bool available) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      if(available){
        return _discountCodes
            .where((element) => DateTime.now().isBefore(element.expirationDate)).toList();
      }
      return _discountCodes
          .where((element) => DateTime.now().isAfter(element.expirationDate)).toList();
    } on StateError {
      return [];
    }
  }
}
