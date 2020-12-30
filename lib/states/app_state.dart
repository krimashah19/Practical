import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:kumbh_practical/requests/google_maps_requests.dart';


class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  static LatLng _currentPosition;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
   String recentLocation,destinationLocation,recentPlaceId;
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  String currentLocation;
  GoogleMapsPlaces places=GoogleMapsPlaces(apiKey: apiKey);
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  Mode _mode = Mode.fullscreen;


  AppState() {
    _getUserLocation();
    _loadingInitialPosition();

  }
// ! TO GET THE USERS LOCATION
  void _getUserLocation() async {
    print("GET USER METHOD RUNNING =========");
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    locationController.text = placemark[0].name;
    currentLocation= placemark[0].name+" "+placemark[0].subLocality+" "+placemark[0].locality;

    notifyListeners();
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    _polyLines.clear();
    notifyListeners();
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  // ! ADD A MARKER ON THE MAO
  void _addMarker(LatLng location, String address) {
    _markers.clear();
    _markers.add(Marker(
        markerId: MarkerId(""),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  Future<Prediction> handlePressButton(BuildContext context) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      onError: onError,
      mode: _mode,
      language: "en",
      logo:null ,
      hint:'Search Location' ,


      components: [Component(Component.country, "In")],
    );


    displayPrediction(p, homeScaffoldKey.currentState);
    return p;
  }
  //theme for place autoComplete

  final customTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.00)),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 12.50,
        horizontal: 10.00,
      ),
    ),
  );

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      PlacesDetailsResponse detailRecent = await places.getDetailsByPlaceId(recentPlaceId);
      // _initialPosition=LatLng(detail.result.geometry.location.lat,detail.result.geometry.location.lng);

      _currentPosition=LatLng(detailRecent.result.geometry.location.lat,detailRecent.result.geometry.location.lng);
      print('data-->${p.description}');

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
  // ! SEND REQUEST
  void sendRequest(String intendedLocation) async {
    _polyLines.clear();
    notifyListeners();
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _currentPosition!=null?_currentPosition:_initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

//  LOADING INITIAL POSITION
  void _loadingInitialPosition()async{
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
