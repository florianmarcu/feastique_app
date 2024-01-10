import 'package:feastique/config/config.dart';
import 'package:feastique/screens/reservation_page/components/cancel_reservation_popup_page.dart';
import 'package:feastique/screens/reservation_page/components/place_directions_page.dart';
import 'package:feastique/screens/reservation_page/reservation_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'components/place_offers.dart';

class ReservationPage extends StatelessWidget {

  final _scrollController = ScrollController(
    keepScrollOffset: true,
    initialScrollOffset: 0
  );
  final bool manager;
  ReservationPage([this.manager = false]);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ReservationPageProvider>();
    var wrapperHomePageProvider; 
    if(!manager)
      wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var reservation = provider.reservation;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        //toolbarHeight: 70,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
        // title: Center(child: Text("Rezervare confirmată", style: Theme.of(context).textTheme.headline4,)),
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
      floatingActionButton: reservation.canceled || (reservation.claimed != null && reservation.claimed!) || (reservation.accepted != null && !reservation.accepted!)
      ? Container()
      : FloatingActionButton.extended(
        elevation: 0, 
        shape: ContinuousRectangleBorder(),
        backgroundColor: reservation.canceled
        ? Colors.grey
        : Theme.of(context).primaryColor,
        onPressed: 
        reservation.canceled
        ? null
        :(){
          showModalBottomSheet(
            context: context, 
            // elevation: 0,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).primaryColor,
            barrierColor: Colors.black.withOpacity(0.35),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            builder: (context) => ChangeNotifierProvider<ReservationPageProvider>.value(
              value: provider,
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column( 
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(height: 4, width: 40, margin: EdgeInsets.symmetric(vertical: 4), decoration: BoxDecoration(color: Theme.of(context).canvasColor,borderRadius: BorderRadius.circular(30),)),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      child: Container(
                        color: Theme.of(context).canvasColor,
                        child: CancelReservationPopupPage()
                      )
                    ),
                  ],
                ),
              )
            )
          );
        },
        label: Opacity(
          opacity: reservation.canceled
            ? 0.7
            : 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              reservation.canceled
              ? "Anulată"
              :"Anulează rezervarea", 
              textAlign: TextAlign.center, 
              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Stack( /// The place's image
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(150,30), bottomRight: Radius.elliptical(200,50)),
                      child: Container(
                        height: 220 + MediaQuery.of(context).padding.top,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(150,30), bottomRight: Radius.elliptical(200,50)),
                      child: Stack(
                        children: [
                          Container(
                            height: 200 + MediaQuery.of(context).padding.top,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: FutureBuilder<Image>(
                                future: provider.image,
                                builder: (context, image){  
                                  if(!image.hasData)
                                    return Container(
                                      width: 400,
                                      height: 200,
                                      color: Colors.transparent,
                                    );
                                  else 
                                    return image.data!;
                                }
                              ),
                            ),
                          ),
                          reservation.canceled
                          ? Container(
                            height:  200 + MediaQuery.of(context).padding.top,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            child: Center(
                              child: Text("Anulată", style: Theme.of(context).textTheme.headline4),
                            ),
                          )
                          : Container(),
                          reservation.active == true
                            ? Container(
                              height:  200 + MediaQuery.of(context).padding.top,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black54,
                              child: Center(
                                child: Text("Rezervare activă", style: Theme.of(context).textTheme.headline4),
                              ),
                            )
                            : Container()
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Rezervare la",
                    style: Theme.of(context).textTheme.headline6
                  ),
                ),
                Padding( /// The place's name
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "${reservation.placeName}",
                    style: Theme.of(context).textTheme.headline3
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(/// TIME, DATE 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich( /// The Date
                            TextSpan(
                              children: [
                                WidgetSpan(child: Image.asset(localAsset('calendar'), width: 17)),
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: formatDateToDay(reservation.dateStart),
                                  style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15)
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 20),
                          Text.rich( /// The Time 
                            TextSpan(
                              children: [
                                WidgetSpan(child: Image.asset(localAsset('time'), width: 17)),
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: formatDateToHourAndMinutes(reservation.dateStart),
                                  style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15)
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 20),
                          Text.rich( /// The Name
                            TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.person, size: 20)),
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: reservation.guestName.length < 20 ?  reservation.guestName : reservation.guestName.substring(0,20),
                                  style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15)
                                ),
                              ]
                            )
                          ),
                        ],
                      ),                    
                      Column(///PEOPLE_NNUMBER
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich( /// The People No
                            TextSpan(
                              children: [
                                WidgetSpan(child: Image.asset(localAsset('user'), width: 16)),
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: reservation.peopleNo.toString(),
                                  style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15)
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 20,),
                          Text.rich( /// The Discount 
                            TextSpan(
                              children: [
                                WidgetSpan(child: Image.asset(localAsset('time'), width: 16)),
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: reservation.discount != null && reservation.discount != 0
                                    ? reservation.discount.toString() 
                                    : "fără reducere",
                                  style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15)
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 20,),
                          Text.rich( /// The phone number 
                            TextSpan(
                              children: [
                                WidgetSpan(child: Image.asset(localAsset('phone'), width: 16)),
                                WidgetSpan(child: SizedBox(width: 10)),
                                TextSpan(
                                  text: reservation.contactPhoneNumber,
                                  style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 15)
                                ),
                              ]
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      Text("Discount-urile se aplică doar la meniul de mâncare, fără băuturi")
                    ],
                  ),
                ),
                !manager
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      style: Theme.of(context).textButtonTheme.style!.copyWith(
                        //backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20))
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: provider,),
                            !manager
                            ? ChangeNotifierProvider<WrapperHomePageProvider>.value(value: wrapperHomePageProvider,)
                            : ChangeNotifierProvider.value(value: null)
                          ],
                          child: PlaceDirectionsPage()
                        ))
                      ),
                      icon: Image.asset(localAsset("map"), width: 20,),
                      label: Text("Cum ajung?", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 13),),
                    ),
                    SizedBox(width: 30,),
                    SizedBox(
                      width: 80,
                      child: TextButton(
                        style: Theme.of(context).textButtonTheme.style!.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)
                        ),
                        onPressed: () => provider.launchUber(context, wrapperHomePageProvider.currentLocation),
                        //icon: Image.asset(asset("map"), width: 20,),
                        child: Text("Uber", style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 13),),
                      ),
                    ),
                  ],
                )
                : Container(),
                SizedBox(height: 30,),
                provider.place != null
                ? PlaceOffers(provider.place!)
                : Container(),
                Container(height: MediaQuery.of(context).size.height*0.1,)
                // reservation.claimed == true
                // ? Center(
                //   child: TextButton(
                //     style: Theme.of(context).textButtonTheme.style!.copyWith(
                //       //backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                //       padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20))
                //     ),
                //     onPressed: () => Navigator.push(context, MaterialPageRoute(
                //       builder: (context) => MultiProvider(
                //         providers: [
                //           ChangeNotifierProvider.value(value: provider,),
                //           // !manager
                //           // ? ChangeNotifierProvider<WrapperHomePageProvider>.value(value: wrapperHomePageProvider,)
                //           // : ChangeNotifierProvider.value(value: null)
                //         ],
                //         child: PastOrdersPage()
                //       ))
                //     ),
                //     child: Text("Comenzi", style: Theme.of(context).textTheme.overline!.copyWith(fontSize: 13),),
                //   ),
                // )
                // : Container(),
              
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: Text(
                //     reservation.accepted == null
                //     ? "Rezervare în așteptare"
                //     : (reservation.accepted == true 
                //       ? "Rezervare acceptată"
                //       : "Rezervare refuzată"
                //     ),
                //     style: Theme.of(context).textTheme.headline3
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: Text(
                //     reservation.accepted == null
                //     ? "Rezervarea va fi în scurt timp confirmată"
                //     : (reservation.accepted == true 
                //       ? "Rezervare acceptată"
                //       : "Rezervare refuzată"
                //     ),
                //     style: Theme.of(context).textTheme.headline6
                //   ),
                // ),
              ]),
            ),
          ],
        ),
      )
    );
  }
}