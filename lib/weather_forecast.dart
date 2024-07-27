import 'package:flutter/material.dart';
class WeatherForecast extends StatelessWidget {
  
  final String time;
  final IconData icon;
  final double temp;
  const WeatherForecast({ super.key, required this.time ,required this.icon, required  this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 8,
                    child: Container(
                      width: 110,
                      padding:const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                              children: [
                                Text(time,
                                style:const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: 1,
                                 overflow:TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12,),
                                Icon(
                                  icon,
                                  size: 22,
                                ),
                               const  SizedBox(height: 12,),
                                Text('$temp',
                                style:const TextStyle(
                                    fontSize: 11,
                                ),
                                ),
                              ],
                      ),
                    ),
                    );
  }
}