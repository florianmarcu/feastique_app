import 'package:feastique/config/config.dart';
import 'package:feastique/screens/place_page/place_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMapPage extends StatelessWidget {

  PlaceMapPage();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<PlacePageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var placeLocation = provider.place.location;
    var userLocation = wrapperHomePageProvider.currentLocation;
    // print(provider.distanceBetween(userLocation!, placeLocation));
    if(provider.distance == null && provider.time == null)
      provider.getTimeAndDistance(userLocation, placeLocation);
    if(userLocation != null && provider.polyline == null)
      provider.getPolylines(context, LatLng(userLocation.latitude!, userLocation.longitude!),  LatLng(placeLocation.latitude, placeLocation.longitude));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 30
        ),
        elevation: 0,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Align(
        alignment: Alignment(0,0.8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  boxShadow: [
                    BoxShadow(offset: Offset(0,1), color: Colors.black54)
                  ]
                ),
                //height: 100,
                width: 230,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(provider.place.name, style: Theme.of(context).textTheme.labelMedium,),
                    // Container(
                    //   height: 100,
                    //   width: 220,
                    //   child: Text.rich(
                    //       TextSpan(
                    //         children: [
                    //           TextSpan(text: "Deschide în",style: Theme.of(context).textTheme.subtitle1!.copyWith(letterSpacing: 0, fontWeight: FontWeight.bold),),
                    //           WidgetSpan(child: SizedBox(width: 10,)),
                    //           WidgetSpan(child: Image.asset(localAsset('google-maps'), width: 18, ))
                    //         ]
                    //       )

                    //     ),
                    // ),
                    SizedBox(height: 10,),
                    provider.distance != null && provider.time != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(localAsset("distance"), width: 18,),
                              SizedBox(width: 20),
                              Text(provider.distance!)
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Image.asset(localAsset("time"), width: 16,),
                              SizedBox(width: 20),
                              Text(provider.time!)
                            ],
                          ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     MaterialButton(
                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          //       color: Theme.of(context).highlightColor,
                          //       padding: EdgeInsets.zero,
                          //       child: Text("w"),
                          //       onPressed: (){}
                          //     ),
                          //     MaterialButton(
                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          //       color: Theme.of(context).highlightColor,
                          //       padding: EdgeInsets.zero,
                          //       child: Text("w"),
                          //       onPressed: (){}
                          //     ),
                          //     MaterialButton(
                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          //       padding: EdgeInsets.zero,
                          //       color: Theme.of(context).highlightColor,
                          //       child: Text("w"),
                          //       onPressed: (){}
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    )
                    : Container(),
                    //SizedBox(height: 20),
                    userLocation == null
                    ? Container(
                      height: 40,
                      width: 220,
                      child: FloatingActionButton.extended(
                        label: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Traseu",style: Theme.of(context).textTheme.subtitle1!.copyWith(letterSpacing: 0, fontWeight: FontWeight.bold),),
                              // WidgetSpan(child: SizedBox(width: 10,)),
                              // WidgetSpan(child: Image.asset(localAsset('google-maps'), width: 18, ))
                            ]
                          )

                        ),
                        onPressed: () => wrapperHomePageProvider.getLocation()
                      ),
                    )
                    : Container(),
                    // SizedBox(width: 10,),
                    // Container(
                    //   height: 40,
                    //   width: 150,
                    //   child: FloatingActionButton.extended(
                    //     label: Column(
                    //       children: [
                    //         Text("Comandă", style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),),
                    //       ],
                    //     ),
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          /// We have the user's location
          userLocation != null
          ? GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                (userLocation.latitude! + placeLocation.latitude) / 2, (userLocation.longitude! + placeLocation.longitude) / 2
              ),
              zoom: 13
            ),
            myLocationEnabled: true,
            markers: provider.pin != null
            ? {
              Marker(
                icon: provider.pin!,
                markerId: MarkerId('place'),
                position: LatLng(placeLocation.latitude,placeLocation.longitude)
              ),
              Marker(
                icon: provider.pin!,
                markerId: MarkerId('user'),
                position: LatLng(userLocation.latitude!, userLocation.longitude!)
              ),
            }
            : {},
            polylines: provider.polyline != null
            ? {
              provider.polyline!
            }
            : {},
          )
          /// We don't have the user's location
          : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(placeLocation.latitude, placeLocation.longitude),
              zoom: 15
            ),
            myLocationEnabled: true,
            markers: provider.pin != null
            ? {
              Marker(
                icon: provider.pin!,
                markerId: MarkerId('0'),
                position: LatLng(placeLocation.latitude ,placeLocation.longitude)
              ),
            }
            : {},
          ),
          provider.pin == null && provider.polyline == null
          ? Positioned(
            child: Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
            ),
            bottom: MediaQuery.of(context).padding.bottom,
          )
          : Container(),
        ],
      ),
    );
  }
}