import 'package:flutter/material.dart';

import '../../controller/price_header_controller.dart';
import '../../data_models/price_data.dart';
import '../../utils/services/price_service.dart';
import '../../utils/services/web_socket_service.dart';

class PrinceHeader extends StatefulWidget {
  const PrinceHeader({super.key});

  @override
  State<PrinceHeader> createState() => _PrinceHeaderState();
}

class _PrinceHeaderState extends State<PrinceHeader> {
  late final PriceController _priceController;
  late final WebSocketService _webSocketService;
  late final PriceApiService _apiService;

  PriceData _priceData = PriceData.initial();
  String _error = '';
  static const String _symbol = "BTCUSDT";

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    _webSocketService = WebSocketService();
    _apiService = PriceApiService(baseUrl: 'https://api.binance.com');

    _priceController = PriceController(
      webSocketService: _webSocketService,
      apiService: _apiService,
      symbol: _symbol,
    );

    _priceController.priceDataStream.listen((data) {
      setState(() {
        _priceData = data;
        _error = '';
      });
    });

    _priceController.errorStream.listen((error) {
      setState(() {
        _error = error;
      });
    });

    _priceController.initialize();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }

    return PriceHeaderView(
      priceData: _priceData,
      symbol: _symbol,
    );
  }
}

class PriceHeaderView extends StatelessWidget {
  final PriceData priceData;
  final String symbol;

  const PriceHeaderView({
    super.key,
    required this.priceData,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 8,
                          child: Text('₿', style: TextStyle(fontSize: 10)),
                        ),
                        SizedBox(width: 4),
                        Text('BTC/USDT'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '\$${priceData.currentPrice}',
                    style: TextStyle(
                      fontSize: 20,
                      color: priceData.isPositiveChange
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPriceChanges(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceChanges() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildPriceSection(
            label: '24h change',
            value: priceData.priceChange,
            percentage: priceData.priceChangePercent,
            icon: Icons.access_time_rounded,
            isPositive: priceData.isPositiveChange,
          ),
          _buildDivider(),
          const SizedBox(width: 5),
          _buildPriceSection(
            label: '24h high',
            value: priceData.highPrice,
            percentage: priceData.priceChangePercent,
            icon: Icons.arrow_upward_rounded,
            isPositive: true,
          ),
          _buildDivider(),
          const SizedBox(width: 5),
          _buildPriceSection(
            label: '24h low',
            value: priceData.lowPrice,
            percentage: priceData.priceChangePercent,
            icon: Icons.arrow_downward_rounded,
            isPositive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[800],
    );
  }

  Widget _buildPriceSection({
    required String label,
    required String value,
    required String percentage,
    required IconData icon,
    required bool isPositive,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.grey[400], size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: percentage.isEmpty
                        ? null
                        : (isPositive ? Colors.green : Colors.red),
                  ),
                ),
                if (percentage.isNotEmpty) ...[
                  const SizedBox(width: 5),
                  Text(
                    percentage,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
