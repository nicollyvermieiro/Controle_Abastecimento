import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_controle_abastecimento/controller/veiculo_controller.dart';
import 'package:flutter_controle_abastecimento/view/editar_veiculo.dart';
import 'package:flutter_controle_abastecimento/view/novo_abastecimento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MeusVeiculosScreen extends StatelessWidget {
  final VeiculoController _veiculoController = VeiculoController();

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Veículos'),
        backgroundColor: Color(0xFF4A148C),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xFF2E2E2E),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('veiculos')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var veiculo = snapshot.data!.docs[index];
                return Card(
                  color: Color(0xFF4A148C).withOpacity(0.2),
                  child: ListTile(
                    title: Text(
                      veiculo['nome'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${veiculo['modelo']} - ${veiculo['ano']}',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.local_gas_station, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NovoAbastecimentoScreen(veiculoId: veiculo.id),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarVeiculoScreen(
                                  veiculoId: veiculo.id,
                                  existingData: veiculo.data() as Map<String, dynamic>,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            await _veiculoController.deletarVeiculo(veiculo.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}