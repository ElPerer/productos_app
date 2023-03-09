import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;
  const ProductCard({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        height: 400,
        width: double.infinity,
        decoration: _cardDecoration(),
        child: Stack(

          // Con la propiedad Alignment del WIDGET Stack se alinean todos sus hijos a donde nos permita
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            _CardImageBackground(url: productModel.picture,),
            _ProductDetails(id: productModel.id, name: productModel.name),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(precio: productModel.price,)
            ),

            //TODO: Mostrar de manera condicional
            Positioned(
              top: 0,
              left: 0,
              child: _NotAvailable(disponible: productModel.available)
            )
          ],
        ),
      ),
    );
  }
  BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),

      // La propiedad boxShadow nos sirve para poder poner sombreado de un color y aparte para ponerle remarcado el blur del mismo color, es decir un defuminado
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black12,

          // La propiedad offset nos permite mover lo que es el sombreado o el BoxShadow de lugar, dependiendo si es en X o en Y
          offset: Offset(0, 7),
          blurRadius: 10
        )
      ]
    );
}

class _CardImageBackground extends StatelessWidget {
  final String? url;
  const _CardImageBackground({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // El WIDGET ClipRRect lo utilizamos para que la imagen o el WIDGET que contiene la imagen tenga un border radius como el WIDGET padre
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 400,
        width: double.infinity,
    
        // El WIDGET FadeInImage, nos permite poner una imagen de cargado muientras nuestra imagen real se termina de cargar
        child: (url == null) 
        ? const Image( image: AssetImage('assets/no-image.png'), fit: BoxFit.cover,)
        : FadeInImage(
          image: NetworkImage(url!),
          placeholder: const AssetImage('assets/jar-loading.gif'),
          // La propiedad fit nos permite expander la imagen a todo el WIDGET padre para que así no quede ningún espacio en blanco
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String? id;
  final String name;
  const _ProductDetails({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 70,
        width: double.infinity,
        decoration: _decorationDetails(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(name, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(id!, style: TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
      ),
    );
  }
  BoxDecoration _decorationDetails() => const BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
  );
}

class _PriceTag extends StatelessWidget {
  final double precio;
  const _PriceTag({Key? key, required this.precio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      // El WIDGET FittedBox nos permite definirle como queremos adaptarle el WIDGET interno o el WIDGET hijo
      child: FittedBox(
        // Con la propiedad fit: BoxFit.contain nos permite adaptar el hijo de manera correcta, que se acomple al padre
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          // De la siguiente manera le decimos que no tome el $ para poner una variable si no como un signo de dinero
          child: Text('\$$precio', style: TextStyle(color: Colors.white, fontSize: 20))
        ),
      ),
      height: 70,
      width: 100,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  final bool disponible;
  const _NotAvailable({Key? key, required this.disponible}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text((disponible) ? 'Disponible' : 'No disponible', style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ),
      height: 70,
      width: 100,
      decoration: BoxDecoration(
        color: (disponible) ? Colors.green[800] : Colors.yellow[800],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
    );
  }
}