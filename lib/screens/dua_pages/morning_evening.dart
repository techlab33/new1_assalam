import 'package:assalam/data/models/dua_model/dua_data_model.dart';
import 'package:assalam/screens/dua_pages/show_dua_page.dart';
import 'package:assalam/screens/dua_pages/widgets/dua_list_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MorningAndEveningPage extends StatelessWidget {
  MorningAndEveningPage({super.key, required this.categoryName, required this.duaDataModel, required this.categoryID});

  String categoryName;
  DuaDataModel duaDataModel;
  String categoryID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                for (final category in duaDataModel.allCategories!)
                  for (final subcategory in category.subCategories!.where((element) => element.categoryId == categoryID))
                    DuaListCard(
                      onPressed: () => Get.to(ShowDuaPage(
                        categoryID: category.id.toString(),
                        duaDataModel: duaDataModel,
                        subCategoryID: subcategory.id.toString(),
                        subCategoryName: subcategory.subCategoryName ?? '',
                      )),
                      number: subcategory.id.toString(),
                      text: subcategory.subCategoryName ?? '',
                    ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

