import 'package:feastique/config/paths.dart';
import 'package:feastique/screens/discover_page/discover_provider.dart';
import 'package:feastique/screens/place_page/place_page.dart';
import 'package:feastique/screens/place_page/place_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

import 'places_list_empty.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({ Key? key }) : super(key: key);

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {

  // List<Place> _places = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    //     _loadMorePlaces(places);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var places = context.watch<DiscoverPageProvider>().places;
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    // setState(() {
    //   _places = places;
    // });
    // //_loadPlaces(places);
    // _scrollController.addListener(() {
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    //     _loadMorePlaces(places);
    //   }
    // });
    // // print(places.length);
    // // setState(() {
    // //   _places = places;
    // // });
    // print(_places.length);
    return ScrollConfiguration(
      behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      child: places.length == 0
      ? EmptyList()
      : ListView.separated(
        addAutomaticKeepAlives: false,
        cacheExtent: 0,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 30, right: 30, bottom: 30),
        controller: _scrollController,
        itemCount: places.length,
        separatorBuilder: (context, index) => SizedBox(height: 30),
        itemBuilder: (context, index){
          // if(index == _places.length)
          //   return Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor) ,));
          var place = places[index];
          return InkWell(
            splashColor: Theme.of(context).splashColor,
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider<PlacePageProvider>(create: (context) => PlacePageProvider(place, wrapperHomePageProvider),),
                    ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                  ],
                  builder: (context, child) => PlacePage(context)
                )
              )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 325,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0, spreadRadius: 10.0, color: Colors.grey, offset: Offset(0,-1))
                        ],
                      ),
                    ),
                    Container(
                      height: 310,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        //color: Theme.of(context).highlightColor,
                        // boxShadow: [
                        //   BoxShadow(blurRadius: 5.0, spreadRadius: 10.0, color: Colors.grey, offset: Offset(0,-1))
                        // ],
                      ),
                      child: Column(
                        children: [
                          // place.finalImage != null
                          // ? place.finalImage!
                          // : Container()
                          /// The Place's profile image 
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            child: Container(
                              height: 225,
                              width: MediaQuery.of(context).size.width*0.9,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                              child: FutureProvider<Image?>.value(
                                value: places[index].image,
                                initialData: places[index].finalImage,
                                builder: (context, child){
                                  var image = Provider.of<Image?>(context);
                                  return image == null
                                  ? Container()
                                  : image;
                                },
                              ),
                            ),
                          ),
                          /// The Place's description
                          Expanded(
                            child: Container(
                              color: Theme.of(context).highlightColor,
                              alignment: Alignment(-1,0),
                              padding: EdgeInsets.only(left: 35, top: 10, right: 20),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Text(place.name.length < 25 ? place.name : place.name.substring(0,22) + "...", maxLines: 2, style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 22*(1/MediaQuery.textScaleFactorOf(context)))),
                                    Spacer(),
                                    Row(children: List.generate(place.cost, (index) => 
                                      Container(
                                        child: Text('\$', style: Theme.of(context).textTheme.labelMedium,),
                                      )
                                    ))
                                  ],
                                ),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Image.asset(localAsset("cuisine"), width: 17),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Wrap
                                      (
                                        children: place.types!.map((type) => 
                                          Container(
                                            child: Text(type + "  ")
                                          )
                                        ).toList()
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // _loadPlaces(List<Place> places) => setState(() {
  //   _places = places.take(10).toList();
  // });

  // _loadMorePlaces(List<Place> places){
  //   var temp = <Place>[];
  //   if(_places.length < places.length)
  //     for(int i = _places.length; i < _places.length + min(10, places.length - _places.length); i++){
  //       print(i+1);
  //       temp.add(places[i]);
  //     }
  //   setState(() {
  //     _places.addAll(temp);
  //     print(_places);
  //   });
  // }
  
}