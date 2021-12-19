import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PointsChart extends StatefulWidget {
  const PointsChart({Key? key}) : super(key: key);

  @override
  _PointsChartState createState() => _PointsChartState();
}

class _PointsChartState extends State<PointsChart> {
  late List<PointsData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getPointsData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<double> stops = <double>[
    0.2,
    0.4,
    0.6,
    0.8,
    1,
  ];
  List<Color> colors = <Color>[
    const Color(0xFFCC5803),
    const Color(0xFFE2711D),
    const Color(0xFFFF9505),
    const Color(0xFFFFB627),
    const Color(0xFFFFC971),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCircularChart(
        onCreateShader: (ChartShaderDetails chartShaderDetails) {
          return ui.Gradient.sweep(
              chartShaderDetails.outerRect.center,
              colors,
              stops,
              TileMode.clamp,
              _degreeToRadian(0),
              _degreeToRadian(360),
              _resolveTransform(
                  chartShaderDetails.outerRect, TextDirection.ltr));
        },
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          RadialBarSeries<PointsData, String>(
              maximumValue: 100000,
              radius: '100%',
              gap: '20',
              trackOpacity: 0.2,
              cornerStyle: CornerStyle.bothCurve,
              dataSource: _chartData,
              xValueMapper: (PointsData data, _) => data.range,
              yValueMapper: (PointsData data, _) => data.points,
              dataLabelMapper: (PointsData data, _) => data.range,
              dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'SourceCodePro',
                  ),
                  labelAlignment: ChartDataLabelAlignment.outer),
              enableTooltip: true)
        ],
      ),
    );
  }

  // Rotate the sweep gradient according to the start angle
  Float64List _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  // Convert degree to radian
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

  List<PointsData> getPointsData() {
    final List<PointsData> pointsData = [
      PointsData('Month', 55000),
    ];
    return pointsData;
  }
}

class PointsData {
  PointsData(this.range, this.points);
  final String range;
  final int points;
}