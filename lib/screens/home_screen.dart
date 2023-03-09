import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String route = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Aquí ya estamos utilizando el Provider ProductsService el cual ya tiene los datos de Firebase
    final productsService = Provider.of<ProductsService>(context);
    print(productsService.products);
    if(productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Productos')
        ),
      ),
      // Crea los WIDGETS un momento antes de crear o acceder a la pantalla, y no los mantiene activos es útil cundo se tiene demasiados WIDGETS, es mejor que ListView normal
      body: ListView.builder(
        // La propiedad obligatoria para este WIDGET es la de itemBuilder, la cual nos permite construir la lista, donde le pasamos el contexto para construir la lista
        // El WIDGET GestureDetector nos permite ir a una ruta de screens cuando demos TAP en el WIDGET que tiene como hijo, en nuestro caso es toda la tarjeta
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            //La siguiente línea es para obtener el producto seleccionado, y a la misma vez hacemos la copia del producto
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(productModel: productsService.products[index],)
        ),
        // La propiedad itemCount nos permite limitar la cantidad de elementos de la lista
        itemCount: productsService.products.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          productsService.selectedProduct = ProductModel(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}