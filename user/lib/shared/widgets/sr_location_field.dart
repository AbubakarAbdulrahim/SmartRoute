import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/services/location_service.dart';
import 'sr_ui.dart';

class SrLocationField extends ConsumerStatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color themeColor;
  final Function(LatLng, String)? onSelected;
  final String? initialValue;

  const SrLocationField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.themeColor,
    this.onSelected,
    this.initialValue,
  });

  @override
  ConsumerState<SrLocationField> createState() => _SrLocationFieldState();
}

class _SrLocationFieldState extends ConsumerState<SrLocationField> {
  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.length < 3) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _isSearching = true);
      try {
        List<Location> locations = await locationFromAddress(value);
        if (locations.isNotEmpty) {
          // In a real app, you'd use Places API for better suggestions.
          // For now, we'll just show the user's input as a valid option if resolved.
          setState(() => _suggestions = [value, "Kano, Nigeria", "Lagos, Nigeria", "Abuja, Nigeria"]);
        }
      } catch (e) {
        setState(() => _suggestions = []);
      } finally {
        setState(() => _isSearching = false);
      }
    });
  }

  Future<void> _useCurrentLocation() async {
    final locationService = ref.read(locationServiceProvider);
    final hasPermission = await locationService.handlePermission();
    if (!hasPermission) return;

    setState(() => _isSearching = true);
    try {
      Position pos = await locationService.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = "${place.name}, ${place.locality}, ${place.country}";
        _controller.text = address;
        widget.onSelected?.call(LatLng(pos.latitude, pos.longitude), address);
      }
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: SrColors.muted, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: SrColors.panel,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SrColors.line),
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: Icon(widget.icon, color: widget.themeColor, size: 20),
                  suffixIcon: _isSearching 
                    ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
                    : IconButton(
                        icon: Icon(LucideIcons.mapPin, color: SrColors.muted, size: 18),
                        onPressed: _useCurrentLocation,
                        tooltip: "Use current location",
                      ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              if (_suggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => const Divider(color: SrColors.line, height: 1),
                    itemBuilder: (context, index) => ListTile(
                      title: Text(_suggestions[index], style: const TextStyle(fontSize: 14)),
                      onTap: () async {
                        final address = _suggestions[index];
                        _controller.text = address;
                        setState(() => _suggestions = []);
                        try {
                          List<Location> locs = await locationFromAddress(address);
                          if (locs.isNotEmpty) {
                            widget.onSelected?.call(LatLng(locs.first.latitude, locs.first.longitude), address);
                          }
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
