import '../models/sensor_data.dart';

// ponytail: static dummy service; swap with mqtt_client stream in next assignment.
class DummyIotService {
  static const IotDashboardData initialData = IotDashboardData(
    isConnected: true,
    temperature: 30.5,
    humidity: 75,
    sensorName: 'Sensor DHT11',
    broker: 'broker.hivemq.com',
    topic: 'kampus/iot/kelas1/sensor',
    lastUpdate: '10:15:30',
    history: [
      TemperaturePoint(time: '10:00', temperature: 28.0),
      TemperaturePoint(time: '10:05', temperature: 29.0),
      TemperaturePoint(time: '10:10', temperature: 28.5),
      TemperaturePoint(time: '10:15', temperature: 30.5),
    ],
  );
}
