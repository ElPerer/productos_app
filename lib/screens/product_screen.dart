import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  static const String route = 'product';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService)
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // la siguiente línea es para poder ocultar el teclado cuando el usuario quiera hacer scroll en la pantalla
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ProductImage(url: productService.selectedProduct.picture,),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 40, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop()
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt_rounded, size: 40, color: Colors.white),
                    onPressed: () async {
                      //TODO: Abrir cámara o galería
                      final picker = ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 100);
                      if (pickedFile == null) {
                        print('No seleccionó nada');
                        return;
                      }
                      print('Tenemos imagen ${pickedFile.path}');
                      productService.updateSelectedProductImage(pickedFile.path);
                    }
                  ),
                ),
              ],
            ),

            const _ProductForm(),
            const SizedBox(height: 50,)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.indigo,
        
        child: productService.isSaving ? CircularProgressIndicator(color: Colors.white,) : const Icon(Icons.save, color: Colors.white,),
        onPressed: productService.isSaving ? null : () async {
          //TODO: Guardar producto
          if (!productForm.isValidForm()) return;

          final String? imageUrl = await productService.uploadImage();

          if(imageUrl != null) productForm.product.picture = imageUrl;

          await productService.saveOrCreatedProduct(productForm.product);
        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric( horizontal: 20),
      width: double.infinity,
      decoration: _formDecoration(),
      child: Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10,),
            TextFormField(
              initialValue: product.name,
              onChanged: (value) => product.name = value,
              validator: (value) {
                if( value == null || value.length < 1) {
                  return 'El nombre es obligatorio';
                }
              },
              decoration: const InputDecoration(
                labelText: 'Nombre:',
                hintText: 'Nombre del producto',
              ),
            ),
            const SizedBox(height: 30,),
            TextFormField(
              initialValue: '${product.price}',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              onChanged: (value) {
                if (double.tryParse(value) == null) {
                  product.price = 0;
                } else {
                  product.price = double.parse(value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio:',
                hintText: '\$150',
              ),
            ),
            const SizedBox(height: 30,),
            SwitchListTile.adaptive(
              value: product.available,
              title: const Text('Disponible'),
              activeColor: Colors.indigo,
              onChanged: (value) => productForm.updateAvailability(value)
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  BoxDecoration _formDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 5),
        blurRadius: 5
      )
    ]
  );
}