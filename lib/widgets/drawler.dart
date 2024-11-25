import 'package:flutter_controle_abastecimento/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  final AuthController _authController = AuthController();

  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = _authController.getCurrentUser();

    return Drawer(
      backgroundColor: const Color(0xFF2E2E2E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Nome do Usuário', style: TextStyle(color: Colors.white)),
            accountEmail: Text(user?.email ?? 'email@exemplo.com', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              color: Color(0xFF3639F4),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            iconColor: Color(0xFF3639F4),
            title: Text('Home'),
            textColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          ListTile(
            leading: Icon(Icons.car_rental),
            iconColor: Color(0xFF3639F4),
            title: Text('Meus Veículos'),
            textColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, '/meus_veiculos'),
          ),
          ListTile(
            leading: Icon(Icons.add),
            iconColor: Color(0xFF3639F4),
            title: Text('Adicionar Veículo'),
            textColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, '/adicionar_veiculo'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            iconColor: Color(0xFF3639F4),
            title: Text('Histórico de Abastecimentos'),
            textColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, '/historico_abastecimentos'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            iconColor: Color(0xFF3639F4),
            title: Text('Perfil'),
            textColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, '/perfil'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            iconColor: Color(0xFF3639F4),
            title: Text('Logout'),
            textColor: Colors.white,
            onTap: () async {
              await _authController.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}