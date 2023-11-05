import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exports.dart';

class CattleView extends StatefulWidget {
  final DataBaseFarmModel selectedFarm;
  const CattleView({super.key, required this.selectedFarm});

  @override
  State<CattleView> createState() => _CattleViewState();
}

class _CattleViewState extends State<CattleView> {
  late final TextEditingController controller = TextEditingController();
  late final HomeCubit cubit = context.read<HomeCubit>();
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<DataBaseCattleModel> filteredList;

  bool _isLoading = false;
  late final StreamController<bool> _isFormValidStreamController = StreamController<bool>.broadcast(
    onListen: () {
      _isFormValidStreamController.sink.add(_isLoading);
    },
  );
  Stream<bool> get isFormValidStream => _isFormValidStreamController.stream;

  Future<void> create() async {
    _isLoading = true;
    _isFormValidStreamController.sink.add(_isLoading);
    await cubit.addCattle(selectedFarm: widget.selectedFarm, tag: controller.text);
    controller.clear();
    _isLoading = false;
    _isFormValidStreamController.sink.add(_isLoading);
  }

  @override
  void dispose() {
    _isFormValidStreamController.close();
    super.dispose();
  }

  void showAlert() {
    final alert = AlertDialog.adaptive(
      title: const Text('Deseja deletar todos os gados?'),
      content: const Text('Ao realizar a ação, não sera possivel reverter'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteAllCattles(filteredList);
              controller.clear();
            },
            child: const Text('Ok'))
      ],
    );
    showAdaptiveDialog(context: context, builder: (_) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Adicionar gado'),
        centerTitle: true,
        actions: [IconButton(onPressed: () => showAlert(), icon: const Icon(Icons.delete))],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeErrorState) {
            AppSnackbar.show(text: state.errorMessage, status: AppSnackbarStatus.error, context: context);
          }
        },
        builder: (context, state) {
          final cattleList = state.cattles.where((element) => element.farmId == widget.selectedFarm.id).toList();
          filteredList = cattleList;
          return LayoutBuilder(
            builder: (context, constraints) => ConstrainedBox(
              constraints: constraints,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 64),
                      Visibility(
                        replacement: const SizedBox.shrink(),
                        visible: state.cattles.isEmpty,
                        child: const Text(
                          'Você pode adicionar gados utilizando o botão de mais abaixo',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFieldComponent(
                          hint: 'Digite a tag do gado',
                          controller: controller,
                          keyboardType: TextInputType.number,
                          validator: tagValidator,
                          onFieldSubmitted: (p0) {
                            if (!(formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            create();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<bool>(
                        initialData: false,
                        stream: isFormValidStream,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                if (!(formKey.currentState?.validate() ?? false)) {
                                  return;
                                }
                                create();
                              },
                              child: snapshot.hasData && snapshot.data == true
                                  ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                                  : const Text('Adicionar'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: constraints.maxHeight * 0.6,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cattleList.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(32)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Gado ${cattleList[index].tag}',
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.white, overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
