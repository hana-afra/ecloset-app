import 'package:dio/dio.dart';
import 'package:ecloset/models/my_selling_items.dart';
import 'package:ecloset/models/product.dart';
import 'package:ecloset/models/shopPants.dart'; 
import 'package:ecloset/models/shopShoes.dart'; 
import 'package:ecloset/models/shopTop.dart';
import 'package:ecloset/screens/addItem.dart';
import 'package:ecloset/screens/home.dart'; 
import 'package:ecloset/screens/favorite_items.dart'; 
import 'package:ecloset/screens/login.dart';
import 'package:ecloset/screens/my_profile.dart'; 
import 'package:ecloset/screens/filtered_products.dart';
import 'package:ecloset/screens/register.dart'; 
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:ecloset/models/shop.dart'; 
import 'package:ecloset/models/shopdress.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
final dio =Dio();

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://jzredydxgjflzlgkamhn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6cmVkeWR4Z2pmbHpsZ2thbWhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIzMDQ1OTYsImV4cCI6MjAxNzg4MDU5Nn0.7jYAyMpWdzAnyioSoVkJiRFWzWyZvs0kdDxlli02er4',
  );
  final supabase = Supabase.instance.client;
  
  runApp( 
    MultiProvider( 
      providers: [ 
        ChangeNotifierProvider<MySellingItems>(
          create: (context) => MySellingItems(),
        ),
        ChangeNotifierProvider<Shop>( 
          create: (context) => Shop(), 
        ), 
        ChangeNotifierProvider<ShopDress>( 
          create: (context) => ShopDress(), 
        ), 
        ChangeNotifierProvider<ShopShoes>( 
          create: (context) => ShopShoes(), 
        ), 
        ChangeNotifierProvider<ShopPants>( 
          create: (context) => ShopPants(), 
        ), 
        ChangeNotifierProvider<ShopTop>( 
          create: (context) => ShopTop(), 
        ), 
        // Add more providers if needed 
      ], 
      child: const MyApp(), 
    ) 
  ); 
} 
class MyApp extends StatelessWidget { 
  const MyApp({super.key}); 
 
  // This widget is the root of your application. 
  @override 
  Widget build(BuildContext context) { 
    return  MaterialApp( 
      debugShowCheckedModeBanner: false, 
      routes: { 
      '/home'     : (context) => HomeScreen(), 
      '/profile'  : (context) => MyProfile(), 
      '/plus'     : (context) => AddItemsPage(), 
      '/search'   : (context) => FilteredProducts(filteredProducts: [],), 
      '/favorite' : (context) => favorite_items(), 
      '/welcome'  : (context) => Login(),
     
  }, 
      home: HomeScreen(), 
    ); 
  } 
}