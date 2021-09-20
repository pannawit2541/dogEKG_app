import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  final List<FlSpot> value;

  final List<Color> lineColor;
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
  @override
  void initState() {
    super.initState();
    _color = widget.lineColor.first;
  }

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
        padding: EdgeInsets.all(10),
        child: LineChart(LineChartData(
          maxX: 300,
            axisTitleData: FlAxisTitleData(
                bottomTitle: AxisTitle(showTitle: true, margin: 0)),
            titlesData: FlTitlesData(
                leftTitles: SideTitles(
                    showTitles: false,
                    interval: 5,
                    getTextStyles: (value) => const TextStyle(
                        color: Color(0xffd2d3d6),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSansPro')),
                bottomTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 5,
                  interval: 10,
                  getTitles: (value) => '|',
                  getTextStyles: (value) => TextStyle(
                    color: _color,
                  ),
                )),
            // rangeAnnotations: rangeAnnotations,
            gridData: gridData,
            borderData: borderData,
            lineTouchData: lineTouchData,
            lineBarsData: [
              LineChartBarData(
                curveSmoothness: 0.2,
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
