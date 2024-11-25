import 'package:flutter_controle_abastecimento/controller/veiculo_controller.dart';
import 'package:flutter/material.dart';

class AdicionarVeiculoScreen extends StatefulWidget {
  const AdicionarVeiculoScreen({super.key});

  @override
  _AdicionarVeiculoScreenState createState() => _AdicionarVeiculoScreenState();
}

class _AdicionarVeiculoScreenState extends State<AdicionarVeiculoScreen> {
  final _nomeController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anoController = TextEditingController();
  final _placaController = TextEditingController();
  String _errorMessage = '';
  final VeiculoController _veiculoController = VeiculoController();

  Future<void> _adicionarVeiculo() async {
    if (!_veiculoController.anoValido(_anoController.text)) {
      setState(() {
        _errorMessage = 'Ano inválido. Por favor, insira um ano entre 1886 e ${DateTime.now().year}.';
      });
      return;
    }

    try {
      await _veiculoController.adicionarVeiculo(
        _nomeController.text,
        _modeloController.text,
        int.parse(_anoController.text),
        _placaController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao adicionar veículo: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Veículo'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF2E2E2E),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(_nomeController, 'Nome'),
              _buildTextField(_modeloController, 'Modelo'),
              _buildTextField(_anoController, 'Ano', keyboardType: TextInputType.number),
              _buildTextField(_placaController, 'Placa'),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarVeiculo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD29B0),
                ),
                child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
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
        keyboardType: keyboardType,
      ),
    );
  }
}