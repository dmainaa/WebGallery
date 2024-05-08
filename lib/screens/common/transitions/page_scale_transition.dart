import 'package:flutter/cupertino.dart';

class PageSizeTransition extends PageRouteBuilder{

  dynamic page;
  PageSizeTransition(this.page): super(
      pageBuilder: (context, animation, secondaryAnimation)=>page,
      transitionsBuilder: (context, animation, secondaryAnimation, child){

        return Align(
          alignment: Alignment.center,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500)
  );

}