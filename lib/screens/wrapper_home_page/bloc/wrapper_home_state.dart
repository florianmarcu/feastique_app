// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'wrapper_home_cubit.dart';

class WrapperHomeState extends Equatable {

  /// Configuration data about the cities
  final Map<String, dynamic>? configData;
  /// Configuration data about the assets
  final Map<String, dynamic>? assetsData;
  /// The cities available in the app
  final List<Map<String, dynamic>>? cities;
  /// The main city selected in the app
  final Map<String, dynamic>? mainCity;

  final UserProfile? currentUser; 
  final LocationData? currentLocation;
  final Reservation? activeReservation;
  final int selectedScreenIndex;

  final bool isLoading;
  final PageController pageController = PageController(initialPage: 1);
  final List<Widget> screens;

  final List<BottomNavigationBarItem> screenLabels = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Acasă",
      icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(
      label: "Descoperă",
      icon: Icon(Icons.search)
    ),
    BottomNavigationBarItem(
      label: "Rezervări",
      icon: Image.asset(localAsset('reservation'), width: 19,)
    ),
    BottomNavigationBarItem(
      label: "Profil",
      icon: Icon(Icons.person)
    ),
  ];


  WrapperHomeState({
    this.configData,
    this.assetsData,
    this.cities,
    this.isLoading = false,
    this.currentUser,
    this.currentLocation,
    this.activeReservation,
    this.selectedScreenIndex = 0,
    this.mainCity,
    this.screens = const []
  });
  
  @override
  List<Object?> get props => [
    configData, 
    assetsData, 
    cities, 
    isLoading, 
    currentUser, 
    currentLocation,
    activeReservation,
    selectedScreenIndex, 
    pageController, 
    mainCity, 
    screens, 
  ];


  WrapperHomeState copyWith({
    Map<String, dynamic>? configData,
    Map<String, dynamic>? assetsData,
    List<Map<String, dynamic>>? cities,
    Map<String, dynamic>? mainCity,
    UserProfile? currentUser,
    LocationData? currentLocation,
    Reservation? activeReservation,
    int? selectedScreenIndex,
    bool? isLoading,
    List<Widget>? screens,
  }) {
    return WrapperHomeState(
      configData: configData ?? this.configData,
      assetsData: assetsData ?? this.assetsData,
      cities: cities ?? this.cities,
      mainCity: mainCity ?? this.mainCity,
      currentUser: currentUser ?? this.currentUser,
      currentLocation: currentLocation ?? this.currentLocation,
      activeReservation: activeReservation ?? this.activeReservation,
      selectedScreenIndex: selectedScreenIndex ?? this.selectedScreenIndex,
      isLoading: isLoading ?? this.isLoading,
      screens: screens ?? this.screens,
    );
  }
}
