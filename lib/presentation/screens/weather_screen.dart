import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data; // réponse Open-Meteo
  final TextEditingController _cityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadByGeoloc();
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  // --- Actions UI ---

  Future<void> _loadByGeoloc() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      LocationPermission p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
      if (p == LocationPermission.deniedForever || p == LocationPermission.denied) {
        setState(() {
          _loading = false;
          _error = "Permission localisation refusée. Tu peux saisir une ville ci-dessous.";
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      await _fetchForecast(lat: pos.latitude, lon: pos.longitude);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Erreur géoloc : $e";
      });
    }
  }

  Future<void> _loadByCity() async {
    final q = _cityCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final coords = await _geocodeCity(q);
      if (coords == null) {
        setState(() {
          _loading = false;
          _error = "Ville introuvable. Essaie “Paris”, “Lyon”, etc.";
        });
        return;
      }
      await _fetchForecast(lat: coords.$1, lon: coords.$2);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Erreur de recherche : $e";
      });
    }
  }

  // --- API calls ---

  // Geocoding Open-Meteo (pas de clé)
  Future<(double, double)?> _geocodeCity(String name) async {
  final url = Uri.parse(
    'https://geocoding-api.open-meteo.com/v1/search'
    '?name=${Uri.encodeQueryComponent(name)}&count=1&language=fr&format=json',
  );
  final res = await http.get(url);
  if (res.statusCode != 200) return null;

  final json = jsonDecode(res.body);
  final results = (json['results'] as List?) ?? [];
  if (results.isEmpty) return null;

  final r = results[0] as Map<String, dynamic>;
  final lat = (r['latitude'] as num).toDouble();
  final lon = (r['longitude'] as num).toDouble();
  return (lat, lon); // 👈 record bien typé (double,double)
}

  Future<void> _fetchForecast({required double lat, required double lon}) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lon'
      '&current=temperature_2m,weather_code'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
      '&timezone=auto',
    );

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('API météo indisponible (${res.statusCode})');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    setState(() {
      _data = json;
      _loading = false;
      _error = null;
    });
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Météo'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorView()
              : _contentView(),
    );
  }

  Widget _errorView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          _citySearchBar(),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loadByGeoloc,
            icon: const Icon(Icons.my_location),
            label: const Text("Utiliser ma position"),
          ),
        ],
      ),
    );
  }

  Widget _contentView() {
    final current = _data?['current'] as Map<String, dynamic>?;
    final daily = _data?['daily'] as Map<String, dynamic>?;

    final times = (daily?['time'] as List?)?.cast<String>() ?? [];
    final tMax = (daily?['temperature_2m_max'] as List?)?.cast<num>() ?? [];
    final tMin = (daily?['temperature_2m_min'] as List?)?.cast<num>() ?? [];
    final wCodes = (daily?['weather_code'] as List?)?.cast<int>() ?? [];
    final precipProb = (daily?['precipitation_probability_max'] as List?)?.cast<num>() ?? [];

    // On limite à 5 jours
    final n = [times.length, tMax.length, tMin.length, wCodes.length].reduce((a, b) => a < b ? a : b);
    final count = n >= 5 ? 5 : n;

    final currTemp = current?['temperature_2m'];
    final currCode = current?['weather_code'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ---- Recherche / géoloc actions
          _citySearchBar(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _loadByCity,
                  icon: const Icon(Icons.search),
                  label: const Text("Rechercher"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _loadByGeoloc,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Ma position"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // ---- Carte météo actuelle
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  const Text("Aujourd'hui", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    currTemp != null ? "${currTemp.round()}°C" : "--",
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(_mapWeatherCode(currCode), style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          // ---- Prévisions 5 jours
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Prévisions (5 jours)", style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: count,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final date = DateTime.parse(times[i]);
                final label = _weekdayShortFr(date);
                final code = wCodes[i];
                final max = tMax[i].round();
                final min = tMin[i].round();
                final prob = i < precipProb.length ? precipProb[i] : null;

                return Container(
                  width: 110,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(_emojiForCode(code), style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 6),
                      Text("$min° / $max°"),
                      if (prob != null) Text("Pluie ${prob.toInt()}%"),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          const Text("Source : Open-Meteo", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _citySearchBar() {
    return TextField(
      controller: _cityCtrl,
      decoration: InputDecoration(
        hintText: "Rechercher une ville (ex : Paris)",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.location_city),
        suffixIcon: _cityCtrl.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _cityCtrl.clear()),
              ),
      ),
      onSubmitted: (_) => _loadByCity(),
    );
  }

  // --- Utils mapping / format ---

  String _weekdayShortFr(DateTime d) {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[d.weekday - 1];
  }

  String _mapWeatherCode(int? code) {
    if (code == null) return "—";
    final label = switch (code) {
      0 => "Ciel clair",
      1 || 2 || 3 => "Peu/partiellement nuageux",
      45 || 48 => "Brouillard",
      51 || 53 || 55 => "Bruine",
      61 || 63 || 65 => "Pluie",
      66 || 67 => "Pluie verglaçante",
      71 || 73 || 75 => "Neige",
      77 => "Grains de neige",
      80 || 81 || 82 => "Averses",
      85 || 86 => "Averses de neige",
      95 => "Orage",
      96 || 99 => "Orage violent",
      _ => "Temps variable",
    };
    return "${_emojiForCode(code)} $label";
  }

  String _emojiForCode(int code) {
    if (code == 0) return "☀️";
    if ([1, 2, 3].contains(code)) return "🌤";
    if ([45, 48].contains(code)) return "🌫";
    if ([51, 53, 55].contains(code)) return "🌦";
    if ([61, 63, 65, 80, 81, 82].contains(code)) return "🌧";
    if ([66, 67].contains(code)) return "🧊";
    if ([71, 73, 75, 85, 86].contains(code)) return "❄️";
    if ([95, 96, 99].contains(code)) return "⛈";
    return "🌈";
  }
}
