import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMIScreen(),
      theme: ThemeData(fontFamily: 'Arial'),
    );
  }
}

class BMIScreen extends StatefulWidget {
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> with SingleTickerProviderStateMixin {
  double _height = 170;
  double _weight = 70;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSliderChange() {
    _controller.forward(from: 0);
    setState(() {});
  }

  void _reset() {
    setState(() {
      _height = 170;
      _weight = 70;
    });
    _controller.forward(from: 0);
  }

  Map<String, dynamic> _bmiCategory(double bmi) {
    if (bmi < 18.5) {
      return {
        'label': 'Underweight',
        'color': Colors.blueAccent,
        'emoji': '😟',
        'gradient': [Colors.blue.shade200, Colors.blue.shade400]
      };
    } else if (bmi < 25) {
      return {
        'label': 'Normal',
        'color': Colors.green,
        'emoji': '😃',
        'gradient': [Colors.green.shade200, Colors.green.shade400]
      };
    } else if (bmi < 30) {
      return {
        'label': 'Overweight',
        'color': Colors.orange,
        'emoji': '😅',
        'gradient': [Colors.orange.shade200, Colors.orange.shade400]
      };
    } else {
      return {
        'label': 'Obese',
        'color': Colors.red,
        'emoji': '😱',
        'gradient': [Colors.red.shade200, Colors.red.shade400]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    double bmi = _weight / pow(_height / 100, 2);
    final cat = _bmiCategory(bmi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎉 Fun BMI Calculator 🎉'),
        backgroundColor: cat['color'],
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: cat['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Set your height',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _height,
                    min: 100,
                    max: 220,
                    divisions: 120,
                    label: '${_height.toStringAsFixed(1)} cm',
                    onChanged: (val) {
                      _height = val;
                      _onSliderChange();
                    },
                  ),
                  Text(
                    '${_height.toStringAsFixed(1)} cm',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Set your weight',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _weight,
                    min: 30,
                    max: 150,
                    divisions: 120,
                    label: '${_weight.toStringAsFixed(1)} kg',
                    onChanged: (val) {
                      _weight = val;
                      _onSliderChange();
                    },
                  ),
                  Text(
                    '${_weight.toStringAsFixed(1)} kg',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnim.value,
                        child: child,
                      );
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                        child: Column(
                          children: [
                            Text(
                              'Your BMI',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cat['color']),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              bmi.toStringAsFixed(1),
                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: cat['color']),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${cat['emoji']}  ${cat['label']}',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: cat['color']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cat['color'],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
