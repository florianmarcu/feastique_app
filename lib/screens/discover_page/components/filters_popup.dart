import 'package:feastique/config/constants.dart';
import 'package:feastique/screens/discover_page/discover_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class FiltersPopUpPage extends StatefulWidget {

  @override
  State<FiltersPopUpPage> createState() => _FiltersPopUpPageState();
}

class _FiltersPopUpPageState extends State<FiltersPopUpPage> {
  
  final _filters = kFilters;
  Map<String, List<bool>> _currSelectedFilters = {"types": [], "ambiences": [], "costs": [], "sorts": []};
  //var _prevFiltersSelected = false;
  var _currFiltersSelected = false;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<DiscoverPageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var prevSelectedFilters = context.read<DiscoverPageProvider>().activeFilters;
    //_prevFiltersSelected = prevSelectedFilters['types'].fold(false, (prev, curr) => prev || curr) || prevSelectedFilters['ambiences'].fold(false, (prev, curr) => prev || curr) || prevSelectedFilters['costs'].fold(false, (prev, curr) => prev || curr);
    /// If the current filters are not initialized, initialize them with a copy of the previously selected filters
    if(_currSelectedFilters['types']!.isEmpty || _currSelectedFilters['ambiences']!.isEmpty || _currSelectedFilters['costs']!.isEmpty){
      _currSelectedFilters['types'] = List.from(prevSelectedFilters['types']); 
      _currSelectedFilters['ambiences'] = List.from(prevSelectedFilters['ambiences']); 
      _currSelectedFilters['costs'] = List.from(prevSelectedFilters['costs']);
      _currSelectedFilters['sorts'] = List.from(prevSelectedFilters['sorts']);
    }
    _currFiltersSelected = 
    _currSelectedFilters['types']!.fold(false, (prev, curr) => prev || curr) 
    || _currSelectedFilters['ambiences']!.fold(false, (prev, curr) => prev || curr) 
    || _currSelectedFilters['costs']!.fold(false, (prev, curr) => prev || curr)
    || _currSelectedFilters['sorts']!.fold(false, (prev, curr) => prev || curr);
    print("$prevSelectedFilters SELECTED FILTERS");
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0, 
        shape: ContinuousRectangleBorder(),
        backgroundColor: _currFiltersSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).primaryColor.withOpacity(0.6),
        onPressed: _currFiltersSelected 
        ? () {
          provider.filter({"types": _currSelectedFilters['types']!, "ambiences" : _currSelectedFilters['ambiences']!, "costs": _currSelectedFilters['costs']! , "sorts": _currSelectedFilters['sorts']!}, wrapperHomePageProvider);
          Navigator.pop(context);
        } 
        : null,
        label: Container(
          width: MediaQuery.of(context).size.width,
          child: Text("Aplică", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4,),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Text("Filtrează", style: Theme.of(context).textTheme.headline6),
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
        actions: [
          TextButton(
            style: Theme.of(context).textButtonTheme.style!.copyWith(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor)
            ),
            onPressed: _currFiltersSelected 
            ? (){
              provider.removeFilters();
              Navigator.pop(context);
            }
            : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Șterge filtre", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.normal,
                color: _currFiltersSelected ? Theme.of(context).textTheme.labelMedium!.color :  Theme.of(context).textTheme.labelMedium!.color!.withOpacity(0.4)
              ),),
            ),
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Text("Specific", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                height: (_filters['types']!.length/4 + 1) * 50,
                child: GridView.builder(
                  cacheExtent: 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 110, mainAxisExtent: 50, crossAxisSpacing: 10), 
                  itemCount: _filters['types']!.length,
                  itemBuilder: (context, index){
                    return Container(
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                        pressElevation: 0,
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).canvasColor,
                        labelStyle: Theme.of(context).textTheme.overline!,
                        label: Text(_filters['types']![index],),
                        selected: _currSelectedFilters['types']![index],
                        onSelected: (selected){
                          setState(() {
                            _currSelectedFilters['types']![index] = selected;
                          });
                        },
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Text("Atmosferă", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                height: (_filters['ambiences']!.length/5 + 1) * 50,
                child: GridView.builder(
                  cacheExtent: 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80,mainAxisExtent: 50), 
                  itemCount: _filters['ambiences']!.length,
                  itemBuilder: (context, index){
                    return Container(
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                        pressElevation: 0,
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).canvasColor,
                        labelStyle: Theme.of(context).textTheme.overline!,
                        label: Text(kAmbiences[_filters['ambiences']![index]]!,),
                        selected: _currSelectedFilters['ambiences']![index],
                        onSelected: (selected){
                          setState(() {
                            _currSelectedFilters['ambiences']![index] = selected;
                          });
                        },
                      ),
                    );
                  }
                ),
              ),
              Text("Preț", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                height: (_filters['costs']!.length/5 + 1) * 50,
                child: GridView.builder(
                  cacheExtent: 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80,mainAxisExtent: 50), 
                  itemCount: _filters['costs']!.length,
                  itemBuilder: (context, index){
                    return ChoiceChip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                      pressElevation: 0,
                      selectedColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).canvasColor,
                      labelStyle: Theme.of(context).textTheme.overline!,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(int.parse(_filters['costs']![index]), (index) => 
                        Container(
                          child: Text('\$', textAlign: TextAlign.center),
                        )
                      )),
                      selected: _currSelectedFilters['costs']![index],
                      onSelected: (selected){
                        setState(() {
                          _currSelectedFilters['costs']![index] = selected;
                        });
                      },
                    );
                  }
                ),
              ),
              Text("Sortează după", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
              //SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Container(
                height: 60,
                child: ListView.builder(
                  cacheExtent: 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemExtent: 80,
                  itemCount: 1,
                  itemBuilder: (context, index){
                    return ChoiceChip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                      pressElevation: 0,
                      selectedColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).canvasColor,
                      labelStyle: Theme.of(context).textTheme.overline!,
                      label: Text("distanță"),
                      selected: _currSelectedFilters['sorts']![index],
                      onSelected: (selected){
                        setState(() {
                          _currSelectedFilters['sorts']![index] = selected;
                        });
                      },
                    );
                  }
                ),
              )
              // Container(
              //   height: (_filters['costs']!.length/5 + 1) * 50,
              //   child: GridView.builder(
              //     cacheExtent: 0,
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 80,mainAxisExtent: 50), 
              //     itemCount: _filters['costs']!.length,
              //     itemBuilder: (context, index){
              //       return ChoiceChip(
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              //         side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
              //         pressElevation: 0,
              //         selectedColor: Theme.of(context).primaryColor,
              //         backgroundColor: Theme.of(context).canvasColor,
              //         labelStyle: Theme.of(context).textTheme.overline!,
              //         label: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: List.generate(int.parse(_filters['costs']![index]), (index) => 
              //           Container(
              //             child: Text('\$', textAlign: TextAlign.center),
              //           )
              //         )),
              //         selected: _currSelectedFilters['costs']![index],
              //         onSelected: (selected){
              //           setState(() {
              //             _currSelectedFilters['costs']![index] = selected;
              //           });
              //         },
              //       );
              //     }
              //   ),
              // )
            ],
          ),
        ),
      )
    );
  }
}


