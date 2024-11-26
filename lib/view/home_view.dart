import 'package:flutter_controle_abastecimento/controller/home_controller.dart';
import 'package:flutter_controle_abastecimento/widgets/drawler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    User? user = _homeController.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        backgroundColor: Color(0xFF36CAC3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _homeController.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        color: const Color(0xFF2E2E2E),
        child: StreamBuilder<QuerySnapshot>(
          stream: _homeController.getVeiculos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF36CAC3)));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Color(0xFF36CAC3))));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Nenhum veículo encontrado', style: TextStyle(color: Colors.white)));
            }

            List<DocumentSnapshot> veiculos = snapshot.data!.docs;
            return StreamBuilder<List<QuerySnapshot>>(
              stream: _homeController.getAbastecimentos(veiculos),
              builder: (context, abastecimentoSnapshot) {
                if (abastecimentoSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF36CAC3)));
                }
                if (abastecimentoSnapshot.hasError) {
                  return Center(child: Text('Erro: ${abastecimentoSnapshot.error}', style: const TextStyle(color: Color(0xFF36CAC3))));
                }

                int recentRefuels = 0;
                for (var abastecimentos in abastecimentoSnapshot.data!) {
                  recentRefuels += abastecimentos.docs.length;
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bem-vindo ao Controle de Abastecimento!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      if (user != null)
                        Card(
                          color: Color(0xFF36CAC3),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Usuário Atual', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text(user.email ?? '', style: const TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(color: Colors.white70),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Total de Veículos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text('${veiculos.length}', style: const TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(color: Colors.white70),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Abastecimentos Recentes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text('$recentRefuels', style: const TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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