import 'package:feastique/config/config.dart';
import 'package:feastique/screens/manager_reservations_page/manager_reservations_provider.dart';
import 'package:feastique/screens/reservation_page/reservation_page.dart';
import 'package:feastique/screens/reservation_page/reservation_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class ManagerReservationsPage extends StatefulWidget {
  @override
  State<ManagerReservationsPage> createState() => _ManagerReservationsPageState();
}

class _ManagerReservationsPageState extends State<ManagerReservationsPage> {

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ManagerReservationsPageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var pendingReservations = provider.pendingReservations;
    var pastReservations = provider.pastReservations;
    var activeReservations = provider.activeReservations;
    print(pendingReservations);
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 25, right: 25),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rezervări în așteptare",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: pendingReservations == null ? 1 : pendingReservations.length,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                if(pendingReservations == null)
                  return Container(
                    padding: EdgeInsets.only(top: 95),
                    height: 100,
                    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                  );
                else {
                  var reservation = pendingReservations[index];
                  var image = provider.getImage(reservation.placeId);
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      //color: Colors.green,
                      child: Image.asset(localAsset("accepted"), width: 30, color: Colors.green),

                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      //color: Colors.green,
                      child: Image.asset(localAsset("refused"), width: 30, color: Colors.red),

                    ),
                    onDismissed: (direction) => direction == DismissDirection.startToEnd
                    ? provider.acceptReservation(reservation)
                    : provider.declineReservation(reservation),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          ChangeNotifierProvider(
                            create: (context) => ReservationPageProvider(reservation, image, wrapperHomePageProvider),
                            child: ReservationPage(true),
                          )
                        )),
                        child: Container(
                          color: Theme.of(context).highlightColor,
                          //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          height: 100,
                          child: Row(
                            children: [
                              FutureProvider<Image?>.value(
                                value: image,
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
                                    : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reservation.placeName, style: Theme.of(context).textTheme.labelMedium),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text.rich( /// The Date
                                          TextSpan(
                                            children: [
                                              WidgetSpan(child: Image.asset(localAsset('calendar'), width: 18)),
                                              WidgetSpan(child: SizedBox(width: 10)),
                                              TextSpan(
                                                text: formatDateToDay(reservation.dateStart)
                                              ),
                                            ]
                                          )
                                        ),
                                        SizedBox(width: 10,),
                                        Text.rich( /// The Time 
                                          TextSpan(
                                            children: [
                                              WidgetSpan(child: Image.asset(localAsset('time'), width: 18)),
                                              WidgetSpan(child: SizedBox(width: 10)),
                                              TextSpan(
                                                text: formatDateToHourAndMinutes(reservation.dateStart)
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  );
                  }
                }
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rezervări procesate",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: pastReservations == null ? 1 : pastReservations.length,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                if(pastReservations == null)
                  return Container(
                    padding: EdgeInsets.only(top: 95),
                    height: 5,
                    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                  );
                else {
                  var reservation = pastReservations[index];
                  var image = provider.getImage(reservation.placeId);
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      //color: Colors.green,
                      child: Image.asset(localAsset("activate"), width: 30, color: Colors.green),

                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      //color: Colors.green,
                      child: Image.asset(localAsset("activate"), width: 30, color: Colors.green),

                    ),
                    direction: !(reservation.claimed != null && reservation.claimed == true)
                    ? DismissDirection.horizontal
                    : DismissDirection.none,
                    onDismissed: (direction) => provider.activateReservation(reservation),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          ChangeNotifierProvider(
                            create: (context) => ReservationPageProvider(reservation, image, wrapperHomePageProvider),
                            child: ReservationPage(true),
                          )
                        )).whenComplete(() => provider.getData()),
                        child: Stack(
                          children: [
                            Container(
                              color: Theme.of(context).highlightColor,
                              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              height: 100,
                              child: Row(
                                children: [
                                  FutureProvider<Image?>.value(
                                    value: image,
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
                                        : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(reservation.placeName, style: Theme.of(context).textTheme.labelMedium),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text.rich( /// The Date
                                              TextSpan(
                                                children: [
                                                  WidgetSpan(child: Image.asset(localAsset('calendar'), width: 18)),
                                                  WidgetSpan(child: SizedBox(width: 10)),
                                                  TextSpan(
                                                    text: formatDateToDay(reservation.dateStart)
                                                  ),
                                                ]
                                              )
                                            ),
                                            SizedBox(width: 10,),
                                            Text.rich( /// The Time 
                                              TextSpan(
                                                children: [
                                                  WidgetSpan(child: Image.asset(localAsset('time'), width: 18)),
                                                  WidgetSpan(child: SizedBox(width: 10)),
                                                  TextSpan(
                                                    text: formatDateToHourAndMinutes(reservation.dateStart)
                                                  ),
                                                ]
                                              )
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text.rich( /// The 'Accepted' or 'Refused' symbol
                                              TextSpan(
                                                children: reservation.accepted!
                                                ? [
                                                  WidgetSpan(child: Image.asset(localAsset('accepted'), width: 18, color: Colors.green)),
                                                  WidgetSpan(child: SizedBox(width: 10)),
                                                  TextSpan(
                                                    text: "Acceptată",
                                                    style: TextStyle(
                                                      color: Colors.green
                                                    )
                                                  ),
                                                ]
                                                : [
                                                  WidgetSpan(child: Image.asset(localAsset('refused'), width: 18, color: Colors.red)),
                                                  WidgetSpan(child: SizedBox(width: 10)),
                                                  TextSpan(
                                                    text: "Refuzată",
                                                    style: TextStyle(
                                                      color: Colors.red
                                                    )
                                                  ),
                                                ]
                                              )
                                            ),
                                            SizedBox(width: 20,),
                                            reservation.claimed != null && reservation.claimed == true
                                            ? Column( children: [
                                              SizedBox(width: 10,),
                                              Text.rich( /// The "claimed" property
                                                TextSpan(
                                                  children: [
                                                    WidgetSpan(child: Image.asset(localAsset('claimed'), width: 18)),
                                                    WidgetSpan(child: SizedBox(width: 10)),
                                                    TextSpan(
                                                      text: "Revendicată"
                                                    ),
                                                  ]
                                                )
                                              ),
                                            ])
                                            : Container()
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                            (reservation.active != null && reservation.active!)
                            ? Container(
                              height: 100,
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
                    ),
                  );
                }
              }
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rezervări active",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: activeReservations == null ? 1 : activeReservations.length,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                if(activeReservations == null)
                  return Container(
                    padding: EdgeInsets.only(top: 95),
                    height: 100,
                    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                  );
                else {
                  var reservation = activeReservations[index];
                  var image = provider.getImage(reservation.placeId);
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      //color: Colors.green,
                      child: Image.asset(localAsset("deactivate"), width: 30, color: Colors.red),

                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      //color: Colors.green,
                      child: Image.asset(localAsset("deactivate"), width: 30, color: Colors.red),

                    ),
                    onDismissed: (direction) => provider.deactivateReservation(reservation),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          ChangeNotifierProvider(
                            create: (context) => ReservationPageProvider(reservation, image, wrapperHomePageProvider),
                            child: ReservationPage(true),
                          )
                        )),
                        child: Container(
                          color: Theme.of(context).highlightColor,
                          //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          height: 100,
                          child: Row(
                            children: [
                              FutureProvider<Image?>.value(
                                value: image,
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
                                    : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reservation.placeName, style: Theme.of(context).textTheme.labelMedium),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text.rich( /// The Date
                                          TextSpan(
                                            children: [
                                              WidgetSpan(child: Image.asset(localAsset('calendar'), width: 18)),
                                              WidgetSpan(child: SizedBox(width: 10)),
                                              TextSpan(
                                                text: formatDateToDay(reservation.dateStart)
                                              ),
                                            ]
                                          )
                                        ),
                                        SizedBox(width: 10,),
                                        Text.rich( /// The Time 
                                          TextSpan(
                                            children: [
                                              WidgetSpan(child: Image.asset(localAsset('time'), width: 18)),
                                              WidgetSpan(child: SizedBox(width: 10)),
                                              TextSpan(
                                                text: formatDateToHourAndMinutes(reservation.dateStart)
                                              ),
                                            ]
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  );
                }
              }
            ),
            SizedBox(height: 20,)
          ],
        ),
      )
    );
  }
}