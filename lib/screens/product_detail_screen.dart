import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_max/localization/localization_constants.dart';
import 'package:shop_max/providers/cart.dart';
import 'package:shop_max/providers/products.dart';
import 'package:toast/toast.dart';

class ProductDetailScreen extends StatelessWidget {
/*  final String title;
  final double price;
  ProductDetailScreen(this.title, this.price);*/


  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    final cart = Provider.of<Cart>(context,listen: false);

    //print(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.white,
                    child: CachedNetworkImage(
                      imageUrl: loadedProduct.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  loadedProduct.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  loadedProduct.description,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    child: Text(getTranslated(context, 'add_to_cart'),style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      cart.addItem(loadedProduct.id, loadedProduct.price, loadedProduct.title);
                      Toast.show(getTranslated(context, 'added_to_cart'), context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                    },
                  ),
                ),
                /*Row(
                  children: [
                    IconButton(
                      icon: Icon(loadedProduct.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        loadedProduct.toggleFavoriteStatus();
                      },
                      color: Theme.of(context).accentColor,
                    ),
                    //child: Text('Never changes!'),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
