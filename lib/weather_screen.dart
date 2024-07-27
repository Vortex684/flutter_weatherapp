
import 'dart:convert';


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_git/additional_info.dart';
import 'package:weather_app_git/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_git/weather_forecast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
    String cityName='london';
    final res= await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'));
    final data=jsonDecode(res.body);
    if(data['cod']!='200'){
      throw'An error occured';
    }
    return data;
    }
    catch(e)
    {
      throw e.toString();
    }   
  }  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      appBar: AppBar(
        title:const Text('Weather App',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ) ,
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            //here we use setstate because whenever we tap on refresh icon it rebuilds again.
            setState(() {});
            debugPrint("refresh");
          }, 
          icon:const Icon(Icons.refresh)),
        ],
      ),
      //instead of using setstates and initstates flutter has given a fuction future builder to handle everything using snapshot functon.
      body: FutureBuilder(future: getCurrentWeather(),
       builder: (context,snapshot) {
       /*as we are using an async func to get temperature so at the start it shows the temprature zero and then the temperature it gets from 
       the so it does not look good so we are using a progress loading indicator till it gets the value from the API so the progress loading 
       indicator will just show circular loading */
        if(snapshot.connectionState==ConnectionState.waiting)
        {
          return const Center(child:  CircularProgressIndicator());
        }
        if(snapshot.hasError){
          return Text (snapshot.error.toString());
        }
        final data=snapshot.data!;
        final curWeatherData=data['list'][0];
        double temp=curWeatherData['main']['temp']-273;
        String curWeather=curWeatherData['weather'][0]['main'];
        double pressure=curWeatherData['main']['pressure'];
        double windspeed=curWeatherData['wind']['speed'];
        double humidity=curWeatherData['main']['humidity'];

         return Padding(
        padding:const  EdgeInsets.all(16.0),
        child: 
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //we can put it into container but if we have to use only width to take the complete then flutter recomends to use sizedbox.
            SizedBox(
              width: double.infinity,
              child:  Card(
                elevation: 18,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                //A brackdrop is used to merge the elevation wit the screen so in order too look more good
                // As we use backdrop the elevation looks kind of gone so in order for the card to look elevated and backdropped we use ClipRRect widget.
             child: ClipRRect(
              borderRadius:BorderRadius.circular(16) ,
               child: BackdropFilter(
                filter:ImageFilter.blur(sigmaX: 10, sigmaY: 10) ,
                 child:  Padding(  
                  padding:const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('${temp.toStringAsFixed(2)}°C',
                      style:const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                     const SizedBox(height: 16,),
                      Icon(
                      curWeather=='Clouds'|| curWeather=='Rain' ? Icons.cloud : Icons.sunny,   
                        size: 64,
                      ),
                     const SizedBox(height: 16,),
                     Text(curWeather,
                      style:const TextStyle(
                        fontSize: 20,
                      )
                      ,)
                    ],
                    ),
                ),
               ),
             ), 
            ) ,
             ) ,
           const SizedBox(height: 10,),
          const Text('Weather Forecast',
           style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
             ),
             ), 
            const SizedBox(
              height: 15,
             ),
            //   SingleChildScrollView(
            //    child: Row(
            //      children: <Widget>[
            //       for(int i=0;i<5;i++)
                
            //       WeatherForecast(
            //         time: data['list'][i+1]['dt'].toString(),
            //         icon: data['list'][i+1]['weather']['main'] == 'Rain' || data['list'][i]['weather']['main'] =='Clouds' ? Icons.cloud :Icons.sunny,
            //         temp: data['list'][i+1]['main']['temp'].toString(),
            //         ),
            //     const  SizedBox(width: 12,),
                  
            //       ],
            //    ),
            //  ),
            /* here istead of using for loop we can also use listveiw.builder because it does not creates all the widgets when the code is run but instead it lazily loads
            the widgets which means they are created when the user is scrolling them. so it makes are app more efficient. */
             SizedBox(
              height: 120,
                child: ListView.builder( 
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context,index){
                  final forecast=data['list'][index+1];
                  //here we have parsed the dt_txt from the api into date so we can format the dt_txt that was shoing both date and time but we only wanted time so we formatted it
                  //using dateformat function
                  final forecastTime=DateTime.parse(forecast['dt']);
                  return WeatherForecast(
                    //here we have added a dependency 'intl' in pubspec.yaml file that provides us with date time formatting,here 'hm' means hour minute.
                    time:DateFormat.Hm().format(forecastTime) , 
                    icon:forecast['weather']['main'] == 'Rain' || forecast['weather']['main'] =='Clouds' ? Icons.cloud :Icons.sunny , 
                    temp:forecast['main']['temp'],
                    );
                }
                ),
             ),
             const SizedBox(height: 20,),
                const Text('Additional Information',
                 style: TextStyle(
                 fontSize: 24,
                 fontWeight: FontWeight.bold
                 ),
             ),
           const SizedBox(height: 10,),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               AdditionalInfo(
                icon: Icons.air,
                label: 'Wind Speed',
                value: windspeed.toString(),
               ),
               AdditionalInfo(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: humidity.toString(),
               ),
               AdditionalInfo(
                icon: Icons.umbrella,
                label: 'Pressure',
                value: pressure.toString(),
               ),
              ],
             ),
          ],
          ),
             );
       },
      ),
    );
  }
}