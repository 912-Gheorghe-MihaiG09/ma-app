import 'dart:developer';

import 'package:crud_project/data/data_sources/discount_data_source.dart';
import 'package:crud_project/data/domain/database_action.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DiscountLocalDataSource extends DiscountDataSource {
  late Database _database;
  final String _tableName = "discount_codes";
  final String _logTableName = "action_log";

  DiscountLocalDataSource();

  Future<void> initDatabase() async {
    _database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'discount_code_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, code TEXT, description TEXT,'
          ' webSite TEXT, siteType TEXT, expirationDate TEXT, creator TEXT)',
        );
        db.execute(
          'CREATE TABLE $_logTableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, actionType TEXT, code_id INTEGER, code TEXT, description TEXT,'
          ' webSite TEXT, siteType TEXT, expirationDate TEXT, creator TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  @override
  Future<DiscountCode> addDiscount(DiscountCodeCreateRequest request) async {
    DiscountCode code = DiscountCode(
        id: 0,
        code: request.code,
        description: request.description,
        webSite: request.webSite,
        siteType: request.siteType,
        expirationDate: request.expirationDate,
        creator: request.creator);

    int savedId = await _database.insert(_tableName, code.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    DiscountCode savedCode = DiscountCode.fromJson((await _database
            .query(_tableName, where: "id = ?", whereArgs: [savedId]))
        .first);

    await _database.insert(
        _logTableName, DatabaseAction(ActionType.add, savedCode).toJson(),);

    return savedCode;
  }

  @override
  Future<void> deleteDiscount(DiscountCode discountCode) async {
    await _database
        .delete(_tableName, where: "id=?", whereArgs: [discountCode.id]);
    await _database.insert(
      _logTableName, DatabaseAction(ActionType.delete, discountCode).toJson(),);
  }

  @override
  Future<DiscountCode?> getDiscount(String discountId) async {
    return DiscountCode.fromJson((await _database
            .query(_tableName, where: "id = ?", whereArgs: [discountId]))
        .first);
  }

  @override
  Future<List<DiscountCode>> getDiscounts() async {
    final List<Map<String, dynamic>> maps = await _database.query(_tableName);

    return List.generate(maps.length, (i) {
      return DiscountCode.fromJson(maps[i]);
    });
  }

  @override
  Future<DiscountCode?> updateDiscount(DiscountCode discountCode) async {
    _database.update(
      _tableName,
      discountCode.toJson(),
      where: 'id = ?',
      whereArgs: [discountCode.id],
    );

    await _database.insert(
      _logTableName, DatabaseAction(ActionType.update, discountCode).toJson(),);

    return DiscountCode.fromJson((await _database
            .query(_tableName, where: "id = ?", whereArgs: [discountCode.id]))
        .first);
  }

  Future<List<DatabaseAction>> getActions() async{
    final List<Map<String, dynamic>> maps = await _database.query(_logTableName);

    return List.generate(maps.length, (i) {
      return DatabaseAction.fromJson(maps[i]);
    });
  }

  Future<void> deleteActions(DatabaseAction action) async{
    await _database
        .delete(_logTableName, where: "id=?", whereArgs: [action.id]);
  }
  
  Future<void> deleteDiscountTableData() async{
    await _database.delete(_tableName);
  }
  
  Future<void> addAllDiscounts(List<DiscountCode> discounts) async{
    for(DiscountCode code in discounts){
      var json = code.toJson();
      json['id'] = code.id;
      _database.insert(_tableName, json);
    }
    log((await _database.query(_tableName)).toString());
  }
}
