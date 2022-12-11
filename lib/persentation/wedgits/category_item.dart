import 'package:flutter/material.dart';
import 'package:shormeh_delivery/theme.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
final  bool active;
  const CategoryItem({Key? key,required this.title,required this.image,required this.color,required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;

    return Container(
      height: size.height * .13,
      width: size.width * .23,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey
                  .withOpacity(0.3),
              offset: const Offset(1.1, 4.0),
              blurRadius: 8.0),
        ],

        borderRadius:  BorderRadius.circular(10),
        border: Border.all(color: color,width: active== true? 3: 1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,height: size.height * .06,),
          SizedBox(height: size.height * .01,),
          Text(title,
          style: TextStyle(
           // fontFamily: fontName,
            fontWeight: FontWeight.bold,
            fontSize: size.width * .04,
            letterSpacing: 0.18,
            height: size.height *.0025,
            color: AppTheme.darkerText,
          )),
        ],
      ),
    );
  }
}
