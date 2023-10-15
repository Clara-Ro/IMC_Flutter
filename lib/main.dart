import 'package:flutter/material.dart';
import 'package:imc_flutter/database/database_interface.dart';
import 'package:imc_flutter/database/sqlite_impl.dart';
import 'package:imc_flutter/history.dart';
import 'package:imc_flutter/imcs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: IMC(),debugShowCheckedModeBanner: false,);
  }
}


class IMC extends StatefulWidget {
  const IMC({super.key});

  @override
  State<IMC> createState() => _IMCState();
}

class _IMCState extends State<IMC> {
  double weight = 1;
  double height = 1;
  double imc = 1;
  String result = '';
  bool isOpen = false;
  SharedPreferences? cache;
  TextEditingController heightController = TextEditingController();
  late Database db;

  @override
  void initState() {
    super.initState();
    initCache();
    db = SQLiteImpl();
  }

  Future<void> initCache () async{
    cache = await SharedPreferences.getInstance();
    setState(() async {
      height =  cache!.getDouble("height") ?? 1;
      heightController.text = height.toStringAsFixed(2);
    });
  }

  void calculateIMC(){
    setState(() {
      imc = weight/(height*height);
      if (imc < 18.5) {
        result = ('Você está abaixo do peso.');
      } else if (imc <= 24.9) {
        result = ('Seu peso está normal.');
      } else if (imc <= 29.9) {
        result = ('Você está com sobrepeso.');
      } else if (imc <= 34.9) {
        result = ('Você está com obesidade grau 1.');
      } else if (imc <= 39.9) {
        result = ('Você está com obesidade grau 2.');
      } else {
        result = ('Você está com obesidade grau 3.');
      }
      db.addIMC(IMCs(weight,height,imc,result));
    });
  }

  void setHeight(value){
    setState((){
      height = double.parse(value);
      if (cache != null) {
        cache!.setDouble("height", height);
      }
    });
  }

  void setWeight(value){
    setState((){
      weight = double.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurpleAccent[100],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, left: 8, bottom: 12),
              child: const Text(
                "Digite sua altura: ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: setHeight,
                controller: heightController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white)
                  ),
                  labelText: 'Altura',
                  labelStyle: TextStyle(
                    color: Colors.white
                  )
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 8, bottom: 12),
              child: const Text(
                "Digite seu peso: ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: setWeight,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white)
                  ),
                  labelText: 'Peso',
                  labelStyle: TextStyle(
                    color: Colors.white
                  )
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    calculateIMC();
                    isOpen = true;
                  }, 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple[400])),
                  label: const Text("Salvar e Calcular"),
                  icon: const Icon(Icons.save),
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> HistoryIMC(db: db))
                    );
                  }, 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple[400])),
                  label: const Text("Histórico"),
                  icon: const Icon(Icons.history),
                )
              ],
            ),
            if(isOpen)...[
              AlertDialog(content: Text('${imc.toStringAsFixed(2)} - $result'),)
            ],
          ],
        ),
      ),
    );
  }
}

