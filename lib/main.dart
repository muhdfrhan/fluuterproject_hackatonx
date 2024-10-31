import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async'; // Import for using Timer
import 'dart:ui' as ui;
import 'package:table_calendar/table_calendar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LogInScreen after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Image.asset('assets/image/LESTARI_CITY.png'), // Display the logo
      ),
    );
  }
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: <Widget>[
            Image.asset('assets/image/Scenery.jpg'),
            const SizedBox(height: 20),
            Text(
              "Welcome to Lestari City",
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 31.0,
              ),
            ),
            const SizedBox(height: 8), // Add space between text and image
            Text(
              "New Way for A Cleaner Future",
              style: TextStyle(
                color: Colors.green[300],
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20), // Add space between text and button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  // Navigate to LogInForm screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LogInForm()),
                  );
                },
                child: const Text('Let\' Go'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final usernameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();

  LatLng _initialLocation = LatLng(37.423, -122.0848);
  late MapController _mapController;
  Marker? _addressMarker;
  LatLng? _savedAddressLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _pinAddressLocation() async {
    try {
      List<Location> locations = await locationFromAddress(addressController.text);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _initialLocation = LatLng(location.latitude, location.longitude);
          _addressMarker = Marker(
            point: _initialLocation,
            builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
          );
          _mapController.move(_initialLocation, 16.0);
          _savedAddressLocation = _initialLocation;
        });
      }
    } catch (e) {
      print("Error finding location: $e");
    }
  }

  Widget _buildMap() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _initialLocation,
          zoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          if (_addressMarker != null)
            MarkerLayer(
              markers: [_addressMarker!],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.person, size: 100),
                const SizedBox(height: 50),
                const Text(
                  'Welcome',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: phoneNoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: 'Residence Address',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.pin_drop),
                        onPressed: _pinAddressLocation, // Pin address location
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildMap(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(savedAddressLocation: _savedAddressLocation),
                      ),
                    );
                  },
                  child: const Text('Log In'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class HomePage extends StatelessWidget {
  final LatLng? savedAddressLocation;

  const HomePage({super.key, this.savedAddressLocation});

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.calendar_today,
      Icons.recycling_outlined,
      Icons.schedule,
      Icons.settings,
    ];
    final List<String> names = [
      'Garbage collection calendar',
      'Recycling center location',
      'Bus Schedule',
      'Settings',
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(244, 177, 209, 130)),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Welcome to the Home Page!',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipPath(
              clipper: CurvedTopClipper(),
              child: Container(
                color: const Color.fromARGB(244, 177, 209, 130),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: List.generate(4, (index) {
                      return GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CalendarPage()),
                              );
                              break;
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecyclingPage(
                                    userAddressLocation: savedAddressLocation,
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BusSchedulePage()),
                              );
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingsPage()),
                              );
                              break;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(244, 104, 143, 78),
                            border: Border.all(
                              color: const Color.fromARGB(244, 104, 143, 78),
                              width: 6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(3, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icons[index], size: 50, color: Colors.white),
                              const SizedBox(height: 8),
                              Text(
                                names[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Custom clipper for the curved top border
class CurvedTopClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(ui.Size size) {
    ui.Path path = ui.Path();
    path.lineTo(0, 50); // Start from the left side of the top curve
    path.quadraticBezierTo(
      size.width / 2, 0, // Control point for the curve
      size.width, 50, // End point of the curve
    );
    path.lineTo(size.width, size.height); // Move to the bottom right corner
    path.lineTo(0, size.height); // Move to the bottom left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) {
    return false;
  }
}

// Placeholder pages for navigation
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _garbageTimeMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garbage Collection Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Calendar Widget
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                // Set the selected day
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;

                  // Check for garbage collection times
                  switch (_selectedDay?.weekday) {
                    case DateTime.monday:
                    case DateTime.wednesday:
                      _garbageTimeMessage = 'Garbage collection at 10:00 a.m.';
                      break;
                    case DateTime.saturday:
                      _garbageTimeMessage = 'Garbage collection at 7:00 a.m.';
                      break;
                    default:
                      _garbageTimeMessage = 'No garbage collection on this day.';
                      break;
                  }
                });
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 20.0),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedDay != null)
              Text(
                'Selected day: ${_selectedDay.toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18),
              )
            else
              const Text(
                'No day selected',
                style: TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            // Container for garbage collection message
            if (_garbageTimeMessage != null)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _garbageTimeMessage!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// Example recycling center data
class RecyclingCenter {
  final String name;
  final LatLng location;
  final double distance; // Distance from user location (just a placeholder here)

  RecyclingCenter({required this.name, required this.location, required this.distance});
}

class RecyclingPage extends StatelessWidget {
  final LatLng? userAddressLocation;

  const RecyclingPage({super.key, this.userAddressLocation});

  // Mock method to fetch nearby recycling centers (replace with real data fetching logic if needed)
  List<RecyclingCenter> _getNearbyRecyclingCenters(LatLng userLocation) {
    // Normally, you would use an API to get actual nearby locations. This is just dummy data.
    return [
      RecyclingCenter(name: 'Green Earth Recycling', location: LatLng(userLocation.latitude + 0.01, userLocation.longitude + 0.01), distance: 1.2),
      RecyclingCenter(name: 'EcoWise Center', location: LatLng(userLocation.latitude - 0.02, userLocation.longitude - 0.02), distance: 2.5),
      RecyclingCenter(name: 'ReCycle Hub', location: LatLng(userLocation.latitude + 0.03, userLocation.longitude + 0.03), distance: 3.8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (userAddressLocation == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recycling Center Locations'),
        ),
        body: const Center(
          child: Text('User Address Location not available'),
        ),
      );
    }

    // Fetch the nearby recycling centers
    List<RecyclingCenter> nearbyCenters = _getNearbyRecyclingCenters(userAddressLocation!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Center Locations'),
      ),
      body: ListView.builder(
        itemCount: nearbyCenters.length,
        itemBuilder: (context, index) {
          final center = nearbyCenters[index];
          return ListTile(
            title: Text(center.name),
            subtitle: Text(
                'Distance: ${center.distance.toStringAsFixed(2)} km\nLocation: (${center.location.latitude.toStringAsFixed(4)}, ${center.location.longitude.toStringAsFixed(4)})'),
            leading: const Icon(Icons.recycling, color: Colors.green),
          );
        },
      ),
    );
  }
}


