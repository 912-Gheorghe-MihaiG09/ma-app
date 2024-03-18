import 'package:flutter_test/flutter_test.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/repository/discount_code_repository_impl.dart';

void main() {
  late DiscountCodeRepositoryImpl repository;

  setUp(() {
    repository = DiscountCodeRepositoryImpl();
  });

  group('DiscountCodeRepositoryImpl Tests', () {
    test('Adding a discount should return the added discount', () async {
      final request = DiscountCodeCreateRequest(
        code: 'TESTCODE',
        description: 'Test Discount Code',
        webSite: 'www.test.com',
        siteType: 'Test Site',
        expirationDate: DateTime.now().add(Duration(days: 7)),
        creator: 'Test User',
      );

      final addedDiscount = await repository.addDiscount(request);
      final discounts = await repository.getDiscounts();

      expect(addedDiscount.id, isNotNull);
      expect(discounts, contains(addedDiscount));
    });

    test('Getting a discount by ID should return the correct discount', () async {
      final existingDiscount = await repository.getDiscounts().then((discounts) => discounts.first);
      final foundDiscount = await repository.getDiscount(existingDiscount.id.toString());

      expect(foundDiscount, equals(existingDiscount));
    });

    test('Getting all discounts should return a list of discounts', () async {
      final discounts = await repository.getDiscounts();

      expect(discounts, isList);
      expect(discounts.length, greaterThan(0));
    });

    test('Updating a discount should return the updated discount', () async {
      final existingDiscount = await repository.getDiscounts().then((discounts) => discounts.first);
      final updatedDiscount = existingDiscount.copyWith(description: 'Updated Description');

      final result = await repository.updateDiscount(updatedDiscount);
      final discounts = await repository.getDiscounts();

      expect(result, equals(updatedDiscount));
      expect(discounts, contains(updatedDiscount));
    });

    test('Deleting a discount should remove it from the list', () async {
      final discountToDelete = await repository.getDiscounts().then((discounts) => discounts.first);
      await repository.deleteDiscount(discountToDelete);

      final discounts = await repository.getDiscounts();

      expect(discounts, isNot(contains(discountToDelete)));
    });

    test('Getting discounts by availability should return correct discounts', () async {
      final availableDiscounts = await repository.getDiscountsByAvailability(true);
      final expiredDiscounts = await repository.getDiscountsByAvailability(false);

      expect(availableDiscounts, isList);
      expect(expiredDiscounts, isList);

      for (final discount in availableDiscounts) {
        expect(DateTime.now().isBefore(discount.expirationDate), isTrue);
      }

      for (final discount in expiredDiscounts) {
        expect(DateTime.now().isAfter(discount.expirationDate), isTrue);
      }
    });
  });
}
