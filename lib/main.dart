import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_max/localization/demo_localization.dart';
import 'package:shop_max/localization/localization_constants.dart';
import 'package:shop_max/providers/auth.dart';
import 'package:shop_max/providers/cart.dart';
import 'package:shop_max/providers/orders.dart';
import 'package:shop_max/providers/products.dart';
import 'package:shop_max/screens/auth_screen.dart';
import 'package:shop_max/screens/cart_screen.dart';
import 'package:shop_max/screens/edit_product_screen.dart';
import 'package:shop_max/screens/orders_screen.dart';
import 'package:shop_max/screens/product_detail_screen.dart';
import 'package:shop_max/screens/products_overview_screen.dart';
import 'package:shop_max/screens/settings_screen.dart';
import 'package:shop_max/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  Auth _auth;
  Products _products;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
//        ChangeNotifierProxyProvider<Auth, Products>(
//          create: (ctx)=>Products(_auth.token,_products.items),
//          update: (ctx, auth, previousProducts) => Products(
//            auth.token,
//            previousProducts == null ? [] : previousProducts.items,
//          ),
//        ),

        ChangeNotifierProvider.value(
          value: Cart(),
          // create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),

    /*    ChangeNotifierProvider.value(
          value: Orders(),
          //create: (ctx) => Orders(),
        ),*/
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          locale: _locale,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
//            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
          },
        ),
      ),
    );
  }
}
