import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'splash_screen.dart';
import 'map.dart';
import 'profile.dart';
import 'saved.dart';

void main() async {
  await setup();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(dotenv.env["MAPBOX_ACCESS_TOKEN"]!);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIPNav',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

//================== MAIN BODY ==========================//

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreen(
        onViewPressed: () {
          // homescreen page
          setState(() {
            selectedIndex = 1; // index for the map page
          });
        },
      ),
      MapPage(),
      SavedPage(),
      ProfilePage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E9ED),
      body: SafeArea(
        child: Column(
          children: [
            if (selectedIndex != 1 && selectedIndex != 3) const AppHeader(),
            Expanded(
              child: IndexedStack(index: selectedIndex, children: _pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomnav(),
    );
  }

  //===================== BOTTOM NAVBAR ==========================//

  Widget _bottomnav() {
  return SafeArea(
    child: Container(
      height: 55,
      color: const Color(0xFF1C1C1C),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home, 0),
          _navIcon(Icons.map, 1),
          _navIcon(Icons.bookmark, 2),
          _navIcon(Icons.person, 3),
        ],
      ),
    ),
  );
}

  Widget _navIcon(IconData icon, int index) {
    final bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFFFC107) : Colors.white,
            size: 25,
          ),
          const SizedBox(height: 5),
          if (isActive)
            Container(height: 2, width: 30, color: Color(0xFFFFC107)),
        ],
      ),
    );
  }
}

//===================== HOMESCREEN ==========================//

class HomeScreen extends StatelessWidget {
  final VoidCallback onViewPressed;
  HomeScreen({Key? key, required this.onViewPressed}) : super(key: key);

  Future<void> _requestAndEnableLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      mapboxMapController?.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          puckBearingEnabled: true,
        ),
      );
    } else {
      print("Location permission denied");
    }
  }

  MapboxMap? mapboxMapController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text(
              "CATEGORIES",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.0,
              ),
            ),
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(width: 15),
                buildCard(Icons.apartment, "Building"),
                SizedBox(width: 12),
                buildCard(Icons.menu_book, "Library"),
                SizedBox(width: 12),
                buildCard(Icons.restaurant, "Food"),
                SizedBox(width: 12),
                buildCard(Icons.park, "Garden"),
                SizedBox(width: 12),
                buildCard(Icons.fitness_center, "P.E."),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CAMPUS MAP",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: onViewPressed,
                      child: Text(
                        "View",
                        style: TextStyle(color: Colors.grey, fontSize: 21),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MapWidget(
                    styleUri: "mapbox://styles/aldringa/cmmw6cqju00dm01sk91ihcifz",
                    onMapCreated: onMapCreated),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LOCATIONS",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.0,
                  ),
                ),
                SizedBox(height: 10),
                _locationCArd("Building 9", "Building"),
                SizedBox(height: 10),
                _locationCArd("Building 1", "Building"),
                SizedBox(height: 10),
                _locationCArd("Canteen", "Food"),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(MapboxMap controller) {
    mapboxMapController = controller;

    _requestAndEnableLocation();

    mapboxMapController?.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(121.06172490077569, 14.62583118823927),
        ),
        zoom: 17.5,
        bearing: 153.0,
      ),
    );

    mapboxMapController?.setBounds(
      CameraBoundsOptions(
        bounds: CoordinateBounds(
          southwest: Point(
            coordinates: Position(121.06026219557567, 14.623513918765012),
          ),
          northeast: Point(
            coordinates: Position(121.06381678593198, 14.627686648537976),
          ),
          infiniteBounds: false,
        ),
      ),
    );
  }
}

Widget buildCard(IconData icon, String label) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Color(0xFF231E1F),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Color(0xFFFFC107), size: 35),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

Widget _locationCArd(String title, String category) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10),
          child: Image.asset(
            'images/OutsideTIP.png',
            height: 65,
            width: 65,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                category,
                style: TextStyle(fontSize: 13, color: Color(0xFFBBBCBE)),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Color(0xFFFFC50C),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.location_on, color: Colors.black, size: 20),
        ),
        SizedBox(width: 5),
      ],
    ),
  );
}

//===================== HEADER ==========================//

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C1C1C), Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Hello ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "T.I.P.ian!",
                            style: TextStyle(
                              color: Color(0xFFFFDB0C),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Where do you want to go?",
                      style: TextStyle(color: Color(0xFFFFDB0C), fontSize: 14),
                    ),
                  ], // children of the column to the second power
                ),
              ),
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('images/aldrin.jpg'),
              ),
            ], //children of row
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFF8B8F98),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Color(0xFFFFDB0C)),
                hintText: "Search building, room, or facilities...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ], //children of column
      ),
    ); //container
  }
}