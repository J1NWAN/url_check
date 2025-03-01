import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:url_check/features/home/widget/legend_widget.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF4CAE51);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFF44336);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class BarChartSample6 extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardStatusList;
  const BarChartSample6({super.key, required this.dashboardStatusList});

  final steadyColor = AppColors.contentColorGreen;
  final errorColor = AppColors.contentColorRed;
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
    double quickWorkout,
    double cycling,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: steadyColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: errorColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 8);
    String text = '';

    for (var status in dashboardStatusList) {
      if (status['index'] == value.toInt()) {
        text = status['systemCode'];
      }
    }

    // switch (value.toInt()) {
    //   case 0:
    //     text = 'WWW';
    //     break;
    //   case 1:
    //     text = 'NSIC';
    //     break;
    //   case 2:
    //     text = 'OPIS';
    //     break;
    //   case 3:
    //     text = 'NSIC';
    //     break;
    //   case 4:
    //     text = 'CLEAN';
    //     break;
    //   case 5:
    //     text = 'KINSRP';
    //     break;
    //   case 6:
    //     text = 'INSS';
    //     break;
    //   case 7:
    //     text = 'RMSNET';
    //     break;
    //   case 8:
    //     text = 'SEP';
    //     break;

    //   default:
    //     text = '';
    // }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text.length > 5 ? text.substring(0, 5) : text,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '최근 시스템 현황',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LegendsListWidget(
                legends: [
                  Legend('정상', steadyColor),
                  Legend('오류', errorColor),
                ],
              ),
              //const SizedBox(height: 14),
              AspectRatio(
                aspectRatio: 2,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 20,
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(enabled: false),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      for (var status in dashboardStatusList)
                        generateGroupData(
                            status['index'], (status['successCount'] as int).toDouble(), (status['errorCount'] as int).toDouble(), 0),
                    ],
                    maxY: 11 + (betweenSpace * 3),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 3.3,
                          color: Colors.grey[200],
                          strokeWidth: 1,
                          dashArray: [20, 4],
                        ),
                        HorizontalLine(
                          y: 8,
                          color: Colors.grey[200],
                          strokeWidth: 1,
                          dashArray: [20, 4],
                        ),
                        HorizontalLine(
                          y: 11,
                          color: Colors.grey[200],
                          strokeWidth: 1,
                          dashArray: [20, 4],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
