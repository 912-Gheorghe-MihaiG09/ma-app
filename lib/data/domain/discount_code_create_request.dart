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
}
