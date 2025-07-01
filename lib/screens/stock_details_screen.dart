import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import '../services/stock_service.dart';

class StockDetailsScreen extends StatefulWidget {
  final String stockSymbol;
  final String stockName;

  const StockDetailsScreen({
    super.key,
    required this.stockSymbol,
    required this.stockName,
  });

  @override
  State<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  List<FlSpot> chartSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChart();
  }

  Future<void> fetchChart() async {
    final now = DateTime.now();
    final to = now.millisecondsSinceEpoch ~/ 1000;
    final from = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;
    final rawData = await StockService.fetchCandleData(
      symbol: widget.stockSymbol,
      resolution: 'D',
      from: from,
      to: to,
    );
    final spots = rawData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final price = double.tryParse(entry.value['price'].toString()) ?? 0.0;
      return FlSpot(index, price);
    }).toList();
    setState(() {
      chartSpots = spots;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.stockName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartSpots,
                            isCurved: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Stock title and change
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.stockName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("110.93", style: TextStyle(fontSize: 18)),
                    Text("-1053.7 (-1.23%)", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),

            // Stock info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Market Cap", style: TextStyle(color: Colors.grey)),
                Text("1.67T"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Day’s Range", style: TextStyle(color: Colors.grey)),
                Text("82964.18 - 84208.81"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("52W Range", style: TextStyle(color: Colors.grey)),
                Text("48569.59 - 108125.82"),
              ],
            ),

            const Divider(height: 32),

            // Set price alert
            const Text("🔔 Set price alert"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                _alertButton("-5"),
                _alertButton("-10"),
                _alertButton("+5"),
                _alertButton("+10"),
                _alertButton("custom"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for alert buttons
Widget _alertButton(String label) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade800,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    ),
    child: Text(label),
  );
}