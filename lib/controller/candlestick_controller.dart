import 'dart:async';

import '../data_models/candlesticks.dart';
import '../utils/services/candle_stick_service.dart';

class ChartController {
  final CryptoApiService _apiService;
  final StreamController<List<CandleStickModel>> _candlesticksController =
      StreamController<List<CandleStickModel>>.broadcast();

  List<CandleStickModel> _currentCandlesticks = [];
  StreamSubscription? _candlestickSubscription;
  String _currentSymbol = 'BTCUSDT';
  String _currentInterval = '1m';

  Stream<List<CandleStickModel>> get candlesticksStream =>
      _candlesticksController.stream;

  ChartController(this._apiService);

  Future<void> loadInitialData() async {
    try {
      final data = await _apiService.getCandlestickData(
        symbol: _currentSymbol,
        interval: _currentInterval,
      );
      _currentCandlesticks = data;
      _candlesticksController.add(_currentCandlesticks);
      subscribeToRealtimeUpdates();
    } catch (e) {
      _candlesticksController.addError(e);
    }
  }

  void subscribeToRealtimeUpdates() {
    _candlestickSubscription?.cancel();
    final stream = _apiService.subscribeToCandlesticks(
      _currentSymbol,
      _currentInterval,
    );

    _candlestickSubscription = stream?.listen((newCandle) {
      final index = _currentCandlesticks.indexWhere(
        (candle) => candle.time == newCandle.time,
      );

      if (index != -1) {
        _currentCandlesticks[index] = newCandle;
      } else {
        _currentCandlesticks.add(newCandle);
        if (_currentCandlesticks.length > 100) {
          _currentCandlesticks.removeAt(0);
        }
      }
      _candlesticksController.add(_currentCandlesticks);
    });
  }

  void changeSymbol(String symbol) {
    _currentSymbol = symbol;
    loadInitialData();
  }

  void changeInterval(String interval) {
    _currentInterval = interval;
    loadInitialData();
  }

  void dispose() {
    _candlestickSubscription?.cancel();
    _candlesticksController.close();
    _apiService.unsubscribe();
  }
}
