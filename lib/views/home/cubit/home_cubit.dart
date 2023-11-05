import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../exports.dart';

class HomeCubit extends Cubit<HomeState> {
  final DatabaseService databaseService;
  HomeCubit(this.databaseService) : super(HomeInitialState(farms: [], cattles: []));

  List<DataBaseFarmModel> localFarms = [];
  List<DataBaseCattleModel> localCattles = [];
  Future<void> init() async {
    try {
      await databaseService.open();
      final List<DataBaseFarmModel> farms = await databaseService.getAllFarms();
      final List<DataBaseCattleModel> cattles = await databaseService.getAllCattles();
      localFarms.addAll(farms);
      localCattles.addAll(cattles);
      emit(HomeLoadedState(farms: farms, cattles: cattles));
    } catch (e) {
      emit(HomeErrorState(farms: [], cattles: [], errorMessage: e.toString()));
    }
  }

  void emitInitialToAddMoreFarms() => emit(HomeInitialState(farms: [], cattles: []));

  Future<void> addFarm(String name) async {
    try {
      final farm = await databaseService.createFarm(name: name);
      localFarms.add(farm);
      emit(HomeLoadedState(farms: localFarms, cattles: localCattles));
    } catch (e) {
      emit(HomeErrorState(farms: [], cattles: [], errorMessage: e.toString()));
    }
  }

  Future<void> addCattle({required DataBaseFarmModel selectedFarm, required String tag}) async {
    try {
      final cattle = await databaseService.createCattle(owner: selectedFarm);
      final updatedCattle = await databaseService.updateCattle(cattle: cattle, tag: tag);
      localCattles.add(updatedCattle);
      emit(
        HomeLoadedState(
          farms: localFarms,
          cattles: localCattles,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(farms: [], cattles: [], errorMessage: e.toString()));
    }
  }

  Future<void> deleteAllCattles(List<DataBaseCattleModel> deletedIds) async {
    try {
      await databaseService.deleteAllCattles(deletedIds);
      localCattles.removeWhere((element) => element.farmId == deletedIds[0].farmId);
      emit(
        HomeLoadedState(farms: localFarms, cattles: localCattles),
      );
    } catch (e) {
      emit(HomeErrorState(farms: [], cattles: [], errorMessage: e.toString()));
    }
  }
}
