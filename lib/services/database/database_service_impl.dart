import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

import '../../exports.dart';

class DatabaseServiceImpl implements DatabaseService {
  Database? _db;

  List<DataBaseCattleModel> _cattles = [];

  Future<void> _cacheCattles() async {
    final allCattles = await getAllCattles();
    _cattles = allCattles.toList();
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw Exception('Falha ao abrir o banco');
    } else {
      return db;
    }
  }

  @override
  Future<void> open() async {
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createFarmTable);

      await db.execute(createCattleTable);

      await _cacheCattles();
    } on MissingPlatformDirectoryException catch (e) {
      log(e.toString());
      throw Exception('Falha ao abrir o banco');
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw Exception('Falha ao abrir o banco');
    } else {
      await db.close();
      _db = null;
    }
  }

  @override
  Future<DataBaseFarmModel> createFarm({required String name}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      farmTable,
      limit: 1,
      where: 'name = ?',
      whereArgs: [name.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw Exception('Fazenda ja existente');
    }
    final farmId = await db.insert(farmTable, {
      'name': name.toLowerCase(),
    });
    return DataBaseFarmModel(id: farmId, name: name);
  }

  @override
  Future<DataBaseFarmModel> getFarm({required String name}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      farmTable,
      limit: 1,
      where: 'name = ?',
      whereArgs: [name.toLowerCase()],
    );
    if (results.isEmpty) {
      throw Exception('Fazenda não encontrada');
    } else {
      return DataBaseFarmModel.fromRow(results.first);
    }
  }

  @override
  Future<void> deleteFarm({required String name}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      farmTable,
      where: 'name = ?',
      whereArgs: [
        name.toLowerCase(),
      ],
    );

    if (deletedCount != 1) {
      throw Exception('Não foi possivel encontrar a fazenda');
    }
  }

  @override
  Future<DataBaseCattleModel> createCattle({required DataBaseFarmModel owner}) async {
    final db = _getDatabaseOrThrow();
    final dbFarm = await getFarm(name: owner.name);
    if (dbFarm != owner) {
      throw Exception('Não foi possivel encontrar a fazenda');
    }
    const String name = '';
    final cattleId = await db.insert(cattleTable, {
      'farm_id': owner.id,
      'tag': name,
    });
    final cattle = DataBaseCattleModel(id: cattleId, farmId: owner.id, tag: name);
    _cattles.add(cattle);
    return cattle;
  }

  @override
  Future<void> deleteCattle({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      cattleTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw Exception('Não foi possivel encontrar o gado');
    } else {
      _cattles.removeWhere((cattle) => cattle.id == id);
    }
  }

  @override
  Future<int> deleteAllCattles(List<DataBaseCattleModel> deletions) async {
    final db = _getDatabaseOrThrow();
    for (var element in deletions) {
      await db.delete(
        cattleTable,
        where: 'id = ?',
        whereArgs: [element.id],
      );
    }
    return 0;
  }

  @override
  Future<DataBaseCattleModel> getCattle({required int id}) async {
    final db = _getDatabaseOrThrow();
    final cattles = await db.query(
      cattleTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (cattles.isEmpty) {
      throw Exception('Não foi possivel encontrar o gado');
    } else {
      final cattle = DataBaseCattleModel.fromRow(cattles.first);
      _cattles.removeWhere((note) => note.id == id);
      _cattles.add(cattle);
      return cattle;
    }
  }

  @override
  Future<List<DataBaseCattleModel>> getAllCattles() async {
    final db = _getDatabaseOrThrow();
    final cattles = await db.query(cattleTable);
    return cattles.map((cattleRow) => DataBaseCattleModel.fromRow(cattleRow)).toList();
  }

  @override
  Future<DataBaseCattleModel> updateCattle({
    required DataBaseCattleModel cattle,
    required String tag,
  }) async {
    final db = _getDatabaseOrThrow();
    await getCattle(id: cattle.id);
    final updatesCount = await db.update(
      cattleTable,
      {
        'tag': tag,
      },
      where: 'id = ?',
      whereArgs: [cattle.id],
    );
    if (updatesCount == 0) {
      throw Exception('Não foi possivel atualizar o gado');
    } else {
      final updatedCattle = await getCattle(id: cattle.id);
      _cattles.removeWhere((cattle) => cattle.id == updatedCattle.id);
      _cattles.add(updatedCattle);
      return updatedCattle;
    }
  }

  @override
  Future<List<DataBaseFarmModel>> getAllFarms() async {
    final db = _getDatabaseOrThrow();
    final farms = await db.query(farmTable);
    return farms.map((farmRow) => DataBaseFarmModel.fromRow(farmRow)).toList();
  }
}
