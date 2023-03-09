import 'package:flutter/material.dart';
import 'package:productos_app/models/particle_model.dart';
class SplashScreen extends StatefulWidget {
  static const String route = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFA50E), Color(0xFFF26D2B)]
                )
              ),
            ),
          ),
          const Positioned.fill(child: AnimacionParticulas(numberOfParticles: 50,))
        ],
      ),
    );
  }
}