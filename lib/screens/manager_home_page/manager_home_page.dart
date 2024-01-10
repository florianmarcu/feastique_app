import 'package:feastique/screens/manager_home_page/manager_home_provider.dart';
import 'package:feastique/screens/manager_orders_page/manager_orders_provider.dart';
import 'package:feastique/screens/manager_reservations_page/manager_reservations_provider.dart';
import 'package:flutter/material.dart';

class ManagerHomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ManagerHomePageProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //toolbarHeight: 70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Center(child: Text(provider.screenLabels![provider.selectedScreenIndex].label!, style: Theme.of(context).textTheme.headline4,)),
        // bottom: PreferredSize(
        //   preferredSize: Size(MediaQuery.of(context).size.width, 80),
        //   child: Row(children: [
            
        //   ],)
        // ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: provider.selectedScreenIndex,
        items: provider.screenLabels!,
        onTap: (index) => 
        // provider.updateSelectedScreenIndex(index),
        provider.pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn)
      ),
      // body: Center(
      //   child: IndexedStack(
      //     children: _screens,
      //     index: provider.selectedScreenIndex
      //   )
      // ),
      body: SizedBox.expand(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: provider.screens!,
          controller: provider.pageController,
          onPageChanged: (index) => provider.updateSelectedScreenIndex(index),
        ),
      ),
    );
  }
}