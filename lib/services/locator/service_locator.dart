import 'package:cattle_crud/exports.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

GetIt get getIt => G;
@protected
GetIt G = GetIt.instance;

class ServiceLocator {
  static Future<void> initDependencies() async {
    getIt.registerSingleton<DatabaseService>(DatabaseServiceImpl());
    getIt.registerSingleton<HomeCubit>(HomeCubit(getIt()));
  }
}
