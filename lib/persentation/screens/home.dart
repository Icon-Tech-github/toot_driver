import 'package:countup/countup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shormeh_delivery/local_storage.dart';
import 'package:shormeh_delivery/persentation/screens/change_pass.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../bloc/home_bloc/order_cubit.dart';
import '../../bloc/order_details_bloc/order_details_cubit.dart';
import '../../data/ServerConstants.dart';
import '../../data/models/order.dart';
import '../../data/reposetories/Order_details_repo.dart';
import '../../data/reposetories/auth_repo.dart';
import '../../data/reposetories/home_repo.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../wedgits/category_item.dart';
import '../wedgits/default_button.dart';
import '../wedgits/loading.dart';
import '../wedgits/order_item.dart';
import 'login.dart';
import 'order_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  fcmNotification() async {


print("lllllllllllllll");
print("lllllllllllllll");

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print("33333");

      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      if (notification != null && android != null) {
        LocalStorage.getData(key: 'lang') == 'en'?
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            message.data['title_en'],
            message.data['description_en'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                message.data['title_en'],
                message.data['description_en'],
                icon: '@mipmap/ic_launcher',
              ),
            )):
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            message.data['title_ar'],
            message.data['description_ar'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                message.data['title_ar'],
                message.data['description_ar'],
                icon: '@mipmap/ic_launcher',
              ),
            ));
        print(message.data['description_en'].toString()+"kjjjjjjjjjjj");

        if (notification != null) {
          showSimpleNotification(
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  BlocProvider<OrderDetailsCubit>(
                      create: (BuildContext context) => OrderDetailsCubit(OrderDetailsRepo(), int.parse(message.data['order_id'].toString())),
                      child: OrderDetailsScreen()),));
                  // push(
                  //   context,
                  //   BlocProvider<NotificationCubit>(
                  //       create: (BuildContext
                  //       context) =>
                  //           NotificationCubit(
                  //               NotificationRepo()),
                  //       child:
                  //       NotifyScreen()),
                  // );
                },
                child: Container(
                  height: 65,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: [
                          Text(
                            LocalStorage.getData(key: 'lang') ==
                                'en' ? message.data['title_en'] : message
                                .data['title_ar'],
                            style: TextStyle(
                                color: AppTheme.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   message.notification!.body!,
                          //   style: TextStyle(
                          //       color: HomePage.colorGreen,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ],
                      )),
                ),
              ),
              duration: Duration(seconds: 3),
              background: AppTheme.white,
              elevation: 3
          );
          print("kkkkkkkkkkkkkkkk");
          OrderCubit.categoryNum=1;
          context.read<OrderCubit>().page=1;
          context.read<OrderCubit>().newOrderOnLoad();
        }

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              MultiBlocProvider(
                providers: [
                  BlocProvider<OrderCubit>(
                    create: (BuildContext context) =>
                        OrderCubit(GetHomeRepository()),
                  ),
                  BlocProvider<AuthCubit>(
                    create: (BuildContext context) =>
                        AuthCubit(AuthRepo()),
                  ),
                ],
                child: HomeScreen(),
              ),
        ),
      );
    });

  }
