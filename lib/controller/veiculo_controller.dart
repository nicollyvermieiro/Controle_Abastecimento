import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VeiculoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> adicionarVeiculo(String nome, String modelo, int ano, String placa) async {
    await _firestore.collection('veiculos').add({
      'nome': nome,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
      'userId': _auth.currentUser!.uid,
    });
  }

  Future<void> editarVeiculo(String veiculoId, String nome, String modelo, int ano, String placa) async {
    await _firestore.collection('veiculos').doc(veiculoId).update({
      'nome': nome,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
    });
  }

  Future<void> deletarVeiculo(String veiculoId) async {
    await _firestore.collection('veiculos').doc(veiculoId).delete();
    var abastecimentos = await _firestore.collection('abastecimentos').where('veiculoId', isEqualTo: veiculoId).get();
    for (var abastecimento in abastecimentos.docs) {
      await _firestore.collection('abastecimentos').doc(abastecimento.id).delete();
    }
  }

  bool anoValido(String ano) {
    int? year = int.tryParse(ano);
    return year != null && year >= 1886 && year <= DateTime.now().year;
  }
}