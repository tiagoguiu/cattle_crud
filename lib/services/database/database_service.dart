import '../../exports.dart';

abstract interface class DatabaseService {
  Future<void> open();
  Future<DataBaseFarmModel> createFarm({required String name});
  Future<DataBaseFarmModel> getFarm({required String name});
  Future<void> deleteFarm({required String name});
  Future<DataBaseCattleModel> createCattle({required DataBaseFarmModel owner});
  Future<void> deleteCattle({required int id});
  Future<int> deleteAllCattles(List<DataBaseCattleModel> deletedIds);
  Future<DataBaseCattleModel> getCattle({required int id});
  Future<List<DataBaseCattleModel>> getAllCattles();
  Future<List<DataBaseFarmModel>> getAllFarms();
  Future<DataBaseCattleModel> updateCattle({
    required DataBaseCattleModel cattle,
    required String tag,
  });
}
