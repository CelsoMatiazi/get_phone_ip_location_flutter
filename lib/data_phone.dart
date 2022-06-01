
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:wifi_scan/wifi_scan.dart';


class DataPhoneScreen extends StatefulWidget {
  const DataPhoneScreen({Key? key}) : super(key: key);

  @override
  _DataPhoneScreenState createState() => _DataPhoneScreenState();
}

class _DataPhoneScreenState extends State<DataPhoneScreen> {

  bool isLoadingPhone = true;
  bool isLoadingIp = true;
  bool isLoadingLocation = true;


  String ipFy = '';
  void getIpFy()  async{
    final ip = await Ipify.ipv4();
    setState(() {
      ipFy = ip;
      isLoadingIp = false;
    });
  }


  //List<SimCard> _simCard = <SimCard>[];
  String _mobileNumber = '';
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      //return;
      //initMobileNumberState();
    }
    String mobileNumber = '';

    try {
      mobileNumber = (await MobileNumber.mobileNumber)!;
      //_simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }

    getLocation();
    if (!mounted) return;
    setState(() {
      if(mobileNumber.isEmpty){
        _mobileNumber = "Phone number not found!";
      }else{
        _mobileNumber = mobileNumber;
      }
      isLoadingPhone = false;
    });
  }



   _requestPermission() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;


     await location.requestPermission();
    _permissionGranted = await location.hasPermission();

    if(_permissionGranted == PermissionStatus.denied){
      print('negado');
      _requestPermission();
    }else{
      print('aprovado');
    }

    _serviceEnabled = await location.requestService();

    print(_serviceEnabled);
    print(_permissionGranted);
  }



  Location location = Location();
  late String locationData;
  getLocation() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();

    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(_serviceEnabled){
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      if(_locationData.toString().isEmpty){
        locationData = "Location not found";
      }else{
        locationData = 'Latitude: ${_locationData.latitude}\nLongitude: ${_locationData.longitude}';
      }
      isLoadingLocation = false;
    });
  }


  //WIFI
  List<WiFiAccessPoint> access = [];
  void _scan() async{
    final result = await WiFiScan.instance.getScannedResults();
    access = result;
    setState(() {});
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIpFy();

    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if(isPermissionGranted){
        initMobileNumberState();
      }
    });
    initMobileNumberState();
    _requestPermission();
    _scan();
  }



  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Phone Information'),
        backgroundColor: Colors.blueGrey,
      ),

      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              //'https://www.mooniluminacao.com.br/storage/images/cache/banner-luminaria-mobile-919-b8e68dcd.jpg',
              'https://www.teahub.io/photos/full/286-2866937_cyber-wallpaper-iphone.jpg',
            ),
            fit: BoxFit.fill,
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * .85,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.contact_phone_rounded, size: 50,),
                        Text('Phone Number'),
                        SizedBox(height: 10,),
                        isLoadingPhone ? CircularProgressIndicator(color: Colors.black38,):Text(_mobileNumber),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: size.width * .85,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.wifi_tethering, size: 50,),
                        Text('IP Address'),
                        SizedBox(height: 10,),
                        isLoadingIp ? CircularProgressIndicator(color: Colors.black38,):Text(ipFy),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: size.width * .85,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.location_pin, size: 50, color: Colors.red),
                        Text('Location'),
                        SizedBox(height: 10,),
                        isLoadingLocation ? CircularProgressIndicator(color: Colors.black38,):Text(locationData),
                        SizedBox(height: 10,),

                       // Text('Longitude:' + locationData.longitude.toString()),
                      ],
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20,),
              Container(
                width: size.width * .85,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.wifi_sharp, size: 50, color: Colors.red),
                        Text('WI-FI Access Point'),
                        SizedBox(height: 10,),
                        access.isEmpty
                            ? CircularProgressIndicator(color: Colors.black38,)
                            : Column(
                                children: access.map((e) =>
                                Text(e.ssid)
                                ).toList(),
                        ),

                        SizedBox(height: 10,),

                        // Text('Longitude:' + locationData.longitude.toString()),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
