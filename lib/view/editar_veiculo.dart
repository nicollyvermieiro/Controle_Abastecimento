import 'package:flutter_controle_abastecimento/controller/veiculo_controller.dart';
import 'package:flutter/material.dart';

class EditarVeiculoScreen extends StatefulWidget {
  final String veiculoId;
  final Map<String, dynamic> existingData;

  const EditarVeiculoScreen({super.key, required this.veiculoId, required this.existingData});

  @override
  _EditarVeiculoScreenState createState() => _EditarVeiculoScreenState();
}

class _EditarVeiculoScreenState extends State<EditarVeiculoScreen> {
  final _nomeController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anoController = TextEditingController();
  final _placaController = TextEditingController();
  String _errorMessage = '';
  final VeiculoController _veiculoController = VeiculoController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.existingData['nome'];
    _modeloController.text = widget.existingData['modelo'];
    _anoController.text = widget.existingData['ano'].toString();
    _placaController.text = widget.existingData['placa'];
  }

  Future<void> _editarVeiculo() async {
    if (!_veiculoController.anoValido(_anoController.text)) {
      setState(() {
        _errorMessage = 'Ano inválido. Por favor, insira um ano entre 1886 e ${DateTime.now().year}.';
      });
      return;
    }

    try {
      await _veiculoController.editarVeiculo(
        widget.veiculoId,
        _nomeController.text,
        _modeloController.text,
        int.parse(_anoController.text),
        _placaController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao editar veículo: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Veículo'),
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
                    style: const TextStyle(color: Color(0xFF5F36F4)),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editarVeiculo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF36CAC3),
                ),
                child: const Text('Salvar', style: TextStyle(color: Colors.white)),
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