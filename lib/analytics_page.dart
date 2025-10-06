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
  String _selectedGraphType = 'line';
  int _totalTasksInPeriod = 0;
  int _completedTasksInPeriod = 0;
  int _pendingTasksInPeriod = 0; // NEW: Added a variable for pending tasks
  double _completionPercentage = 0.0;
  List<FlSpot> _chartDataCompleted = [];
  List<FlSpot> _chartDataPending = [];

  @override
  void initState() {
    super.initState();
    _loadTasksAndAnalytics();
  }

  // This method ensures the data is reloaded every time you switch to this page.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTasksAndAnalytics();
  }

  Future<void> _loadTasksAndAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getStringList('tasks_history') ?? [];
    // NEW: Also load tasks that are currently pending.
    final savedPending = prefs.getStringList('tasks') ?? [];

    final history = savedHistory.map((e) => Task.fromJson(jsonDecode(e))).toList();
    final pending = savedPending.map((e) => Task.fromJson(jsonDecode(e))).toList();

    if (mounted) {
      setState(() {
        _tasksHistory = history + pending; // Combine all tasks for analysis
        _calculateAnalytics();
      });
    }
  }

  void _calculateAnalytics() {
    _chartDataCompleted.clear();
    _chartDataPending.clear();
    _totalTasksInPeriod = 0;
    _completedTasksInPeriod = 0;

    final now = DateTime.now();
    List<Task> relevantTasks = [];
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final int daysToDisplay = _selectedTimeframe == '1day' ? 24 : (_selectedTimeframe == '7day' ? 7 : daysInMonth);

    if (_selectedTimeframe == '1day') {
      relevantTasks = _tasksHistory.where((task) =>
      task.createdDate.year == now.year && task.createdDate.month == now.month && task.createdDate.day == now.day).toList();
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
    _completionPercentage = _totalTasksInPeriod > 0 ? (_completedTasksInPeriod / _totalTasksInPeriod) * 100 : 0.0;

    final Map<int, int> completedData = {};
    final Map<int, int> pendingData = {};
    for (int i = 0; i < daysToDisplay; i++) {
      completedData[i] = 0;
      pendingData[i] = 0;
    }

    relevantTasks.forEach((task) {
      int index;
      if (_selectedTimeframe == '1day') {
        index = task.createdDate.hour;
      } else {
        final daysAgo = now.difference(task.createdDate).inDays;
        index = (daysToDisplay - 1) - daysAgo;
      }
      if (task.isCompleted) {
        completedData[index] = (completedData[index] ?? 0) + 1;
      } else {
        pendingData[index] = (pendingData[index] ?? 0) + 1;
      }
    });

    _chartDataCompleted = completedData.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
    _chartDataPending = pendingData.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
  }

  Widget _buildGraph() {
    if (_chartDataCompleted.isEmpty && _chartDataPending.isEmpty) {
      return const Center(child: Text('No data for this period.'));
    }

    final maxY = _totalTasksInPeriod > 0 ? _totalTasksInPeriod.toDouble() : 100.0;

    if (_selectedGraphType == 'line') {
      return LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _chartDataCompleted,
              isCurved: true,
              color: Colors.green, // Completed tasks
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: _chartDataPending,
              isCurved: true,
              color: Colors.red, // Pending tasks
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          minX: 0, maxX: _chartDataCompleted.length.toDouble() - 1, minY: 0, maxY: maxY,
        ),
      );
    } else { // Scatter plot
      return ScatterChart(
        ScatterChartData(
          scatterSpots: [
            ..._chartDataCompleted.map((spot) => ScatterSpot(spot.x, spot.y)).toList(),
            ..._chartDataPending.map((spot) => ScatterSpot(spot.x, spot.y)).toList(),
          ],
          minX: 0, maxX: _chartDataCompleted.length.toDouble() - 1, minY: 0, maxY: maxY,
          scatterTouchData: ScatterTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
        ),
      );
    }
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
          _loadTasksAndAnalytics();
        });
      },
      borderRadius: BorderRadius.circular(20),
      children: const [
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('1D')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('7D')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('1M')),
      ],
    );
  }

  Widget _buildGraphTypeButtons() {
    return ToggleButtons(
      isSelected: [
        _selectedGraphType == 'line',
        _selectedGraphType == 'scatter',
      ],
      onPressed: (int index) {
        setState(() {
          if (index == 0) {
            _selectedGraphType = 'line';
          } else {
            _selectedGraphType = 'scatter';
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      children: const [
        Icon(Icons.show_chart),
        Icon(Icons.scatter_plot),
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
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeframeButtons(),
                _buildGraphTypeButtons(),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildGraph(),
            ),
            _buildNumericSummary(),
          ],
        ),
      ),
    );
  }
}