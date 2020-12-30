import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kumbh_practical/states/app_state.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'map.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return SafeArea(
        child: appState.initialPosition == null
            ? Container(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitRotatingCircle(
                        color: Colors.black,
                        size: 50.0,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: appState.locationServiceActive == false,
                    child: Text(
                      "Please enable location services!",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                ],
              ))
            : Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                      child: Text(
                    'Direction App',
                    style: TextStyle(fontSize: 20),
                  )),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  recentLocationWidget('Recent Location'),
                                  SizedBox(height: 10),
                                  locationTitle('You are At', appState),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  locationTextWidget(appState),
                                  SizedBox(height: 10),
                                  changeBtn('change', appState),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      appState
                                          .handlePressButton(context)
                                          .then((value) {
                                        print(value);
                                        appState.destinationLocation = value.description;
                                        setState(() {});
                                      });
                                    },
                                    child: recentLocationWidget(
                                        'Destination Location'),
                                  ),
                                  SizedBox(height: 10),
                                  locationTitle('Go to At', appState),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  locationDestinationTextWidget(appState),
                                  SizedBox(height: 15),
                                  changeDestinationLocationBtn(
                                      'change', appState),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100,),
                      submitButton(appState)
                    ],
                  )
                ],
              )

//       Stack(
//               children: <Widget>[
//                 GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                       target: appState.initialPosition, zoom: 10.0),
//                   onMapCreated: appState.onCreated,
//                   myLocationEnabled: true,
//                   mapType: MapType.normal,
//                   compassEnabled: true,
//                   markers: appState.markers,
//                   onCameraMove: appState.onCameraMove,
//                   polylines: appState.polyLines,
//                 ),
//
//                 Positioned(
//                   top: 50.0,
//                   right: 15.0,
//                   left: 15.0,
//                   child: Container(
//                     height: 50.0,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(3.0),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(1.0, 5.0),
//                             blurRadius: 10,
//                             spreadRadius: 3)
//                       ],
//                     ),
//                     child: TextField(
//                       cursorColor: Colors.black,
//                       controller: appState.locationController,
//                       decoration: InputDecoration(
//                         icon: Container(
//                           margin: EdgeInsets.only(left: 20, top: 5),
//                           width: 10,
//                           height: 10,
//                           child: Icon(
//                             Icons.location_on,
//                             color: Colors.black,
//                           ),
//                         ),
//                         hintText: "pick up",
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Positioned(
//                   top: 105.0,
//                   right: 15.0,
//                   left: 15.0,
//                   child: Container(
//                     height: 50.0,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(3.0),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(1.0, 5.0),
//                             blurRadius: 10,
//                             spreadRadius: 3)
//                       ],
//                     ),
//                     child: TextField(
//                       cursorColor: Colors.black,
//                       controller: appState.destinationController,
//                       textInputAction: TextInputAction.go,
//                       onSubmitted: (value) {
//                         appState.sendRequest(value);
//                       },
//                       decoration: InputDecoration(
//                         icon: Container(
//                           margin: EdgeInsets.only(left: 20, top: 5),
//                           width: 10,
//                           height: 10,
//                           child: Icon(
//                             Icons.local_taxi,
//                             color: Colors.black,
//                           ),
//                         ),
//                         hintText: "destination?",
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
//                       ),
//                     ),
//                   ),
//                 ),
//
// //        Positioned(
// //          top: 40,
// //          right: 10,
// //          child: FloatingActionButton(onPressed: _onAddMarkerPressed,
// //          tooltip: "aadd marker",
// //          backgroundColor: black,
// //          child: Icon(Icons.add_location, color: white,),
// //          ),
// //        )
//               ],
//             ),
        );
  }

  recentLocationWidget(String name) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow[800], width: 2),
            borderRadius: BorderRadius.circular(8)),
        height: 60,
        child: Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18),
            )));
  }

  locationTextWidget(AppState appState) {
    return Text(appState.recentLocation != null
        ? appState.recentLocation
        : appState.currentLocation);
  }

  locationDestinationTextWidget(AppState appState) {
    return Text(appState.destinationLocation != null
        ? appState.destinationLocation
        : '');
  }

  locationTitle(String title, AppState appState) {
    return Container(
        margin: EdgeInsets.only(left: 4),
        child: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
  }

  changeBtn(String name, AppState appState) {
    return Container(
      width: 110,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange,
      ),
      child: FlatButton(
        onPressed: () {
          appState.handlePressButton(context).then((value) {
            print(value);
            appState.recentLocation = value.description;
            appState.recentPlaceId=value.placeId;
            setState(() {});
          });
        },
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  changeDestinationLocationBtn(String name, AppState appState) {
    return Container(
      width: 110,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange,
      ),
      child: FlatButton(
        onPressed: () {
          appState.handlePressButton(context).then((value) {
            print(value);
            appState.destinationLocation = value.description;
            setState(() {});
          });
        },
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  submitButton(AppState appState) {
    return Container(
      width: MediaQuery.of(context).size.width-100,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange,
      ),
      child: FlatButton(
        onPressed: () {

         if(appState.destinationLocation!=null)
           {
             appState.sendRequest(appState.destinationLocation);
             Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => MapScreen(),
                 ));
           }
         else{
           Toast.show("Please Select Destination Location", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
         }
        },
        child: Text(
          'SUBMIT',
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
