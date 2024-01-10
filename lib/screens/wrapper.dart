// import 'package:authentication/authentication.dart';
// import 'package:feastique/models/models.dart';
// import 'package:feastique/screens/authentication_page/ui/authentication_page.dart';
// import 'package:feastique/screens/authentication_page/bloc/authentication_provider.dart';
// import 'package:feastique/screens/app/bloc/wrapper_provider.dart';
// import 'package:feastique/screens/wrapper_home_page/wrapper_home_provider.dart';
// import 'package:flutter/material.dart';

// import 'wrapper_home_page/ui/wrapper_home_page.dart';

// /// Class that handles the UI according to the authentication state:
// ///   - logged in
// ///   - logged out
// class Wrapper extends StatelessWidget {
//   const Wrapper({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var provider = context.watch<WrapperProvider>();
//     var user = Provider.of<User?>(context);
//     print(Authentication.currentUser);
//     if(provider.isLoading)
//       return Container(
//         color: Theme.of(context).canvasColor,
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Center(
//           // alignment: Alignment.bottomCenter,
//           // height: 5,
//           // width: MediaQuery.of(context).size.width,
//           child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
//         ), 
//       );
//     // Logged out
//     else if(user == null)
//       return ChangeNotifierProvider(
//         create: (context) => AuthenticationPageProvider(),
//         child: AuthenticationPage()
//       );
//     // Logged in
//     else return ChangeNotifierProvider(
//         create: (context) => WrapperHomePageProvider(context),
//         //lazy: false,
//         child: WrapperHomePage()
//       );
//   }
// }