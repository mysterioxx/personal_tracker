import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard1.dart'; // Import the Task class from dashboard1.dart

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Task> _tasksHistory = [];
  String _selectedTimeframe = '7day';
  String _selectedGraphType = 'line'; // Options: 'line', 'bar', 'scatter'
  bool _isCurvedLine = false; // Toggle between Curved Spline and Straight Lines

  int _totalTasksInPeriod = 0;
  int _completedTasksInPeriod = 0;
  int _pendingTasksInPeriod = 0;
  double _completionPercentage = 0.0;
  List<FlSpot> _chartDataCompleted = [];
  List<FlSpot> _chartDataPending = [];

  late Future<void> _refreshFuture;

  @override
  void initState() {
    super.initState();
    _refreshFuture = _loadTasksAndAnalytics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshFuture = _loadTasksAndAnalytics();
  }

  Future<void> _loadTasksAndAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getStringList('tasks_history') ?? [];
    final savedPending = prefs.getStringList('tasks') ?? [];

    final history = savedHistory.map((e) => Task.fromJson(jsonDecode(e))).toList();
    final pending = savedPending.map((e) => Task.fromJson(jsonDecode(e))).toList();

    if (mounted) {
      setState(() {
        _tasksHistory = history + pending;
        _calculateAnalytics();
      });
    }
  }

  void _calculateAnalytics() {
    _chartDataCompleted.clear();
    _chartDataPending.clear();
    _totalTasksInPeriod = 0;
    _completedTasksInPeriod = 0;
    _pendingTasksInPeriod = 0;

    final now = DateTime.now();
    List<Task> relevantTasks = [];
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final int daysToDisplay = _selectedTimeframe == '1day' 
        ? 24 
        : (_selectedTimeframe == '7day' ? 7 : daysInMonth);

    if (_selectedTimeframe == '1day') {
      relevantTasks = _tasksHistory.where((task) =>
          task.createdDate.year == now.year &&
          task.createdDate.month == now.month &&
          task.createdDate.day == now.day).toList();
    } else if (_selectedTimeframe == '7day') {
      relevantTasks = _tasksHistory.where((task) =>
          task.createdDate.isAfter(now.subtract(const Duration(days: 7)))).toList();
    } else if (_selectedTimeframe == '30day') {
      relevantTasks = _tasksHistory.where((task) =>
          task.createdDate.isAfter(now.subtract(Duration(days: daysInMonth)))).toList();
    }

    _totalTasksInPeriod = relevantTasks.length;
    _completedTasksInPeriod = relevantTasks.where((task) => task.isCompleted).length;
    _pendingTasksInPeriod = _totalTasksInPeriod - _completedTasksInPeriod;
    _completionPercentage = _totalTasksInPeriod > 0 
        ? (_completedTasksInPeriod / _totalTasksInPeriod) * 100 
        : 0.0;

    final Map<int, int> completedData = {};
    final Map<int, int> pendingData = {};
    for (int i = 0; i < daysToDisplay; i++) {
      completedData[i] = 0;
      pendingData[i] = 0;
    }

    for (var task in relevantTasks) {
      int index;
      if (_selectedTimeframe == '1day') {
        index = task.createdDate.hour;
      } else {
        final daysAgo = now.difference(task.createdDate).inDays;
        index = (daysToDisplay - 1) - daysAgo;
      }

      if (index >= 0 && index < daysToDisplay) {
        if (task.isCompleted) {
          completedData[index] = (completedData[index] ?? 0) + 1;
        } else {
          pendingData[index] = (pendingData[index] ?? 0) + 1;
        }
      }
    }

    _chartDataCompleted = completedData.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
    _chartDataPending = pendingData.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
  }

  String _getFormattedTimeframeText() {
    switch (_selectedTimeframe) {
      case '1day':
        return '1 day';
      case '7day':
        return '7 days';
      case '30day':
        return '30 days';
      default:
        return '';
    }
  }

  Widget _buildGraph() {
    if (_chartDataCompleted.isEmpty && _chartDataPending.isEmpty) {
      return const Center(child: Text('No data for this period.'));
    }

    double highestCount = 0;
    for (var spot in _chartDataCompleted) {
      if (spot.y > highestCount) highestCount = spot.y;
    }
    for (var spot in _chartDataPending) {
      if (spot.y > highestCount) highestCount = spot.y;
    }

    final double maxY = highestCount > 0 ? (highestCount + 2) : 5.0;

    if (_selectedGraphType == 'line') {
      return LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final String label = touchedSpot.barIndex == 0 ? 'Completed' : 'Pending';
                  return LineTooltipItem(
                    '$label: ${touchedSpot.y.toInt()}',
                    TextStyle(
                      color: touchedSpot.barIndex == 0 ? Colors.greenAccent : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            // Completed tasks line
            LineChartBarData(
              spots: _chartDataCompleted,
              isCurved: _isCurvedLine,
              curveSmoothness: 0.25, // Controlled tension prevents dipping under 0
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.08),
              ),
            ),
            // Pending tasks line
            LineChartBarData(
              spots: _chartDataPending,
              isCurved: _isCurvedLine,
              curveSmoothness: 0.25,
              color: Colors.red,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.08),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: maxY > 10 ? 5 : 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  );
                },
              ),
              axisNameWidget: const Text(
                'Task Count',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              axisNameSize: 18,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: _selectedTimeframe == '1day' 
                    ? 4 
                    : (_selectedTimeframe == '7day' ? 1 : 5),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _getXAxisLabel(value, _chartDataCompleted.length),
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
              axisNameWidget: const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Time Period',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              axisNameSize: 22,
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY > 10 ? 5 : 1,
          ),
          minX: 0,
          maxX: (_chartDataCompleted.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
        ),
      );
    } else if (_selectedGraphType == 'bar') {
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: maxY > 10 ? 5 : 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: _selectedTimeframe == '1day' ? 4 : (_selectedTimeframe == '7day' ? 1 : 5),
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(_getXAxisLabel(value, _chartDataCompleted.length), style: const TextStyle(fontSize: 11)),
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          barGroups: List.generate(_chartDataCompleted.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _chartDataCompleted[i].y,
                  color: Colors.green,
                  width: 6,
                  borderRadius: BorderRadius.circular(2),
                ),
                BarChartRodData(
                  toY: _chartDataPending[i].y,
                  color: Colors.red,
                  width: 6,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }),
        ),
      );
    } else { // Scatter plot
      return ScatterChart(
        ScatterChartData(
          scatterSpots: [
            ..._chartDataCompleted.map((spot) => ScatterSpot(
                  spot.x,
                  spot.y,
                  dotPainter: FlDotCirclePainter(
                    radius: 6,
                    color: Colors.green,
                    strokeWidth: 0,
                  ),
                )),
            ..._chartDataPending.map((spot) => ScatterSpot(
                  spot.x,
                  spot.y,
                  dotPainter: FlDotCirclePainter(
                    radius: 6,
                    color: Colors.red,
                    strokeWidth: 0,
                  ),
                )),
          ],
          minX: 0,
          maxX: (_chartDataCompleted.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          scatterTouchData: ScatterTouchData(enabled: true),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
        ),
      );
    }
  }

  String _getXAxisLabel(double value, int totalPoints) {
    int index = value.toInt();
    if (totalPoints <= 0 || index < 0 || index >= totalPoints) return '';

    if (_selectedTimeframe == '1day') {
      return '$index:00';
    } else {
      DateTime date = DateTime.now().subtract(Duration(days: totalPoints - 1 - index));
      return '${date.day}';
    }
  }

  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, color: Colors.green, size: 12),
        SizedBox(width: 4),
        Text('Completed', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(width: 16),
        Icon(Icons.circle, color: Colors.red, size: 12),
        SizedBox(width: 4),
        Text('Pending', style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTimeframeButtons() {
    return ToggleButtons(
      isSelected: [
        _selectedTimeframe == '1day',
        _selectedTimeframe == '7day',
        _selectedTimeframe == '30day',
      ],
      onPressed: (int index) {
        setState(() {
          if (index == 0) {
            _selectedTimeframe = '1day';
          } else if (index == 1) {
            _selectedTimeframe = '7day';
          } else {
            _selectedTimeframe = '30day';
          }
          _refreshFuture = _loadTasksAndAnalytics();
        });
      },
      borderRadius: BorderRadius.circular(20),
      children: const [
        Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('1D')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('7D')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('1M')),
      ],
    );
  }

  Widget _buildGraphTypeButtons() {
    return Row(
      children: [
        if (_selectedGraphType == 'line') ...[
          IconButton(
            tooltip: _isCurvedLine ? 'Switch to Straight Lines' : 'Switch to Smooth Curves',
            icon: Icon(
              _isCurvedLine ? Icons.gesture : Icons.show_chart,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                _isCurvedLine = !_isCurvedLine;
              });
            },
          ),
          const SizedBox(width: 4),
        ],
        ToggleButtons(
          isSelected: [
            _selectedGraphType == 'line',
            _selectedGraphType == 'bar',
            _selectedGraphType == 'scatter',
          ],
          onPressed: (int index) {
            setState(() {
              if (index == 0) _selectedGraphType = 'line';
              if (index == 1) _selectedGraphType = 'bar';
              if (index == 2) _selectedGraphType = 'scatter';
            });
          },
          borderRadius: BorderRadius.circular(20),
          children: const [
            Icon(Icons.show_chart, size: 20),
            Icon(Icons.bar_chart, size: 20),
            Icon(Icons.scatter_plot, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildNumericSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard('Completed', '$_completedTasksInPeriod'),
          _buildSummaryCard('Pending', '$_pendingTasksInPeriod'),
          _buildSummaryCard('Completion', '${_completionPercentage.toStringAsFixed(0)}%'),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: FutureBuilder(
        future: _refreshFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Your productivity trend over the last ${_getFormattedTimeframeText()}.',
                    style: TextStyle(
                      fontSize: 15, 
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeframeButtons(),
                      _buildGraphTypeButtons(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 220,
                    child: _buildGraph(),
                  ),
                  const SizedBox(height: 12),
                  _buildLegend(),
                  const SizedBox(height: 12),
                  _buildNumericSummary(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}