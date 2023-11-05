import 'package:cattle_crud/models/models.dart';

sealed class HomeState {
  final List<DataBaseFarmModel> farms;
  final List<DataBaseCattleModel> cattles;

  HomeState({required this.farms, required this.cattles});
}

final class HomeInitialState extends HomeState {
  HomeInitialState({required super.farms, required super.cattles});
}

final class HomeLoadedState extends HomeState {
  HomeLoadedState({required super.farms, required super.cattles});
}

final class HomeErrorState extends HomeState {
  final String errorMessage;
  HomeErrorState({
    required super.farms,
    required super.cattles,
    required this.errorMessage,
  });
}
