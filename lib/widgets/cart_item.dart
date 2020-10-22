import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_max/localization/localization_constants.dart';
import 'package:shop_max/providers/cart.dart';
import 'package:toast/toast.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //return Future.value(true);
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(getTranslated(context, 'are_you_sure')),
            content: Text(getTranslated(context, 'do_you_want_to_remove')),
            actions: [
              FlatButton(
                child: Text(getTranslated(context, 'no')),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(getTranslated(context, 'yes')),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
        Toast.show(getTranslated(context, 'removed_from_cart'), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(child: Text('\$${price.toStringAsFixed(3)}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('${getTranslated(context, 'total')}: \$${price.toStringAsFixed(3) * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}

/*
Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(child: Text('\$$price')),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Total: \$${price * quantity}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                    Text('$quantity x'),
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
        )
 */
