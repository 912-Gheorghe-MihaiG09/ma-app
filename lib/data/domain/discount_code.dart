import 'package:equatable/equatable.dart';

class DiscountCode extends Equatable {
  final int id;
  final String code;
  final String description;
  final String webSite;
  final String siteType;
  final DateTime expirationDate;
  final String creator;

  const DiscountCode(
      {required this.id,
      required this.code,
      required this.description,
      required this.webSite,
      required this.siteType,
      required this.expirationDate,
      required this.creator});

  static List<DiscountCode> getPopulation() {
    List<DiscountCode> discountCodes = [];

    for (int i = 1; i <= 10; i++) {
      DiscountCode discountCode = DiscountCode(
        id: i,
        code: 'CODE$i',
        description: 'Description $i',
        webSite: 'Website $i',
        siteType: 'Site Type $i',
        expirationDate: i < 5
            ? DateTime.now().add(Duration(days: i))
            : DateTime.now().subtract(Duration(days: i)),
        creator: 'Creator $i',
      );

      discountCodes.add(discountCode);
    }
    return discountCodes;
  }

  @override
  List<Object?> get props =>
      [id, code, description, webSite, siteType, expirationDate, creator];
}
