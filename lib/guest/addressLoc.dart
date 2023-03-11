import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../provider/provider1.dart';
import '../../utils/multiText.dart';

class LocAddress extends StatefulWidget {
  LocAddress({super.key});

  @override
  State<LocAddress> createState() => _LocAddressState();
}

class _LocAddressState extends State<LocAddress> {
  final _formKey = GlobalKey<FormState>();
  String data = "";
  String value = "home";
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addres = TextEditingController();
  TextEditingController mail = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(24.8879434, 67.0465303);
  static const LatLng destinationLocation = LatLng(24.9026764, 67.1122625);

  List<LatLng> polylineCoordinates = [];
  late List<LatLng> polylineCoordinates2;
  double _distance = 0;
  BitmapDescriptor? markerbitmap;

  void getPolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
            "AIzaSyBPgyZijp1jS3RdFXQTJohNP9KBAJQQ6ak",
            PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
            PointLatLng(
                destinationLocation.latitude, destinationLocation.longitude))
        as PolylineResult;
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
    }
  }

  void _calculateDistance() {
    double totalDistance = 0;
    for (int i = 0; i < polylineCoordinates2.length - 1; i++) {
      double distance = _coordinateDistance(
        polylineCoordinates2[i].latitude,
        polylineCoordinates2[i].longitude,
        polylineCoordinates2[i + 1].latitude,
        polylineCoordinates2[i + 1].longitude,
      );
      totalDistance += distance;
    }
    setState(() {
      _distance = totalDistance;
    });
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    getPolyPoints();

    polylineCoordinates2 = [
      LatLng(24.8879434, 67.0465303),
      LatLng(24.9026764, 67.1122625)
    ];
    _calculateDistance();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: GoogleMap (
                      initialCameraPosition:
                          CameraPosition(target: sourceLocation, zoom: 11.5),
                      polylines: {
                        Polyline(
                            polylineId: PolylineId("route"),
                            points: polylineCoordinates,
                            color: Colors.red,
                            width: 2),
                      },
                      markers: {
                        Marker(
                          markerId: MarkerId("source"),
                          position: sourceLocation,
                          
                           
                        ),
                        Marker(
                            markerId: MarkerId("destination"),
                            position: destinationLocation),
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                'Distance: ${_distance.toStringAsFixed(2)} km'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Multi(
                              color: Color.fromARGB(255, 91, 90, 90),
                              subtitle: "NAME",
                              weight: FontWeight.w700,
                              size: 12),
                          SizedBox(
                            height: 7.h,
                          ),
                          TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                            controller: name,
                            cursorColor: Color.fromARGB(255, 91, 90, 90),
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                              helperStyle: TextStyle(fontSize: 10.sp),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Multi(
                              color: Color.fromARGB(255, 91, 90, 90),
                              subtitle: "PHONE",
                              weight: FontWeight.w700,
                              size: 12),
                          SizedBox(
                            height: 7.h,
                          ),
                          TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                            controller: phone,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            cursorColor: Color.fromARGB(255, 91, 90, 90),
                            decoration: InputDecoration(
                              hintText: "Enter your phone number",
                              helperStyle: TextStyle(fontSize: 10.sp),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Multi(
                              color: Color.fromARGB(255, 91, 90, 90),
                              subtitle: "STREET,AREA,NEIGHBOURHOOD NAME ",
                              weight: FontWeight.w700,
                              size: 12),
                          SizedBox(
                            height: 7.h,
                          ),
                          TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                            controller: addres,
                            cursorColor: Color.fromARGB(255, 91, 90, 90),
                            decoration: InputDecoration(
                              hintText:
                                  "Ex :Rashid Minhas Road RJ mall 4th floor Karachi",
                              helperStyle: TextStyle(fontSize: 10.sp),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Multi(
                              color: Color.fromARGB(255, 91, 90, 90),
                              subtitle: "EMAIL",
                              weight: FontWeight.w700,
                              size: 12),
                          SizedBox(
                            height: 7.h,
                          ),
                          TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                            controller: mail,
                            cursorColor: Color.fromARGB(255, 91, 90, 90),
                            decoration: InputDecoration(
                              hintText: "EX:abc@xyz.com",
                              helperStyle: TextStyle(fontSize: 10.sp),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 91, 90, 90)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Multi(
                              color: Color.fromARGB(255, 91, 90, 90),
                              subtitle: "LABEL AS",
                              weight: FontWeight.w700,
                              size: 12),
                          SizedBox(
                            height: 7.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    value = "home";
                                  });
                                },
                                child: value != 'home'
                                    ? Container(
                                        height: 70.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(CupertinoIcons.house),
                                            Multi(
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48),
                                                subtitle: "Home",
                                                weight: FontWeight.w700,
                                                size: 13),
                                            Icon(
                                              CupertinoIcons.circle,
                                              size: 15.sp,
                                              color: Color.fromARGB(
                                                  255, 50, 48, 48),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 70.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color(0xffD7A563),
                                                width: 2.w)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              CupertinoIcons.house,
                                              color: Color(0xffD7A563),
                                            ),
                                            Multi(
                                                color: Color(0xffD7A563),
                                                subtitle: "Home",
                                                weight: FontWeight.w700,
                                                size: 13),
                                            Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 15.sp,
                                              color: Color(0xffD7A563),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    value = "work";
                                  });
                                },
                                child: value != 'work'
                                    ? Container(
                                        height: 70.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(CupertinoIcons.briefcase),
                                            Multi(
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48),
                                                subtitle: "Work",
                                                weight: FontWeight.w700,
                                                size: 13),
                                            Icon(
                                              CupertinoIcons.circle,
                                              size: 15.sp,
                                              color: Color.fromARGB(
                                                  255, 50, 48, 48),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 70.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color(0xffD7A563),
                                                width: 2.w)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              CupertinoIcons.briefcase,
                                              color: Color(0xffD7A563),
                                            ),
                                            Multi(
                                                color: Color(0xffD7A563),
                                                subtitle: "Work",
                                                weight: FontWeight.w700,
                                                size: 13),
                                            Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 15.sp,
                                              color: Color(0xffD7A563),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    value = "other";
                                  });
                                },
                                child: value != 'other'
                                    ? Container(
                                        height: 70.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(CupertinoIcons.add),
                                            Multi(
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48),
                                                subtitle: "other",
                                                weight: FontWeight.w700,
                                                size: 13),
                                            Icon(CupertinoIcons.circle,
                                                size: 15.sp,
                                                color: Color.fromARGB(
                                                    255, 50, 48, 48))
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 70.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color(0xffD7A563),
                                                width: 2.w)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              CupertinoIcons.add,
                                              color: Color(0xffD7A563),
                                            ),
                                            Multi(
                                                color: Color(0xffD7A563),
                                                subtitle: "Other",
                                                weight: FontWeight.w700,
                                                size: 13),
                                            Icon(
                                              CupertinoIcons
                                                  .check_mark_circled_solid,
                                              size: 15.sp,
                                              color: Color(0xffD7A563),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 15.0, // soften the shadow
                              spreadRadius: 5.0, //extend the shadow
                              offset: Offset(
                                5.0, // Move to right 5  horizontally
                                5.0, // Move to bottom 5 Vertically
                              ),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Multi(
                                    color: Color(0xffD7A563),
                                    subtitle: "Save",
                                    weight: FontWeight.w600,
                                    size: 18), // <-- Text
                                Icon(
                                  // <-- Icon
                                  Icons.arrow_forward,
                                  size: 24.0,
                                  color: Color(0xffD7A563),
                                ),
                              ],
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15.r), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Provider11.name = name.text;
                            // Provider11.phone=phone.text;
                            Provider11.address = addres.text;
                            // Provider11.email = mail.text;
                            if (_formKey.currentState!.validate()) {
                            } else {}
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}