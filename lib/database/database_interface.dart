import 'package:imc_flutter/imcs.dart';

abstract class Database{
  Future<List<IMCs>> getIMCs();

  Future<void> addIMC(IMCs imc);
}