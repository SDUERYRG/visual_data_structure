// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:math' as math;
import 'dart:core';

import 'component_screen.dart';

List<List<double>> data = List.empty();
List<List<double>> data2 = List.empty();
List<List<double>> path = List.empty();
List<List<double>> path2 = List.empty();
List<List<double>> nodePosition = List.empty();
List<String> str = List.empty();
List<List<double>> current = List.empty();
String str2 = "";
String str1 = "";

class DataStructureScreen extends StatefulWidget {
  const DataStructureScreen({Key? key}) : super(key: key);

  @override
  _DataStructureScreenState createState() => _DataStructureScreenState();
}

class _DataStructureScreenState extends State<DataStructureScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Container(
            height: 800,
            width: 600,
            child: Center(
              child: CustomPaint(
                size: Size(600, 600),
                painter: Mypainter(),
              ),
            ),
          ),
          Expanded(
            child: Container(
                height: 800,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // 添加这一行
                      children: <Widget>[
                        Text('distance数组'),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: DynamicTable(
                            data: data,
                          ),
                        ),
                        Text('path数组'),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: DynamicTable(data: path),
                        ),
                      ]),
                )),
          ),
          Expanded(
            child: Container(
              height: 800,
              child: Container(
                child: Column(children: <Widget>[
                  MyCustomForm(
                    onDataChanged: (newData) {
                      setState(() {
                        data = newData;
                      });
                    },
                    onDataChanged2: (newData) {
                      setState(() {
                        path = newData;
                      });
                    },
                    onCurrentChanged: (newData) {
                      setState(() {
                        current = newData;
                      });
                    },
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  final Function(List<List<double>>) onDataChanged;
  final Function(List<List<double>>) onDataChanged2;
  final Function(List<List<double>>) onCurrentChanged;
  const MyCustomForm(
      {Key? key,
      required this.onDataChanged,
      required this.onDataChanged2,
      required this.onCurrentChanged})
      : super(key: key);
  void floydWarshall(List<List<double>> dis, List<List<double>> path) async {
    int n = dis.length;
    for (int k = 1; k < n; k++) {
      for (int i = 1; i < n; i++) {
        for (int j = 1; j < n; j++) {
          current[0][0] = i.toDouble();
          current[0][1] = k.toDouble();
          current[0][2] = j.toDouble();
          current[1][0] = dis[i][k];
          current[1][1] = dis[k][j];
          current[1][2] = dis[i][j];
          onCurrentChanged(current);
          if (dis[i][k] + dis[k][j] < dis[i][j]) {
            str2 = '(distance[$i][$k]+distance[$k][$j]<distance[$i][$j])=true';
            str1 = '则dis[$i][$j] = dis[$i][$k] + dis[$k][$j]';
            dis[i][j] = dis[i][k] + dis[k][j];
            onDataChanged(data);
            await Future.delayed(Duration(milliseconds: 500));
            path[i][j] = k.toDouble();
            onDataChanged2(path);
          } else {
            str2 = '(distance[$i][$k]+distance[$k][$j]<distance[$i][$j])=false';
            str1 = '';
            await Future.delayed(Duration(milliseconds: 500));
            onCurrentChanged(current);
          }
        }
      }
    }
    // window.alert('执行成功');
    result();
  }

  void quickfloydWarshall(List<List<double>> dis, List<List<double>> path) {
    int n = dis.length;
    for (int k = 1; k < n; k++) {
      for (int i = 1; i < n; i++) {
        for (int j = 1; j < n; j++) {
          if (dis[i][k] + dis[k][j] < dis[i][j]) {
            dis[i][j] = dis[i][k] + dis[k][j];
            onDataChanged(data);
            path[i][j] = k.toDouble();
            onDataChanged2(path);
          }
        }
      }
    }
    // window.alert('执行成功');
    result();
  }

  void result() {
    int index = 1;
    for (int i = 1; i < path.length; i++) {
      for (int j = 1; j < path[i].length; j++) {
        if (path[i][j] == -1) {
          str[index] = '从顶点$i到顶点$j没有通路。';
          index++;
        } else if (path[i][j] == i) {
          str[index] = '顶点$i与顶点$j邻接。';
          index++;
        } else {
          int k = path[i][j].toInt();
          String route = '从顶点$i到顶点$j：$i';
          String temp = '';
          while (k != i) {
            temp = ' --> $k' + temp;
            k = path[i][k].toInt();
          }
          route = route + temp;
          route += ' --> $j';
          str[index] = route;
          index++;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 添加这一行
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5, // 设置你想要的宽度
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: myController,
                keyboardType: TextInputType.number,
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5, // 设置你想要的宽度
              child: ComponentDecoration(
                label: '',
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 添加这一行
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            child: Text('生成图'),
                            onPressed: () {
                              int count = int.parse(myController.text);
                              List<List<double>> data = List.generate(
                                  count + 1,
                                  (_) =>
                                      List.filled(count + 1, double.infinity));
                              List<List<double>> path = List.generate(
                                  count + 1, (_) => List.filled(count + 1, -1));
                              str = List.generate(
                                  (count + 1) * (count + 1), (_) => '');
                              current =
                                  List.generate(2, (_) => List.filled(3, 0));
                              Random random = new Random();
                              // 初始化邻接矩阵
                              for (int i = 1; i <= count; i++) {
                                data[0][i] = i.toDouble();
                                path[0][i] = i.toDouble();
                                data[i][0] = i.toDouble();
                                path[i][0] = i.toDouble();
                              }

                              // 随机填充邻接矩阵
                              for (int i = 1; i <= count; i++) {
                                for (int j = 1; j <= count; j++) {
                                  if (random.nextBool()) {
                                    // 50%的概率生成边
                                    data[i][j] = random
                                        .nextInt(100)
                                        .toDouble(); // 边的权重为0-99的随机数
                                    if (i == j) {
                                      data[i][j] = double.infinity;
                                    }
                                  }
                                }
                              }

                              for (int i = 1; i <= count; i++) {
                                data[i][i] = double.infinity;
                                path[i][i] = -1;
                              }

                              data[0][0] = 0;
                              path[0][0] = 0;
                              onDataChanged(data);
                              int n = data.length;
                              for (int i = 1; i <= count; i++) {
                                for (int j = 1; j <= count; j++) {
                                  if (i != j && data[i][j] != double.infinity) {
                                    // Nodes i and j are connected directly
                                    path[i][j] = i.toDouble();
                                  }
                                }
                              }
                              path2 = path.map((list) => [...list]).toList();
                              data2 = data.map((list) => [...list]).toList();
                              onDataChanged2(path);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            child: Text('动态演示'),
                            onPressed: () {
                              floydWarshall(data, path);
                              onDataChanged(data);
                              onDataChanged2(path);
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 添加这一行
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            child: Text('直接执行'),
                            onPressed: () {
                              quickfloydWarshall(data, path);
                              onDataChanged(data);
                              onDataChanged2(path);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            child: const Text(
                              '重新演示',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              path = path2.map((list) => [...list]).toList();
                              data = data2.map((list) => [...list]).toList();
                              onDataChanged(data);
                              onDataChanged2(path);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5, // 设置你想要的宽度
              child: Dialogs(),
            )),
        Text(str2),
        Text(str1),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/asset/images/bc.png'), // 使用AssetImage从你的资源文件夹中加载图片
              fit: BoxFit.cover, // 使用BoxFit.cover来填充整个容器
            ),
          ),
          child: CustomPaint(
            size: Size(400, 400),
            painter: CustomImagePainter(),
          ),
        ),
      ],
    );
  }
}

Future<ui.Image> getImage(String asset) async {
  ByteData data = await rootBundle.load(asset);
  Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  FrameInfo fi = await codec.getNextFrame();
  print('object');
  print(fi.image);
  return fi.image;
}

class DynamicTable extends StatelessWidget {
  final List<List<double>> data;

  DynamicTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: data.map((row) {
        return TableRow(
          children: row.map((cell) {
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Text(cell.toString()),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class DynamicIntTable extends StatelessWidget {
  final List<int> current;

  DynamicIntTable({required this.current});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(
          children: current.map((cell) {
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Text(cell.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CustomImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawInner(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      this != oldDelegate;

  // void drawBackground(Canvas canvas) {
  //   Paint _linePaint = new Paint()
  //     ..color = Colors.blue
  //     ..style = PaintingStyle.fill
  //     ..isAntiAlias = true
  //     ..strokeCap = StrokeCap.round
  //     ..strokeWidth = 30.0;

  //   // 绘制图片
  //   canvas.drawImage(image, Offset(0, 0), _linePaint); // 直接画图
  // }

  void drawInner(Canvas canvas) {
    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(current[0][1].toInt().toString());
    final constraints = ui.ParagraphConstraints(width: 300);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    final offset = Offset(192, 29);
    canvas.drawParagraph(paragraph, offset);
    final paragraphBuilder2 = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(current[0][0].toInt().toString());
    final constraints2 = ui.ParagraphConstraints(width: 300);
    final paragraph2 = paragraphBuilder2.build();
    paragraph2.layout(constraints2);
    final offset2 = Offset(36, 295);
    canvas.drawParagraph(paragraph2, offset2);
    final paragraphBuilder3 = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(current[0][2].toInt().toString());
    final constraints3 = ui.ParagraphConstraints(width: 300);
    final paragraph3 = paragraphBuilder3.build();
    paragraph3.layout(constraints3);
    final offset3 = Offset(348, 295);
    canvas.drawParagraph(paragraph3, offset3);
    //绘制权值

    if (current[1][0] == double.infinity) {
      final paragraphBuilder4 = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText('INF');
      final constraints4 = ui.ParagraphConstraints(width: 300);
      final paragraph4 = paragraphBuilder4.build();
      paragraph4.layout(constraints4);
      final offset4 = Offset(75, 162);
      canvas.drawParagraph(paragraph4, offset4);
    } else {
      final paragraphBuilder4 = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(current[1][0].toInt().toString());
      final constraints4 = ui.ParagraphConstraints(width: 300);
      final paragraph4 = paragraphBuilder4.build();
      paragraph4.layout(constraints4);
      final offset4 = Offset(75, 162);
      canvas.drawParagraph(paragraph4, offset4);
    }
    if (current[1][1] == double.infinity) {
      final paragraphBuilder5 = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText('INF');
      final constraints5 = ui.ParagraphConstraints(width: 300);
      final paragraph5 = paragraphBuilder5.build();
      paragraph5.layout(constraints5);
      final offset5 = Offset(285, 162);
      canvas.drawParagraph(paragraph5, offset5);
    } else {
      final paragraphBuilder5 = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(current[1][1].toInt().toString());
      final constraints5 = ui.ParagraphConstraints(width: 300);
      final paragraph5 = paragraphBuilder5.build();
      paragraph5.layout(constraints5);
      final offset5 = Offset(285, 162);
      canvas.drawParagraph(paragraph5, offset5);
    }
    if (current[1][2] == double.infinity) {
      final paragraphBuilder6 = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText('INF');
      final constraints6 = ui.ParagraphConstraints(width: 300);
      final paragraph6 = paragraphBuilder6.build();
      paragraph6.layout(constraints6);
      final offset6 = Offset(192, 310);
      canvas.drawParagraph(paragraph6, offset6);
    } else {
      final paragraphBuilder6 = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(current[1][2].toInt().toString());
      final constraints6 = ui.ParagraphConstraints(width: 300);
      final paragraph6 = paragraphBuilder6.build();
      paragraph6.layout(constraints6);
      final offset6 = Offset(192, 310);
      canvas.drawParagraph(paragraph6, offset6);
    }
  }
}

class Mypainter extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    drawBackground(canvas, rect);
    drawNode(canvas, size);
    drawPath(canvas);
  }

  void drawNode(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    int sides = data.length - 1; // 正多边形的边数
    double radius = 200.0; // 正多边形的半径
    var center = Offset(size.width / 2, size.height / 2); // 正多边形的中心点
    // 计算并绘制正多边形的每个顶点
    nodePosition = List.generate(sides + 1, (_) => List.filled(2, 0));
    for (int i = 1; i <= sides; i++) {
      double x = center.dx + radius * math.cos(i * 2.0 * math.pi / sides);
      double y = center.dy + radius * math.sin(i * 2.0 * math.pi / sides);
      var point = Offset(x, y);
      canvas.drawCircle(point, 20.0, paint);
      nodePosition[i][0] = x;
      nodePosition[i][1] = y;
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas,
          point - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  void drawPath(Canvas canvas) {
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 根据path数组中的值连接顶点
    for (int i = 1; i < path2.length; i++) {
      for (int j = 1; j < path2[i].length; j++) {
        if (path2[i][j] != -1) {
          var start = Offset(nodePosition[i][0], nodePosition[i][1]);
          var end = Offset(nodePosition[j][0], nodePosition[j][1]);

          // 计算起点和终点在圆上的位置
          var startOnCircle = Offset(
              start.dx +
                  20 *
                      math.cos(
                          math.atan2(end.dy - start.dy, end.dx - start.dx)),
              start.dy +
                  20 *
                      math.sin(
                          math.atan2(end.dy - start.dy, end.dx - start.dx)));
          var endOnCircle = Offset(
              end.dx -
                  20 *
                      math.cos(
                          math.atan2(end.dy - start.dy, end.dx - start.dx)),
              end.dy -
                  20 *
                      math.sin(
                          math.atan2(end.dy - start.dy, end.dx - start.dx)));

          canvas.drawLine(startOnCircle, endOnCircle, paint);

          // 计算箭头的方向
          var dx = startOnCircle.dx - endOnCircle.dx;
          var dy = startOnCircle.dy - endOnCircle.dy;
          var angle = math.atan2(dy, dx);

          // 计算箭头的两个点
          var arrowPoint1 = Offset(
              endOnCircle.dx + 10 * math.cos(angle + math.pi / 6),
              endOnCircle.dy + 10 * math.sin(angle + math.pi / 6));
          var arrowPoint2 = Offset(
              endOnCircle.dx + 10 * math.cos(angle - math.pi / 6),
              endOnCircle.dy + 10 * math.sin(angle - math.pi / 6));

          // 绘制箭头
          canvas.drawLine(endOnCircle, arrowPoint1, paint);
          canvas.drawLine(endOnCircle, arrowPoint2, paint);

          // 在直线的1/3位置绘制data2[i][j]的值
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: '${data2[i][j]}',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          var textPoint = Offset(
              startOnCircle.dx - dx * 4 / 5, startOnCircle.dy - dy * 4 / 5);
          textPainter.paint(
              canvas,
              textPoint -
                  Offset(textPainter.width / 2, textPainter.height / 2));
        }
      }
    }
  }

  void drawBackground(Canvas canvas, Rect rect) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..color = Color(0xFFDCC48C);
    canvas.drawRect(rect, paint);
  }
}

class Dialogs extends StatefulWidget {
  const Dialogs({super.key});

  @override
  State<Dialogs> createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  void openDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('执行结果'),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: str.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                str[index],
                style: TextStyle(
                    fontSize: 20, // 调整文字大小为20
                    fontFamily: 'AbrilFatface'),
              );
            },
          ),
        ),
        actions: <Widget>[
          FilledButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  again() {}
  @override
  Widget build(BuildContext context) {
    return ComponentDecoration(
      label: '',
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          ElevatedButton(
            child: const Text(
              '执行结果',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => openDialog(context),
          ),
        ],
      ),
    );
  }
}
