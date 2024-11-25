import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_controle_abastecimento/controller/veiculo_controller.dart';
import 'package:flutter_controle_abastecimento/view/editar_veiculo.dart';
import 'package:flutter_controle_abastecimento/view/novo_abastecimento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MeusVeiculosScreen extends StatelessWidget {
  final VeiculoController _veiculoController = VeiculoController();

  MeusVeiculosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Veículos'),
        backgroundColor: const Color(0xFF3639F4),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF2E2E2E),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('veiculos')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var veiculo = snapshot.data!.docs[index];
                return Card(
                  color: const Color(0xFF3639F4),
                  child: ListTile(
                    title: Text(
                      veiculo['nome'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${veiculo['modelo']} - ${veiculo['ano']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NovoAbastecimentoScreen(veiculoId: veiculo.id),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: const Color(0xFF3639F4),
                            ),
                            child: const Text('Abastecer'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
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
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: const Color(0xFF3639F4),
                            ),
                            child: const Text('Editar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await _veiculoController.deletarVeiculo(veiculo.id);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: const Color(0xFF3639F4),
                            ),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
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