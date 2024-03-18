import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'description': description,
      'webSite': webSite,
      'siteType': siteType,
      'expirationDate': DateFormat('yyyy-MM-dd').format(expirationDate),
      'creator': creator,
    };
  }

  factory DiscountCode.fromMap(Map<String, dynamic> map) {
    return DiscountCode(
      id: map['id'],
      code: map['code'].toString(),
      description: map['description'].toString(),
      webSite: map['webSite'].toString(),
      siteType: map['siteType'].toString(),
      expirationDate: DateTime.parse(map['expirationDate'].toString()),
      creator: map['creator'],
    );
  }

  DiscountCode copyWith({
    int? id,
    String? code,
    String? description,
    String? webSite,
    String? siteType,
    DateTime? expirationDate,
    String? creator,
  }) {
    return DiscountCode(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      webSite: webSite ?? this.webSite,
      siteType: siteType ?? this.siteType,
      expirationDate: expirationDate ?? this.expirationDate,
      creator: creator ?? this.creator,
    );
  }


  @override
  List<Object?> get props =>
      [id, code, description, webSite, siteType, expirationDate, creator];
}
