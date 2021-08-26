
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;


class LoadCsvDataScreen extends StatefulWidget {
  final String path;

  LoadCsvDataScreen({this.path});
  @override
  _LoadCsvDataScreen createState() => _LoadCsvDataScreen();
}

class _LoadCsvDataScreen extends State<LoadCsvDataScreen> {

  List<List<dynamic>> listData = List<List<dynamic>>();

  @override
  void initState() {
    super.initState();
    loadingCsvData(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CSV DATA"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: listData.length,
                itemBuilder: (_, index) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    color: index == 0 ? Colors.amber : Colors.white,
                    child: ListTile(
                      leading: Text(listData[index][0].toString()),
                      title: Text(listData[index][0].toString()),
                      trailing: Text(listData[index][0].toString()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadingCsvData(String path) async {
    // final csvFile = new File(path).openRead();
    // return await csvFile.transform(utf8.decoder).transform(
    //   CsvToListConverter(),
    // ).toList();

    final myData = await rootBundle.loadString(path, cache: true);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    print(csvTable);
    setState(() {
      listData = csvTable;
    });
  }

}