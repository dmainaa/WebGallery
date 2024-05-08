import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_gallery/app/constants/app_strings.dart';
import 'package:web_gallery/domain/providers/images/images_provider.dart';
import 'package:web_gallery/screens/common/image_widget.dart';
import 'package:web_gallery/screens/common/responsive_widget.dart';

import '../common/error_widget.dart';
import '../common/loading_widget.dart';
import 'package:web_gallery/domain/models/image.dart' as ImageModel;


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {

  int gridCount = 3;

  final ScrollController _controller = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  Timer? _timer;

  List<ImageModel.Image> allImages = [];

  bool isSearch = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(_scrollListener);

  }



  @override
  Widget build(BuildContext context) {
    gridCount = getGridCount(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: Row(
          children: [

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(AppString.gallery, style:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18, color: Colors.white),),
                ) ,
            const Expanded(child: SizedBox()),
            Container(
              width: getSearchbarWidth(context),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: const Color(0xFF4946DB)),
              child:  TextField(
                onChanged: onTextChangedListener,
                controller: _searchController,
                decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    hintText: AppString.searchImages,
                    hintStyle: const TextStyle(color: Colors.white),
                    helperStyle: const TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      onPressed: (){
                        if(_searchController.text.isNotEmpty){
                          _searchController.text = "";
                          isSearch = true;
                          ref.read(imagesStateNotifierProvider.notifier).dismissSearch();
                          _scrollToBeginning();
                        }
                      },
                      icon: const Icon(Icons.cancel,),
                      color: Colors.grey,
                    )),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
              ),
            ),


          ],
        ),

      ),
      body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            var imagesState = ref.watch(imagesStateNotifierProvider);
            return Builder(builder: (context) {
              if (imagesState.isLoading ?? false) {
                return const LoadingWidget();
              } else if (imagesState.isError ?? false) {
                return MErrorWidget(
                    errorMessage: imagesState.errorMessage ?? "");
              } else {

                allImages = imagesState.images ?? [];
                if(allImages.isEmpty && isSearch){
                  return MErrorWidget(
                    errorMessage: AppString.failedToFetchImages, onRetryClicked: (){
                    ref.read(imagesStateNotifierProvider.notifier).getImages();
                  }, showButton: false,);
                }else{
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: GridView.builder(
                      controller: _controller,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: allImages.length,
                      itemBuilder: (context, index) {
                        var image = allImages[index];
                        return LayoutBuilder(builder: (context, constraints){
                              return Card(
                                elevation: 5,
                                  child: Column(children: [
                                    SizedBox(width: constraints.maxWidth,
                                    height: constraints.maxWidth * 0.8, child: ImageWidget(image: image,),),
                                    SizedBox(
                                      height: constraints.maxWidth * 0.15,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                               Align(alignment: Alignment.center, child: Icon(Icons.favorite, color: Colors.lightBlue,size: getIconSize(context), )),
                                              const SizedBox(width: 5,),
                                              Align(alignment: Alignment.center, child: Text(image.likes.toString(), style: Theme.of(context).textTheme.bodySmall,)),
                                              const SizedBox(width: 10,),
                                               Icon(Icons.remove_red_eye, color: Colors.lightBlue,size: getIconSize(context)),
                                              const SizedBox(width: 5,),
                                              Align(alignment: Alignment.center, child: Text(image.views.toString(), style: Theme.of(context).textTheme.bodySmall,))
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]));
                            },


                        );
                      },
                    ),
                  );
                }
              }
            });
          }
      ),
    );
  }

  void onTextChangedListener(String text){
    if(_timer != null){
      _timer?.cancel();
    }

    if(text.isEmpty){
      //dismiss the current search results
      ref.read(imagesStateNotifierProvider.notifier).dismissSearch();
    }else{

      _timer = Timer(const Duration(milliseconds: 1000), () {
       //perform search for the query
        isSearch = true;
        ref.read(imagesStateNotifierProvider.notifier).getImages(isSearch: true, query: text);
        _scrollToBeginning();

      });
    }
  }


  void _scrollListener() {
    if (!_controller.position.atEdge) return;
    if (_controller.offset >= _controller.position.maxScrollExtent * 0.75) {
      //when the user scrolls to 3/4 of the list, load more images
      ref.read(imagesStateNotifierProvider.notifier).loadMore();
    }
  }


  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _controller.removeListener(_scrollListener);
    _controller.dispose();

  }

  _scrollToBeginning() {
    _controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  int getGridCount(BuildContext context){
    if(ResponsiveWidget.isMobile(context)){
      return 2;
    }else if(ResponsiveWidget.isTablet(context)){
      return 3;
    }else if(ResponsiveWidget.isLaptop(context)){
      return 4;
    }else {
      return 5;
    }
  }

  double getIconSize(BuildContext context){
    if(ResponsiveWidget.isMobile(context)){
      return 20;
    }else if(ResponsiveWidget.isTablet(context)){
      return 25;
    }else if(ResponsiveWidget.isLaptop(context)){
      return 29;
    }else {
      return 29;
    }
  }

  double getSearchbarWidth(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    if(ResponsiveWidget.isMobile(context)){
      return width * 0.65;
    }else if(ResponsiveWidget.isTablet(context)){
      return width * 0.6;
    }else if(ResponsiveWidget.isLaptop(context)){
      return width * 0.45;
    }else {
      return width * 0.4;
    }
  }


}
