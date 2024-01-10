import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/models/user/user.dart';
import 'package:feastique/screens/wrapper_home_page/bloc/wrapper_home_provider.dart';
import 'package:flutter/widgets.dart';
export 'package:provider/provider.dart';

class ProfilePageProvider with ChangeNotifier{

  UserProfile user;
  BuildContext context;
  Map<String, dynamic>? configData;
  List<Map<String, dynamic>>? cities;
  Map<String, dynamic>? city;
  
  String? phoneNumber;
  String? displayName;
  bool isLoading = false;
 
  ProfilePageProvider(this.context, this.user, this.phoneNumber, this.displayName){
    getData(context);
  }
    
  void getData(BuildContext context){
  }

  void changePhoneNumber(String number){
    phoneNumber = number;

    notifyListeners();
  }
  
  void changeDisplayName(String name){
    displayName = name;

    notifyListeners();
  }
  Future<void> updateData(BuildContext context, WrapperHomePageProvider wrapperHomePageProvider) async{
    _loading();
    if(phoneNumber != null && phoneNumber != ""){
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          "contact_phone_number": phoneNumber
        },
        SetOptions(merge: true)
      );
    }
    if(displayName != null && displayName != ""){
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          "display_name": displayName
        },
        SetOptions(merge: true)
      );
    }

    wrapperHomePageProvider.getData(context);

    _loading();

    notifyListeners();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}