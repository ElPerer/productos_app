import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(const AppState());

// El siguiente WIDGET nos permite colocar el Provider en la parte más alta de nuestra aplicación, es decir cuando la aplicación se levanta o es abierta por el usuario
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[

        // Nuestro Provider tiene la propiedad Lazy en true por defecto, cuando le pongo el valor de false, el provider se dispara cuando el ProductsService es creado
        ChangeNotifierProvider(create: (_) => ProductsService())
      ],
      child:const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Productos',

      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (_) => const LoginScreen(),
        RegisterScreen.route: (_) => const RegisterScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
        ProductScreen.route: (_) => const ProductScreen()
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}