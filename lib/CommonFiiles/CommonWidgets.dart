import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonWidgets{

  static Color appThemeColor = Colors.green;
  static Color boxGrey = const Color(0xFFF1F0F0);

  Widget getWillPopScopeWidget(
      BuildContext context,
      WillPopCallback? onWillPop,
      Widget bodyContainer,
      bool resizeToAvoidBottomPadding,
      GlobalKey<ScaffoldState>? formKey) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: []);
              },
              child: bodyContainer,
            ),
            resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
            key: formKey),
      );
  }

  Widget passwordTextField(
      BuildContext context,
      TextEditingController controller,
      String labelText,
      ValueChanged<String>? onValueChanged,
      ValueChanged<String>? onFieldSubmitted,
      double fontSize,
      VoidCallback onPressed,
      {bool isObscure = true}) {
      return TextFormField(
        enabled: true,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.done,
        obscureText: isObscure,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              splashRadius: 20,
              icon: Icon(
                isObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black,
              ),
              onPressed: onPressed),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.pinkAccent,
            ),
          ),
          // border: InputBorder.none,
          labelText: labelText,
          labelStyle:const TextStyle(
            fontSize: 10,
            color:  Colors.black,
          ),
          isDense: false,
        ),
        maxLines: 1,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        keyboardType: TextInputType.visiblePassword,
        autocorrect: false,
        controller: controller,
      );
  }

  Padding getPadding(
      {double top = 0,
  double bottom = 0,
  double right = 0,
  double left = 0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
    );
  }

  Widget emailTextField(
      BuildContext context,
      TextEditingController controller,
      String labelText,
      ValueChanged<String>? onValueChanged,
      ValueChanged<String>? onFieldSubmitted,
      double fontSize) {
    return TextFormField(
      enabled: true,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        // border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
        labelText: labelText,
        labelStyle:const TextStyle(
          fontSize: 10,
          color:  Colors.black,
        ),
        isDense: false,
      ),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      controller: controller,
    );
  }

  Widget emailTextFieldWithBackground(
      BuildContext context,
      TextEditingController controller,
      String labelText,
      ValueChanged<String>? onValueChanged,
      ValueChanged<String>? onFieldSubmitted,
      double fontSize) {
    return TextFormField(
      enabled: true,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        labelStyle:const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:  Colors.green,
        ),
        isDense: false,
      ),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: Colors.green,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      controller: controller,
    );
  }

  Widget commonTextInputFieldWithBackground(BuildContext context,
      double fontSize,
      String fieldText,
      int maxLines,
      TextInputAction textInputAction,
      TextInputType textInputType,
      TextEditingController controller,
      ValueChanged<String> onFieldSubmitted,
      ValueChanged<String> onChanged,
      VoidCallback onTap) {
    return TextFormField(
      enabled: true,
      textAlign: TextAlign.start,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        labelText: fieldText,
        labelStyle:const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:  Colors.green,
        ),
        isDense: false,
      ),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: Colors.green,
      keyboardType: textInputType,
      autocorrect: false,
      controller: controller,
    );
  }

  Widget passwordTextFieldWithBackground(
      BuildContext context,
      TextEditingController controller,
      String labelText,
      ValueChanged<String>? onValueChanged,
      ValueChanged<String>? onFieldSubmitted,
      double fontSize,
      VoidCallback onPressed,
      {bool isObscure = true}) {
    return TextFormField(
      enabled: true,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.done,
      obscureText: isObscure,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        suffixIcon: IconButton(
            splashRadius: 20,
            icon: Icon(
              isObscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.green,
            ),
            onPressed: onPressed),
        labelText: labelText,
        labelStyle:const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:  Colors.green,
        ),
        isDense: false,
      ),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: Colors.green,
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      controller: controller,
    );
  }


  Widget commonTextInputField(BuildContext context,
      double fontSize,
      String fieldText,
      int maxLines,
      TextInputAction textInputAction,
      TextInputType textInputType,
      TextEditingController controller,
      ValueChanged<String> onFieldSubmitted,
      ValueChanged<String> onChanged,
      VoidCallback onTap) {
    return TextFormField(
      enabled: true,
      textAlign: TextAlign.start,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        // border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
        labelText: fieldText,
        labelStyle:const TextStyle(
          fontSize: 10,
          color:  Colors.black,
        ),
        isDense: false,
      ),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      keyboardType: textInputType,
      autocorrect: false,
      controller: controller,
    );
  }

  Widget commonTextInputFieldWithSuffixIcon(BuildContext context,
      double fontSize,
      String fieldText,
      int maxLines,
      TextEditingController controller,
      ValueChanged<String> onFieldSubmitted,
      ValueChanged<String> onChanged,
      VoidCallback onTap,
      VoidCallback iconClick,
      ) {
    return TextFormField(
      enabled: true,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: fieldText,
        labelStyle:const TextStyle(
          fontSize: 10,
          color:  Colors.black,
        ),
        isDense: false,contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
  /*      suffixIcon: Container(
          decoration: BoxDecoration(color: Colors.white,
              // border: Border.all(color: Colors.pinkAccent,width: 1),
              borderRadius: BorderRadius.circular(30)),
        child: IconButton(
          icon: const Icon(Icons.attachment,color: Colors.pinkAccent,),
          onPressed: iconClick,
        ),
      ),*/
      ),
      maxLines: 1,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      controller: controller,
    );
  }

  Widget getIconWithText(
      icon,
      Color color,
      double iconSize,
      String buttonText,
      double fontSize,
      VoidCallback onPressed
      ) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          IconButton(
              splashRadius: 20,
              icon: Icon(
                icon,
                color: color,
                size: iconSize,
              ),
              onPressed: onPressed),
          getNormalText(buttonText, color, 1, fontSize)
        ],
      ),
    );
  }

  Widget getIcon(
      icon,
      Color color,
      double iconSize,
      VoidCallback onPressed
      ) {
    return GestureDetector(
      onTap: onPressed,
      child: IconButton(
          splashRadius: 20,
          icon: Icon(
            icon,
            color: color,
            size: iconSize,
          ),
          onPressed: onPressed),
    );
  }
  
  Widget commonButton(
      BuildContext context,
      String buttonText,
      double fontSize,
      Color buttonBgColor,
      Color buttonBorderColor,
      Color buttonTextColor,
      EdgeInsets padding,
      VoidCallback onPressed
      ) {
    return TextButton(
        onPressed: onPressed, 
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: buttonBgColor,
            border: Border.all(color: buttonBorderColor),
            borderRadius: BorderRadius.circular(30)
          ),
            child: getNormalText(buttonText, buttonTextColor, 1, fontSize)));
  }

  Widget commonSubmitButton(
      BuildContext context,
      String buttonText,
      double fontSize,
      Color buttonBgColor,
      Color buttonBorderColor,
      Color buttonTextColor,
      VoidCallback onPressed
      ) {
    return TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: buttonBgColor,
                  border: Border.all(color: buttonBorderColor),
                  borderRadius: BorderRadius.circular(5)
                ),
                  child: getNormalTextWithCenterAlignment(buttonText, buttonTextColor, 1, fontSize, FontWeight.bold)),
            ),
          ],
        ));
  }

  BoxDecoration getBoxDecorationWithColor(Color buttonBgColor, Color borderColor,double radius) {
    return BoxDecoration(
        color: buttonBgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(radius)
    );
  }

  Widget getNormalText(String text, Color color, int maxLines, double fontSize) {
      return Text(text,
          maxLines: maxLines,
          style: TextStyle(fontSize: fontSize, color: color));
  }

  Widget getNormalTextWithCenterAlignment(String text, Color color, int maxLines, double fontSize, FontWeight fontWeight) {
      return Text(text,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, color: color,fontWeight: fontWeight));
  }


  Widget getNormalTextWithBold(String text, Color color, int maxLines, double fontSize) {
      return Text(text,
          maxLines: maxLines,
          style: TextStyle(fontSize: fontSize, color: color,fontWeight: FontWeight.bold));
  }

  Widget commonAppBar(double fontSize,String name,VoidCallback onclick) {
    return Container(
      height: 70,
      color: Colors.indigo,
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getIcon(Icons.person_outline, Colors.white, 30, () {

            }),
            getNormalText(name, Colors.white, 1, fontSize),
            getIcon(Icons.logout, Colors.white, 30, onclick),
          ],
        ),
      ),
    );
  }

  commonDialog(
      BuildContext context,
      double fontSize,
      double headingFontSize,
      double iconSize,
      String dialogTitleText,
      Color dialogTitleTextColor,
      Widget widget,
      VoidCallback closePressed) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        backgroundColor:Colors.white,
        shape: const RoundedRectangleBorder(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonWidgets().getNormalText(dialogTitleText, dialogTitleTextColor, 1, fontSize),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
                child: CommonWidgets().getNormalText("Close", Colors.amberAccent, 1, fontSize))
          ],
        ),
        content: SingleChildScrollView(
          child: widget,
        ),
      );
  }

  launchPage(BuildContext context, Widget builder) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => builder));
  }


  Widget topTabBar(
      BuildContext context,
      int length,
      String title1,
      String title2,
      Color color,
      double fontSize,
      _tabController,
      Widget title1Page,
      Widget title2Page) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 48,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              TabBar(
                indicator: const BoxDecoration(color: Colors.deepOrangeAccent),
                tabs: [
                  Container(
                    alignment: Alignment.center,
                    child: Tab(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         Text(title1)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Tab(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title2)
                        ],
                      ),
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [title1Page, title2Page],
            ),
          )
        ],
      );
  }


  Future<void> storeBooleanInSharedPreferences(String key, bool value) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool(key, value);
    } catch (exception, stackTrace) {
      print("exception$exception");
    }
  }

  Future<bool> getBooleanFromSharedPreferences(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getBool(key) ?? false;
    } catch (exception, stackTrace) {
      print("exception$exception");
      return false;
    }
  }

  void storeStringInSharedPreferences(String key, String value) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(key, value);
    } catch (exception, stackTrace) {
      print("exception$exception");
    }
  }

  Future<String> getStringFromSharedPreferences(String key) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return preferences.getString(key) ?? '';
    } catch (exception, stackTrace) {
      print("exception$exception");
      return "";
    }
  }
