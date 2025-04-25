import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'localization_service.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController(text: '');
  final TextEditingController _heightController = TextEditingController(text: '');
  double _bmi = 0.0;
  String _category = '';
  bool _isMenuOpen = false;

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Animation controller for gauge
  late AnimationController _gaugeAnimationController;
  late Animation<double> _gaugeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize gauge animation controller
    _gaugeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create the animation with a curved effect
    _gaugeAnimation = CurvedAnimation(
      parent: _gaugeAnimationController,
      curve: Curves.elasticOut,
    );
  }

  void _calculateBMI({bool animate = true}) {
    // Check if weight or height is empty or invalid
    if (_weightController.text.isEmpty || _heightController.text.isEmpty) {
      if (animate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter weight and height'.tr)),
        );
      }
      return;
    }

    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;

    if (weight <= 0 || height <= 0) {
      if (animate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter valid weight and height'.tr)),
        );
      }
      return;
    }

    double bmi = weight / ((height / 100) * (height / 100));
    setState(() {
      _bmi = double.parse(bmi.toStringAsFixed(1));

      if (bmi < 16) {
        _category = 'severely_underweight';
      } else if (bmi < 18.5) {
        _category = 'underweight';
      } else if (bmi < 25) {
        _category = 'optimal';
      } else if (bmi < 30) {
        _category = 'overweight';
      } else if (bmi < 35) {
        _category = 'obese';
      } else {
        _category = 'severely_obese';
      }
    });

    // Save data to Firestore
    _saveBMIToFirestore(weight, height, _bmi, _category);

    // Reset and start the gauge animation
    _gaugeAnimationController.reset();
    _gaugeAnimationController.forward();
  }

  // Save BMI record to Firestore
  Future<void> _saveBMIToFirestore(double weight, double height, double bmi, String category) async {
    try {
      // Make sure user is logged in
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('bmi_records').add({
          'userId': user.uid,
          'weight': weight,
          'height': height,
          'bmi': bmi,
          'category': category,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving BMI record: $e');
    }
  }

  // Show BMI history from Firestore
  void _showBMIHistory() {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to view history'.tr)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'bmi_history'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('bmi_records')
                      .where('userId', isEqualTo: user.uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('${'error'.tr}: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No BMI records found'.tr));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var record = snapshot.data!.docs[index];
                        var data = record.data() as Map<String, dynamic>;

                        // Format the timestamp
                        String formattedDate = 'N/A';
                        if (data['timestamp'] != null) {
                          Timestamp timestamp = data['timestamp'] as Timestamp;
                          DateTime dateTime = timestamp.toDate();
                          formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
                        }

                        return Card(
                          child: ListTile(
                            title: Text(
                              'BMI: ${data['bmi']?.toStringAsFixed(1) ?? 'N/A'} - ${data['category'] != null ? (data['category'] as String).tr : 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                            subtitle: Text(
                                '${'weight_kg'.tr}: ${data['weight']?.toString() ?? 'N/A'}, ${'height_cm'.tr}: ${data['height']?.toString() ?? 'N/A'}\n$formattedDate'
                            ),
                            trailing: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getBMICategoryColor(data['bmi'] ?? 0),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBMICategoryColor(double bmi) {
    if (bmi < 16) {
      return Colors.blue.shade800; // Severely Underweight
    } else if (bmi < 18.5) {
      return Colors.blue.shade300; // Underweight
    } else if (bmi < 25) {
      return Colors.green; // Optimal
    } else if (bmi < 30) {
      return Colors.yellow; // Overweight
    } else if (bmi < 35) {
      return Colors.orange; // Obese
    } else {
      return Colors.red; // Severely Obese
    }
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen after logout
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'error'.tr} ${'logout'.tr}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
    appBar: AppBar(
    title: Text('bmi_calculator'.tr),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
    IconButton(
    icon: Container(
    decoration: BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(4),
    child: const Icon(Icons.menu, color: Colors.white, size: 20),
    ),
    onPressed: () {
    setState(() {
    _isMenuOpen = !_isMenuOpen;
    });
    },
    ),
    const SizedBox(width: 8),
    ],
    ),
    body: SafeArea(
    child: Stack(
    children: [
    // Main Content
    SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Weight Input
    Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'weight_kg'.tr,
    style: const TextStyle(
    fontSize: 14,
    color: Colors.grey,
    ),
    ),
    Row(
    children: [
    const Icon(Icons.menu, size: 24, color: Colors.black54),
    const SizedBox(width: 16),
    Expanded(
    child: TextField(
    controller: _weightController,
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    ),
    decoration: const InputDecoration(
    border: InputBorder.none,
    isDense: true,
    contentPadding: EdgeInsets.zero,
    hintText: 'Enter weight',
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),

    // Height Input
    Container(
    margin: const EdgeInsets.only(bottom: 32),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.green, width: 1.5),
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'height_cm'.tr,
    style: const TextStyle(
    fontSize: 14,
    color: Colors.grey,
    ),
    ),
    Row(
    children: [
    Transform.rotate(
    angle: 90 * math.pi / 180,
    child: const Icon(Icons.sync_alt, size: 24, color: Colors.black54),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: TextField(
    controller: _heightController,
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    ),
    decoration: const InputDecoration(
    border: InputBorder.none,
    isDense: true,
    contentPadding: EdgeInsets.zero,
    hintText: 'Enter height',
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),

    // Calculate Button
    SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
    onPressed: _calculateBMI,
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
    ),
    ),
    child: Text(
    'calculate'.tr,
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    ),
    ),
    ),
    ),

    // BMI Result
    const SizedBox(height: 32),
    Center(
    child: Column(
    children: [
    Text(
    _bmi > 0 ? _bmi.toStringAsFixed(1) : '-',
    style: const TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.normal,
    ),
    ),
    Text(
    _category.isNotEmpty ? _category.tr : 'Calculate your BMI',
    style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: _bmi > 0 ? _getBMICategoryColor(_bmi) : Colors.grey,
    ),
    ),
    const SizedBox(height: 24),

    // Animated BMI Gauge
    SizedBox(
    height: 240,
    width: double.infinity,
    child: CustomPaint(
    painter: _bmi > 0
    ? AnimatedBMIGaugePainter(
    bmi: _bmi,
    animation: _gaugeAnimation,
    )
        : null,
    child: _bmi == 0
    ? Center(
    child: Text(
    'Enter your weight and height\nto calculate BMI',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.grey[600], fontSize: 16),
    ),)
        : Container(),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    ),

      // Dropdown Menu (conditionally shown)
      if (_isMenuOpen)
        Positioned(
          top: 60,
          right: 16,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // History option
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('bmi_history'.tr),
                  onTap: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                    _showBMIHistory();
                  },
                ),
                const Divider(height: 1),

                // Language option
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('select_language'.tr),
                  onTap: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                    Navigator.pushNamed(context, '/language');
                  },
                ),
                const Divider(height: 1),

                // Logout option
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                    _handleLogout();
                  },
                ),
              ],
            ),
          ),
        ),
    ],
    ),
    ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _gaugeAnimationController.dispose();
    super.dispose();
  }
}

