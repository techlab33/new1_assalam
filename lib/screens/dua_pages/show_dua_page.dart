import 'package:assalam/data/models/dua_model/dua_data_model.dart';
import 'package:assalam/data/services/dua/dua_fev_check_note_data.dart';
import 'package:assalam/controller/language_controller.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

class ShowDuaPage extends StatefulWidget {
  ShowDuaPage({
    super.key,
    required this.duaDataModel,
    required this.categoryID,
    required this.subCategoryID,
    required this.subCategoryName,
  });

  DuaDataModel duaDataModel;
  String categoryID;
  String subCategoryID;
  String subCategoryName;

  @override
  State<ShowDuaPage> createState() => _ShowDuaPageState();
}

class _ShowDuaPageState extends State<ShowDuaPage> {

  final translator = GoogleTranslator();
  late String targetLanguage;

  @override
  void initState() {
    _updateTargetLanguage();
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
    // Text Editing Controller
    final TextEditingController noteController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryName),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [

              for (final category in widget.duaDataModel.allCategories!)
                for (final subcategory in category.subCategories.where((element) => element.categoryId == widget.categoryID))
                  for (final dua in subcategory.doas.where((element) => element.doaSubCategoryId == widget.subCategoryID))
                    Card(
                      elevation: 3,
                      shadowColor: TColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          children: [
                            Text(dua.doa, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500), textAlign: TextAlign.right),
                            FutureBuilder<Translation>(
                              future: translator.translate(dua.doaTranslate ?? '', from: 'auto', to: targetLanguage),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final translatedText = snapshot.data!.text;
                                  return Text(translatedText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            FutureBuilder<Translation>(
                              future: translator.translate(dua.doaDescription , from: 'auto', to: targetLanguage),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final translatedText = snapshot.data!.text;
                                  return Text(translatedText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: ()  {
                                    String newFavoriteValue = dua.isFavorite == '1' ? '0' : '1'; // Toggle the value
                                    DuaFevCheckNote().duaFavoriteData(dua.id, newFavoriteValue);
                                    setState(() {
                                      dua.isFavorite = newFavoriteValue; // Update the state with the new value
                                    });
                                  },
                                  icon: Icon(dua.isFavorite == '1' ? Icons.favorite : Icons.favorite_border , color: dua.isFavorite == '1' ? Colors.red : Colors.black54, size: 28),
                                ),
                                IconButton(
                                  onPressed: () {
                                    String newCheckValue = dua.isChecked == '1' ? '0' : '1'; // Toggle the value
                                    DuaFevCheckNote().duaCheckData(dua.id!, newCheckValue);
                                    setState(() {
                                      dua.isChecked = newCheckValue; // Update the state with the new value
                                    });
                                  },
                                  icon: Icon(dua.isChecked == '1' ? Icons.check_box_outlined : Icons.check_box_outline_blank ,color: dua.isChecked == '1' ? Colors.green : Colors.black54, size: 28),
                                ),
                                // IconButton(
                                //   onPressed: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return AlertDialog(
                                //           title: Text('Write your notes!', style: TextStyle(fontSize: 16)),
                                //           content: Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: [
                                //               TextField(
                                //                 controller: noteController,
                                //                 decoration: InputDecoration(border: InputBorder.none),
                                //                 textInputAction: TextInputAction.newline,
                                //                 maxLines: 5,
                                //                 autofocus: true,
                                //               ),
                                //               SizedBox(height: 20),
                                //               Row(
                                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                 children: [
                                //                   TextButton(
                                //                     onPressed: () {
                                //                       Navigator.of(context).pop();
                                //                     },
                                //                     child: Text('Cancel', style: TextStyle(fontSize: 16)),
                                //                   ),
                                //                   TextButton(
                                //                     onPressed: () {
                                //                       DuaFevCheckNote().duaNoteData(dua.id, noteController.text.toString());
                                //                       Navigator.of(context).pop();
                                //                       setState(() {});
                                //                     },
                                //                     child: Text('Save', style: TextStyle(fontSize: 16)),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ],
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   },
                                //   // icon: Icon(Icons.edit, color: (dua.note != null && dua.note.isNotEmpty) ? Colors.green : Colors.black54 , size: 28),
                                //   icon: Icon(Icons.edit, color: dua.note == "" ? Colors.black54 : Colors.green , size: 28),
                                // ),
                                IconButton(
                                  onPressed: () {
                                    Share.share('${dua.doa}\n\n${dua.doaTranslate}\n\n${dua.doaDescription}');
                                  },
                                  icon: Icon(Icons.share ,color: Colors.black54, size: 28),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      )),
    );
  }
}
