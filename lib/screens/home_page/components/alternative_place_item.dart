import 'package:feastique/models/models.dart';
import 'package:feastique/screens/home_page/home_provider.dart';
import 'package:feastique/screens/place_page/place_page.dart';
import 'package:feastique/screens/place_page/place_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class AlternativePlaceItem extends StatelessWidget {

  final Place place;

  AlternativePlaceItem(this.place);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        //width: MediaQuery.of(context).size.width*0.3,
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => PlacePageProvider(place, wrapperHomePageProvider),),
                ChangeNotifierProvider.value(value: wrapperHomePageProvider)
              ],
              child: PlacePage(context),
            ),
          )),
          child: Stack(
            children: [
              Container(
                color: Theme.of(context).highlightColor,
                //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                height: 100,
                child: Row(
                  children: [
                    FutureProvider<Image?>.value(
                      value: provider.getImage(place.id),
                      initialData: null,
                      builder: (context, child){
                        var image = Provider.of<Image?>(context);
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: image != null 
                          ? AspectRatio(
                            aspectRatio: 1.5,
                            child: image,
                          )
                          : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,))
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.name, style: Theme.of(context).textTheme.labelMedium),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Text.rich( /// The Date
                          //       TextSpan(
                          //         children: [
                          //           WidgetSpan(child: Image.asset(localAsset('calendar'), width: 18)),
                          //           WidgetSpan(child: SizedBox(width: 10)),
                          //           TextSpan(
                          //             text: formatDateToDay(reservation.dateStart)
                          //           ),
                          //         ]
                          //       )
                          //     ),
                          //     SizedBox(width: 20,),
                          //     Text.rich( /// The Time 
                          //       TextSpan(
                          //         children: [
                          //           WidgetSpan(child: Image.asset(localAsset('time'), width: 18)),
                          //           WidgetSpan(child: SizedBox(width: 10)),
                          //           TextSpan(
                          //             text: formatDateToHourAndMinutes(reservation.dateStart)
                          //           ),
                          //         ]
                          //       )
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Text.rich( /// The 'Accepted' or 'Refused' symbol
                          //       TextSpan(
                          //         children: reservation.accepted != null
                          //         ? ( reservation.accepted == true
                          //           ? [
                          //           WidgetSpan(child: Image.asset(localAsset('accepted'), width: 18, color: Colors.green)),
                          //           WidgetSpan(child: SizedBox(width: 10)),
                          //           TextSpan(
                          //             text: "Acceptată",
                          //             style: TextStyle(
                          //               color: Colors.green
                          //             )
                          //           ),
                          //         ]
                          //         : [
                          //           WidgetSpan(child: Image.asset(localAsset('refused'), width: 18, color: Colors.red)),
                          //           WidgetSpan(child: SizedBox(width: 10)),
                          //           TextSpan(
                          //             text: "Refuzată",
                          //             style: TextStyle(
                          //               color: Colors.red
                          //             )
                          //           ),
                          //         ])
                          //         : [
                          //           WidgetSpan(child: Image.asset(localAsset('refused'), width: 18)),
                          //           WidgetSpan(child: SizedBox(width: 10)),
                          //           TextSpan(
                          //             text: "În așteptare",
                          //           ),
                          //         ]
                          //       )
                          //     ),
                          //     SizedBox(width: 20,),
                          //     !reservation.canceled
                          //     ? Column( children: [
                          //       SizedBox(width: 10,),
                          //       Text.rich( /// The "claimed" property
                          //         TextSpan(
                          //           children: [
                          //             WidgetSpan(child: Image.asset(localAsset('claimed'), width: 18, color: reservation.claimed != null && reservation.claimed == true ? Colors.green : Colors.red,)),
                          //             WidgetSpan(child: SizedBox(width: 10)),
                          //             TextSpan(
                          //               text: (reservation.claimed != null && reservation.claimed == true) && reservation.accepted == true
                          //               ? "Revendicată"
                          //               : "Nerevendicată",
                          //               style: (reservation.claimed != null && reservation.claimed == true) && reservation.accepted == true
                          //               ? TextStyle(color: Colors.green)
                          //               : TextStyle(color: Colors.red)
                          //             ),
                          //           ]
                          //         )
                          //       ),
                          //     ])
                          //     : Container()
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}