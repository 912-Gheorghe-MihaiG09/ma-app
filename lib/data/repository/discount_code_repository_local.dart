import 'dart:async';
import 'dart:developer';

import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/repository/discount_code_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DiscountCodeRepositoryLocal extends DiscountCodeRepository {
  late Database database;
  final String _tableName = "discount_codes";

  DiscountCodeRepositoryLocal() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'discount_code_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, code TEXT, description TEXT,'
          ' webSite TEXT, siteType TEXT, expirationDate TEXT, creator TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    super.databaseInitialized.complete();
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

    int savedId = await database.insert(_tableName, code.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return DiscountCode.fromMap((await database
            .query(_tableName, where: "id = ?", whereArgs: [savedId]))
        .first);
  }

  @override
  Future<void> deleteDiscount(DiscountCode discountCode) async {
    await database
        .delete(_tableName, where: "id=?", whereArgs: [discountCode.id]);
  }

  @override
  Future<DiscountCode?> getDiscount(String discountId) async {
    try {
      return DiscountCode.fromMap((await database
              .query(_tableName, where: "id = ?", whereArgs: [discountId]))
          .first);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<List<DiscountCode>> getDiscounts() async {
    final List<Map<String, dynamic>> maps = await database.query(_tableName);

    return List.generate(maps.length, (i) {
      return DiscountCode.fromMap(maps[i]);
    });
  }

  @override
  Future<DiscountCode?> updateDiscount(DiscountCode discountCode) async {
    try {
      await database.update(
        _tableName,
        discountCode.toMap(),
        where: 'id = ?',
        whereArgs: [discountCode.id],
      );

      return discountCode;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<List<DiscountCode>> getDiscountsByAvailability(bool available) {
    // TODO: implement getDiscountsByAvailability
    throw UnimplementedError();
  }
}
