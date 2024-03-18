part of 'discount_bloc.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object?> get props => [];
}

class FetchDiscountCodes extends DiscountEvent {
  const FetchDiscountCodes();
}

class AddDiscount extends DiscountEvent {
  final String code;
  final String description;
  final String webSite;
  final String siteType;
  final DateTime expirationDate;

  const AddDiscount(
      {required this.code,
      required this.description,
      required this.webSite,
      required this.siteType,
      required this.expirationDate});

  @override
  List<Object?> get props =>
      [code, description, webSite, siteType, expirationDate];
}

class DeleteDiscount extends DiscountEvent {
  final DiscountCode discountCode;

  const DeleteDiscount(this.discountCode);

  @override
  List<Object?> get props => [discountCode];
}

class UpdateDiscount extends DiscountEvent {
  final String code;
  final String codeId;
  final String description;
  final String webSite;
  final String siteType;
  final DateTime expirationDate;

  const UpdateDiscount(
      {required this.codeId,
      required this.code,
      required this.description,
      required this.webSite,
      required this.siteType,
      required this.expirationDate});

  @override
  List<Object?> get props =>
      [code, codeId, description, webSite, siteType, expirationDate];
}

class UpdateUsername extends DiscountEvent {
  final String username;

  const UpdateUsername(this.username);

  @override
  List<Object?> get props => [username];
}

class FilterByExpiration extends DiscountEvent{
  final bool available;

  const FilterByExpiration(this.available);
}