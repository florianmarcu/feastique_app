import 'package:feastique/models/models.dart';
import 'package:feastique/screens/home_page/components/alternative_place_item.dart';
import 'package:feastique/screens/home_page/components/recommended_place_item.dart';
import 'package:feastique/screens/home_page/home_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:provider/provider.dart';

import 'components/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var recommendedPlace = provider.getFirstPlace(); 
    return Theme(
      data: _buildTheme(context),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
            child: ListView(
              padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 140),
                // Text(
                //   "Bună!",
                //   style: Theme.of(context).textTheme.headline3,
                // ),
                // Text(
                //   "Rezervă o masă prin aplicație și bucură-te de ofertele exclusive!",
                //   style: Theme.of(context).textTheme.headline6,
                // ),
                Text(
                  "Ai rămas fără idei?",
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(height: 12,),
                TextButton( /// 'Find the perfect place' button
                  onPressed: () => wrapperHomePageProvider.pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn),
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Center(child: Text("Găsește localul perfect"))
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Încearcă din nou",
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(height: 12,),
                provider.noClaimedReservations != null && provider.noClaimedReservations != true
                ? Builder(
                  builder: (context) {
                    if(!provider.isLoading){
                      return FutureProvider(
                        create:(context) => recommendedPlace,
                        initialData: null,
                        builder: (context, child) {
                          var place = context.watch<Place?>();
                          if(place == null)
                            return Container(height: 200, child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)));
                          else{
                            return RecommendedPlaceItem(place);
                          }
                        },
                      );
                    }
                    else{
                      return Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,));
                    }
                  }
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("Nu știm ce să-ți recomandăm, \ndeci încearcă ceva aleatoriu...", style: TextStyle(fontSize: 18),),
                ),
                 provider.noClaimedReservations != null && provider.noClaimedReservations != true
                ? Column(children: [
                SizedBox(height: 20),
                Text(
                  "...sau ceva similar :)",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Builder(
                  builder: (context) {
                    if(!provider.isLoading){
                      return FutureProvider(
                        create: (context) => provider.getRecommendations(),
                        initialData: null,
                        builder: (context, child) {
                          var places = context.watch<List<Place>?>();
                          if(places == null)
                            return Container(height: 200, child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)));
                          else{
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              height: 120,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: places.length,
                                separatorBuilder: (context, index) => SizedBox(width: 20),
                                itemBuilder:  (context, index) => AlternativePlaceItem(places[index]),
                              ),
                            );
                          }
                        },
                      );
                    }
                    else{
                      return Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,));
                    }
                  }
                ),])
                : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) => Theme.of(context).copyWith(textButtonTheme: textButtonTheme(context));
}