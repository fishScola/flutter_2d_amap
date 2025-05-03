// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flutter2dAMap.updatePrivacy(true);
  Flutter2dAMap.setApiKey(
    iOSKey: '1a8f6a489483534a9f2ca96e4eeeb9b3',
    webKey: '4e479545913a3a180b3cffc267dad646',
  ).then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PoiSearch> _list = [];
  int _index = 0;
  final ScrollController _controller = ScrollController();
  late AMap2DController? _aMap2DController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_2d_amap'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Stack(
                  children: [
                    AMap2DView(
                      onPoiSearched: (result) {
                        if (result.isEmpty) {
                          if (kDebugMode) {
                            print('无搜索结果返回');
                          }
                          return;
                        }
                        _controller.animateTo(0.0,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.ease);
                        setState(() {
                          _index = 0;
                          _list = result;
                        });
                      },
                      onAMap2DViewCreated: (controller) {
                        _aMap2DController = controller;
                      },
                    ),
                    // 地图缩放控制按钮
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "zoomIn",
                            mini: true,
                            child: const Icon(Icons.add),
                            onPressed: () {
                              if (_aMap2DController != null) {
                                _aMap2DController!.zoomIn();
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton(
                            heroTag: "zoomOut",
                            mini: true,
                            child: const Icon(Icons.remove),
                            onPressed: () {
                              if (_aMap2DController != null) {
                                _aMap2DController!.zoomOut();
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton(
                            heroTag: "location",
                            mini: true,
                            child: const Icon(Icons.my_location),
                            onPressed: () {
                              if (_aMap2DController != null) {
                                _aMap2DController!.location();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 11,
                child: ListView.separated(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _list.length,
                    separatorBuilder: (_, index) {
                      return const Divider(height: 0.6);
                    },
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _index = index;
                            if (_aMap2DController != null) {
                              _aMap2DController?.move(
                                  _list[index].latitude ?? '',
                                  _list[index].longitude ?? '');
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 50.0,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '${_list[index].provinceName!} ${_list[index].cityName!} ${_list[index].adName!} ${_list[index].title!}',
                                ),
                              ),
                              Opacity(
                                  opacity: _index == index ? 1 : 0,
                                  child: const Icon(Icons.done,
                                      color: Colors.blue))
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
