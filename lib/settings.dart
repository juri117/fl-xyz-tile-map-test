import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:maptest/utils/text_input_filter.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SharedPreferencesScreen();
  }
}

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({Key? key}) : super(key: key);

  @override
  _SharedPreferencesScreenState createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final bgTileServerController = TextEditingController();
  final bgMinZoomController = TextEditingController();
  final bgMaxZoomController = TextEditingController();
  final fgTileServerController = TextEditingController();
  final fgMinZoomController = TextEditingController();
  final fgMaxZoomController = TextEditingController();

  final latController = TextEditingController();
  final lonController = TextEditingController();
  final zoomController = TextEditingController();

  Future<void> _store() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("bg-tile-server", bgTileServerController.text);
    prefs.setInt("bg-min-zoom", int.tryParse(bgMinZoomController.text) ?? 0);
    prefs.setInt("bg-max-zoom", int.tryParse(bgMaxZoomController.text) ?? 19);
    prefs.setString("fg-tile-server", fgTileServerController.text);
    prefs.setInt("fg-min-zoom", int.tryParse(fgMinZoomController.text) ?? 0);
    prefs.setInt("fg-max-zoom", int.tryParse(fgMaxZoomController.text) ?? 19);

    prefs.setDouble("def-lat", double.tryParse(latController.text) ?? 0.0);
    prefs.setDouble("def-lon", double.tryParse(lonController.text) ?? 0.0);
    prefs.setInt("def-zoom", int.tryParse(zoomController.text) ?? 16);
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      bgTileServerController.text = prefs.getString('bg-tile-server') ??
          "https://a.tile.openstreetmap.org";
      bgMinZoomController.text = (prefs.getInt('bg-min-zoom') ?? 1).toString();
      bgMaxZoomController.text = (prefs.getInt('bg-max-zoom') ?? 19).toString();
      fgTileServerController.text = prefs.getString('fg-tile-server') ??
          "https://b.tile.openstreetmap.org";
      fgMinZoomController.text = (prefs.getInt('fg-min-zoom') ?? 1).toString();
      fgMaxZoomController.text = (prefs.getInt('fg-max-zoom') ?? 19).toString();

      latController.text = (prefs.getDouble('def-lat') ?? 0.0).toString();
      lonController.text = (prefs.getDouble('def-lon') ?? 0.0).toString();
      zoomController.text = (prefs.getInt('def-zoom') ?? 16).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
      ),
      body: ListView(children: [
        Card(
            child: Column(children: [
          const Text("Tile-server",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
              title: const Text("background tile-server"),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(children: [
                  SizedBox(
                      width: 300,
                      child: TextField(
                          controller: bgTileServerController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: 'https://a.tile.openstreetmap.org',
                            labelText: 'server-address',
                          ))),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 100,
                      child: TextField(
                          controller: bgMinZoomController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '1',
                            labelText: 'min.-zoom',
                          ))),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 100,
                      child: TextField(
                          controller: bgMaxZoomController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '19',
                            labelText: 'max.-zoom',
                          ))),
                ]),
              )),
          ListTile(
            title: const Text("foreground tile-server"),
            subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(children: [
                  SizedBox(
                      width: 300,
                      child: TextField(
                          controller: fgTileServerController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: 'https://b.tile.openstreetmap.org',
                            labelText: 'server-address',
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 100,
                      child: TextField(
                          controller: fgMinZoomController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '1',
                            labelText: 'min.-zoom',
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 100,
                      child: TextField(
                          controller: fgMaxZoomController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '19',
                            labelText: 'max.-zoom',
                          ))),
                ])),
          ),
          ListTile(
              title: const Text("background tile-server"),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(children: [
                  SizedBox(
                      width: 200,
                      child: TextField(
                          controller: latController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(DECIMAL_NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '12.781',
                            labelText: 'lat',
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 200,
                      child: TextField(
                          controller: lonController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(DECIMAL_NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '52.945',
                            labelText: 'lon',
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 100,
                      child: TextField(
                          controller: zoomController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(NUMBER_ONLY_REGEX)),
                          ],
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '16',
                            labelText: 'zoom',
                          ))),
                ]),
              )),
        ]))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _store,
        tooltip: 'save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
