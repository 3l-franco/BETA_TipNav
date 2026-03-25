import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:ui';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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

  void _onSearch(String value) {
    print("Searching for: $value");
  }

  MapboxMap? mapboxMapController;
  PointAnnotationManager? _pointAnnotationManager;
  Map<String, Map<String, dynamic>> annotationData = {};
  Map<String, dynamic>? selectedLocation;
  bool _showCard = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(
          styleUri: "mapbox://styles/aldringa/cmmw6cqju00dm01sk91ihcifz",
          onMapCreated: onMapCreated,
        ), //this is the map
        SafeArea(
          // the map header on top
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 30,
              right: 30,
              bottom: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _onSearch,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search buildings or rooms...",
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFFFC107),
                        ),
                        filled: true,
                        fillColor: Color(0xFF8B8F98),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFC107),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF8B8F98),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_alt, color: Color(0xFFFFC50C)),
                    onPressed: () {
                      print("test search button");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selectedLocation != null)
          AnimatedSlide(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            offset: _showCard
                ? Offset.zero
                : const Offset(0, 1), // 👈 controls animation
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: const [0.7, 0.9],
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 202, 203, 205),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _buildLocationCard(),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void onMapCreated(MapboxMap controller) async {
    mapboxMapController = controller;

    _requestAndEnableLocation();

    _pointAnnotationManager = await mapboxMapController!.annotations
        .createPointAnnotationManager();

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

    _pointAnnotationManager?.tapEvents(
      onTap: (annotation) {
        final data = annotationData[annotation.id];
        if (data != null) {
          setState(() {
            selectedLocation = data;
            _showCard = false; // start OFFSCREEN first
          });

          Future.delayed(const Duration(milliseconds: 10), () {
            if (mounted) {
              setState(() {
                _showCard = true; // THEN animate UP
              });
            }
          });
        }
      },
    );

    await _addMultiplePins();
  }

  //===================== LOCATION PINS ========================//

  Future<void> _addMultiplePins() async {
    if (_pointAnnotationManager == null) return;

    List<Map<String, dynamic>> locations = [
      {
        "position": Position(121.0615347916442, 14.626363278495857), // bldg 6
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 6",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5", "F6"],
      },
      {
        "position": Position(121.06209721509742, 14.62622648303014), // bldg 9
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 9",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
      {
        "position": Position(121.06266632400033, 14.626117662172929), // bldg 5
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 5",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4"],
      },
      {
        "position": Position(
          121.06169804041711,
          14.625643937971176,
        ), // pe center 1
        "image": "images/pins/GymPin.png",
        "id": "bldg6",
        "name": "PE CENTER 1",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(
          121.06122300580736,
          14.62568436671969,
        ), // pe center 2
        "image": "images/pins/GymPin.png",
        "id": "bldg6",
        "name": "PE CENTER 2",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(121.06140993334739, 14.625390338106826), // parking
        "image": "images/pins/ParkingPin.png",
        "id": "bldg6",
        "name": "PARKING LOT",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(121.06254936324278, 14.626345688633299), // canteen
        "image": "images/pins/FoodPin.png",
        "id": "bldg6",
        "name": "CANTEEN",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(
          121.0622595820087,
          14.62590351556203,
        ), // anniv. hall
        "image": "images/pins/HallPin.png",
        "id": "bldg6",
        "name": "ANNIVERSARY HALL",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(121.06228982598468, 14.625710171882591), // garden
        "image": "images/pins/GardenPin.png",
        "id": "bldg6",
        "name": "GARDEN",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(
          121.06281733491983,
          14.625690757753244,
        ), // technocore
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "TECHNOCORE",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
      {
        "position": Position(121.06250505867008, 14.625437649401778), // congre
        "image": "images/pins/CongrePin.png",
        "id": "bldg6",
        "name": "CONGRESSIONAL AREA",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(
          121.06212337809318,
          14.625313374192332,
        ), // study hall
        "image": "images/pins/StudyPin.png",
        "id": "bldg6",
        "name": "STUDY HALL",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
      },
      {
        "position": Position(121.06159366738731, 14.624996855306804), // bldg 1
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 1",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
      {
        "position": Position(121.06239727314681, 14.624978349633427), // bldg 8
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 8",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
      {
        "position": Position(121.06257555569795, 14.625158852428992), // bldg 2
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 2",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
      {
        "position": Position(121.06273543732884, 14.625285333540434), // bldg 4
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 4",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
      {
        "position": Position(121.06279430039302, 14.624647698091284), // bldg 3
        "image": "images/pins/BuildingPin.png",
        "id": "bldg6",
        "name": "BUILDING 3",
        "floor": "5F",
        "wifi": "Strong",
        "description": "Lorem ipsum dolor sit amet...",
        "floors": ["F1", "F2", "F3", "F4", "F5"],
      },
    ];

    for (var loc in locations) {
      final ByteData bytes = await DefaultAssetBundle.of(
        context,
      ).load(loc["image"]);
      final Uint8List imageData = bytes.buffer.asUint8List();

      final annotation = await _pointAnnotationManager!.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: loc["position"]),
          image: imageData,
          iconSize: 0.35,
        ),
      );

      annotationData[annotation.id] = loc;
    }
  }

  Widget _buildLocationCard() {
    // LOCATION CARDDDD //  <-----------------
    final data = selectedLocation!;

    final floorsData = data["floors"];
    final List<String>? floors = (floorsData is List)
        ? floorsData.cast<String>()
        : (floorsData is String ? [floorsData] : null);
    ;

    final List<String> images =
        data["images"] ??
        [
          "images/OutsideTIP.png",
          "images/OutsideTIP.png",
          "images/OutsideTIP.png",
        ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 202, 203, 205),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag handle + close button
            Stack(
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showCard = false; // animate DOWN
                        });

                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            setState(() {
                              selectedLocation = null; // remove AFTER animation
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2B2323),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// HEADER (Title + Right Actions)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsetsGeometry.only(left: 20)),

                /// LEFT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["name"],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 3),

                      Row(
                        children: [
                          const Icon(
                            Icons.stairs_rounded,
                            size: 20,
                            color: Color(0xFF686868),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            data["floor"],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF686868),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "•",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF686868),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.wifi,
                            size: 20,
                            color: Color(0xFF686868),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            data["wifi"],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF686868),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// RIGHT
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2323),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "BUILDING",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _iconButton(Icons.directions),
                          const SizedBox(width: 8),
                          _iconButton(Icons.bookmark_border),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                data["description"],
                style: const TextStyle(fontSize: 18, color: Color(0xFF686868)),
              ),
            ),

            const SizedBox(height: 20),

            /// FLOOR SELECTOR
            if (floors != null && floors.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    ...floors.map((floor) {
                      final isSelected = floor == data["floor"];
                      return Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2323),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Colors.black54
                                  : Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            floor,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 34,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],

            /// GALLERY
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: const Text(
                "GALLERY",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16), // peekable left spacing
                  /// BIG IMAGE
                  SizedBox(
                    height: 180,
                    width: 200, // set a width for scrollable item
                    child: _imageCard(images[0]),
                  ),

                  const SizedBox(width: 10),

                  /// RIGHT STACK
                  SizedBox(
                    height: 180,
                    width: 130, // width of the column stack
                    child: Column(
                      children: [
                        Expanded(child: _imageCard(images[1])),
                        const SizedBox(height: 10),
                        Expanded(child: _imageCard(images[2])),
                      ],
                    ),
                  ),

                  SizedBox(width: 10),

                  SizedBox(
                    height: 180,
                    width: 200, // set a width for scrollable item
                    child: _imageCard(images[0]),
                  ),

                  const SizedBox(width: 16), // optional right spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2323),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.amber),
    );
  }

  Widget _imageCard(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(path, fit: BoxFit.cover),
    );
  }
}
