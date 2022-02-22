import 'dart:convert';
import 'dart:io';

import 'package:customer_service_app/Layouts/Home%20Page/Tech/tech_ticket_summary.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../../../Widgets/button_widget.dart';

class DownloadPage extends StatefulWidget {
  static const String id = 'download_page';

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final Dio _dio = Dio();
  String? _progress;
  double percentage = 0;
  bool _isLoading = false;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final iOS = IOSInitializationSettings();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    _progress = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تنزيل التذكرة',
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isLoading
                  ? Center(
                      child: SpinKitChasingDots(
                        color: Colors.brown,
                      ),
                    )
                  : Icon(
                      Icons.cloud_download,
                      color: Colors.brown,
                      size: 250,
                    ),
              SizedBox(
                height: 15,
              ),
              _progress != null && _progress != '100%'
                  ? Column(
                      children: [
                        Text(
                          'جاري التنزيل ',
                        ),
                        Text(
                          '$_progress',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    )
                  : _progress == '100%'
                      ? Text('تم تنزيل الملف')
                      : Container(),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ButtonWidget(
                  text: 'تنزيل التقرير ',
                  onTap: () async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      _download(reportName, reportUrl);
                    } catch (ex) {}
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              invoiceUrl != 'N/A'
                  ? Center(
                      child: ButtonWidget(
                        text: 'تنزيل الفاتورة ',
                        onTap: () async {
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            _download(invoiceName, invoiceUrl);
                          } catch (ex) {}
                        },
                      ),
                    )
                  : Container(),
            ]),
      ),
    );
  }

  Future<void> _download(docName, link) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      final savePath = path.getDownloadsDirectory().toString();
      await _startDownload(savePath, link);
    } else {
      // handle the scenario when user declines the permissions
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    return await path.getExternalStorageDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.request();
    return permission == PermissionStatus.granted;
  }

  Future<void> _startDownload(String savePath, String linkToSave) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    try {
      final response = await _dio.download(
        linkToSave,
        savePath,
        onReceiveProgress: _onReceiveProgress,
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + '%';
        if (_progress == '100%') {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _onSelectNotification(String? json) async {
    final obj = jsonDecode(json!);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('خطأ'),
          content: Text('حصل خطأ في تنزيل الملف'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails('channel id', 'channel name',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin
        .show(
            0,
            isSuccess ? 'نجح التنزيل' : 'خطأ في التنزيل',
            isSuccess ? 'تم تنزيل الملف بنجاح' : 'حصل خطأ في تنزيل الملف',
            platform,
            payload: json)
        .then((value) => _progress = '0');
  }
}
