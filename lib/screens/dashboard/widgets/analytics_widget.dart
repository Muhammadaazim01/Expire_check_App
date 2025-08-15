import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsWidget extends StatefulWidget {
  final List<ChartData> monthlyData;
  final List<ChartData> dailyData;

  const AnalyticsWidget({
    super.key,
    required this.monthlyData,
    required this.dailyData,
  });

  @override
  State<AnalyticsWidget> createState() => _AnalyticsWidgetState();
}

class _AnalyticsWidgetState extends State<AnalyticsWidget> {
  bool showMonthly = true; // default monthly view

  @override
  Widget build(BuildContext context) {
    final TooltipBehavior tooltip = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      color: Colors.black87,
      textStyle: GoogleFonts.montserrat(color: Colors.white),
    );

    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Toggle Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: Text("Monthly"),
                selected: showMonthly,
                selectedColor: Color(0xFF6A11CB), // selected ka color
                backgroundColor: Colors.grey[300], // default color
                labelStyle: GoogleFonts.montserrat(
                  color: showMonthly
                      ? Colors.white
                      : Colors.black, // text color
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  setState(() => showMonthly = true);
                },
              ),

              SizedBox(width: 10),
              ChoiceChip(
                label: Text("Daily"),
                selected: !showMonthly,
                selectedColor: Color(0xFF6A11CB),
                backgroundColor: Colors.grey[300],
                labelStyle: GoogleFonts.montserrat(
                  color: !showMonthly ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  setState(() => showMonthly = false);
                },
              ),
            ],
          ),
          SizedBox(height: 10),

          // Chart
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              backgroundColor: Colors.white,
              plotAreaBorderWidth: 0,
              title: ChartTitle(
                text:
                    'Performance Analytics (${showMonthly ? "Monthly" : "Daily"})',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: tooltip,
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                zoomMode: ZoomMode.x,
              ),
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 1),
                labelRotation: -45,
                labelStyle: GoogleFonts.montserrat(fontSize: 12),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: GoogleFonts.montserrat(fontSize: 12),
                majorTickLines: MajorTickLines(size: 0),
                axisLine: AxisLine(width: 1),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource: showMonthly
                      ? widget.monthlyData
                      : widget.dailyData,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y,
                  name: 'Bar View',
                  width: 0.6,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0288D1), Color(0xFF00BCD4)],
                  ),
                ),
                SplineAreaSeries<ChartData, String>(
                  dataSource: showMonthly
                      ? widget.monthlyData
                      : widget.dailyData,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y,
                  name: 'Growth',
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // ignore: deprecated_member_use
                      Color(0xFF42A5F5).withOpacity(0.95),
                      // ignore: deprecated_member_use
                      Color(0xFFE3F2FD).withOpacity(0.05),
                    ],
                  ),
                  borderColor: Color(0xFF1E88E5),
                  borderWidth: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderWidth: 2,
                    borderColor: Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}
