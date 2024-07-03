import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/data/models/premium_content/premium_content_data_model.dart';
import 'package:assalam/data/services/premium_content/premium_content_data.dart';
import 'package:assalam/screens/premium_content_page/premium_conent_video_play_page.dart';
import 'package:assalam/screens/premium_content_page/view_all_page.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class PremiumContentPage extends StatefulWidget {
  const PremiumContentPage({Key? key}) : super(key: key);

  @override
  _PremiumContentPageState createState() => _PremiumContentPageState();
}

class _PremiumContentPageState extends State<PremiumContentPage> {
  final premiumContentData = PremiumContentGetData();
  final translator = GoogleTranslator();
  late String targetLanguage;

  @override
  void initState() {
    _updateTargetLanguage();
    premiumContentData.fetchPremiumContentData();
    super.initState();
  }

  void _updateTargetLanguage() {
    final languageController = Get.put(LanguageController());
    targetLanguage = languageController.language;
    languageController.languageStream.listen((language) {
      setState(() {
        targetLanguage = language;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Translation>(
          future: translator.translate('Educational Resource', from: 'auto', to: targetLanguage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final translatedText = snapshot.data!.text;
              return Text(
                translatedText,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          },
        ),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<PremiumContentDataModel>(
                    future: premiumContentData.fetchPremiumContentData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: EdgeInsets.only(top: screenSize.height / 3.94),
                          child: Center(child: CircularProgressIndicator(color: Colors.green)),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('No data available');
                      } else {
                        final PremiumContentDataModel premiumContentDataModel = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: premiumContentDataModel.allCategories!.map((category) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(category.categoryName!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                                    InkWell(onTap: () => Get.to(ViewAllPage(premiumContentDataModel: premiumContentDataModel,categoryId: category.categoryId!,categoryName: category.categoryName!,)),child: Text('View All', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: TColors.primaryColor))),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 180,
                                  child: ListView.builder(
                                    itemCount: category.subcategories!.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var subcategory = category.subcategories![index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(PremiumContentVideoPlayPage(premiumContentDataModel: premiumContentDataModel, categoryId: category.categoryId!, subCategoryId: subcategory.subcategoryId,));
                                            },
                                            child: Container(
                                              height: 130,
                                              width: 200,
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.blue,
                                                image: DecorationImage(
                                                  image: NetworkImage(subcategory.image),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(subcategory.subcategoryName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
