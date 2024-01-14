import 'dart:developer';

import 'package:crud_project/data/domain/discount_code.dart';

class DatabaseAction {
  final int id;
  final DiscountCode discountCode;
  final ActionType actionType;

  DatabaseAction(this.actionType, this.discountCode, {this.id = 0});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = discountCode.toJson();
    json['code_id'] = discountCode.id;
    json['actionType'] = actionType.actionName;
    return json;
  }

  static DatabaseAction fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return DatabaseAction(
      ActionType.fromString(json['actionType']),
      DiscountCode(
        id: json['code_id'],
        code: json['code'].toString(),
        description: json['description'].toString(),
        webSite: json['webSite'].toString(),
        siteType: json['siteType'].toString(),
        expirationDate: DateTime.parse(json['expirationDate'].toString()),
        creator: json['creator'],
      ),
      id: json['id'] ?? 0,
    );
  }
}

enum ActionType {
  add('ADD'),
  update('UPDATE'),
  delete('DELETE'),
  undefined('UNDEFINED');

  final String actionName;

  const ActionType(this.actionName);

  static ActionType fromString(String? action) {
    for (ActionType index in ActionType.values) {
      if (index.actionName == action) {
        return index;
      }
    }
    return undefined;
  }
}
