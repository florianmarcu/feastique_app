import 'package:feastique/core/common_ui/loading_screen.dart';
import 'package:feastique/screens/app/bloc/app_cubit.dart';
import 'package:feastique/screens/authentication_page/bloc/authentication_cubit.dart';
import 'package:feastique/screens/authentication_page/ui/authentication_page.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_cubit.dart';
import 'package:feastique/screens/wrapper_home_page/ui/wrapper_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state){
        // loading
        if(state is LoadingAppState){
          return LoadingScreen();
        }
        /// authenticated
        if(state is AuthenticatedAppState){
          return BlocProvider(
          create: (context) => WrapperHomeCubit(context),
          child: WrapperHomePage()
        );
        }
        /// unauthenticated
        return BlocProvider(
          create: (context) => AuthenticationCubit(),
          child: AuthenticationPage()
        );
      },
    );
  }
}