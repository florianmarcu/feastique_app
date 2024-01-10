import 'package:feastique/config/config.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/order_page/order_provider.dart';
import 'package:flutter/material.dart';

class OrderItemPage extends StatelessWidget {

  final TableOrder order;

  OrderItemPage(this.order);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<OrderPageProvider>();
    print(order.accepted);
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).canvasColor,
          child: IconButton(
            splashRadius: 28,
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: (){
              Navigator.pop(context);
            }
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: FloatingActionButton(
          elevation: 0, 
          shape: ContinuousRectangleBorder(),
          backgroundColor: order.accepted == null && !order.canceled
          ? Theme.of(context).colorScheme.primary
          : Colors.grey,
          onPressed: order.accepted == null
          ? () async{
            await provider.cancelOrder(order)
            .then((value) => Navigator.pop(context));
          }
          : null,
          child: Opacity(
            opacity: order.accepted == null && !order.canceled ? 1 : 0.4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Anulează", 
                textAlign: TextAlign.center, 
                style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric( vertical: 12.0, horizontal: 20),
            child: Text("Comandă nouă la ${formatDateToHourAndMinutes(order.dateCreated)}", style: Theme.of(context).textTheme.headline6,),
          ),
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.items.length,
            separatorBuilder: (context, index) => SizedBox(height: 20),
            itemBuilder: (context, index){
              var count = order.items[index]['count'];
              var item = order.items[index]['item'];
              return ListTile(
                leading: Text("$count x"),
                title: Text(item['title'], style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18),),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich( /// The Date
                  TextSpan(
                    children: [
                      WidgetSpan(child: Image.asset(localAsset('important'), width: 16)),
                      WidgetSpan(child: SizedBox(width: 10)),
                      TextSpan(
                        text: "Informații importante",
                        style: Theme.of(context).textTheme.headline6
                      ),
                    ]
                  )
                ),
                SizedBox(
                  height: 10
                ),
                Text(order.details != ""
                   ? "order.details"
                   : "-"
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}