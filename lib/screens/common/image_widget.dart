import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:web_gallery/domain/models/image.dart' as ImageModel;
import 'package:web_gallery/screens/common/transitions/page_scale_transition.dart';
import 'package:web_gallery/screens/home/fullscreen_imageview.dart';


class ImageWidget extends StatefulWidget {
  final  ImageModel.Image image;
  final bool isFullSize;
  const ImageWidget({Key? key, required this.image, this.isFullSize = false}) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> with SingleTickerProviderStateMixin{



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      Size size = MediaQuery.of(context).size;
      if(widget.isFullSize){
        int width = widget.image.imageWidth ?? 1;
        int height = widget.image.imageHeight ?? 1;
        return AspectRatio(aspectRatio: width / height,
          child:
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.image.largeImageURL ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(child: Container(width: 30, height: 30, child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Icon(Icons.error),),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2), child:
                  IconButton(
                    iconSize: 40,
                    onPressed: (){
                      Navigator.of(context).pop(true);
                    }, icon: const Icon(Icons.cancel), color: Colors.white,)
                  ))

            ],
          ),);
      }else{
        return InkWell(
          onTap: (){
            Navigator.of(context).push(PageSizeTransition( FullScreenImage(image: widget.image)));
          },
          child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: widget.image.largeImageURL ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(child: Container(width: 30, height: 30, child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error), fadeInCurve: Curves.bounceInOut,),
              ),


        );
      }
    });
  }
}



// Widget likesAndViewsContainer(int likes, int views){
//   return Container(
//     width: double.infinity * 0.2,
//     decoration: BoxDecoration(
//       color: Colors.grey.withOpacity(0.7)
//     ),
//     child: Row(
//       children: [
//         Row(
//           children: [
//             Icon(Icons.favorite),
//             SizedBox(width: 5.0,),
//             Te
//           ],
//         )
//       ],
//     ),
//   );
// }
