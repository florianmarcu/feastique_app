import 'package:feastique/screens/order_page/order_page.dart';
import 'package:feastique/screens/order_page/order_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_cubit.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:feastique/widgets/app_drawer/app_drawer.dart';
import 'package:flutter/material.dart';


/// This Page is a Wrapper Page
/// It doesn't have a body of its own, but instead it wraps multiple different pages in a Navigation Bar manner
/// - Home Page
/// - Discover Page
/// - Reservations Page
/// - Profile Page
class WrapperHomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var cubit = context.watch<WrapperHomeCubit>();
    var selectedScreenIndex = cubit.state.selectedScreenIndex; 

    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        // key: ,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedScreenIndex,
        items: cubit.state.screenLabels,
        // onTap: (index) => provider.updateSelectedScreenIndex(index),
        onTap: (index) =>
        //  provider.updateSelectedScreenIndex(index)
        cubit.state.pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn),

      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //toolbarHeight: 70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Center(child: Text(cubit.state.screenLabels[selectedScreenIndex].label!, style: Theme.of(context).textTheme.headline4,)),
      ),
      drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: cubit.state.activeReservation != null
      ? Align(
        alignment: Alignment(0,0.8),
        child: Container(
          height: 60,
          width: 250,
          child: FloatingActionButton.extended(
            label: Column(
              children: [
                Text(cubit.state.activeReservation!.placeName, style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0, fontSize: 13, color: Colors.black),),
                SizedBox(height: 10,),
                Text("Comandă", style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0),),
              ],
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => OrderPageProvider(cubit.state.activeReservation!),
                child: OrderPage()
              )
            )),
          ),
        ),
      )
      : Container(), /// Added for orders
      // body: Center(
      //   child: IndexedStack(
      //     children: provider.screens,
      //     index: selectedScreenIndex
      //   )
      // ),
      // body: provider.screens[selectedScreenIndex],
      body: SizedBox.expand(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: cubit.state.pageController,
          onPageChanged: (index) => cubit.updateSelectedScreenIndex(index),
          children: cubit.state.screens
        ),
      ),
    );
  }
}
