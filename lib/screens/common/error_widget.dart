import 'package:flutter/material.dart';
import 'package:web_gallery/screens/common/responsive_widget.dart';

import '../../app/constants/app_strings.dart';



class MErrorWidget extends StatelessWidget {
  final String errorMessage;
  final bool showButton;
  final Function()? onRetryClicked;

  const MErrorWidget(
      {Key? key, required this.errorMessage, this.showButton = true, this.onRetryClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, size: 250, color: Colors.grey,),
              Text(errorMessage, style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,),
              const SizedBox(height: 20,),
              showButton ? Container(
                height: 50,
                width: getButtonWidth(size.width, context),

                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor), // Set the background color
                  ),
                    child: Text(AppString.retry, style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white)),
                    onPressed: () {
                      onRetryClicked!();
                    },

                ),


              ) : Container(),
            ]));
  }

  double getButtonWidth(double width, BuildContext context){
    if(ResponsiveWidget.isMobile(context)){
      return width * 0.5;
    }else if(ResponsiveWidget.isTablet(context)){
      return width * 0.3;
    }else if(ResponsiveWidget.isLaptop(context)){
      return width * 0.2;
    }else {
      return width * 0.1;
    }
  }
}