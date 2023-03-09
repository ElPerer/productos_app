import 'package:flutter/material.dart';

//El ChangeNotifier es lo que nos permite hacer poner esta clase dentro del WIDGET MultiProvider
class LoginFormProvider extends ChangeNotifier {

  //En la parte de GlobalKey es para poder controlar las llaves o los estados de algún tipo de WIDGET, en este caso es de un WIDGET Form, por lo tanto colocamos FormState
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Las dos propiedaddes siguientes las vamos a conectar al campo del correo y al campo de la contraseña
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool isValidForm() {

    print(formKey.currentState?.validate());
    print('$email - $password');
    //En la siguiente línea validamos si lo que nos regresa un estado en el método del validate, si regresa un true entonces todo está bien, si regresa un false hay un error
    return formKey.currentState?.validate() ?? false;
  }

}