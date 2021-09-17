import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giderhesabi/viewmodel/expense_vm.dart';
import 'package:sizer/sizer.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses By Category"),
      ),
      body: GetBuilder<ExpenseVM>(
        builder: (c) => GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100.0.sp,
          ),
          itemBuilder: (context, index) => Card(),
        ),
      ),
    );
  }
}
