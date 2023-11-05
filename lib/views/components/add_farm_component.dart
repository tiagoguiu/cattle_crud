import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exports.dart';

class AddFarmComponent extends StatefulWidget {
  const AddFarmComponent({super.key});

  @override
  State<AddFarmComponent> createState() => _AddFarmComponentState();
}

class _AddFarmComponentState extends State<AddFarmComponent> {
  late final TextEditingController controller = TextEditingController();
  late final HomeCubit cubit = context.read<HomeCubit>();
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    await cubit.addFarm(controller.text);
    _isLoading = false;
    _isFormValidStreamController.sink.add(_isLoading);
  }

  @override
  void dispose() {
    _isFormValidStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 64),
              const Text(
                'Você ainda não adicionou fazenda, clique para adicionar uma.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: TextFieldComponent(
                  hint: 'Digite o nome da fazenda',
                  controller: controller,
                  validator: emptyValidator,
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
              const SizedBox(height: 64),
              Image.asset('assets/images/ponta_logo.png'),
            ],
          ),
        ),
      ),
    );
  }
}
