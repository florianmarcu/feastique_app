import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/material.dart';

class CitiesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wrapperHomePageProvider = context.watch<WrapperHomePageProvider>();
    var cities = wrapperHomePageProvider.configData!['cities'].values.toList();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      child: ScrollConfiguration(
        behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: cities.length,
          separatorBuilder: (context,index) => Divider(height: 2), 
          itemBuilder: (context, index) => MaterialButton(
            onPressed: () {
              /// Update the Main city of the app
              wrapperHomePageProvider.updateMainCity(wrapperHomePageProvider.configData!['cities'].keys.where((key) => wrapperHomePageProvider.configData!['cities'][key]['name'] == cities[index]['name']).first);
              Navigator.pop(context);
            },
            child: Container(
              // decoration: BoxDecoration(
              //   color: 
              //   cities[index]['name'] == mainCity!['name']
              //   ? Colors.black45
              //   : Theme.of(context).highlightColor,
              //   //borderRadius: BorderRadius.circular(30)
              // ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(30),
              child: Text( 
                cities[index]['name'],
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
      )
    );
  }
}