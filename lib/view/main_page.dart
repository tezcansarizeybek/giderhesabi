import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giderhesabi/view/expense_form_page.dart';
import 'package:giderhesabi/view/google_map_page.dart';
import 'package:giderhesabi/view/widgets/expense_list_widget.dart';
import 'package:giderhesabi/viewmodel/expense_vm.dart';
import 'package:giderhesabi/viewmodel/location_vm.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ExpenseVM());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gider Hesabım"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () async {
              await Get.find<LocationVM>().markerAdd();
              Get.to(() => const GoogleMapPage());
            },
          )
        ],
      ),
      body: GetBuilder<ExpenseVM>(
        initState: (_) async {
          Get.put(LocationVM());
          await Get.find<LocationVM>().getLocation();
          await Get.find<ExpenseVM>().openDb();
          await Get.find<ExpenseVM>().categoryGet();
          await Get.find<ExpenseVM>().expenseGet();
        },
        builder: (c) => Column(
          children: [
            Expanded(
              child: Obx(() => c.expenseStatus.value == ExpenseStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ExpenseListWidget()),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (Get.find<ExpenseVM>().selectedExpenses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: FloatingActionButton(
                  heroTag: "btn2",
                  child: const Icon(CupertinoIcons.delete),
                  onPressed: () {
                    Get.find<ExpenseVM>().expenseDeleteSelected();
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FloatingActionButton(
                heroTag: "btn1",
                child: const Icon(CupertinoIcons.add),
                onPressed: () {
                  Get.find<ExpenseVM>().controllerSet();
                  Get.to(() => ExpenseFormPage());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
