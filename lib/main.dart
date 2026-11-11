import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 2: Flutter GUI')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
          ),

          // Content on top
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Frosted glass header
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'RoadEZ!',
                              style: TextStyle(fontSize: 50),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.wb_sunny,
                                        color: Colors.orange, size: 28),
                                    SizedBox(width: 6),
                                    Text('32°C',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                LiveDateTime(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Welcome to your personalized road trip!',
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        letterSpacing: 2,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 6, offset: Offset(2, 2)),
                      ],),
                  ),

                  const SizedBox(height: 40),

                  // NEW: swipeable vehicle picker + GO button
                  const VehiclePicker(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VehiclePicker extends StatefulWidget {
  const VehiclePicker({super.key});

  @override
  State<VehiclePicker> createState() => _VehiclePickerState();
}

class _VehiclePickerState extends State<VehiclePicker> {
  final _controller = PageController(viewportFraction: 0.8);
  int _current = 0;

  // name + image path
  final _vehicles = const [
    ('NazaBlade', 'assets/photo.jpg'),
    ('Ysuku', 'assets/ysuku.jpg'),
    ('RsxWinner', 'assets/winner.jpg'),
    ('ADV','assets/adv.jpg'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Choose your ride',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 6, offset: Offset(2, 2)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Swipeable pictures
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _controller,
            itemCount: _vehicles.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(_vehicles[i].$2, fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Vehicle name
        Text(
          _vehicles[_current].$1,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 6, offset: Offset(2, 2)),
              ],
          ),
        ),
        const SizedBox(height: 8),

        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_vehicles.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == _current ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == _current ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Go button
        SizedBox(
          width: 200,
          height: 50,
          child: FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NextPage(vehicle: _vehicles[_current].$1),
                ),
              );
            },
            child: const Text('GO', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}

// Placeholder for your upcoming project page
class NextPage extends StatelessWidget {
  final String vehicle;
  const NextPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Page')),
      body: Center(
        child: Text(
          'You chose: $vehicle, will be updated soon',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class LiveDateTime extends StatefulWidget {
  const LiveDateTime({super.key});

  @override
  State<LiveDateTime> createState() => _LiveDateTimeState();
}

class _LiveDateTimeState extends State<LiveDateTime> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now().toUtc().add(const Duration(hours: 8));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now().toUtc().add(const Duration(hours: 8)));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('EEE, d MMM yyyy').format(_now),
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          DateFormat('hh:mm:ss a').format(_now),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
// i did this based on claude ai as a companion to guide and
// make my concept comes alive