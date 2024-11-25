import 'package:flutter_controle_abastecimento/controller/home_controller.dart';
import 'package:flutter_controle_abastecimento/widgets/drawler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
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
        title: Text('Home'),
        backgroundColor: Color(0xFF4A148C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _homeController.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        color: Color(0xFF2E2E2E),
        child: StreamBuilder<QuerySnapshot>(
          stream: _homeController.getVeiculos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}', style: TextStyle(color: Colors.white)));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Nenhum veículo encontrado', style: TextStyle(color: Colors.white)));
            }

            List<DocumentSnapshot> veiculos = snapshot.data!.docs;
            return StreamBuilder<List<QuerySnapshot>>(
              stream: _homeController.getAbastecimentos(veiculos),
              builder: (context, abastecimentoSnapshot) {
                if (abastecimentoSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (abastecimentoSnapshot.hasError) {
                  return Center(child: Text('Erro: ${abastecimentoSnapshot.error}', style: TextStyle(color: Colors.white)));
                }

                int recentRefuels = 0;
                for (var abastecimentos in abastecimentoSnapshot.data!) {
                  recentRefuels += abastecimentos.docs.length;
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo ao Controle de Abastecimento!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      if (user != null)
                        Column(
                          children: [
                            Card(
                              color: Color(0xFF4A148C).withOpacity(0.2),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: Icon(Icons.person, color: Colors.white),
                                title: Text('Usuário logado', style: TextStyle(color: Colors.white)),
                                subtitle: Text(user!.email ?? '', style: TextStyle(color: Colors.white70)),
                              ),
                            ),
                            Card(
                              color: Color(0xFF4A148C).withOpacity(0.2),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: Icon(Icons.car_rental, color: Colors.white),
                                title: Text('Total de Veículos', style: TextStyle(color: Colors.white)),
                                subtitle: Text('${veiculos.length}', style: TextStyle(color: Colors.white70)),
                              ),
                            ),
                            Card(
                              color: Color(0xFF4A148C).withOpacity(0.2),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: Icon(Icons.local_gas_station, color: Colors.white),
                                title: Text('Abastecimentos Recentes', style: TextStyle(color: Colors.white)),
                                subtitle: Text('$recentRefuels', style: TextStyle(color: Colors.white70)),
                              ),
                            ),
                          ],
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