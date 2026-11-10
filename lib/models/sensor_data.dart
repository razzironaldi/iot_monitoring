class TemperaturePoint {
  final String time;
  final double temperature;

  const TemperaturePoint({
    required this.time,
    required this.temperature,
  });
}

class IotDashboardData {
  final bool isConnected;
  final double temperature;
  final int humidity;
  final String sensorName;
  final String broker;
  final String topic;
  final String lastUpdate;
  final List<TemperaturePoint> history;

  const IotDashboardData({
    required this.isConnected,
    required this.temperature,
    required this.humidity,
    required this.sensorName,
    required this.broker,
    required this.topic,
    required this.lastUpdate,
    required this.history,
  });

  IotDashboardData copyWith({bool? isConnected}) {
    return IotDashboardData(
      isConnected: isConnected ?? this.isConnected,
      temperature: temperature,
      humidity: humidity,
      sensorName: sensorName,
      broker: broker,
      topic: topic,
      lastUpdate: lastUpdate,
      history: history,
    );
  }
}
