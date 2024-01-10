import 'package:authentication/authentication.dart';
import 'package:feastique/screens/profile_page/components/cities_dialog.dart';
import 'package:feastique/screens/profile_page/components/user_data_page.dart';
import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ProfilePageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var mainCity = wrapperHomePageProvider.mainCity;
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 80,
            ),
            Container(
              child: Text("Salut!", style:  Theme.of(context).textTheme.headline3,)
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => mainCity != null
                    ? showDialog(context: context, builder: (context) => 
                      MultiProvider(
                        providers : [
                          ChangeNotifierProvider.value(
                            value: provider,
                          ),
                          ChangeNotifierProvider.value(
                            value: wrapperHomePageProvider
                          )
                        ],
                        child: CitiesDialog(),
                      )
                    )
                    : {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 150,
                      color: Colors.white,
                      child: 
                      mainCity != null
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Oraș", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),),
                          SizedBox(height: 10,),
                          Text(mainCity['name']),
                        ],
                      )
                      : Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor) ,)),
                    ),
                  ),
                ),
                  SizedBox(width: 50,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => wrapperHomePageProvider.pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn),
                    // onPressed: () => wrapperHomePageProvider.updateSelectedScreenIndex(2),
                    child: Container(
                      height: 100,
                      width: 150,
                      color: Colors.white,
                      child: Center(child: Text("Rezervări", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),)),
                  
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => wrapperHomePageProvider.pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn),
                    // onPressed: () => wrapperHomePageProvider.updateSelectedScreenIndex(1),
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 150,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Descoperă", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                !provider.user.isAnonymous 
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: provider),
                            ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                          ],
                          child: UserDataPage(),
                        ),
                      ), 
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 150,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Datele mele", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),),
                        ],
                      ),
                    ),
                  ),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Authentication.signOut(),
                    child: Container(
                      height: 100,
                      width: 150,
                      color: Colors.white,
                      child: Center(child: Text("Log In", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            !provider.user.isAnonymous 
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Authentication.signOut(),
                    child: Container(
                      height: 100,
                      width: 150,
                      color: Colors.white,
                      child: Center(child: Text("Ieși din cont", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),)),
                    ),
                  ),
                ),
                  SizedBox(width: 50,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 100,
                    width: 150,
                    color: Colors.transparent,
                   // child: Center(child: Text("Ieși din cont", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),)),

                  ),
                ),
              ],
            )
          : Container()
          ],
        ),
      )
    );
  }
}