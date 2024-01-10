import 'package:feastique/screens/order_page/order_provider.dart';
import 'package:flutter/material.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<OrderPageProvider>();
    var items = provider.items;
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0, 
        shape: ContinuousRectangleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          provider.sendOrder();
          // showModalBottomSheet(
          //   context: context, 
          //   // elevation: 0,
          //   isScrollControlled: true,
          //   backgroundColor: Theme.of(context).primaryColor,
          //   barrierColor: Colors.black.withOpacity(0.35),
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          //   builder: (context) => ChangeNotifierProvider<NewReservationPopupProvider>(
          //     create:(context) => NewReservationPopupProvider(place),
          //     child: Container(
          //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          //       child: Column( 
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           ClipRRect(
          //             borderRadius: BorderRadius.circular(30),
          //             child: Container(height: 4, width: 40, margin: EdgeInsets.symmetric(vertical: 4), decoration: BoxDecoration(color: Theme.of(context).canvasColor,borderRadius: BorderRadius.circular(30),)),
          //           ),
          //           ClipRRect(
          //             borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          //             child: Container(
          //               color: Theme.of(context).canvasColor,
          //               child: NewReservationPopupPage(context)
          //             )
          //           ),
          //         ],
          //       ),
          //     )
          //   )
          // );
        },
        label: Container(
          height: 25,
          width: MediaQuery.of(context).size.width,
          child: Text("Trimite comandă", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20),),
        ),
      ),
      
      body: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            provider.image != null 
            ? provider.image!
            : Container(
              width: 400,
              height: 200,
              color: Colors.transparent,
            ),
            // FutureProvider<Image?>.value(
            //   value: provider.getImage(provider.reservation.placeId),
            //   initialData: null,
            //   builder: (context, child){
            //     var image = Provider.of<Image?>(context);
            //     return image == null
            //     ? Container()
            //     : image;
            //   },
            // ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Martina Ristorante Pizzeria", style: Theme.of(context).textTheme.headline6,),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => provider.pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn),
              child: Text("Comenzi trecute")
            ),
            SizedBox(height: 30),
            ListView.builder(
              padding: EdgeInsets.only(left: 20,right: 20),
              shrinkWrap: true,
              itemCount: items == null ? 1 : items.length,
              itemBuilder: (context, index) {
                if(items == null)
                  return Container(
                    padding: EdgeInsets.only(top: 95),
                    height: 100,
                    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                  );
                else{
                  var item = items[index]['item'];
                  var count = items[index]['count'];
                  return ListTile(
                    title: Text(item.title, style: Theme.of(context).textTheme.labelMedium,),
                    subtitle: Text(item.ingredients[0],  style: Theme.of(context).textTheme.overline),
                    selectedTileColor: Theme.of(context).primaryColor,
                    trailing: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Text("-"), onPressed: () => provider.decrementItemCount(index), color: Colors.black,),
                          Text(count.toString()),
                          IconButton(icon: Text("+",), onPressed: () => provider.incrementItemCount(index), color: Colors.black,)
                        ],
                      ),
                    )
                  ) ;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}