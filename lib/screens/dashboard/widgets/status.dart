import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Chart data model
class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}

// Training status widget
class TrainingStatusWidget extends StatelessWidget {
  final RxInt expiringSoon;
  final RxInt expired;

  const TrainingStatusWidget({
    super.key,
    required this.expiringSoon,
    required this.expired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
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
      child: Obx(() {
        final bool hasData = expiringSoon.value > 0 || expired.value > 0;

        // Chart data
        final List<ChartData> data = [
          if (expiringSoon.value > 0)
            ChartData('Expiring Soon', expiringSoon.value.toDouble()),
          if (expired.value > 0) ChartData('Expired', expired.value.toDouble()),
        ];

        final chartData = hasData ? data : [ChartData('No Data', 1)];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  "Training Status",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // No data message
            if (!hasData)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No expiring or expired trainings available.",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            // Chart
            if (hasData)
              SizedBox(
                height: 250,
                child: SfCircularChart(
                  title: ChartTitle(
                    text: 'Employee Status',
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <PieSeries<ChartData, String>>[
                    PieSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      pointColorMapper: (ChartData data, _) {
                        switch (data.x) {
                          case 'Expiring Soon':
                            return Colors.orangeAccent;
                          case 'Expired':
                            return Colors.redAccent;
                          default:
                            return Colors.grey;
                        }
                      },
                      explode: true,
                      explodeIndex: 0,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        connectorLineSettings: ConnectorLineSettings(
                          type: ConnectorType.curve,
                          // length property removed to fix error
                          width: 2,
                        ),
                      ),
                      enableTooltip: true,
                      animationDuration: 1000,
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}