@override
  void initState() {
  fcmNotification();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer:
        BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
      if (state is AuthFailure) {
        ServerConstants.showDialog1(context, state.error);
      } else if (state is AuthSuccess) {
        showTopSnackBar(
            context,
            Card(
              child: CustomSnackBar.success(
                message: LocaleKeys.logout_success.tr(),
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black, fontSize: size.height * 0.02),
              ),
            ));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>  BlocProvider(
                create: (BuildContext context) =>
                    AuthCubit(AuthRepo()),
                child: LoginScreen())));

            //MultiBlocProvider(
        //       providers: [
        //         BlocProvider<HomeAdCubit>(
        //           create: (BuildContext context) =>
        //               HomeAdCubit(GetHomeRepository()),
        //         ),
        //         BlocProvider<DepartmentsCubit>(
        //           create: (BuildContext context) =>
        //               DepartmentsCubit(GetHomeRepository(),false,context,context.locale.toString()),
        //         ),
        //       ],
        //       child: BottomNavBar(branches: BranchesCubit.branches,),
        //     ),
        //   ),
        // );
      } else if (state is AuthLoading) {
        LoadingScreen.show(context);
      }
    },
    builder: (context, state) =>
      Drawer(
        // shape:  const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(30),
        //       bottomLeft: Radius.circular(30)),
        // ),
        width: size.width * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: size.height * .42,
                width: double.infinity,
                color: AppTheme.secondary,
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                    child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * .2,
                            height: size.width * .2,
                            decoration: BoxDecoration(
                                color: AppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(LocalStorage.getData(key: "image")??""),
                                ),
                                border: Border.all(
                                    color: Colors.white,width: 3)),
                            // child:  Center(
                            //   child: Text(LocalStorage.getData(key: "userName").toString()[0].toUpperCase(),
                            //       style: TextStyle(
                            //         // fontFamily: fontName,
                            //          fontWeight: FontWeight.bold,
                            //         fontSize: size.width * .08,
                            //         letterSpacing: 0.18,
                            //         //height: size.height * .001,
                            //
                            //         color: AppTheme.nearlyBlack,
                            //       )),
                            // ),
                            // child: CircleAvatar(
                            //     radius: 48,
                            //   child: Image.asset("assets/images/introo.jpg",fit: BoxFit.fill,)
                            // ),
                          ),
                          SizedBox(
                            width: size.width * .04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocalStorage.getData(key: "userName")??"",
                                  style: TextStyle(
                                    height: size.height * .002,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * .065,
                                    letterSpacing: 0.18,
                                    color: AppTheme.white,
                                  )),
                              // SizedBox(
                              //   height: size.height * .01,
                              // ),
                              Text(LocalStorage.getData(key: "phone"),
                                  style: TextStyle(
                                    // fontFamily: fontName,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: size.width * .03,
                                    letterSpacing: 0.18,
                                    height: size.height * .001,

                                    color: AppTheme.white,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                     SizedBox(height: size.height * .04,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.done_outline_outlined,
                              size:  size.height * .05,
                              color: Colors.white,
                            ),
                            //Image.asset("assets/images/target.png",height: size.height * .05,color: Colors.white,),
                            Countup(
                              begin: 0,
                              end: double.parse(OrderCubit.deliveredOrders.toString()),
                              curve: Curves.easeOut,
                              duration: Duration(seconds: 1),
                              separator: ',',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * .07,
                                letterSpacing: 0.18,
                                height:  size.height * .003,
                                color: AppTheme.white,
                              ),
                            ),
                            // Text(OrderCubit.deliveredOrders.toString(),
                            //     style: TextStyle(
                            //       // fontFamily: fontName,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: size.width * .07,
                            //       letterSpacing: 0.18,
                            //       height:  size.height * .003,
                            //       color: AppTheme.nearlyBlack,
                            //     )),
                            Text(LocaleKeys.success.tr(),
                                style: TextStyle(
                                  // fontFamily: fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * .04,
                                  letterSpacing: 0.18,
                                  height:  size.height * .00001,
                                  color: Colors.white.withOpacity(.5),
                                )),
                          ],
                        ),
                        Column(
                          children: [
                            // Icon(
                            //   Icons.close,
                            //   size:  size.height * .06,
                            //   color: Colors.white,
                            // ),
                            Image.asset("assets/images/close.png",height: size.height * .04,color: Colors.white,),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Countup(
                              begin: 0,
                              end: double.parse(OrderCubit.refusedOrders.toString()),
                              curve: Curves.easeOut,
                              duration: Duration(seconds: 1),
                              separator: ',',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                      fontSize: size.width * .07,
                                      letterSpacing: 0.18,
                                      height:  size.height * .003,
                                      color: AppTheme.white,
                              ),
                            ),
                            // Text("5",
                            //     style: TextStyle(
                            //       // fontFamily: fontName,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: size.width * .07,
                            //       letterSpacing: 0.18,
                            //       height:  size.height * .003,
                            //       color: AppTheme.nearlyBlack,
                            //     )),
                            Text(LocaleKeys.rejected.tr(),
                                style: TextStyle(
                                  // fontFamily: fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * .04,
                                  letterSpacing: 0.18,
                                  height:  size.height * .00001,
                                  color: Colors.white.withOpacity(.5),
                                )),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.warning_amber_outlined,
                              size:  size.height * .05,
                              color: Colors.white,
                            ),
                         //   Image.asset("assets/images/failed.png",height: size.height * .06,color: Colors.white,),
                            Countup(
                              begin: 0,
                              end: double.parse(OrderCubit.failedOrders.toString()),
                              curve: Curves.easeOut,
                              duration: Duration(seconds: 1),
                              separator: ',',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * .07,
                                letterSpacing: 0.18,
                                height:  size.height * .003,
                                color: AppTheme.white,
                              ),
                            ),
                            Text(LocaleKeys.failed.tr(),
                                style: TextStyle(
                                  // fontFamily: fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * .04,
                                  letterSpacing: 0.18,
                                  height:  size.height * .00001,
                                  color: Colors.white.withOpacity(.5),
                                )),
                          ],

                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(LocaleKeys.stats.tr(),
                            style: TextStyle(
                              // fontFamily: fontName,
                              // fontWeight: FontWeight.bold,
                              fontSize: size.width * .04,
                              letterSpacing: 0.18,
                              height: size.height * .001,

                              color: AppTheme.white.withOpacity(.4),
                            )),
                      ),
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(
              height: size.height * .04,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                       ( LocalStorage.getData(key: "lastStatus")??true)==true? Icons.wifi_tethering_rounded:Icons.portable_wifi_off_outlined,
                        color: AppTheme.secondary,
                      ),
                      SizedBox(
                        width: size.width * .02,
                      ),
                      Text(LocaleKeys.available.tr(),
                          style: TextStyle(
                            // fontFamily: fontName,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * .05,
                            letterSpacing: 0.18,
                            color: AppTheme.darkerText,
                          )),
                    ],
                  ),
                  FlutterSwitch(
                    width:  size.width * .18,
                    height:  size.height * .05,
                    //valueFontSize: 20.0,
                    toggleSize: 25.0,
                    value: LocalStorage.getData(key: "lastStatus")??true,
                    borderRadius: 30.0,
                    padding: 8.0,
                   // showOnOff: true,
                    onToggle: (val)async {
                      print(LocalStorage.getData(key: "lastStatus"));
                    await  context.read<AuthCubit>().available(context);
                       setState(() {
                      //   context.read<AuthCubit>().availability = val;
                       });
                      print(LocalStorage.getData(key: "lastStatus"));
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()async{
                if (context.locale.toString() == 'ar') {
                  LocalStorage.saveData(key: "lang", value: 'en');
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // prefs.setString("lang", "en");
                  await context.setLocale(
                    Locale("en"),
                  );
                //  OrderCubit.categoryNum ==1;
                } else {
                  LocalStorage.saveData(key: "lang", value: 'ar');

                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // prefs.setString("lang", "ar");
                  await context.setLocale(
                    Locale("ar"),
                  );
              //    OrderCubit.categoryNum ==1;
                }
                context.read<AuthCubit>().changeLang();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: AppTheme.secondary,
                    ),
                    SizedBox(
                      width: size.width * .02,
                    ),
                    Text(LocaleKeys.language_translate.tr(),
                        style: TextStyle(
                          // fontFamily: fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .05,
                          letterSpacing: 0.18,
                          color: AppTheme.darkerText,
                        )),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   BlocProvider<AuthCubit>(
                    create: (BuildContext context) => AuthCubit(AuthRepo()),
                    child: ChangePassScreen()),));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_open,
                      color: AppTheme.secondary,
                    ),
                    SizedBox(
                      width: size.width * .02,
                    ),
                    Text(LocaleKeys.change_pass_translate.tr(),
                        style: TextStyle(
                          // fontFamily: fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .05,
                          letterSpacing: 0.18,
                          color: AppTheme.darkerText,
                        )),
                  ],
                ),
              ),
            ),
            // SizedBox(height: size.height * .3,),
            GestureDetector(
              onTap: (){
                context.read<AuthCubit>().logout();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: AppTheme.secondary,
                    ),
                    SizedBox(
                      width: size.width * .02,
                    ),
                    Text(LocaleKeys.logout.tr(),
                        style: TextStyle(
                          // fontFamily: fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .05,
                          letterSpacing: 0.18,
                          color: AppTheme.darkerText,
                        )),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                showDialog<void>(
                  context: context,
                  builder: (modal) {
                    var we = MediaQuery.of(context).size.width;
                    var he = MediaQuery.of(context).size.height;
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        content:
                        // StatefulBuilder(
                        //   builder: (BuildContext context, StateSetter setState) {
                        //     return
                        BlocProvider.value(
                            value: BlocProvider.of<AuthCubit>(
                                context),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: he*.01,),
                                Text( LocaleKeys.delete_account.tr(),
                                  style: TextStyle(
                                    color: AppTheme.orange,
                                    fontSize: we * .04,
                                    height: he *.003,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),),
                                Text( LocaleKeys.delete_account_msg.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: we * .035,
                                    height: he *.002,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),),
                                SizedBox(height: he*.02,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    SizedBox(
                                      width: we * .28,
                                      child: DefaultButton(
                                        height: he*.06 ,
                                        width: we+ .3,
                                        textColor: Colors.white,
                                        color: Colors.red,
                                        title: LocaleKeys.ok_translate.tr(),
                                        radius: 15,
                                        function: ()async {
                                          //  context.read<AuthCubit>().deleteAcount();
                                          await BlocProvider.of<AuthCubit>(context).deleteAcount(
                                            // phone: phone,
                                            // password: password,
                                          );
                                        },
                                        font: he * 0.02,
                                      ),
                                    ),
                                    SizedBox(
                                      width: we * .28,
                                      child: DefaultButton(
                                        height: he*.06 ,
                                        width: we * .3,
                                        textColor: Colors.white,
                                        color: Colors.green,
                                        title: LocaleKeys.cancel.tr(),
                                        radius: 15,
                                        function: () {
                                          Navigator.pop(context);
                                        },
                                        font: he* 0.02,
                                      ),
                                    ),
                                  ],
                                )

                              ],
                            )
                        )
                      //   }
                      //
                      // ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      color: AppTheme.secondary,
                    ),
                    SizedBox(
                      width: size.width * .02,
                    ),
                    Text(LocaleKeys.delete_account.tr(),
                        style: TextStyle(
                          // fontFamily: fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .05,
                          letterSpacing: 0.18,
                          color: AppTheme.darkerText,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
      appBar: AppBar(
        toolbarHeight: size.height * .1,
        backgroundColor: AppTheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [

            SizedBox(
              width: size.width * .02,
            ),
            Text("${LocaleKeys.hi.tr()}${LocalStorage.getData(key: "userName")}",
                style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * .06,
                  letterSpacing: 0.18,
                  color: AppTheme.darkerText,
                )),
          ],
        ),
      ),
      body:     BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
        if (state is OrderLoading && state.isFirstFetch|| context.read<OrderCubit>().loading ) {
          return Center(
            child: SafeArea(
              child: Column(
             //   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {


                            context.read<OrderCubit>().page = 1;
                            context.read<OrderCubit>().newOrderOnLoad();
                            OrderCubit.categoryNum = 1;
                          });
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0,left: 8),
                              child: CategoryItem(
                                title: LocaleKeys.New.tr(),
                                image: "assets/images/new.png",
                                color: OrderCubit.categoryNum == 1
                                    ? AppTheme.secondary
                                    : Colors.grey,
                                active: OrderCubit.categoryNum == 1 ? true : false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0, bottom: 0),
                              child: Container(
                                width: size.width * .08,
                                height: size.width * .08,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(.3),
                                    )),
                                child: Center(
                                  child: Text(
                                      context.read<OrderCubit>().newTotal.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: size.height * 0.0023),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          context.read<OrderCubit>().page = 1;
                          context.read<OrderCubit>().openOrderOnLoad();
                          setState(() {
                            OrderCubit.categoryNum = 2;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0,left: 8),
                          child: CategoryItem(
                            title: LocaleKeys.open.tr(),
                            image: "assets/images/accept.png",
                            color: OrderCubit.categoryNum == 2
                                ? AppTheme.secondary
                                : Colors.grey,
                            active: OrderCubit.categoryNum == 2 ? true : false,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          context.read<OrderCubit>().page = 1;
                          context.read<OrderCubit>().closedOrderOnLoad();
                          setState(() {
                            OrderCubit.categoryNum = 3;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0,left: 8),
                          child: CategoryItem(
                            title: LocaleKeys.history.tr(),
                            image: "assets/images/folder.png",
                            color: OrderCubit.categoryNum == 3
                                ? AppTheme.secondary
                                : Colors.grey,
                            active: OrderCubit.categoryNum == 3 ? true : false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //   height: size.height * 0.4,
                    width: size.width * 0.5,
                    alignment: Alignment.bottomCenter,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: const [
                        AppTheme.nearlyDarkBlue,
                        AppTheme.secondary,
                        AppTheme.nearlyBlue,
                      ],
                      strokeWidth: 3,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // else if( context.read<OrderCubit>().loading)
        // {
        //   return Center(
        //     child: SafeArea(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Container(
        //             //   height: size.height * 0.4,
        //             width: size.width * 0.5,
        //             alignment: Alignment.bottomCenter,
        //             child: LoadingIndicator(
        //               indicatorType: Indicator.ballPulse,
        //               colors: const [
        //                 AppTheme.nearlyDarkBlue,
        //                 AppTheme.secondary,
        //                 AppTheme.nearlyBlue,
        //               ],
        //               strokeWidth: 3,
        //               backgroundColor: Colors.transparent,
        //               pathBackgroundColor: Colors.white,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }
        List<OrderData> orders = [];
        bool isLoading = false;
        if (state is OrderLoading) {
          orders = state.oldOrders;
          isLoading = true;
        } else if (state is OrderLoaded) {
          orders = state.orders;
        }
        OrderCubit ordersState = context.read<OrderCubit>();

        return SafeArea(
          child: SmartRefresher(
        header: WaterDropHeader(),
        controller: context.read<OrderCubit>().controller,
        onLoading: () {
          if(OrderCubit.categoryNum == 1)
          ordersState.newOrderOnLoad();
          else if(OrderCubit.categoryNum == 2)
            ordersState.openOrderOnLoad();
          else
            ordersState.closedOrderOnLoad();
        },
        enablePullUp: true,
        enablePullDown: false,
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {


                      context.read<OrderCubit>().page = 1;
                      context.read<OrderCubit>().newOrderOnLoad();
                      OrderCubit.categoryNum = 1;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0,left: 8),
                          child: CategoryItem(
                            title: LocaleKeys.New.tr(),
                            image: "assets/images/new.png",
                            color: OrderCubit.categoryNum == 1
                                ? AppTheme.secondary
                                : Colors.grey,
                            active: OrderCubit.categoryNum == 1 ? true : false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0),
                          child: Container(
                            width: size.width * .08,
                            height: size.width * .08,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.withOpacity(.3),
                                )),
                            child: Center(
                              child: Text(
                                context.read<OrderCubit>().newTotal.toString() ,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: size.height * 0.0023),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {

                      context.read<OrderCubit>().page = 1;
                      context.read<OrderCubit>().openOrderOnLoad();
                      setState(() {
                        OrderCubit.categoryNum = 2;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,left: 8),
                      child: CategoryItem(
                        title: LocaleKeys.open.tr(),
                        image: "assets/images/accept.png",
                        color: OrderCubit.categoryNum == 2
                            ? AppTheme.secondary
                            : Colors.grey,
                        active: OrderCubit.categoryNum == 2 ? true : false,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {

                      context.read<OrderCubit>().page = 1;
                      context.read<OrderCubit>().closedOrderOnLoad();
                      setState(() {
                        OrderCubit.categoryNum = 3;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,left: 8),
                      child: CategoryItem(
                        title: LocaleKeys.history.tr(),
                        image: "assets/images/folder.png",
                        color: OrderCubit.categoryNum == 3
                            ? AppTheme.secondary
                            : Colors.grey,
                        active: OrderCubit.categoryNum == 3 ? true : false,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .04,
              ),
           ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: orders.length,
                    itemBuilder: (ctx, index) => OrderItem(
                        orders: orders[index],
                        acceptOrder: () {
                          ordersState.acceptOrder(orders[index].id!, context);
                          setState(() {
                            OrderCubit.categoryNum = 2;
                          });
                        },
                      rejectOrder: () {
                        ordersState.rejectOrder(orders[index].id!, context);

                      },
                      deliverOrder:  () {
                        ordersState.deliverOrder(orders[index].id!, context);
                        setState(() {
                          OrderCubit.categoryNum = 1;
                        });
                      },
                      failedOrder:  () {
                        ordersState.failedOrder(orders[index].id!, context);
                        setState(() {
                          OrderCubit.categoryNum = 1;
                        });
                      },
                      orderState: ordersState,

                    )) ],)
          ),
        ),
      );}),
    );
  }

}
