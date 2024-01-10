import 'package:feastique/config/paths.dart';
import 'package:feastique/screens/discover_page/components/filters_popup.dart';
import 'package:feastique/screens/discover_page/components/places_list/places_list.dart';
import 'package:feastique/screens/discover_page/components/places_map/places_map.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';
import 'discover_provider.dart';

class DiscoverPage extends StatefulWidget {
  
  final BuildContext context;
  
  DiscoverPage(this.context);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DiscoverPageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var isLoading = provider.isLoading;
    var viewType = provider.viewType;
    var viewTypeText = viewType == "map" ? "Listă" : "Hartă";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).padding.top),
            Container(
              alignment: Alignment(0,0),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row( /// The 'Row' of options buttons
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    style: Theme.of(context).textButtonTheme.style!.copyWith(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10, vertical: 0))),
                    label: Text("Filtre", style: Theme.of(context).textTheme.caption,),
                    icon: Image.asset(localAsset('filter'), width: 15, color: Theme.of(context).highlightColor,),
                    onPressed: (){
                      showGeneralDialog(
                        context: context,
                        transitionDuration: Duration(milliseconds: 300),
                        transitionBuilder: (context, animation, secondAnimation, child){
                          var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                          return SlideTransition(
                            child: child,
                            position: Tween<Offset>(
                              begin: Offset(0,-1),
                              end: Offset(0,0)
                            ).animate(_animation),
                          );
                        },
                        pageBuilder: ((context, animation, secondaryAnimation) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: provider,),
                            ChangeNotifierProvider.value(value: wrapperHomePageProvider)
                          ],
                          child:  FiltersPopUpPage()
                        )
                      ));
                    },
                  ),
                  SizedBox(width: 10),
                  TextButton.icon(
                    style: Theme.of(context).textButtonTheme.style!.copyWith(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10, vertical: 0))),
                    label: Text(viewTypeText, style: Theme.of(context).textTheme.caption,),
                    icon: viewType == 'map'
                    ? Image.asset(localAsset('list'), width: 15, color: Theme.of(context).highlightColor,)
                    : Image.asset(localAsset('map'), width: 15, color: Theme.of(context).highlightColor,),
                    onPressed: () => provider.changeViewType()
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          viewType == "map" 
          ? PlacesMap()
          : PlacesList(),
          // wrapperHomePageProvider.isLoading || 
          isLoading
          ? Positioned(
            child: Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
            ), 
            bottom: MediaQuery.of(context).padding.bottom,
          )
          : Container(),
        ]),
      )
    );
  }
}