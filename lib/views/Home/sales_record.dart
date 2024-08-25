import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/api_service.dart';
import '../../models/sales_record_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SalesRecordPage extends StatefulWidget {
  @override
  _SalesRecordPageState createState() => _SalesRecordPageState();
}

class _SalesRecordPageState extends State<SalesRecordPage> {
  final _apiService = ApiService();
  DateTimeRange? _selectedDateRange;
  List<SalesRecord> _salesRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesRecords();
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _fetchSalesRecords(); // Fetch Records again for the selected date range
      });
    }
  }

  Future<void> _fetchSalesRecords() async {
    try {
      final Records = await _apiService.getSalesRecords();
      setState(() {
        _salesRecords = Records.where((Record) {
          if (_selectedDateRange == null) {
            return true;
          } else {
            final RecordDate = DateTime.parse(Record.date);
            return RecordDate.isAfter(_selectedDateRange!.start) &&
                RecordDate.isBefore(_selectedDateRange!.end);
          }
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load sales Records: $e')),
      );
    }
  }

  List<charts.Series<SalesData, String>> _createChartData() {
    final data = _salesRecords.map((Record) {
      return SalesData(
        DateFormat('MMM d').format(DateTime.parse(Record.date)),
        Record.totalAmount,
      );
    }).toList();

    return [
      charts.Series<SalesData, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SalesData sales, _) => sales.date,
        measureFn: (SalesData sales, _) => sales.amount,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Penjualan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Laporan
            Text(
              'Filter Laporan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _selectDateRange,
                    child: Text(_selectedDateRange == null
                        ? 'Pilih Rentang Tanggal'
                        : '${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Grafik Penjualan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200.0,
              child: charts.BarChart(
                _createChartData(),
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String date;
  final double amount;

  SalesData(this.date, this.amount);
}
