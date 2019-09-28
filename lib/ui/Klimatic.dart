import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../util/utils.dart';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();

}

Map data;
class _KlimaticState extends State<Klimatic> {

  String cityEntered;


  Future _goToNextScreen(BuildContext context) async{

    Map result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return ChangeCity();
      })
    );

    if(result!=null && result.containsKey("enter")){
//      print("Look here "+result['enter'].toString());
      cityEntered = result['enter'].toString();
    }
  }


  void showStuff() async{

    data = await getWeather(apiId, defaultCity);
//    print(data.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Klimatic"
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
//            color: Colors.white,
            icon: Icon(Icons.menu),
            onPressed: (){_goToNextScreen(context);},
          ),

        ],
      ),



      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/umbrella.png',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            alignment: Alignment.topRight,
            child: Text('${cityEntered == null ? defaultCity : cityEntered}',
            style: cityStyle()),
          ),


          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),

          updateTempWidget("${cityEntered == null ? defaultCity : cityEntered}")

        ],
      ),

    );
  }








  Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(apiId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
            // where we get all the info of json data , we setup widgets

          if(snapshot.hasData){
            Map content = snapshot.data;
            print(city);
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(content['main']['temp'].toString(),
                    style: tempStyle(),),

                    subtitle: ListTile(
                      title: Text(
                          "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()}\n"
                          "Max: ${content['main']['temp_max'].toString()}",

                      style: extraTemp(),),
                    ),
                  ),

                ],
              ),
            );
          }

          else{
            return new Container();
          }

    })  ;
  }


  Future<Map> getWeather(String apiID, String city) async{
    String url = "http://api.openweathermap.org/data/2.5/weather?"
        "q=$city&APPID=$apiID";

    http.Response response = await http.get(url);//Telling the app to stop

    return json.decode(response.body);
  }

}



class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Change City"),
        centerTitle: true,
      ),


      body: Stack(
        children: <Widget>[

          Center(
            child: Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),

          ),


          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City",
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),


              ListTile(
                title: FlatButton(
                  onPressed: (){
                    Navigator.pop(context,
                    {
                      'enter':_cityFieldController.text == "" ? defaultCity : _cityFieldController.text
                    });
                  },
                  child: Text(
                    "Get Weather"
                  ),
                  color: Colors.redAccent,
                  textColor: Colors.white70,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}





TextStyle tempStyle(){
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 35.9
  );
}


TextStyle extraTemp(){
  return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 17.0
  );
}

TextStyle cityStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}