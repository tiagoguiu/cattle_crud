import 'package:cattle_crud/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Routes {
  cattle,
  home,
}

final Map<String, Widget Function(BuildContext)> routes = {
  Routes.home.route: (context) {
    return BlocProvider.value(
      value: getIt<HomeCubit>(),
      child: const HomeView(),
    );
  },
  Routes.cattle.route: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as DataBaseFarmModel;
    return BlocProvider.value(
      value: getIt<HomeCubit>(),
      child: CattleView(selectedFarm: args),
    );
  },
};

extension RoutesNaming on Routes {
  String get route => toString();
}

Route<dynamic>? onUnknownRoute(RouteSettings? settings) {
  return MaterialPageRoute(
    builder: (context) {
      return const Scaffold(
        body: Center(child: Text('Erro ao encontrar rotas')),
      );
    },
  );
}
