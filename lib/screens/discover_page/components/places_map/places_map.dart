import 'package:feastique/screens/discover_page/discover_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesMap extends StatelessWidget {
  const PlacesMap({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DiscoverPageProvider>();
    var markers = provider.markers;
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var mainCity = wrapperHomePageProvider.mainCity;
    return wrapperHomePageProvider.isLoading
    ? Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      child: Container(
        height: 5,
        width: MediaQuery.of(context).size.width,
        child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
      ),
    )
    : Builder(
      builder: (context) {
        if(provider.mapController != null)
          provider.mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(mainCity!['location'].latitude, mainCity['location'].longitude), zoom: 14)));
        return GoogleMap(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: mainCity != null ?
          CameraPosition(target: LatLng(mainCity['location'].latitude, mainCity['location'].longitude), zoom: 14)
          : CameraPosition(target: LatLng(0,0)),
          onMapCreated: (controller){
            provider.initializeMapController(controller);
          },
          markers: markers,
        );
      }
    );
  }
}