import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'task_list_screen.dart'; // ✅ arahkan ke TaskListScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Setelah 3 detik pindah ke TaskListScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TaskListScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Stack(
        children: [
          // Dua setengah lingkaran berputar
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(180, 180),
                    painter: _TwoHalfCirclePainter(),
                  ),
                );
              },
            ),
          ),
          // Logo di tengah
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter menggambar 2 setengah lingkaran di sisi berlawanan
class _TwoHalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Arc kiri
    canvas.drawArc(rect, 3 * math.pi / 4, math.pi / 2, false, paint);
    // Arc kanan
    canvas.drawArc(rect, -math.pi / 4, math.pi / 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