// Animated Gauge Painter
class AnimatedBMIGaugePainter extends CustomPainter {
  final double bmi;
  final Animation<double> animation;

  AnimatedBMIGaugePainter({
    required this.bmi,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = math.min(size.width / 2, size.height - 40);

    // Define the gauge colors for each category
    final paints = [
      Paint()
        ..color = Colors.blue.shade800
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Colors.blue.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt,
    ];

    // Calculate the arcs - we'll use 180 degrees total (PI radians)
    final double totalAngle = math.pi;

    // Draw the gauge segments - using a semicircle (π radians)
    final Rect gaugeBounds = Rect.fromCircle(center: center, radius: radius);

    // Segment angles
    final segmentAngles = List.filled(6, totalAngle / 6);

    // Draw gauge segments
    double startAngle = math.pi;
    for (int i = 0; i < paints.length; i++) {
      canvas.drawArc(
        gaugeBounds,
        startAngle,
        segmentAngles[i],
        false,
        paints[i],
      );
      startAngle += segmentAngles[i];
    }

    // Add separating white lines between sections
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw dividing lines between sections
    for (int i = 0; i <= 6; i++) {
      double angle = math.pi + (totalAngle / 6) * i;
      double lineX1 = center.dx + (radius - 15) * math.cos(angle);
      double lineY1 = center.dy + (radius - 15) * math.sin(angle);
      double lineX2 = center.dx + (radius + 15) * math.cos(angle);
      double lineY2 = center.dy + (radius + 15) * math.sin(angle);

      canvas.drawLine(
          Offset(lineX1, lineY1),
          Offset(lineX2, lineY2),
          whitePaint
      );
    }

    // Calculate the needle position based on BMI value
    double needleAngle;

    if (bmi < 16) {
      // Severely underweight
      double proportion = math.max(0, bmi) / 16.0;
      needleAngle = math.pi + proportion * segmentAngles[0];
    } else if (bmi < 18.5) {
      // Underweight
      double proportion = (bmi - 16) / (18.5 - 16);
      needleAngle = math.pi + segmentAngles[0] + proportion * segmentAngles[1];
    } else if (bmi < 25) {
      // Optimal
      double proportion = (bmi - 18.5) / (25 - 18.5);
      needleAngle = math.pi + segmentAngles[0] + segmentAngles[1] + proportion * segmentAngles[2];
    } else if (bmi < 30) {
      // Overweight
      double proportion = (bmi - 25) / (30 - 25);
      needleAngle = math.pi + segmentAngles[0] + segmentAngles[1] + segmentAngles[2] + proportion * segmentAngles[3];
    } else if (bmi < 35) {
      // Obese
      double proportion = (bmi - 30) / (35 - 30);
      needleAngle = math.pi + segmentAngles[0] + segmentAngles[1] + segmentAngles[2] + segmentAngles[3] + proportion * segmentAngles[4];
    } else {
      // Severely obese
      double proportion = math.min(1.0, (bmi - 35) / 5); // Cap at 40 BMI
      needleAngle = math.pi + segmentAngles[0] + segmentAngles[1] + segmentAngles[2] +
          segmentAngles[3] + segmentAngles[4] + proportion * segmentAngles[5];
    }

    // Animated needle length
    double needleLength = (radius - 10) * animation.value;
    final needleEndX = center.dx + math.cos(needleAngle) * needleLength;
    final needleEndY = center.dy + math.sin(needleAngle) * needleLength;

    // Draw the needle with navy blue color
    final needlePaint = Paint()
      ..color = Color(0xFF2B4B81)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(center, Offset(needleEndX, needleEndY), needlePaint);

    // Draw the needle pivot point
    final pivotPaint = Paint()
      ..color = Color(0xFF2B4B81)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 10, pivotPaint);
  }

  @override
  bool shouldRepaint(AnimatedBMIGaugePainter oldDelegate) {
    return oldDelegate.bmi != bmi || oldDelegate.animation != animation;
  }
}