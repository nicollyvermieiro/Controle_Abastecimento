import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbastecimentoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getAbastecimentos(String userId) {
    return _firestore.collection('abastecimentos')
      .where('userId', isEqualTo: userId)
      .orderBy('data', descending: true)
      .snapshots();
  }

  Future<DocumentSnapshot> getVeiculo(String veiculoId) {
    return _firestore.collection('veiculos').doc(veiculoId).get();
  }

  Future<void> deletarAbastecimento(String abastecimentoId) async {
    await _firestore.collection('abastecimentos').doc(abastecimentoId).delete();
  }

  Future<void> registrarAbastecimento(String veiculoId, String? abastecimentoId, double litros, double quilometragem) async {
    DateTime now = DateTime.now();
    String userId = _auth.currentUser!.uid;

    var abastecimentoData = {
      'userId': userId,
      'veiculoId': veiculoId,
      'litros': litros,
      'quilometragem': quilometragem,
      'data': now,
    };

    if (abastecimentoId == null) {
      await _firestore.collection('abastecimentos').add(abastecimentoData);
    } else {
      await _firestore.collection('abastecimentos').doc(abastecimentoId).update(abastecimentoData);
    }
  }
}