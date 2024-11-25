import 'package:flutter_controle_abastecimento/controller/perfil_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final PerfilController _perfilController = PerfilController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = await _perfilController.getCurrentUser();
    if (user != null) {
      _emailController.text = user.email ?? '';
    }
  }

  Future<void> _updateUserProfile() async {
    if (_nicknameController.text.isNotEmpty) {
      await _perfilController.updateNickname(_nicknameController.text);
    }
    if (_emailController.text.isNotEmpty) {
      await _perfilController.updateEmail(_emailController.text);
    }
    if (_senhaController.text.isNotEmpty) {
      await _perfilController.updatePassword(_senhaController.text);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado com sucesso')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF36CAC3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nicknameController, 'Nickname'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_senhaController, 'Senha', obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF36CAC3),
              ),
              child: const Text('Atualizar Perfil'),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF2E2E2E),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF36CAC3).withOpacity(0.2),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF36CAC3)),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
      ),
    );
  }
}