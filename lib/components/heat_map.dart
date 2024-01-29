import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {

  final DateTime starDate;
  final Map<DateTime, int> datasets;

  const MyHeatMap({
    super.key,
    required this.starDate,
    required this.datasets,
  });

   @override
   Widget build(BuildContext context) {

       return HeatMap(
        startDate: starDate,
        endDate: DateTime.now(),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor:Theme.of(context).colorScheme.secondary,
        textColor:Colors.white,
        showColorTip: false,
        showText:true,
        scrollable: true,
        size: 30,
         colorsets: {
          1: Colors.cyan.shade200,
          2: Colors.cyan.shade300,
          3: Colors.cyan.shade400,
          4: Colors.cyan.shade500,
          5: Colors.cyan.shade600,
         },
       );
  }
}