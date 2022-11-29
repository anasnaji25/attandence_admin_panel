import 'dart:io';
import 'dart:async';
import 'package:attandence_admin_panel/constants/colllections_namings.dart';
import 'package:attandence_admin_panel/models/staff_model.dart';
import 'package:attandence_admin_panel/views/staff_management/staff_detsils_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffManagementController extends GetxController {
  List<StaffModel> staffList = [];

  writeToStaffmanagement(StaffModel staffModel) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(staffCollection);

    users.add(staffModel.toJson()).then((value) {
      Get.snackbar("Staff added successfully", "",
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.off(() => StaffListView());
    }).catchError((error) {
      Get.snackbar("Something went wrong", "",
          colorText: Colors.white, backgroundColor: Colors.red);
    });
  }

  getStaffs() async {
    staffList.clear();
    FirebaseFirestore.instance
        .collection(staffCollection)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc["full_name"]);
        StaffModel staffDetail = StaffModel(
          image: doc["full_name"],
          fullName: doc["full_name"],
          mobileNumber: doc["mobile_number"],
          gender: doc["gender"],
          address: doc["address"],
          email: doc["email"],
          dob: (doc["dob"] as Timestamp).toDate(),
          joiningDate: (doc["joining_date"] as Timestamp).toDate(),
          qualification: doc["qualification"],
          totalExperience: doc["totalExperience"],
          designation: doc["designation"],
          esi: doc["esi"],
          aadharCardNumber: doc["aadhar_card_number"],
          aadharCardImage: doc["aadhar_card_image"],
          panCardImage: doc["pan_card_image"],
          panCardNumber: doc["pan_card_number"],
        );
        staffList.add(staffDetail);
      }
      update();
    });
  }

  Future<String> storeImage(
      {required String images,
      required String employeename,
      required String imageName}) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child("Employees/$employeename$imageName");
    await storageReference.putFile(File(images));
    final String url = await storageReference.getDownloadURL();
    return url;
  }
}