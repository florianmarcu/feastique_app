import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/config/config.dart';
import 'package:feastique/config/theme.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/app/bloc/app_cubit.dart';
import 'package:feastique/screens/app/bloc/wrapper_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'screens/app/ui/app.dart';
import 'screens/wrapper.dart';
import 'package:authentication/authentication.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  await config();
  runApp(Main());
}

/// The class that renders the whole MaterialApp
class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /// The providers for app's state
      providers: [
        /// The auth state of the app
        StreamProvider<User?>.value(  
          value: Authentication.user, 
          initialData: null
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Feastique',
        theme: theme(context),
        // home: ChangeNotifierProvider(
        //   create: (context) => WrapperProvider(),
        //   child: Wrapper()
        // ),
        home: BlocProvider(
          create: (context) => AppCubit(),
          child: App(),
        ),
      ),
    );
  }
}

/// Handles all the configuration needed before the app launches
Future<void> config() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  // FirebaseOptions firebaseOptions = const FirebaseOptions(
  //   appId: '1:1009284415459:web:3fe12199aeadcfcf326ad6',
  //   apiKey: 'AIzaSyBeApv-LQI5lDvkZUFD-5yiMLu55KOe6Bo',
  //   projectId: 'hyuga-app',
  //   messagingSenderId: '1009284415459',
  //   storageBucket: 'hyuga-app.appspot.com'
  // );
  // await Firebase.initializeApp(name: "hyuga",options: firebaseOptions);
  //await fillDb();
}

fillDb() async{
  FirebaseFirestore.instance.collection("places").doc("martina_ristorante")
  .set(
    {
      "discounts":{
        "monday":["09:00-24:00_20"],
        "tuesday":["09:00-24:00_30"],
        "wednesday":["09:00-24:00_20"],
        "thursday":["09:00-24:00_30"],
        "friday":["09:00-00:24_20"],
        "saturday":["09:00-24:00_20"],
        "sunday": ["09:00-18:00_20", "18:00-24:00_30"]
      }
    }
    ,SetOptions(merge: true)
  );
  // FirebaseFirestore.instance.collection('config').doc("assets").set(
  //   {
  //     "icons": kFilters['types']!.toList(),
  //   },
  //   SetOptions(merge: true)
  // );
  // FirebaseFirestore.instance.collection("places")
  // .doc("martina_ristorante").set(
  //   {
  //     "menu": {
  //       "items": [
  //         {
  //           "title": "Pizza Margherita",
  //           "content": "Pizza Margherita, cu blat subțire și diametru de 40 cm",
  //           "ingredients": ["aluat, sos de roșii, brânză mozzarella"],
  //           "alergens" : ["lactoză", "gluten"],
  //           "price": "29RON",
  //         },
  //         {
  //           "title": "Pizza Capricciosa",
  //           "content": "Pizza Capricciosa, cu blat subțire și diametru de 40 cm",
  //           "ingredients": ["aluat, sos de roșii, brânză mozzarella", "ciuperci"],
  //           "alergens" : ["lactoză", "gluten"],
  //           "price": "31RON",
  //         },
  //         {
  //           "title": "Pizza Suprema",
  //           "content": "Pizza Suprema, cu blat subțire și diametru de 40 cm",
  //           "ingredients": ["aluat, sos de roșii, brânză mozzarella", "ciuperci", "porumb", "prosciutto crudo"],
  //           "alergens" : ["lactoză", "gluten"],
  //           "price": "35RON",
  //         },
  //         {
  //           "title": "Spaghetti Carbonara",
  //           "content": "Spaghetti Carbonara după rețeta tradițională",
  //           "ingredients": ["ou, parmezan, brânză mozzarella", "spaghette"],
  //           "alergens" : ["lactoză", "gluten", "ou"],
  //           "weight" : "350g",
  //           "price": "33RON",
  //         },
  //         {
  //           "title": "Spaghetti Bolognese",
  //           "content": "Pizza Capricciosa, cu blat subțire și diametru de 40 cm",
  //           "ingredients": ["sos de roșii, carne de vită", "spaghetti", "morcovi"],
  //           "alergens" : ["gluten"],
  //           "price": "35RON",
  //         }
  //       ]
  //     }
  //   },
  //   SetOptions(merge: true)
  // );
}
