import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/endpoints.dart';
import '../data_models/order_book.dart';

class OrderbookController {
  late WebSocketChannel _channel;
  final void Function(List<OrderbookEntry>, List<OrderbookEntry>)?
      onOrderbookUpdate;
  final void Function(String)? onError;
  String? _currentSymbol;

  OrderbookController({this.onOrderbookUpdate, this.onError});

  void connectToSymbol(String symbol, {String updateSpeed = "@1000ms"}) {
    _currentSymbol = symbol.toLowerCase();
    final wsUrl =
        Uri.parse("${Endpoints.baseUrl}/$_currentSymbol@depth$updateSpeed");

    _channel = WebSocketChannel.connect(wsUrl);
    _listenToStream();
  }

  void _listenToStream() {
    _channel.stream.listen(
      (message) => _handleMessage(message),
      onError: (error) {
        onError?.call('Connection error: $error');
        _reconnect();
      },
      onDone: _reconnect,
    );
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final bids = (data['b'] as List)
          .map((e) => OrderbookEntry(
                price: double.parse(e[0] as String),
                quantity: double.parse(e[1] as String),
              ))
          .toList();

      final asks = (data['a'] as List)
          .map((e) => OrderbookEntry(
                price: double.parse(e[0] as String),
                quantity: double.parse(e[1] as String),
              ))
          .toList();

      onOrderbookUpdate?.call(bids, asks);
    } catch (e) {
      onError?.call('Failed to parse data: $e');
    }
  }

  void _reconnect() {
    if (_currentSymbol != null) {
      Future.delayed(const Duration(seconds: 5), () {
        connectToSymbol(_currentSymbol!);
      });
    }
  }

  void dispose() {
    _channel.sink.close();
    _currentSymbol = null;
  }
}
