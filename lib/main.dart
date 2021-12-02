import 'package:flutter/material.dart';
import 'package:tf/redux/appState.dart';
import 'package:tf/redux/reducer.dart';
import 'package:tf/repositories/menu_repository.dart';
import 'package:tf/screens/address_create_screen.dart';
import 'package:tf/screens/address_update_screen.dart';
import 'package:tf/screens/checkout_screen.dart';
import 'package:tf/screens/delivery_screen.dart';
import 'package:tf/screens/order_detail_screen.dart';
import 'package:tf/screens/product_detail_screen.dart';
import 'package:tf/screens/product_list_screen.dart';
import 'package:tf/screens/save_money_screen.dart';
import 'package:tf/screens/search_screen.dart';
import 'package:tf/screens/signin_screen.dart';
import 'package:tf/screens/size_guide_screen.dart';
import 'package:tf/screens/user_update_screen.dart';
import 'package:tf/screens/web_checkout_screen.dart';
import 'package:tf/screens/welcome_screen.dart';
import 'components/bottomTabBar.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  final List<MenuNode> menu = await MenuRepository().getMenu();
  var initialState = await persistor.load();
  if (initialState != null) {
    initialState = initialState.copyWith(menu: menu);
  }

  final store = Store<AppState>(
    reducer,
    initialState: initialState ?? AppState(menu: menu),
    middleware: [persistor.createMiddleware()],
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            title: 'TF',
            theme: ThemeData(
                primarySwatch: Colors.indigo,
                primaryColorDark: Colors.indigo,
                primaryColorLight: Colors.indigo.shade200,
                accentColor: Colors.blue),
            home: BottomTabBar(title: 'TF Abbigliamento'),
            routes: {
              ProductListScreen.routeName: (context) =>
                  const ProductListScreen(),
              ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
              SearchScreen.routeName: (context) => SearchScreen(),
              AddressUpdateScreen.routeName: (context) => AddressUpdateScreen(),
              AddressCreateScreen.routeName: (context) => AddressCreateScreen(),
              UserUpdateScreen.routeName: (context) => UserUpdateScreen(),
              OrderDetailScreen.routeName: (context) => OrderDetailScreen(),
              SigninScreen.routeName: (context) => SigninScreen(),
              WelcomeScreen.routeName: (context) => WelcomeScreen(),
              SizeGuideScreen.routeName: (context) => SizeGuideScreen(),
              DeliveryScreen.routeName: (context) => DeliveryScreen(),
              SaveMoneyScreen.routeName: (context) => SaveMoneyScreen(),
              CheckoutScreen.routeName: (context) => CheckoutScreen(),
              WebCheckoutScreen.routeName: (context) => WebCheckoutScreen()
            }));
  }
}
