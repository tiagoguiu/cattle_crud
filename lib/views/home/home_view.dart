import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exports.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeCubit cubit = context.read<HomeCubit>();
  @override
  void initState() {
    super.initState();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeErrorState) {
          AppSnackbar.show(text: state.errorMessage, status: AppSnackbarStatus.error, context: context);
        }
      },
      builder: (context, state) {
        Widget? body;
        if (state.farms.isEmpty || state is HomeInitialState) {
          body = const AddFarmComponent();
        } else {
          body = ListFarmComponent(farms: state.farms);
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.green,
          floatingActionButton: state.farms.isNotEmpty
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => cubit.emitInitialToAddMoreFarms(),
                )
              : null,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: body,
          ),
        );
      },
    );
  }
}
