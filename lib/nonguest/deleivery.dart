import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/nonguest/change.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';

import 'package:glass/glass.dart';
import 'package:intl/intl.dart';

import '../pages/cartList.dart';
import '../provider/provider1.dart';
import '../utils/multiText.dart';
import '../utils/udelinedMulti.dart';



class NDelievery extends StatelessWidget {
  const NDelievery({super.key});

  @override
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
         leading: GestureDetector(
            onTap: () async {
           
            },
            child: Container(
                                  height: 30.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromARGB(255, 31, 30, 30),
                                      Color.fromARGB(255, 54, 53, 53),
                                    ]),
                                    borderRadius: BorderRadius.circular(5.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 54, 53, 53),
                                        offset: const Offset(0, 0),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
            Color.fromARGB(255, 31, 30, 30),
            Color.fromARGB(255, 54, 53, 53),
            ]
          )
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.white, subtitle: "Delievery", weight: FontWeight.bold, size: 21),
                    Container()
                  ],
                ),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.white, subtitle: "Deliever To", weight: FontWeight.bold, size: 12),
                    Container()
                  ],
                ),
                SizedBox(height: 5.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 27.r,
                      backgroundColor: Colors.white,   
                      backgroundImage:Provider11.imgAddress==null?AssetImage("assets/user.png"):AssetImage(Provider11.imgAddress.toString()),
                    ),
                    SizedBox(width: 5.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Multi(color: Colors.white, subtitle: "${Provider11.name}", weight: FontWeight.bold, size: 12),
                        Multi(color: Colors.grey, subtitle: "${Provider11.gmail}", weight: FontWeight.bold, size: 12),
                      ],
                    )
                  ],
                ),
                
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.white, subtitle: "Details", weight: FontWeight.bold, size: 12),
                    GestureDetector(
                      onTap: ()async{
                          await   Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                NPaymentEdit()));
                      },
                      child: Multi(color: Colors.red, subtitle: "modify", weight: FontWeight.bold, size: 12))
                  ],
                ),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/loc.png",height: 25.h,width: 25.w,)),
                        SizedBox(width: 5.w,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Multi(color: Colors.white, subtitle: "Deleivery Address", weight: FontWeight.bold, size: 12),
                            Container(
                              width: 250.w,
                              child: Multi(color: Colors.grey, subtitle: "${Provider11.address}", weight: FontWeight.normal, size: 12)),
                          ],
                        )
                      ],
                    ),
                    UndeLinedMulti(color: Color(0xffCC0006), subtitle: "", weight: FontWeight.bold, size: 12)
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/time.png",height: 25.h,width: 25.w,)),
                        SizedBox(width: 5.w,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Multi(color: Colors.white, subtitle: "Deleivery Time", weight: FontWeight.bold, size: 12),
                            Container(
                              width: 250.w,
                              child: Multi(color: Colors.grey, subtitle: "${Provider11.time}", weight: FontWeight.normal, size: 12)),
                          ],
                        )
                      ],
                    ),
                    UndeLinedMulti(color: Color(0xffCC0006), subtitle: "", weight: FontWeight.bold, size: 12)
                  ],
                ),
                SizedBox(height: 20.h,),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/phone.png",height: 25.h,width: 25.w,)),
                        SizedBox(width: 5.w,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Multi(color: Colors.white, subtitle: "Phone Number", weight: FontWeight.bold, size: 12),
                            Container(
                              width: 250.w,
                              child: Multi(color: Colors.grey, subtitle: "${Provider11.number}", weight: FontWeight.normal, size: 12)),
                          ],
                        )
                      ],
                    ),
                    UndeLinedMulti(color: Color(0xffCC0006), subtitle: "", weight: FontWeight.bold, size: 12)
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/card.png",height: 25.h,width: 25.w,)),
                        SizedBox(width: 5.w,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Multi(color: Colors.white, subtitle: "Payment Method", weight: FontWeight.bold, size: 12),
                            Container(
                              width: 250.w,
                              child: Multi(color: Colors.grey, subtitle: "${Provider11.method}", weight: FontWeight.normal, size: 12)),
                          ],
                        )
                      ],
                    ),
                    UndeLinedMulti(color: Color(0xffCC0006), subtitle: "", weight: FontWeight.bold, size: 12)
                  ],
                ),
                 SizedBox(height: 9.h,),
                Divider(color: Colors.white,thickness: 2,),
                SizedBox(height: 9.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.white, subtitle: "${Provider11.itemLength} Products", weight: FontWeight.bold, size: 12),
                    GestureDetector(
                      onTap: ()async{
                           await   Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                CartList()));
                      },
                      child: UndeLinedMulti(color: Colors.red, subtitle: "view all", weight: FontWeight.bold, size: 12))
                  ],
                ),
                  SizedBox(height: 9.h,),
                Divider(color: Colors.white,thickness: 2,),
                SizedBox(height: 9.h,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.grey, subtitle: "Sub Total", weight: FontWeight.bold, size: 12),
                    UndeLinedMulti(color: Colors.grey, subtitle: "${Provider11.priceSum}", weight: FontWeight.bold, size: 12)
                  ],
                ),
                SizedBox(height: 20.h,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.grey, subtitle: "Delievery Fee", weight: FontWeight.bold, size: 12),
                    UndeLinedMulti(color: Colors.grey, subtitle: "100", weight: FontWeight.bold, size: 12)
                  ],
                ),
                SizedBox(height: 20.h,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Multi(color: Colors.grey, subtitle: "Total", weight: FontWeight.bold, size: 12),
                    UndeLinedMulti(color: Colors.white, subtitle: "${Provider11.priceSum}", weight: FontWeight.bold, size: 16)
                  ],
                ),
                 SizedBox(height: 20.h,),
                 Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10.r)),
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Multi(
                              color: Colors.white,
                              subtitle: "Place Order",
                              weight: FontWeight.w600,
                              size: 18), // <-- Text
                          Icon(Icons.arrow_forward,color: Colors.white,)
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffCC0006),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        // <-- Radius
                      ),
                    ),
                    onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final orderCollectionRef=  db.collection("orders").doc(Provider11.uid).collection("suborders").doc()
          ;
      for (var i = 0; i < Provider11.items_in_cart!.length; i++) {
         orderCollectionRef.collection("orderss").doc().set({
            "obj":Provider11.items_in_cart![i].id
      });
      }
      
                    },
                  )
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



