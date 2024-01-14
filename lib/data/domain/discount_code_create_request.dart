import 'package:intl/intl.dart';

class DiscountCodeCreateRequest {
  final String code;
  final String description;
  final String webSite;
  final String siteType;
  final DateTime expirationDate;
  final String creator;

  DiscountCodeCreateRequest(
      {required this.code,
      required this.description,
      required this.webSite,
      required this.siteType,
      required this.expirationDate,
      required this.creator});

  Map<String, dynamic> get toJson => {
    "code": code,
    "description": description,
    "webSite": webSite,
    "siteType": siteType,
    "expirationDate": DateFormat('yyyy-MM-dd').format(expirationDate),
    "creator": creator,
  };
}
