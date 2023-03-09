import 'package:flutter/material.dart';

//Esta clase se almacenarán métodos estaticos
class InputDecorations {

  //Ahora el método llamada authInputDecoration será el estilo de nuestros inputs que tendremos en el Login, y recibimos como parámetros los siguientes valores
  static InputDecoration authInputDecoration({required String hintText, required String labelText, IconData? prefixIcon}) {
    //La propiedad decoration es de tipo InputDecoration, sirve para añadirle diseños extras a nuestros inputs y personalizarlos aún más
    return InputDecoration(
      //La siguiente propiedad nos permite personalizar el color de la línea de abajo de nuestro input
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple)
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,

          //La propiedad width es para poder colocar la línea más gruesa
          width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),

      //En la propiedad prefixIcon, usaremos una operación condicional, un ternario
      prefixIcon: prefixIcon != null ? Icon(
        prefixIcon,
        color: Colors.deepPurple,
      ) : null
    );
  }
}