/*
  Future<Response?> performServerCommunication(
      String formUrl,
      Map<String, String>? queryParamMap,
      BuildContext? context,
      String? encodedPassword) async {
    try {

        Response? relationShipResponse;
          relationShipResponse = (await getDioResponse(
              formUrl,
              queryParamMap ??  HashMap(),
              context!,
              encodedPassword))!;

        if (relationShipResponse != null) {
          int relationShipStatusCode = checkHTTPURLConnectionResponse(
              relationShipResponse.statusCode ?? 500);

          if (relationShipStatusCode == 0) {
            return relationShipResponse;
          } else if (relationShipStatusCode == -2) {
            performServerCommunication(
                 formUrl, queryParamMap, context, encodedPassword);
          } else if (relationShipStatusCode == -3) {
            performServerCommunication(
                 formUrl, queryParamMap, context, encodedPassword);
          } else {
            // throw Exception as  Server Not Available permanently
          }
        }
    return null;
    } catch (exception, stackTrace) {
  print("exception$exception");
  print("stackTrace$stackTrace");
      return null;
    }
  }

  Future<Response?> performPOSTServerCommunication( String formUrl,
      Map<String, String> queryParamMap, BuildContext context, Map<String, dynamic> data) async {
    try {

          Response? relationShipResponse =
          await postDataToServerwithDio(formUrl, queryParamMap, data, context);

          if (relationShipResponse != null) {
            int? relationShipStatusCode = checkHTTPURLConnectionResponse(relationShipResponse.statusCode ?? 0);

            if (relationShipStatusCode == 0 && relationShipResponse.statusMessage == "Created") {
              return relationShipResponse;
            } else if (relationShipStatusCode == -2) {
              performPOSTServerCommunication( formUrl, queryParamMap, context, data);
            } else if (relationShipStatusCode == -3) {
              performPOSTServerCommunication( formUrl, queryParamMap, context, data);
            } else {
              // throw Exception as Server Not Server Not Available permanently
            }
          }

    } catch (exception, stackTrace) {
      print("exception$exception");
      print("stackTrace$stackTrace");
      return null;
    }
  }

  Future<Response?> postDataToServerwithDio(String formUrl, Map<String, String> queryParamMap,
      Map<String, dynamic> jsonData,  BuildContext context) async {
    try {
      Dio dio =  Dio();
      dio.options =  BaseOptions(
          responseType: ResponseType.json,
          connectTimeout: 300000,
          receiveTimeout: 300000,
          headers: {
            "Accept": "application/json",
            "Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded",
            "Charset": "utf-8"
          });
      Response response = await dio.post<Map>(
        formUrl,
        queryParameters: queryParamMap,
        data: jsonData,
        onSendProgress: (int sent, int total) {
         print("$sent $total");
        },
      );

      return response;
    } on FormatException catch (exception, stackTrace) {
      print("exception$exception");
      print("stackTrace$stackTrace");
      return null;
    } on DioError catch (exception, stackTrace) {
      print("exception$exception");
      print("stackTrace$stackTrace");
      return null;
    }
  }

  Future<Response?> getDioResponse(
      String formUrl,
      Map<String, String> queryParamMap,
      BuildContext context,
      String? encodedPassword) async {
    Response? response;
    try {
      Dio dio =  Dio();
      dio.options =  BaseOptions(
        responseType: ResponseType.json,
        connectTimeout: 680000,
        receiveTimeout: 680000,
        headers: {
          "Accept": "application/json",
          "Connection": "keep-alive",
          "Content-Type": "application/json;charset=UTF-8",
          "Charset": "utf-8",
          "Authorization": encodedPassword ?? "",
        },
      );
      if (queryParamMap != null) {
        response = await dio.get<Map>(formUrl, queryParameters: queryParamMap);
      } else {
        response = await dio.get<Map>(formUrl);
      }

      return response;
    } on FormatException catch (exception, stackTrace) {
      print("exception$exception");
      print("stackTrace$stackTrace");
      return null;
    } on DioError catch (exception, stackTrace) {
      print("exception$exception");
      print("stackTrace$stackTrace");
      return null;
    }
  }

  Future<Response?> performLiveServerCommunication(
      String formUrl,
      Map<String, String> queryParamMap,
      BuildContext context) async {
    try {

        Response? relationShipResponse = await getDioResponse(
            formUrl, queryParamMap,  context, null);
        if (relationShipResponse != null) {
          int relationShipStatusCode = checkHTTPURLConnectionResponse(
              relationShipResponse.statusCode ?? 500);

          if (relationShipStatusCode == 0) {
            return relationShipResponse;
          } else if (relationShipStatusCode == -2) {
            performLiveServerCommunication(
                 formUrl, queryParamMap, context);
          } else if (relationShipStatusCode == -3) {
            performLiveServerCommunication(
                 formUrl, queryParamMap, context);
          } else {
          }
        }
    } catch (exception, stackTrace) {
      print("exception$exception");
      print("stackTrace$stackTrace");
      return null;
    }
    return null;
  }

  int checkHTTPURLConnectionResponse(int responseCode) {
    try {
      if (responseCode >= 300 && responseCode <= 399) {
        return -1;
      } else if (responseCode >= 400 && responseCode <= 499) {
        return -2;
      } else if (responseCode >= 500 && responseCode <= 599) {
        return -3;
      } else if (responseCode < 299) {
        return 0;
      }
      return -1;
    } catch (exception, stackTrace) {
     print("exception$exception");
     print("stackTrace$stackTrace");
      return -1;
    }
  }*/

}