class BusSchedulePage extends StatefulWidget {
  const BusSchedulePage({super.key});

  @override
  _BusSchedulePageState createState() => _BusSchedulePageState();
}

class _BusSchedulePageState extends State<BusSchedulePage> {
  // Sample bus and train schedule data with more times
  final List<Map<String, dynamic>> schedule = const [
    {
      'stopType': 'Bus',
      'stopName': 'Central Station',
      'times': [
        {'departureTime': '08:00 AM', 'arrivalTime': '08:30 AM'},
        {'departureTime': '09:00 AM', 'arrivalTime': '09:30 AM'},
        {'departureTime': '10:00 AM', 'arrivalTime': '10:30 AM'},
        {'departureTime': '11:00 AM', 'arrivalTime': '11:30 AM'},
      ]
    },
    {
      'stopType': 'Bus',
      'stopName': 'North Park',
      'times': [
        {'departureTime': '09:00 AM', 'arrivalTime': '09:30 AM'},
        {'departureTime': '10:00 AM', 'arrivalTime': '10:30 AM'},
        {'departureTime': '11:00 AM', 'arrivalTime': '11:30 AM'},
      ]
    },
    {
      'stopType': 'Bus',
      'stopName': 'South Gate',
      'times': [
        {'departureTime': '10:00 AM', 'arrivalTime': '10:30 AM'},
        {'departureTime': '11:00 AM', 'arrivalTime': '11:30 AM'},
        {'departureTime': '12:00 PM', 'arrivalTime': '12:30 PM'},
      ]
    },
    {
      'stopType': 'Train',
      'stopName': 'East Station',
      'times': [
        {'departureTime': '12:00 PM', 'arrivalTime': '12:30 PM'},
        {'departureTime': '01:00 PM', 'arrivalTime': '01:30 PM'},
        {'departureTime': '02:00 PM', 'arrivalTime': '02:30 PM'},
      ]
    },
    {
      'stopType': 'Train',
      'stopName': 'West Station',
      'times': [
        {'departureTime': '02:00 PM', 'arrivalTime': '02:30 PM'},
        {'departureTime': '03:00 PM', 'arrivalTime': '03:30 PM'},
        {'departureTime': '04:00 PM', 'arrivalTime': '04:30 PM'},
      ]
    },
  ];

  // To keep track of expanded stops
  final Set<int> _expandedStops = {};

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedStops.contains(index)) {
        _expandedStops.remove(index);
      } else {
        _expandedStops.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus & Train Schedule')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final stop = schedule[index];
          final isExpanded = _expandedStops.contains(index);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    stop['stopType'] == 'Bus'
                        ? Icons.directions_bus
                        : Icons.train, // Change icon based on stop type
                    color: Colors.blue,
                  ),
                  title: Text('${stop['stopType']} - ${stop['stopName']}'),
                  onTap: () => _toggleExpansion(index), // Expand or collapse
                ),
                if (isExpanded) ...[
                  // Show departure and arrival times when expanded
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        stop['times'].length,
                        (timeIndex) {
                          final time = stop['times'][timeIndex];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Departure: ${time['departureTime']}'),
                              Text('Arrival: ${time['arrivalTime']}'),
                              const SizedBox(height: 8.0),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
     ),
);
}
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true; // For notifications

  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value; // Update notifications state
      // Show a message when notifications are enabled/disabled
      String message = _isNotificationsEnabled
          ? 'Notifications enabled.'
          : 'Notifications disabled.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Notifications Switch
            ListTile(
              title: const Text('Enable Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ),
            const Divider(),
          ],
        ),
     ),
);
}
}