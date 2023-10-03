import 'package:flutter/material.dart';
import 'package:imc_flutter/imcs.dart';

class HistoryIMC extends StatelessWidget {
  final List<IMCs> imcs;
  HistoryIMC({super.key, required this.imcs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent[100],
        appBar: AppBar(
          title: const Text('Histórico'),
          backgroundColor: Colors.deepPurple[400]
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: imcs.length,
                  itemBuilder: (context, index) {
                    IMCs imc = imcs[index];

                    return Card(
                      elevation: 1,
                      color: Colors.deepPurpleAccent[200],
                      child: ListTile(
                        textColor: Colors.white,
                        title: Column(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            Text('Peso: ${imc.weight.toString()}'),
                            Text('Altura: ${imc.height.toString()}'),
                            Text('IMC: ${imc.imc.toStringAsFixed(2)}'),
                            Text(imc.result)
                          ],
                        )
                      )
                    );
                  }
                ),
              ),
            ],
          ),
        )
      );
  }
}

