import 'package:flutter_controle_abastecimento/firebase_options.dart';
import 'package:flutter_controle_abastecimento/view/adicionar_veiculo.dart';
import 'package:flutter_controle_abastecimento/view/auth_view.dart';
import 'package:flutter_controle_abastecimento/view/historico_abastecimento.dart';
import 'package:flutter_controle_abastecimento/view/home_view.dart';
import 'package:flutter_controle_abastecimento/view/meus_veiculos.dart';
import 'package:flutter_controle_abastecimento/view/perfil_view.dart';
import 'package:flutter_controle_abastecimento/view/registro_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Inicializando Firebase...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase inicializado com sucesso.");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Abastecimento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/meus_veiculos': (context) => MeusVeiculosScreen(),
        '/adicionar_veiculo': (context) => AdicionarVeiculoScreen(),
        '/historico_abastecimentos': (context) => HistoricoAbastecimentosScreen(),
        '/perfil': (context) => PerfilScreen(),
        '/register': (context) => RegisterScreen()
      },
    );
  }
}