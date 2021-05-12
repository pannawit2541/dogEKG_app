import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  List<FlSpot> value;

  List<Color> lineColor;
  // ChartPage({Key key, @required this.value}) : super(key: key);
  ChartPage({
    Key key,
    this.value,
    this.lineColor,
  }) : super(key: key);
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Color _color;
  // double interval = widget.value.
  @override
  void initState() {
    super.initState();
    _color = widget.lineColor.first;
  }

  // FlTitlesData titlesData = FlTitlesData(
  //     leftTitles: SideTitles(
  //         showTitles: false,
  //         interval: 5,
  //         getTextStyles: (value) => const TextStyle(
  //             color: Color(0xffd2d3d6),
  //             fontWeight: FontWeight.bold,
  //             fontFamily: 'SourceSansPro')),
  //     bottomTitles: SideTitles(
  //       showTitles: true,
  //       reservedSize: 5,
  //       interval: 5,
  //       getTitles: (value) => '|',
  //       // getTextStyles: (value) =>
  //       //     TextStyle(color: _color, fontWeight: FontWeight.w200),
  //     ));

  // RangeAnnotations rangeAnnotations =
  //     RangeAnnotations(verticalRangeAnnotations: []);
  FlGridData gridData = FlGridData(
      getDrawingHorizontalLine: (value) =>
          FlLine(color: Color(0xfff2f3f9), strokeWidth: 2),
      show: false,
      horizontalInterval: 5);
  FlBorderData borderData = FlBorderData(
    show: false,
  );
  LineTouchData lineTouchData = LineTouchData(enabled: false);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Color(0xfffbfcff),
        child: LineChart(LineChartData(
          axisTitleData: FlAxisTitleData(bottomTitle: AxisTitle(showTitle: true,margin: 0)),
            maxX: 60,
            // maxY: 250,
            minY: 0,
            titlesData: FlTitlesData(
                leftTitles: SideTitles(
                    showTitles: false,
                    interval: 5,
                    getTextStyles: (value) => const TextStyle(
                        color: Color(0xffd2d3d6),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSansPro')),
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 5,
                  interval: 5,
                  getTitles: (value) => '|',
                  getTextStyles: (value) =>
                      TextStyle(color: _color,),
                )),
            // rangeAnnotations: rangeAnnotations,
            gridData: gridData,
            borderData: borderData,
            lineTouchData: lineTouchData,
            lineBarsData: [
              LineChartBarData(
                curveSmoothness: 0.4,
                colors: widget.lineColor,
                // colorStops: [0, 0.7, 1],
                barWidth: 2,
                spots: widget.value,
                isCurved: true,
                dotData: FlDotData(
                  show: false,
                ),
              )
            ])),
      ),
    );
  }
}
