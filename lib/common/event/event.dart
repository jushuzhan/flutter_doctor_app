/**
 * This is an example of how to set up the [EventBus] and its events.
 */
import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus(sync: true);//同步 默认是异步

/// Event A.
class MyEventA {
  String text;

  MyEventA(this.text);
}

/// Event B.
class MyEventB {
  String text;

  MyEventB(this.text);
}
class MyEventRefresh{
  bool isRefresh=false;//默认不需要刷新
  MyEventRefresh(this.isRefresh);
}