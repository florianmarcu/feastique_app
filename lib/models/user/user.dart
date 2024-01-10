// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  
  final String uid;
  final String? email;
  final String? photoURL;
  final String displayName;
  final bool isAnonymous;
  final String? phoneNumber;
  final bool isManager;

  UserProfile({required this.uid, this.email, this.photoURL,required this.displayName, required this.isAnonymous, this.phoneNumber, this.isManager = false});

  
  @override
  List<Object?> get props => [uid, email, photoURL, displayName, isAnonymous, phoneNumber, isManager];

  UserProfile copyWith({
    String? uid,
    String? email,
    String? photoURL,
    String? displayName,
    bool? isAnonymous,
    String? phoneNumber,
    isManager
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

/// Converts a User to UserProfile
Future<UserProfile?> userToUserProfile(User? user) async{
  if(user != null){
    var userProfile = UserProfile(
      uid: user.uid,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName != null 
        ? user.displayName !
        : (user.email != null
          ? user.email!.substring(0,user.email!.indexOf('@'))
          : "Oaspete"),
      isAnonymous : user.isAnonymous,
    );

    /// Fetch extra data from the user's document in Firestore (users/{user})  
    if(!user.isAnonymous)
      await FirebaseFirestore.instance.collection('users').doc(userProfile.uid).get()
      .then((doc){
        if(doc.data() != null){
          userProfile = userProfile.copyWith(isManager: doc.data()!.containsKey('manager') && doc.data()!['manager'] == true);
          if(doc.data()!.containsKey('contact_phone_number')){
            userProfile = userProfile.copyWith(phoneNumber: doc.data()!['contact_phone_number']);
          }
          if(doc.data()!.containsKey('display_name')){
            userProfile = userProfile.copyWith(displayName: doc.data()!['display_name']);
          }
        }
      });
    
    return userProfile;

  }
  else return null;
}
