import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'configuracion_provider.dart';
import 'services/data_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/seleccion_tipo_servicio_screen.dart';
import 'screens/formulario_taxi_screen.dart';
import 'screens/formulario_delivery_screen.dart';
import 'screens/formulario_servicio_vario_screen.dart';
import 'screens/registro_negocio_screen.dart';
import 'screens/mis_servicios_screen.dart';
import 'screens/configuracion_screen.dart';
import 'screens/perfil_usuario_screen.dart';
import 'screens/servicios_screen.dart';
import 'screens/profesionales_screen.dart';
import 'screens/buscar_servicios_screen.dart';
import 'screens/terminos_screen.dart';
import 'screens/privacidad_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ INICIALIZAR FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfiguracionProvider()),
        ChangeNotifierProvider(create: (context) => DataService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    
    // Cargar datos al iniciar
    if (dataService.servicios.isEmpty) {
      dataService.cargarDatosEjemplo();
    }
    if (dataService.patrocinadores.isEmpty) {
      dataService.cargarPatrocinadores();
    }

    final config = Provider.of<ConfiguracionProvider>(context);

    return MaterialApp(
      title: 'Servicios Margarita',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: config.tema == 'Oscuro' ? Brightness.dark : Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/seleccion_tipo': (context) => const SeleccionTipoServicioScreen(),
        '/formulario_taxi': (context) => const FormularioTaxiScreen(tipo: 'taxi'),
        '/formulario_moto_taxi': (context) => const FormularioTaxiScreen(tipo: 'moto_taxi'),
        '/formulario_delivery': (context) => const FormularioDeliveryScreen(),
        '/formulario_servicio_vario': (context) => const FormularioServicioVarioScreen(),
        '/registro_negocio': (context) => const RegistroNegocioScreen(),
        '/mis_servicios': (context) => const MisServiciosScreen(),
        '/configuracion': (context) => const ConfiguracionScreen(),
        '/perfil': (context) => const PerfilUsuarioScreen(),
        '/servicios': (context) => const ServiciosScreen(),
        '/buscar': (context) => const BuscarServiciosScreen(),
        '/terminos': (context) => const TerminosScreen(),
        '/privacidad': (context) => const PrivacidadScreen(),
      },
    );
  }
}