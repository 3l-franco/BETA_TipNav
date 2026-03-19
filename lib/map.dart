import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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

   @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(
          onMapCreated: onMapCreated,
        ),             //this is the map
        SafeArea(                // the map header on top
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 20),
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
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFFFC107)),
                        filled: true,
                        fillColor: Color(0xFF8B8F98),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white30,),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.white30,
                          ),
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
                const SizedBox(width: 10,),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF8B8F98),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_alt, color: Color(0xFFFFC50C),),
                    onPressed: (){
                      print("test search button");
                    },
                    ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onMapCreated(MapboxMap controller) {
  mapboxMapController = controller;

  _requestAndEnableLocation();

  mapboxMapController?.setCamera(
    CameraOptions(
      center: Point(
        coordinates: Position(121.06172490077569, 14.62583118823927)
        ),
      zoom: 17.5,
      bearing: 153.0,
    )
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