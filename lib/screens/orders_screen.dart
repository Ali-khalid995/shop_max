import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_max/localization/localization_constants.dart';
import 'package:shop_max/providers/orders.dart' show Orders;
import 'package:shop_max/widgets/app_drawer.dart';
import 'package:shop_max/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('Building Orders');
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'your_orders')),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              //..
              //.. Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) {
                    return OrderItem(orderData.orders[index]);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
