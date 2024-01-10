import 'package:feastique/screens/authentication_page/bloc/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInForm extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    var cubit = context.watch<AuthenticationCubit>();
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Email field
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
            ),
            onChanged: (email) => cubit.setEmail(email),
          ),
          SizedBox(height: 20),
          /// Password field
          TextFormField(
            obscureText: !cubit.state.passwordVisible,
            decoration: InputDecoration(
              labelText: "Parolă", 
              suffixIcon: IconButton(
                highlightColor: Colors.grey[200],
                splashColor: Colors.grey[400],
                icon: Icon(Icons.visibility, color: Theme.of(context).highlightColor,), 
                onPressed: () => cubit.setPasswordVisibility(), 
                padding: EdgeInsets.zero, 
              ),
            ),
            onChanged: (password) => cubit.setPassword(password),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => cubit.logIn(context, "email_and_password"),
                child: Text("Log in"),
              ),
              TextButton(
                onPressed: () => cubit.logIn(context, "anonimously"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sari peste"),
                    SizedBox(width: 20,),
                    Icon(Icons.arrow_forward_ios, size: 15)
                  ],
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}