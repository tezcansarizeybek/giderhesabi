import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giderhesabi/view/widgets/text_form_widget.dart';
import 'package:giderhesabi/viewmodel/expense_vm.dart';
import 'package:giderhesabi/viewmodel/location_vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

///This page is two-functional page, you can add&update in this page
///For updating, you have to pass [index] value, else it'll try to add
class ExpenseFormPage extends StatelessWidget {
  ExpenseFormPage({Key? key, this.index = -1}) : super(key: key);
  final int index;
  final c = Get.find<ExpenseVM>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormWidget(
                controller: c.controller.description,
                label: "Açıklama",
                validator: (val) {
                  if (val?.isEmpty ?? false) {
                    return "Bu Alanı Doldurunuz";
                  }
                },
              ),
              TextFormWidget(
                controller: c.controller.total,
                label: "Tutar",
                validator: (val) {
                  if (val == "") {
                    return "Bu Alanı Doldurunuz";
                  }
                  try {
                    if (double.parse(val ?? "") == 0) {
                      return "Sıfırdan Farklı Olmalıdır";
                    }
                  } catch (e) {
                    return "Bir Sayı Olmalıdır";
                  }
                },
                textInputType: const TextInputType.numberWithOptions(decimal: true),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: DropdownButtonFormField(
                  items: c.categoryList.map((element) => DropdownMenuItem(child: Text(element), value: element)).toList(),
                  value: c.controller.category.text,
                  decoration: InputDecoration(labelText: "Kategori", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                ),
              ),
              TextFormWidget(
                controller: c.controller.date,
                label: "Tarih",
                datePicker: true,
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                height: 40.0.h,
                child: Obx(
                  () => GoogleMap(
                    onTap: (v) {
                      Get.find<LocationVM>().markers.assignAll([]);
                      Get.find<LocationVM>().markers.add(Marker(
                            markerId: const MarkerId("Seçili"),
                            position: v,
                          ));
                      c.controller.gpsY = v.longitude;
                      c.controller.gpsX = v.latitude;
                    },
                    markers: Get.find<LocationVM>().markers.toSet(),
                    initialCameraPosition: CameraPosition(
                      target: Get.find<LocationVM>().latLng.value,
                      zoom: 10.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(index == -1 ? CupertinoIcons.add : CupertinoIcons.create),
        onPressed: () async {
          try {
            if (_formKey.currentState?.validate() ?? false) {
              if (index != -1) {
                await c.expenseUpdate(index);
              } else {
                await c.expenseAdd();
              }
              Get.back();
            }
          } catch (e, s) {
            throw Exception("$e $s");
          }
        },
      ),
    );
  }
}
