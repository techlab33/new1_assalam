import 'package:assalam/data/models/premium_content/premium_content_data_model.dart';
import 'package:assalam/screens/premium_content_page/premium_conent_video_play_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllPage extends StatefulWidget {
  final PremiumContentDataModel premiumContentDataModel;
  final int categoryId;
  final String categoryName;
  // final int subCategoryId;
  const ViewAllPage({super.key, required this.premiumContentDataModel, required this.categoryId, required this.categoryName});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {


  @override
  Widget build(BuildContext context) {

    // Screen Size
    var screenSize = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [

                for(var category in widget.premiumContentDataModel.allCategories!)
                  for(var subCategory in category.subcategories!.where((element) => widget.categoryId == category.categoryId,))
                    InkWell(
                      onTap: (){
                        Get.to(PremiumContentVideoPlayPage(premiumContentDataModel: widget.premiumContentDataModel,categoryId: category.categoryId!,subCategoryId: subCategory.subcategoryId,));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                              image: DecorationImage(
                                image: NetworkImage(subCategory.image),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(subCategory.subcategoryName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
