import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-mixtos-default-rtdb.firebaseio.com';

  final List<ProductModel> products = [];
  late ProductModel selectedProduct;
  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  //Lo siguiente es una instancia de la propa clase en la que estamos ubicados
  ProductsService(){
    //En cuanto es instanciado se invoca el método loadProducts
    loadProducts();
  }

  Future<List<ProductModel>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    // En la siguiente línea hacemos la petición
    final url = Uri.https(_baseUrl, 'products.json');

    //En la siguiente línea obtenemos la respuesta
    final resp = await http.get(url);

    //Esto lo hacemos para parsear o convertir nuestra respuesta STRING a un objeto JSON
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = ProductModel.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreatedProduct(ProductModel product) async {
    isSaving = true;
    notifyListeners();
    if(product.id == null) {
      //No tengo un producto y es necesario crear
      await createProduct(product);
    } else {
      //Actualizar el producto
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct (ProductModel product) async {
    // En la siguiente línea hacemos la petición
    final url = Uri.https(_baseUrl, 'products/${ product.id }.json');

    
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    //TODO: actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct (ProductModel product) async {
    // En la siguiente línea hacemos la petición
    final url = Uri.https(_baseUrl, 'products.json');

    
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];

    //TODO: actualizar el listado de productos
    products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage (String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage () async{
    if(newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();

    //El parse es el url que nosotros tenemos para cargar la imagen
    final url = Uri.parse('https://api.cloudinary.com/v1_1/elperer/image/upload?upload_preset=ea6yn5ai');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);
    
    if(resp.statusCode != 200  && resp.statusCode != 201) {
      return null;
    }

    newPictureFile = null;

    //La siguiente línea nos convierte el String de resp.body a un JSON para poder obtener el dato que deseamos
    final decodedData = json.decode(resp.body);

    return decodedData['secure_url'];
  }

}