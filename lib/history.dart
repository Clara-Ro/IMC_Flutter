import 'package:flutter/material.dart';
import 'package:imc_flutter/database/database_interface.dart';
import 'package:imc_flutter/imcs.dart';

class HistoryIMC extends StatefulWidget {
  final Database db;
  HistoryIMC({super.key, required this.db});

  @override
  State<HistoryIMC> createState() => _HistoryIMCState();
}

class _HistoryIMCState extends State<HistoryIMC> {
  late Future<List<IMCs>> future;

  @override
  void initState() {
    super.initState();
    future = widget.db.getIMCs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent[100],
        appBar: AppBar(
          title: const Text('Histórico'),
          backgroundColor: Colors.deepPurple[400]
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        IMCs imc = snapshot.data![index];
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
            );
          }
        )
      );
  }
}

