import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exports.dart';

class ListFarmComponent extends StatefulWidget {
  final List<DataBaseFarmModel> farms;
  const ListFarmComponent({super.key, required this.farms});

  @override
  State<ListFarmComponent> createState() => _ListFarmComponentState();
}

class _ListFarmComponentState extends State<ListFarmComponent> {
  late final HomeCubit cubit = context.read<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecione uma fazenda', style: TextStyle(fontSize: 24)),
                SizedBox(
                  height: constraints.maxHeight * 0.8,
                  child: ListView.builder(
                    itemCount: widget.farms.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(32)),
                        child: Row(
                          children: [
                            Text(widget.farms[index].name),
                            const Spacer(),
                            Text(
                                'Animais: ${cubit.state.cattles.where((element) => element.farmId == widget.farms[index].id).toList().length}'),
                            IconButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                Routes.cattle.route,
                                arguments: widget.farms[index],
                              ),
                              icon: const Icon(Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
