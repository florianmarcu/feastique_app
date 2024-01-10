import 'package:feastique/screens/manager_home_page/manager_home_provider.dart';
import 'package:feastique/screens/profile_page/profile_provider.dart';
import 'package:flutter/material.dart';

class ManagerPlaceDataPage extends StatefulWidget {
  const ManagerPlaceDataPage({ Key? key }) : super(key: key);

  @override
  State<ManagerPlaceDataPage> createState() => _ManagerPlaceDataPageState();
}

class _ManagerPlaceDataPageState extends State<ManagerPlaceDataPage> {

  var offset = 0.0;

  final _scrollController = ScrollController(
    keepScrollOffset: true,
    initialScrollOffset: 0
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        offset = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ManagerHomePageProvider>();
    var place = provider.place;
    print(provider.image);
    return Scaffold(
      // appBar: AppBar(
      //   //automaticallyImplyLeading: false,
      //   //toolbarHeight: 70,
      //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(210, 30), bottomRight: Radius.elliptical(210, 30))),
      //   // title: Center(child: Text("Rezervare confirmată", style: Theme.of(context).textTheme.headline4,)),
      //   backgroundColor: Colors.transparent,
      //   leading: CircleAvatar(
      //     backgroundColor: Theme.of(context).highlightColor,
      //     child: IconButton(
      //       splashRadius: 28,
      //       icon: Icon(Icons.arrow_back),
      //       color: Colors.black,
      //       onPressed: (){
      //         Navigator.pop(context);
      //       }
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: Text("Datele restaurantului", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 25),),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          provider.isLoading
          ? Positioned(
            child: Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
            ), 
            bottom: MediaQuery.of(context).padding.bottom,
          )
          : Container(),
          FloatingActionButton.extended(
            elevation: 0, 
            shape: ContinuousRectangleBorder(),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              provider.updateData(context);
            },
            label: Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Modifică", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20),),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              expandedTitleScale: 1,
              titlePadding: EdgeInsets.only( /// Creates a dynamic Padding for the title as the Page is scrolled
                left: MediaQuery.of(context).size.width*0.06 + offset/5 < MediaQuery.of(context).size.width*0.18
                ? MediaQuery.of(context).size.width*0.06 + offset/5
                : MediaQuery.of(context).size.width*0.18, 
                bottom: 14,
              ),
              title: Text("Datele localului", style: Theme.of(context).textTheme.headline3),
              background: Container(
                height: 280 + MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    /// The Profile Image of the place
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(150,30), bottomRight: Radius.elliptical(200,50)),
                          child: Container(
                            height: 220 + MediaQuery.of(context).padding.top,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(150,30), bottomRight: Radius.elliptical(200,50)),
                          child: Container(
                            height: 200 + MediaQuery.of(context).padding.top,
                            width: MediaQuery.of(context).size.width,
                            child: provider.image == null
                              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,))
                              : FittedBox(
                                fit: BoxFit.fill,
                                child:  provider.image
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 60,
                      color: Theme.of(context).canvasColor,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Theme.of(context).canvasColor,
            pinned: true,
            //floating: true,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).canvasColor,
              child: IconButton(
                splashRadius: 28,
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: (){
                  Navigator.pop(context);
                }
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              place == null
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,))
              : Stack(
                children: [
                  ScrollConfiguration(
                    behavior: ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
                    child: ListView(
                        padding: EdgeInsets.all(20),
                        shrinkWrap: true,
                        children: [
                          // SizedBox(height: 20),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Container(
                          //     height: 200 + MediaQuery.of(context).padding.top,
                          //     width: MediaQuery.of(context).size.width,
                          //     child:  provider.image == null
                          //     ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,))

                          //     : FittedBox(
                          //       fit: BoxFit.fill,
                          //       child: provider.image
                          //       // child: FutureBuilder<Image>(
                          //       //   future: provider.getImage(),
                          //       //   builder: (context, image){  
                          //       //     if(place.finalImage == null)
                          //       //       return Container(
                          //       //         width: 400,
                          //       //         height: 200,
                          //       //         color: Colors.transparent,
                          //       //       );
                          //       //     else 
                          //       //       return place.finalImage!;
                                      
                          //       //   }
                          //       // ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 50),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Nume",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            initialValue: place.name,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: place.name,
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (name) => provider.changePlaceName(name),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Capacitate",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            initialValue: place.capacity.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: place.name,
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (capacity) => provider.changeCapacity(int.parse(capacity)),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          //   child: Text(
                          //     "Email",
                          //     style: Theme.of(context).textTheme.headline6,
                          //   ),
                          // ),
                          // SizedBox(height: 20),
                          // TextFormField(
                          //   keyboardType: TextInputType.emailAddress,
                          //   readOnly: true,
                          //   decoration: InputDecoration(
                          //     fillColor: Colors.white,
                          //     labelText: user.email!,
                          //     labelStyle: TextStyle(color: Colors.black)
                          //   ),
                          //   //onChanged: (email) => provider.setEmail(email),
                          // ),
                          // SizedBox(height: 20),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          //   child: Text(
                          //     "Număr de telefon",
                          //     style: Theme.of(context).textTheme.headline6,
                          //   ),
                          // ),
                          // SizedBox(height: 20),
                          // TextFormField(
                          //   keyboardType: TextInputType.number,
                          //   style: TextStyle(color: Colors.black),
                          //   initialValue: provider.phoneNumber,
                          //   decoration: InputDecoration(
                          //     fillColor: Colors.white,
                          //     labelText: user.phoneNumber!,
                          //     labelStyle: TextStyle(color: Colors.black)
                          //   ),
                          //   onChanged: (number) => provider.changePhoneNumber(number),
                          // ),
                        ],
                      ),
                    ),
                    provider.isLoading
                    ? Positioned(
                      child: Container(
                          height: 5,
                          width: MediaQuery.of(context).size.width,
                          child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), backgroundColor: Colors.transparent,)
                      ), 
                      bottom: MediaQuery.of(context).padding.bottom,
                    )
                    : Container(),
                  ],
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}