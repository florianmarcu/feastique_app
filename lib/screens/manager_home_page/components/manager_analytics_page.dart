import 'package:feastique/screens/manager_home_page/manager_home_provider.dart';
import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:flutter/material.dart';

class ManagerAnalyticsPage extends StatelessWidget {
  const ManagerAnalyticsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ManagerHomePageProvider>();
    var place = provider.place;
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
        title: Text("Analitice", style: Theme.of(context).textTheme.headline3,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     provider.isLoading
      //     ? Positioned(
      //       child: Container(
      //         height: 5,
      //         width: MediaQuery.of(context).size.width,
      //         child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
      //       ), 
      //       bottom: MediaQuery.of(context).padding.bottom,
      //     )
      //     : Container(),
      //     // FloatingActionButton.extended(
      //     //   elevation: 0, 
      //     //   shape: ContinuousRectangleBorder(),
      //     //   backgroundColor: Theme.of(context).primaryColor,
      //     //   onPressed: () {
      //     //     provider.updateData(context, wrapperHomePageProvider);
      //     //   },
      //     //   label: Container(
      //     //     width: MediaQuery.of(context).size.width,
      //     //     child: Text("Modifică", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20),),
      //     //   ),
      //     // ),
      //   ],
      // ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Venit ultima lună (RON)",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).highlightColor
                  ),
                  child: Text(provider.spentLastMonth.toString()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Venit dintotdeauna (RON)",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).highlightColor
                  ),
                  child: Text(provider.spentAllTime.toString()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Clienți așezați la masă în ultima lună",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).highlightColor
                  ),
                  child: Text(provider.seatedLastMonth.toString()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Clienți așezați la masă dintotdeauna",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).highlightColor
                  ),
                  child: Text(provider.seatedPeopleNoAllTime.toString()),
                ),
              ],
            ),
            provider.isLoading
            ? Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 5,
                width: MediaQuery.of(context).size.width,
                child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
              ),
            )
            : Container(),
          ],
        ),
      ),
    );
  }
}