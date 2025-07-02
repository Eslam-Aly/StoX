/// stock_details_screen.dart
/// Displays a detailed view of a stock, including a price chart, basic info,
/// and quick price alert actions.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/stock_chart_service.dart';
import '../providers/portfolio_provider.dart';

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

  /// Fetches candle data and transforms it into chart spots for FLChart.
  Future<void> fetchChart() async {
    final now = DateTime.now();
    final to = now.millisecondsSinceEpoch ~/ 1000;
    final from = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;

    final rawData = await StockChartService.fetchCandleData(
      symbol: widget.stockSymbol,
      resolution: 'D',
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
            // Chart display
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

            // Stock name and price change
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

            // Additional stock info
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

            // Price alert section
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
            const Divider(height: 32),

            // Portfolio actions
            Consumer<PortfolioProvider>(
              builder: (context, portfolio, _) {
                final isInPortfolio = portfolio.portfolio
                    .any((item) => item['name'] == widget.stockSymbol);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isInPortfolio
                          ? null
                          : () {
                              portfolio.addStock({
                                "name": widget.stockSymbol,
                                "amount": "\$0.00",
                                "change": "0.0 (0.00%)",
                                "icon": Icons.trending_flat,
                                "color": Colors.grey,
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Add"),
                    ),
                    ElevatedButton(
                      onPressed: isInPortfolio
                          ? () {
                              portfolio.removeStock(widget.stockSymbol);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Remove"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Returns a styled ElevatedButton for setting price alerts.
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