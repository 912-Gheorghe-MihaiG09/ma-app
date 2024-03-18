import 'package:crud_project/analytics/bloc/analytics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(builder: (context, state){
      if(state is AnalyticsLoaded) {
        return PieChart(
          dataMap: state.data,
        );
      }
      return CircularProgressIndicator();
    });
  }
}
