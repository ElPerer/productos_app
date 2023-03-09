import 'package:flutter/material.dart';
import 'package:productos_app/models/particle_model.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,

      //El WIDGET Stack coloca los WIDGETS hijos como las columnas pero también se pueden colocar unos ensima de otros
      child: Stack(
        children: <Widget>[
          const _CajaMorada(),

          //El WIDGET SafeArea es para poner los WIDGETS que estén dentro de el de la mejor manera cuando los dispositivos tienen Notch, por defecto añade un margin
          const _IconoUsuario(),

          //Este es el WIDGET que creamos y recibimos desde login_screen.dart
          child
        ],
      ),
    );
  }
}

class _CajaMorada extends StatelessWidget {
  const _CajaMorada({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Con la siguiente línea de código lo que hacemos es obtener las dimensiones de nuestro dispositivo físico, pero obtenemos el valor en píxeles y es de tipo Size
    final Size size = MediaQuery.of(context).size;

    return Container(

      //Para poder poner este contenedor al 40% de nuestra pantalla es necesario colocar el size con la propiedad height y multiplicarlo por el 0.4
      height: size.height*0.4,
      width: double.infinity,

      //Para inciar con los gradientes es necesario colocarlo dentro de la propiedad decoration:
      decoration: _moradoBackground(),

      child: Stack(
        fit: StackFit.expand,
        children: const <Widget>[
          Positioned.fill(
            child: AnimacionParticulas(numberOfParticles: 15)
          ),

          /*
          //El WIDGET Positioned funciona dentro del Stack, este WIDGET nos sirve para poder mover o posinar el WIDGET hijo que tenga el WIDGET Positioned dentro de si
          Positioned(
            child: _Burbuja(),
            top: 90,
            left: 30,
          ),
          Positioned(
            child: _Burbuja(),
            top: -40,
            left: -30,
          ),
          Positioned(
            child: _Burbuja(),
            top: -50,
            right: -20,
          ),
          Positioned(
            child: _Burbuja(),
            bottom: -50,
            left: 10,
          ),
          Positioned(
            child: _Burbuja(),
            bottom: 120,
            right: 20,
          ),
          */
        ],
      ),
    );
  }

  //La siguiente estructura es un método que retorna o regresa un WIDGET 
  BoxDecoration _moradoBackground() => const BoxDecoration(
    gradient: LinearGradient(
      colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]
    )

  );
}

class _IconoUsuario extends StatelessWidget {
  const _IconoUsuario({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100,),
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05 ),
      ),
    );
  }
}