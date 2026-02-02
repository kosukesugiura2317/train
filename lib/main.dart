import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SimpleTrainingApp()));
}

class Sample {
  final String imageUrl;
  final String answer;
  Sample(this.imageUrl, this.answer);

  factory Sample.fromList(List<String> list) {
    return Sample(list[0], list[1]);
  }
}

class SimpleTrainingApp extends StatefulWidget {
  const SimpleTrainingApp({super.key});
  @override
  State<SimpleTrainingApp> createState() => _SimpleTrainingAppState();
}

const String appTitle = '北アルプス山名トレーニング';

class _SimpleTrainingAppState extends State<SimpleTrainingApp> {
  final List<List<String>> data = [
    ["assets/mountains/yari.jpg", "槍ヶ岳"],
    ["assets/mountains/okuho.jpg", "奥穂高岳"],
    ["assets/mountains/tsurugi.jpg", "剱岳"],
    ["assets/mountains/oyama_tateyama.jpg", "立山（雄山）"],
    ["assets/mountains/shirouma.jpg", "白馬岳"],
    ["assets/mountains/karamatsu.jpg", "唐松岳"],
    ["assets/mountains/jonen.jpg", "常念岳"],
    ["assets/mountains/tsubakuro.jpg", "燕岳"],
    ["assets/mountains/norikura.jpg", "乗鞍岳"],
    ["assets/mountains/kasa.jpg", "笠ヶ岳"],
    ["assets/mountains/yakushi.jpg", "薬師岳"],
    ["assets/mountains/kurobegoro.jpg", "黒部五郎岳"],
    ["assets/mountains/sugoroku.jpg", "双六岳"],
    ["assets/mountains/otensho.jpg", "大天井岳"],
    ["assets/mountains/goryu.jpg", "五竜岳"],
  ];

  late final List<Sample> _samples;
  int _index = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _samples = data.map((e) => Sample.fromList(e)).toList();
    _samples.shuffle(Random());
  }

  void _onTap() {
    setState(() {
      if (_showAnswer) {
        _showAnswer = false;

        // 最後まで行ったら再シャッフルして先頭へ
        if (_index == _samples.length - 1) {
          _samples.shuffle(Random());
          _index = 0;
        } else {
          _index++;
        }
      } else {
        _showAnswer = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_samples.isEmpty) {
      return const Scaffold(body: Center(child: Text('データがありません')));
    }

    final sample = _samples[_index];

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                sample.imageUrl,
                // fit: BoxFit.cover,// 画面いっぱいに広げる代わりに上下左右が切れる
                fit: BoxFit.contain, // 画像全体が必ず画面内に収まる（余白が出ることはあるが切れない）
                errorBuilder: (e1, e2, e3) =>
                    const Center(child: Text('画像を読み込めません')),
              ),
            ),

            if (_showAnswer)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    sample.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 10,
              right: 10,
              child: _hint(_showAnswer ? 'タップで次へ' : 'タップで正解表示'),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: _hint('${_index + 1}/${_samples.length}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
