import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PrintScreen extends StatefulWidget {
  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, String> _printers = {
    'Impresora 1': '192.168.1.100:9100',
    'Impresora 2': '192.168.1.101:9100',
  };
  String? _selectedPrinterLabel;
  bool _isImageVisible = false;

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> printData() async {
    if (_selectedPrinterLabel == null) {
      showPrintNotification('No se ha seleccionado ninguna impresora.');
      return;
    }

    final printerIp = _printers[_selectedPrinterLabel]!;
    final url = 'http://$printerIp'; // URL de impresión
    final headers = {'Content-Type': 'text/plain'};
    final body = 'Hello, Printer!'; // Datos a enviar

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        showPrintNotification('Impresión exitosa');
        setState(() {
          _isImageVisible = true;
        });
      } else {
        showPrintNotification('Error en la impresión');
      }
    } catch (e) {
      showPrintNotification('Error de conexión');
    }
  }

  void showPrintNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'print_channel_id',
      'Print Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: null,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Print Notification',
      message,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: printData,
                  child: Text('Print'),
                ),
                if (_printers.isNotEmpty)
                  DropdownButton<String>(
                    value: _selectedPrinterLabel,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPrinterLabel = newValue;
                      });
                    },
                    items: _printers.keys
                        .map<DropdownMenuItem<String>>((String label) {
                      return DropdownMenuItem<String>(
                        value: label,
                        child: Text(label),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          _isImageVisible
              ? Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(16),
                  child: Image.asset('assets/images/preview_image.png'),
                )
              : Container(),
        ],
      ),
    );
  }
}
