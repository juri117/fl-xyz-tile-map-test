import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maptest/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var loadingTime = false;
  var showCoords = false;
  var grid = false;

  StreamController<Null> resetController = StreamController.broadcast();
  final MapController _mapControl = MapController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isInit = false;
  String bgTileServer = "";
  int bgMinZoom = 0;
  int bgMaxZoom = 0;
  String fgTileServer = "";
  int fgMinZoom = 0;
  int fgMaxZoom = 0;

  double lat = 0.0;
  double lon = 0.0;
  int zoom = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      bgTileServer = prefs.getString('bg-tile-server') ??
          "https://a.tile.openstreetmap.org";
      bgMinZoom = prefs.getInt('bg-min-zoom') ?? 0;
      bgMaxZoom = prefs.getInt('bg-max-zoom') ?? 19;
      fgTileServer = prefs.getString('fg-tile-server') ??
          "https://b.tile.openstreetmap.org";
      fgMinZoom = prefs.getInt('fg-min-zoom') ?? 0;
      fgMaxZoom = prefs.getInt('fg-max-zoom') ?? 19;

      lat = prefs.getDouble('def-lat') ?? 0.0;
      lon = prefs.getDouble('def-lon') ?? 0.0;
      zoom = prefs.getInt('def-zoom') ?? 16;
      isInit = true;
    });
  }

  Widget tileBuilder(BuildContext context, Widget tileWidget, Tile tile) {
    final coords = tile.coords;
    return Container(
      decoration: BoxDecoration(
        border: grid ? Border.all() : null,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          tileWidget,
          if (loadingTime || showCoords)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showCoords)
                  Text(
                    '${coords.x.floor()} : ${coords.y.floor()} : ${coords.z.floor()}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                if (loadingTime)
                  Text(
                    tile.loaded == null
                        ? 'Loading'
                        // sometimes result is negative which shouldn't happen, abs() corrects it
                        : '${(tile.loaded!.millisecond - tile.loadStarted.millisecond).abs()} ms',
                    style: Theme.of(context).textTheme.headline5,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _reset() async {
    imageCache?.clear();
    resetController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return !isInit
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text('Tile builder'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Einstellungen',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    ).then((value) => _loadData());
                  },
                ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'grid',
                  label: Text(
                    grid ? 'Hide grid' : 'Show grid',
                    textAlign: TextAlign.center,
                  ),
                  icon: Icon(grid ? Icons.grid_off : Icons.grid_on),
                  onPressed: () => setState(() => grid = !grid),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: 'coords',
                  label: Text(
                    showCoords ? 'Hide coords' : 'Show coords',
                    textAlign: TextAlign.center,
                  ),
                  icon: Icon(showCoords ? Icons.unarchive : Icons.bug_report),
                  onPressed: () => setState(() => showCoords = !showCoords),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: 'ms',
                  label: Text(
                    loadingTime ? 'Hide loading time' : 'Show loading time',
                    textAlign: TextAlign.center,
                  ),
                  icon: Icon(loadingTime ? Icons.timer_off : Icons.timer),
                  onPressed: () => setState(() => loadingTime = !loadingTime),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: 'dark-light',
                  label: const Text(
                    'reset map',
                    textAlign: TextAlign.center,
                  ),
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _reset();
                  },
                ),
              ],
            ),
            body: FlutterMap(
              mapController: _mapControl,
              options: MapOptions(
                center: LatLng(lat, lon),
                zoom: zoom.toDouble(),
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: '$bgTileServer/{z}/{x}/{y}.png',
                  //subdomains: ['a', 'b', 'c'],
                  minZoom: bgMinZoom.toDouble(),
                  maxZoom: bgMaxZoom.toDouble(),
                  tileProvider: const NonCachingNetworkTileProvider(),
                ),
                TileLayerOptions(
                  urlTemplate: "$fgTileServer/{z}/{x}/{y}.png",
                  reset: resetController.stream,
                  tileProvider: const NonCachingNetworkTileProvider(),
                  tileBuilder: tileBuilder,
                  minZoom: fgMinZoom.toDouble(),
                  maxZoom: fgMaxZoom.toDouble(),
                  backgroundColor: const Color(0x00000000),
                ),
                MarkerLayerOptions(
                  markers: <Marker>[
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(lat, lon),
                      builder: (ctx) => const Icon(
                        Icons.location_on_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
