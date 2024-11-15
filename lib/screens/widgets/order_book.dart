import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../controller/order_book_controller.dart';
import '../../data_models/order_book.dart';

class OrderBookEntryWidget extends StatelessWidget {
  final OrderbookEntry entry;
  final bool isBid;
  final double maxQuantity;

  const OrderBookEntryWidget({
    super.key,
    required this.entry,
    required this.isBid,
    required this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: isBid
            ? Colors.green.withOpacity(0.1 * entry.quantity / maxQuantity)
            : Colors.red.withOpacity(0.1 * entry.quantity / maxQuantity),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              entry.price.toStringAsFixed(2),
              style: TextStyle(
                color:
                    isBid ? const Color(0xFF00C853) : const Color(0xFFFF5252),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              entry.quantity.toStringAsFixed(6),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              (entry.price * entry.quantity).toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderBookScreen extends StatefulWidget {
  final String symbol;
  final int depth;

  const OrderBookScreen(
      {super.key,
      required this.symbol,
      this.depth = 5 // Default to showing 5 entries
      });

  @override
  State<OrderBookScreen> createState() => _OrderBookScreenState();
}

class _OrderBookScreenState extends State<OrderBookScreen> {
  late OrderbookController _controller;
  List<OrderbookEntry> _bids = [];
  List<OrderbookEntry> _asks = [];

  @override
  void initState() {
    super.initState();
    _controller = OrderbookController(
      onOrderbookUpdate: _handleUpdate,
      onError: _handleError,
    );
    _controller.connectToSymbol(widget.symbol);
  }

  void _handleUpdate(List<OrderbookEntry> bids, List<OrderbookEntry> asks) {
    if (mounted) {
      setState(() {
        // Take only the first 5 entries
        _bids = bids.take(widget.depth).toList();
        _asks = asks.take(widget.depth).toList();
      });
    }
  }

  void _handleError(String error) {
    if (mounted) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxQuantity = [..._bids, ..._asks]
        .fold(0.0, (max, entry) => entry.quantity > max ? entry.quantity : max);

    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Price\n(USDT)',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Amounts\n(BTC)',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.depth * 32.0,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _asks.length,
              reverse: true,
              itemBuilder: (context, index) => OrderBookEntryWidget(
                entry: _asks[index],
                isBid: false,
                maxQuantity: maxQuantity,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _bids.isNotEmpty
                      ? _bids.first.price.toStringAsFixed(2)
                      : '-.--',
                  style: const TextStyle(
                    color: AppColors.kGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_upward,
                  size: 16,
                  color: AppColors.kGreen,
                ),
                Text(
                  ' ${_bids.isNotEmpty ? _bids.first.price.toStringAsFixed(2) : '-.--'}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.depth * 32.0, // Assuming each row is 32px high
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bids.length,
              itemBuilder: (context, index) => OrderBookEntryWidget(
                entry: _bids[index],
                isBid: true,
                maxQuantity: maxQuantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
