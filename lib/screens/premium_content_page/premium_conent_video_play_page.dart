

import 'package:assalam/data/models/premium_content/premium_content_data_model.dart';
import 'package:assalam/utils/constants/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PremiumContentVideoPlayPage extends StatefulWidget {
  final PremiumContentDataModel premiumContentDataModel;
  final int categoryId;
  final int subCategoryId;

  PremiumContentVideoPlayPage({
    Key? key,
    required this.premiumContentDataModel,
    required this.categoryId,
    required this.subCategoryId,
  }) : super(key: key);

  @override
  State<PremiumContentVideoPlayPage> createState() =>
      PremiumContentVideoPlayPageState();
}

class PremiumContentVideoPlayPageState
    extends State<PremiumContentVideoPlayPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // Initialize with a placeholder video
    _initializeVideoPlayerController('');
  }

  void _initializeVideoPlayerController(String videoUrl) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      // Define other ChewieController properties as needed
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final categories = widget.premiumContentDataModel.allCategories;

    if (categories == null || categories.isEmpty) {
      return Center(
        child: Text(
          'Data not available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    final subcategories = categories
        .expand((category) => category.subcategories!)
        .where((subcategory) => subcategory.categoryId == widget.categoryId)
        .toList();

    if (subcategories.isEmpty) {
      return Center(
        child: Text(
          'Data not available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    final contents = subcategories
        .expand((subcategory) => subcategory.contents)
        .where((content) => content.subcategoryId == widget.subCategoryId)
        .toList();

    if (contents.isEmpty) {
      return Center(
        child: Text(
          'Data not available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      children: contents.map((content) {
        if (content.videoLink.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // Ensure the height is set to the desired value for the video player
                height: MediaQuery.of(context).size.width * (9 / 16), // Assuming 16:9 aspect ratio
                width: double.infinity,
                child: Chewie(
                  controller: ChewieController(
                    videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(content.videoLink)),
                    aspectRatio: 16 / 9, // Adjust aspect ratio as per your video's aspect ratio
                    autoPlay: true,
                    looping: false,
                    allowFullScreen: true,
                    materialProgressColors: ChewieProgressColors(
                      playedColor: Colors.red,
                      handleColor: Colors.blue,
                      backgroundColor: Colors.grey,
                      bufferedColor: Colors.green,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(content.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Text(content.description ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }
}


