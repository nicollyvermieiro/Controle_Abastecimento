import 'package:flutter_controle_abastecimento/controller/abastecimento_controller.dart';
import 'package:flutter/material.dart';

class NovoAbastecimentoScreen extends StatefulWidget {
  final String veiculoId;
  final String? abastecimentoId;
  final Map<String, dynamic>? existingData;

  NovoAbastecimentoScreen(
      {required this.veiculoId, this.abastecimentoId, this.existingData});

  @override
  _NovoAbastecimentoScreenState createState() =>
      _NovoAbastecimentoScreenState();
}

class _NovoAbastecimentoScreenState extends State<NovoAbastecimentoScreen> {
  final _litrosController = TextEditingController();
  final _quilometragemController = TextEditingController();
  String _errorMessage = '';
  final AbastecimentoController _abastecimentoController =
      AbastecimentoController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _litrosController.text = widget.existingData!['litros'].toString();
      _quilometragemController.text =
          widget.existingData!['quilometragem'].toString();
    }
  }

  Future<void> _registrarAbastecimento() async {
    if (!_validaCampos()) {
      return;
    }

    try {
      await _abastecimentoController.registrarAbastecimento(
        widget.veiculoId,
        widget.abastecimentoId,
        double.parse(_litrosController.text),
        double.parse(_quilometragemController.text),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao registrar abastecimento: ${e.toString()}';
      });
    }
  }

  bool _validaCampos() {
    if (_litrosController.text.isEmpty ||
        _quilometragemController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return false;
    }

    if (double.tryParse(_litrosController.text) == null ||
        double.tryParse(_quilometragemController.text) == null) {
      setState(() {
        _errorMessage = 'Por favor, insira apenas números válidos.';
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.abastecimentoId == null
            ? 'Novo Abastecimento'
            : 'Editar Abastecimento'),
        backgroundColor: Color(0xFF36CAC3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xFF2E2E2E),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(_litrosController, 'Litros',
                  keyboardType: TextInputType.number),
              _buildTextField(_quilometragemController, 'Quilometragem',
                  keyboardType: TextInputType.number),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: const Color(0xFF3643F4)),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarAbastecimento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A148C),
                ),
                child: Text(
                    widget.abastecimentoId == null ? 'Registrar' : 'Salvar',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Color(0xFF36CAC3).withOpacity(0.2),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF36CAC3)),
          ),
        ),
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardType,
      ),
    );
  }
}