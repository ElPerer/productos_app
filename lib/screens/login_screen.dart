import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{

  static const String route = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: AuthBackground(

        //El WIDGET SingleChildScrollView me va a permitir hacer Scroll si sus hijos sobre pasan la cantidad de tamaño que tiene nuestro dispositivo
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 200,),
              CardContainer(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox(height: 30,),

                    //Lo siguiente lo que hace es crear una instancia del LoginFormProvider que este puede redibujar los WIDGETS cuando sea necesario solo en LoginFormulario
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: const _LoginFormulario(),
                    )
                    
                  ],
                )
              ),
              const SizedBox(height: 50,),
              TextButton(
                child: const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, color: Colors.black87)),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, 'register')
              ),
              const SizedBox(height: 25,),
            ],
          ),
        )
      )
    );
  }
}

class _LoginFormulario extends StatelessWidget {
  const _LoginFormulario({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {

    final loginForm =  Provider.of<LoginFormProvider>(context);
    return Container(

      //El WIDGET Form va a tener una referencia al estado completo que tiene sus WIDGETS internos o sus hijos
      child: Form(

        //TODO: mantener la referencia al KEY
        
        //Este KEY nos dirá si nuestro formulario pasaron las validaciones respectivas
        key: loginForm.formKey,

        //La propiedad autovalidateMode nos permite colocar en que momento se va a disparar la propiedad validator que tenemos en la parte de abajo
        //Podemos ponerle que siempre se dispare, o cuando el usuario haga alguna interacción con el formulario o campo especifico donde esté el validator definido
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[

            //El WIDGET TextFormField nos sirve para poder poner campos de texto, ya sea dentro de un fomrulario o cuadros de texto para otros usos
            TextFormField(

              //La priopiedad autocorrect está en true por defecto y esto hace que nos autocorrija
              autocorrect: false,

              //La siguiente propiedad es para el tipo de input que deseamos tener en ese apartado
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(hintText: 'ejemplo@hotmail.com', labelText: 'Correo Electrónico', prefixIcon: Icons.alternate_email_rounded),

              onChanged: (value) => loginForm.email = value,
              //La propiedad validator, requiere el parámetro value o el nombre que deseemos colocarle, que este valor es lo que escribimos en la caja de texto o en el input
              validator: (value) {

                //Expresión regular
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);

                //Retornamos la función ternario, en caso que value venga null entonces colocamos una cadena vacía, si es así, entonces no saltará el error
                //En caso contrario que tenga algún valor y no haga Match, es decir, que no se cumpla la condición que sean iguales, saltará el error
                return regExp.hasMatch(value ?? '') ? null : 'El Correo es inválido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(

              //La priopiedad autocorrect está en true por defecto y esto hace que nos autocorrija
              autocorrect: false,

              //La propiedad obscureText es para omitir cada letra por el caracter de *
              obscureText: true,

              //La siguiente propiedad es para el tipo de input que deseamos tener en ese apartado
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(hintText: '**********', labelText: 'Contraseña'),

              onChanged: (value) => loginForm.password = value,
              //La propiedad validator, requiere el parámetro value o el nombre que deseemos colocarle, que este valor es lo que escribimos en la caja de texto o en el input
              validator: (value) {
                if(value != null && value.length >= 6) return null;
                return 'La contraseña menor a 6 caracteres';
              },
            ),
            const SizedBox(height: 30),

            //MaterialButton es un WIDGET para poder crear un botón
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginForm.isLoading ? 'Espere...' : 'Ingresar', style: const TextStyle(color: Colors.white),),
              ),

              //Se pueden hacer ternarios después de declarar la propiedad, en este caso onPressed
              // Para desabilidar un botón es necesario colocar en la propiedad onPressed el valor de null
              onPressed: loginForm.isLoading ? null : () async{

                //Para quitar el teclado cuando seleccionamos este botón, colocamos la siguiente línea
                FocusScope.of(context).unfocus();

                //TODO: LoginForm
                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                await Future.delayed(const Duration(seconds: 2));

                loginForm.isLoading = false;
                //El Navigator.pushReplacementNamed lo que hace es destruir la pantalla anterior y deja solamente la nueva pantalla a la que deseamos navegar
                Navigator.pushReplacementNamed(context, HomeScreen.route);
              },
            )
          ],
        ),
      ),
    );
  }
}