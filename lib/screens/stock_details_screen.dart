// stock_details_screen.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/stock_chart_service.dart';
import '../providers/portfolio_provider.dart';
import '../services/crypto_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/background_wrapper.dart';
import '../providers/country_provider.dart';

class StockDetailsScreen extends StatefulWidget {
  final String stockSymbol;
  final String stockName;
  final double? price;
  final double? prevClose;
  final String? logo;

  const StockDetailsScreen({
    Key? key,
    required this.stockSymbol,
    required this.stockName,
    this.price,
    this.prevClose,
    this.logo,
  }) : super(key: key);

  @override
  State<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  List<FlSpot> chartSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateChartForRange(selectedRange);
  }

  String selectedRange = "1M";

  void updateChartForRange(String range) {
    setState(() {
      selectedRange = range;

      // Simulate different charts for different ranges
      final dummyPrices = switch (range) {
        "1D" => [102, 103, 101, 104],
        "1W" => [100, 105, 107, 106, 109, 108, 110],
        "1M" => [100, 102, 101.5, 103.2, 104.8, 104.2, 105.7, 106.0],
        "3M" => List.generate(30, (i) => 100 + i * 0.7),
        "1Y" => List.generate(50, (i) => 90 + i * 1.2),
        _ => [100, 102, 104],
      };

      chartSpots = dummyPrices
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList();
    });
  }

  Future<void> fetchChart() async {
    final now = DateTime.now();
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
    final currencySymbol = Provider.of<CountryProvider>(context).currencySymbol;
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.stockSymbol),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(  // Added for scrollability
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo section
                    Center(
                      child: widget.logo != null && widget.logo!.isNotEmpty
                          ? Image.network(
                        widget.logo!,
                        height: 60,
                        errorBuilder: (_, __, ___) => Icon(
                          getCryptoIcon(widget.stockSymbol),
                          color: Colors.amber,
                          size: 60,
                        ),
                      )
                          : Icon(
                        getCryptoIcon(widget.stockSymbol),
                        color: Colors.amber,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Chart section
                    ConstrainedBox(  // Added constraints
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SfCartesianChart(
                          backgroundColor: Colors.black,
                          primaryXAxis: CategoryAxis(
                            axisLine: const AxisLine(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries>[
                            LineSeries<FlSpot, String>(
                              dataSource: chartSpots,
                              xValueMapper: (FlSpot spot, _) => spot.x.toInt().toString(),
                              yValueMapper: (FlSpot spot, _) => spot.y,
                              color: Colors.green,
                              dataLabelSettings: const DataLabelSettings(isVisible: false),
                              markerSettings: const MarkerSettings(isVisible: true),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name & Price section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(  // Added flexible
                          child: Text(
                            widget.stockName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,  // Prevent long names from overflowing
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.price != null ? "$currencySymbol${widget.price!.toStringAsFixed(2)}" : "--",
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (widget.price != null && widget.prevClose != null)
                              Text(
                                (() {
                                  final diff = widget.price! - widget.prevClose!;
                                  final percent = (diff / widget.prevClose!) * 100;
                                  return "${diff.toStringAsFixed(2)} (${percent.toStringAsFixed(2)}%)";
                                })(),
                                style: TextStyle(
                                  color: widget.price! >= widget.prevClose! ? Colors.green : Colors.red,
                                ),
                              )
                            else
                              const Text("--", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Stats section
                    Column(
                      children: [
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
                      ],
                    ),
                    const Divider(height: 32),

                    // Time range selector
                    Column(  // Wrapped in column for better spacing
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select Time Range"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children: [
                            _timeRangeButton("1D", () => updateChartForRange("1D")),
                            _timeRangeButton("1W", () => updateChartForRange("1W")),
                            _timeRangeButton("1M", () => updateChartForRange("1M")),
                            _timeRangeButton("3M", () => updateChartForRange("3M")),
                            _timeRangeButton("1Y", () => updateChartForRange("1Y")),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Portfolio actions
                    Consumer<PortfolioProvider>(
                      builder: (context, portfolio, _) {
                        final isInPortfolio = portfolio.portfolio
                            .any((stock) => stock['symbol'] == widget.stockSymbol);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(  // Added flexible for button
                              child: ElevatedButton(
                                onPressed: isInPortfolio
                                    ? null
                                    : () {
                                  final quantityController = TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text("Enter Quantity"),
                                        content: TextField(
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: "e.g. 10",
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              final quantity = double.tryParse(quantityController.text) ?? 1;
                                              portfolio.addStock({
                                                "symbol": widget.stockSymbol,
                                                "name": widget.stockName,
                                                "price": widget.price ?? 0.0,
                                                "prevClose": widget.prevClose ?? 0.0,
                                                "logo": widget.logo ?? '',
                                                "quantity": quantity,
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Add"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Add"),
                              ),
                            ),
                            const SizedBox(width: 16),  // Added spacing
                            Flexible(  // Added flexible for button
                              child: ElevatedButton(
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
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _timeRangeButton(String label, [VoidCallback? onPressed]) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade800,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    ),
    child: Text(label),
  );
}