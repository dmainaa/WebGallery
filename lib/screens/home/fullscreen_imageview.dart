import 'package:flutter/material.dart';

import 'package:web_gallery/domain/models/image.dart' as ImageModel;
import 'package:web_gallery/screens/common/image_widget.dart';

class FullScreenImage extends StatefulWidget {
  final ImageModel.Image image;
  const FullScreenImage({Key? key, required this.image}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: Center(
        child: ImageWidget(image: widget.image, isFullSize: true,),),
    );
  }
}
