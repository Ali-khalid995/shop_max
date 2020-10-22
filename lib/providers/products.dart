import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_max/models/http_exception.dart';
import 'package:shop_max/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://www.marni.com/12/12386489MT_13_n_r.jpg',
    ),
    Product(
      id: 'p2',
      title: 'White Shirt',
      description: 'A white shirt - it is pretty white!',
      price: 39.99,
      imageUrl:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSHIGugUFKHPqC0QkF-CEB3GxTmGkom3AL4Rg&usqp=CAU',
    ),
    Product(
      id: 'p3',
      title: 'Blue Shirt',
      description: 'A blue shirt - it is pretty blue!',
      price: 19.99,
      imageUrl:
      'https://marvel-b1-cdn.bc0a.com/f00000000058595/cdn.shopify.com/s/files/1/0077/0432/products/Whole-Meal_41534_web_400x.progressive.jpg?v=1596764344',
    ),
    Product(
      id: 'p4',
      title: 'Green Shirt',
      description: 'A green shirt - it is pretty green!',
      price: 59.99,
      imageUrl:
      'https://media.gucci.com/style/DarkGray_Center_0_0_600x314/1596215704/626986_XJCOP_9762_001_100_0000_Light-Striped-T-shirt-with-piglet-patch.jpg',
    ),*/
  ];

  //var _showFavoritesOnly = false;
  final String authToken;
  Products(this.authToken, this._items);

  List<Product> get items {
//    if(_showFavoritesOnly) {
//      return _items.where((prodItem) => prodItem.isFavorite).toList();
//    }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /*void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();

  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }
*/

  Future<void> fetchAndSetProducts() async {
    final url = 'https://shop-max1.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if(extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-max1.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
    } catch (error) {
      print(error);
      throw error;
    }
    //_items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-max1.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-max1.firebaseio.com/products/$id.json';
    //_items.removeWhere((prod) => prod.id == id);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
