import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/config/config.dart';
import 'package:feastique/models/models.dart';
import 'package:feastique/screens/place_page/place_page.dart';
import 'package:feastique/screens/place_page/place_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
export 'package:provider/provider.dart';

class DiscoverPageProvider with ChangeNotifier{
  /// The current city
  Map<String,dynamic> city;
  /// The 'places' to be displayed on the Map
  /// They will change according to the filters applied by the users
  List<Place> places = [];
  /// The list of  all 'places', to be filtered everytime we apply filters
  List<Place> allPlaces = [];
  Set<Marker> markers = {};
  List<Place> placesList = [];
  String viewType = 'map';
  Map<String, dynamic> activeFilters = {};
  bool isLoading = false;
  WrapperHomePageProvider wrapperHomePageProvider;

  BuildContext context;
  GoogleMapController? mapController;


  DiscoverPageProvider(this.context, this.city, this.wrapperHomePageProvider){
    /// Initialize the 'places' list with all the available places from Firestore
    /// Also initialize the 'city' with the main city provided by the database
    getData(context);
  }
  
  /// Method that fetches all the places and information about them from the database
  Future<void> getData(BuildContext context) async{
    _loading();
    /// Instantiate active filters with no 'false' for each field
    activeFilters = {
      "types": kFilters['types']!.map((e) => false).toList(),
      "ambiences": kFilters['ambiences']!.map((e) => false).toList(),
      "costs": kFilters['costs']!.map((e) => false).toList(),
      "sorts": kFilters['sorts']!.map((e) => false).toList(),
    };
    print(city["id"] + "ID");
    /// Get all available places from Firestore
    await FirebaseFirestore.instance.collection('places')
    .where("city", isEqualTo: city['id'])
    .get()
    .then((query) => allPlaces = query.docs.map(docToPlace).toList());
    /// Instantiate displayed places with all places
    places = List.from(allPlaces);
    /// Map displayed places to Markers
    markers = await _mapPlacesToMarkers(places);
    /// Initialize the 'city'
    // city = context.watch<WrapperHomePageProvider>().mainCity!;
    notifyListeners();
    _loading();
  }

  double distanceBetween(GeoPoint b,LocationData a) {
    return sqrt(pow(a.latitude! - b.latitude, 2).toDouble() + pow(a.longitude! - b.longitude, 2));
  }

  void filter(Map<String, List<bool>> filters, WrapperHomePageProvider wrapperHomePageProvider) async{
    _loading();

    activeFilters = Map<String, List<bool>>.from(filters);
    
    Map<String, List<String>> finalFilters = {"types" : [], "ambiences" : [], "costs": [], "sorts": []};
    kFilters.forEach((key, list) {
      for(int i = 0; i < list.length; i++)
      if(filters[key]![i])
        finalFilters[key]!.add(list[i]);
    });
    // List.copyRange(places, 0, allPlaces);
    places = List.from(allPlaces);

    // places = allPlaces;

    places.forEach((element) {print(element.types);});
    
    filters.forEach((key, list) {
      for(int i = 0; i < list.length; i++){
        if(list[i]){
          var value = kFilters[key]![i];          
          switch(key){
            case "types":
              places.removeWhere((place) => !place.types!.contains(value));
            break;
            case "ambiences":
              places.removeWhere((place) => place.ambience != value);
            break;
            case "costs":
              places.removeWhere((place) => place.cost.toString() != value);
              break;
            case "sorts":
              places.sort((a,b) => distanceBetween(a.location, wrapperHomePageProvider.currentLocation!).compareTo(distanceBetween(b.location, wrapperHomePageProvider.currentLocation!)) );
            break;
          }
        }
      }
    });

    markers = await _mapPlacesToMarkers(places);

    notifyListeners();
    _loading();
  }

  void removeFilters() async{
    _loading();
     /// Instantiate active filters with no 'false' for each field
    activeFilters = {
      "types": kFilters['types']!.map((e) => false).toList(),
      "ambiences": kFilters['ambiences']!.map((e) => false).toList(),
      "costs": kFilters['costs']!.map((e) => false).toList(),
      "sorts" : kFilters['sorts']!.map((e) => false).toList(),
    };
    /// Reinstantiate displayed places with all places
    places = List.from(allPlaces);
    /// Map displayed places to Markers
    markers = await _mapPlacesToMarkers(places);

    notifyListeners();
    _loading();
  }

  void changeViewType() async{
    _loading();
    if(viewType == "map")
      viewType = "list";
    else viewType = "map";
    notifyListeners();
    _loading();
  }

  Future<Set<Marker>> _mapPlacesToMarkers(List<Place> places) async{
    Set<Marker> markers = {};
    places.forEach((place) async{
      var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20,20), devicePixelRatio: 0), 
        "assets/icons/pin.png",
      );
      var marker = Marker(
        icon: icon,
        markerId: MarkerId(place.name),
        position: LatLng(place.location.latitude, place.location.longitude), 
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => 
          MultiProvider(
            providers: [
              ChangeNotifierProvider<PlacePageProvider>(create: (context) => PlacePageProvider(place, wrapperHomePageProvider),),
              ChangeNotifierProvider.value(value: wrapperHomePageProvider)
            ],
            builder: (context, child) => PlacePage(context)
          )
        ))
      );
      markers.add(marker);
    });
    return markers;
  }

  void initializeMapController(GoogleMapController controller){
    mapController = controller;
  }

  /// Method called everytime a provider function is called to show a progress indicator
  void _loading(){
    isLoading = !isLoading;
    notifyListeners();
  }

}