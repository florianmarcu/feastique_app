import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feastique/config/config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';


/// Most of the configuration data and files from Firebase are fetched here
class WrapperProvider with ChangeNotifier{

  bool isLoading = false;

  WrapperProvider(){
    getData();
  }

  Future<void> getData() async{
    _loading();

    ///Get the assets' names from Cloud Firestore
    var query = FirebaseFirestore.instance.collection("config").doc("assets");
    var doc = await query.get();
    var assetsData = doc.data();
    ///Get the assets
    for(int i = 0; i < assetsData!['icons'].length; i++){
      var assetName = assetsData['icons'][i];
      //print(assetName);
      var image = await FirebaseStorage.instance.ref("config/assets/icons/${assetName.toLowerCase()}.png").getData();
      kAssets[assetName] = image;
      //print(kAssets[assetName].toString());
    }

    notifyListeners();

    _loading();
  }

  void _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}