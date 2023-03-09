import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

   @override
   Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: _crearCard(),
        child: child,
      ),
    );
   }

   BoxDecoration _crearCard() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const <BoxShadow>[
      BoxShadow(
        color: Colors.black12,

        //La propiedad blurRadius es que tanto se puede esparcir el blur
        blurRadius: 15,

        // La propiedad Offset es la posición a donde deseamos mover la sombra, el primer parámetro corresponde al eje X y el segundo al eje Y
        offset: Offset(0, 5)
      )
    ]
   );
}