// class FiltersPopupPage extends PopupRoute {
  
//   DiscoverPageProvider _provider;
//   FiltersPopupPage(this._provider);

//   Widget build(BuildContext context) {

//     var provider = _provider;
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).canvasColor,
//         centerTitle: true,
//         title: Text("Filtrează", style: Theme.of(context).textTheme.headline6),
//         leading: CircleAvatar(
//           backgroundColor: Theme.of(context).highlightColor,
//           child: IconButton(
//             splashRadius: 28,
//             icon: Icon(Icons.arrow_back),
//             color: Colors.black,
//             onPressed: (){
//               Navigator.pop(context);
//             }
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Specific", style: Theme.of(context).textTheme.labelMedium,),
//             Wrap(),

//           ],
//         ),
//       )
//     );
//   }

//   @override
//   Color? get barrierColor => Colors.transparent;

//   @override
//   bool get barrierDismissible => false;

//   @override
//   String? get barrierLabel => "filters-popup";

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//     return build(context);
//   }

//   @override
//   Duration get transitionDuration => Duration(milliseconds: 500);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//     var _animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
//     return SlideTransition(
//       child: child,
//       //child: ClipPath(child: child, clipper: _clipper,),
//       position: Tween<Offset>(
//         begin: Offset(0,-1),
//         end: Offset(0,0)
//       ).animate(_animation),
//     );
//   }
// }