import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_max/localization/localization_constants.dart';
import 'package:shop_max/providers/auth.dart';
import 'package:shop_max/providers/cart.dart';
import 'package:shop_max/providers/product.dart';
import 'package:shop_max/screens/product_detail_screen.dart';
import 'package:toast/toast.dart';

class ProductItem extends StatelessWidget {
/*  final String id;
  final String title;
  final String imageUrl;

  ProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );*/

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context,listen: false);


    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              //label: child, //TODO:: هنا لو في زر فيه مثلا ليبل بنعمل التيكست تبعه برا الزر وبنجيبه هين عشان ما يبنيه تاني
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token);
              },
              color: Theme.of(context).accentColor,
            ),
            //child: Text('Never changes!'),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              /*Toast.show("Added to cart", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);*/
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(getTranslated(context, 'added_to_cart')),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(label:'UNDO',onPressed: (){
                    cart.removeSingleItem(product.id);
                  },),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
