import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class UserDataPage extends StatelessWidget {
  const UserDataPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ProfilePageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var user = wrapperHomePageProvider.currentUser!;
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        //toolbarHeight: 70,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        // title: Center(child: Text("Rezervare confirmată", style: Theme.of(context).textTheme.headline4,)),
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).highlightColor,
          child: IconButton(
            splashRadius: 28,
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: (){
              Navigator.pop(context);
            }
          ),
        ),
        centerTitle: true,
        title: Text("Datele mele", style: Theme.of(context).textTheme.headline3,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          provider.isLoading
          ? Positioned(
            child: Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
            ), 
            bottom: MediaQuery.of(context).padding.bottom,
          )
          : Container(),
          FloatingActionButton.extended(
            elevation: 0, 
            shape: ContinuousRectangleBorder(),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              provider.updateData(context, wrapperHomePageProvider);
            },
            label: Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Modifică", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20),),
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: ListView(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  wrapperHomePageProvider.currentUser!.photoURL == null ? 
                  "https://firebasestorage.googleapis.com/v0/b/feastique.appspot.com/o/config%2Fassets%2Fimages%2Fempty-profile.png?alt=media&token=8d70104f-84ee-4e4b-bf78-77630fad0477"
                  : wrapperHomePageProvider.currentUser!.photoURL!,
                  loadingBuilder: (context, child, progress){
                    if(progress == null)
                      return child;
                    return Center(
                      child: Container(
                        height: 40,
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stacktrace){
                    return Icon(Icons.person, size: 40, color: Theme.of(context).highlightColor,);
                  },
                  width: 50,
                ),
              )
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Nume",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: provider.displayName,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: user.displayName == null ? "" : user.displayName,
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (name) => provider.changeDisplayName(name),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Email",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: user.email!,
                labelStyle: TextStyle(color: Colors.black)
              ),
              //onChanged: (email) => provider.setEmail(email),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Număr de telefon",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              initialValue: provider.phoneNumber,
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: user.phoneNumber!,
                labelStyle: TextStyle(color: Colors.black)
              ),
              onChanged: (number) => provider.changePhoneNumber(number),
            ),
          ],
        ),
      ),
    );
  }
}