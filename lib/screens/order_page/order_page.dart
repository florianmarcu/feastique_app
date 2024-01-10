import 'package:feastique/screens/order_page/components/new_order_page.dart';
import 'package:feastique/screens/order_page/components/past_orders_page.dart';
import 'package:feastique/screens/order_page/order_provider.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<OrderPageProvider>();
    var pastOrders = provider.pastOrders;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //toolbarHeight: 70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        title: Center(child: Text("Comandă", style: Theme.of(context).textTheme.headline4,)),
        // bottom: PreferredSize(
        //   preferredSize: Size(MediaQuery.of(context).size.width, 80),
        //   child: Row(children: [
            
        //   ],)
        // ),
        
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox.expand(
              child: PageView(
                controller: provider.pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  NewOrderPage(),
                  PastOrdersList()
                ],
              ),
            ),
            provider.isLoading
            ? Positioned(
              child: Container(
                height: 5,
                width: MediaQuery.of(context).size.width,
                child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
              ), 
              bottom: 48,
            )
            : Container()
          ],
        ),
      ),
    );
  }
}