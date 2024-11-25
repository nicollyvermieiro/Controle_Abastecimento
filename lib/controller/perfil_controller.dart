import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class HomeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getVeiculos() {
    return _firestore.collection('veiculos')
      .where('userId', isEqualTo: _auth.currentUser!.uid)
      .snapshots();
  }

  Stream<List<QuerySnapshot>> getAbastecimentos(List<DocumentSnapshot> veiculos) {
    List<Stream<QuerySnapshot>> streams = veiculos.map((veiculo) {
      return _firestore.collection('abastecimentos')
        .where('veiculoId', isEqualTo: veiculo.id)
        .snapshots();
    }).toList();
    return CombineLatestStream.list(streams);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}