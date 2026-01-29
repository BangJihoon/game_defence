// lib/game/events/event_bus.dart
import 'dart:async';
import 'package:game_defence/game/events/game_events.dart';

typedef EventCallback<T extends GameEvent> = void Function(T event);

class EventBus {
  final _streamController = StreamController<GameEvent>.broadcast();

  Stream<GameEvent> get _stream => _streamController.stream;

  void fire<T extends GameEvent>(T event) {
    _streamController.add(event);
  }

  StreamSubscription<T> on<T extends GameEvent>(EventCallback<T> callback) {
    return _stream.where((event) => event is T).cast<T>().listen(callback);
  }

  void dispose() {
    _streamController.close();
  }
}
