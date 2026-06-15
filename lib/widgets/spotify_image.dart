import 'package:flutter/material.dart';

class SpotifyImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SpotifyImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  // Gradient fallbacks per image name for a rich look
  static const Map<String, List<Color>> _gradients = {
    'burna': [Color(0xFFFF6B5B), Color(0xFFCC4433)],
    'omah': [Color(0xFF9B8FD4), Color(0xFF6A5FAA)],
    'asake_lungu': [Color(0xFF8B8B8B), Color(0xFF4A4A4A)],
    'asake_mr': [Color(0xFFCC3333), Color(0xFF881111)],
    'asake_artist': [Color(0xFF3A5A3A), Color(0xFF1A3A1A)],
    'odumo': [Color(0xFF1A1A2E), Color(0xFF16213E)],
    'wizkid': [Color(0xFF2D1B4E), Color(0xFF1A0F2E)],
    'cocoa': [Color(0xFF87CEEB), Color(0xFF5BA3C9)],
    'afro_soul': [Color(0xFF4FB3D4), Color(0xFF2A8AAA)],
    'default': [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
  };

  List<Color> _getGradient() {
    final lower = imagePath.toLowerCase();
    for (final entry in _gradients.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return _gradients['default']!;
  }

  IconData _getIcon() {
    final lower = imagePath.toLowerCase();
    if (lower.contains('artist') || lower.contains('odumo') || lower.contains('burna_a')) {
      return Icons.person;
    }
    if (lower.contains('radio')) return Icons.radio;
    return Icons.music_note;
  }

  Widget _buildFallback(BorderRadius? radius) {
    final colors = _getGradient();
    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: radius,
      ),
      child: Icon(_getIcon(), color: Colors.white.withOpacity(0.4), size: (width ?? 60) * 0.35),
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildFallback(borderRadius),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}