import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/video_downloader_service.dart';
import 'downloads_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  
  const HomeScreen({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final VideoDownloaderService _downloaderService = VideoDownloaderService();
  
  bool _isLoadingInfo = false;
  bool _isDownloading = false;
  String _statusMessage = '';
  VideoInfo? _videoInfo;
  DownloadQuality _selectedQuality = DownloadQuality.high;
  DownloadFormat _selectedFormat = DownloadFormat.videoWithAudio;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _getVideoInfo() async {
    if (_urlController.text.trim().isEmpty) {
      _showMessage('Por favor, ingresa una URL válida');
      return;
    }

    setState(() {
      _isLoadingInfo = true;
      _statusMessage = 'Obteniendo información del video...';
      _videoInfo = null;
    });

    try {
      final result = await _downloaderService.getVideoInfo(_urlController.text.trim());
      
      setState(() {
        _isLoadingInfo = false;
        if (result['success']) {
          _videoInfo = result['videoInfo'];
          _statusMessage = 'Información obtenida correctamente';
        } else {
          _statusMessage = result['message'];
        }
      });

      if (!result['success']) {
        _showMessage(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoadingInfo = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
      _showMessage('Error inesperado: ${e.toString()}');
    }
  }

  Future<void> _downloadVideo() async {
    if (_videoInfo == null) {
      _showMessage('Primero obtén la información del video');
      return;
    }

    setState(() {
      _isDownloading = true;
      _statusMessage = 'Iniciando descarga...';
    });

    try {
      final result = await _downloaderService.downloadVideo(
        _urlController.text.trim(),
        _selectedQuality,
        _selectedFormat,
      );
      
      setState(() {
        _isDownloading = false;
        _statusMessage = result['message'];
      });

      if (result['success']) {
        _showSuccessDialog();
        _urlController.clear();
        _videoInfo = null;
      } else {
        _showMessage(result['message']);
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
      _showMessage('Error inesperado: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Descarga Completada!'),
        content: const Text('El video se ha descargado exitosamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DownloadsScreen()),
              );
            },
            child: const Text('Ver Descargas'),
          ),
        ],
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      _urlController.text = clipboardData!.text!;
    }
  }
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return Icons.play_circle_fill;
    } else if (url.contains('tiktok.com')) {
      return Icons.music_video;
    } else if (url.contains('facebook.com') || url.contains('fb.watch')) {
      return Icons.facebook;
    }
    return Icons.video_library;
  }

  String _getPlatformName(String platform) {
    switch (platform) {
      case 'youtube':
        return 'YouTube';
      case 'tiktok':
        return 'TikTok';
      case 'facebook':
        return 'Facebook';
      default:
        return 'Desconocido';
    }
  }

  String _getQualityLabel(DownloadQuality quality) {
    switch (quality) {
      case DownloadQuality.low:
        return '360p (Baja)';
      case DownloadQuality.medium:
        return '480p (Media)';
      case DownloadQuality.high:
        return '720p (Alta)';
      case DownloadQuality.highest:
        return '1080p (Máxima)';
    }
  }

  String _getFormatLabel(DownloadFormat format) {
    switch (format) {
      case DownloadFormat.videoOnly:
        return 'Solo Video';
      case DownloadFormat.audioOnly:
        return 'Solo Audio';
      case DownloadFormat.videoWithAudio:
        return 'Video + Audio';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descargador de Videos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: widget.isDarkMode ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DownloadsScreen()),
              );
            },
            tooltip: 'Ver descargas',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Plataformas soportadas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(_getPlatformIcon(_urlController.text)),
                        const SizedBox(width: 8),
                        Text(
                          'Plataformas Soportadas',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.play_circle_fill, size: 32, color: Colors.blueGrey),
                            const SizedBox(height: 4),
                            const Text('YouTube'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.music_video, size: 32, color: Colors.blueGrey),
                            const SizedBox(height: 4),
                            const Text('TikTok'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.facebook, size: 32, color: Colors.blueGrey),
                            const SizedBox(height: 4),
                            const Text('Facebook'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Campo de URL
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL del Video',
                hintText: 'Pega aquí la URL del video...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: _pasteFromClipboard,
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _getVideoInfo,
                    ),
                  ],
                ),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _getVideoInfo(),
            ),
            const SizedBox(height: 16),
            
            // Botón para obtener información
            ElevatedButton.icon(
              onPressed: _isLoadingInfo ? null : _getVideoInfo,
              icon: _isLoadingInfo
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.info),
              label: Text(_isLoadingInfo ? 'Obteniendo info...' : 'Obtener Información'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Información del video
            if (_videoInfo != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_getPlatformIcon(_urlController.text)),
                          const SizedBox(width: 8),
                          Text(
                            'Información del Video',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Thumbnail y detalles
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Container(
                            width: 120,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[300],
                            ),
                            child: _videoInfo!.thumbnail.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _videoInfo!.thumbnail,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.video_library,
                                          size: 40,
                                          color: Colors.grey[600],
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.video_library,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Detalles
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _videoInfo!.title,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Plataforma: ${_getPlatformName(_videoInfo!.platform)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  'Duración: ${_videoInfo!.duration}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Opciones de calidad
                      Text(
                        'Calidad:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<DownloadQuality>(
                        value: _selectedQuality,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: DownloadQuality.values.map((quality) {
                          final size = _selectedFormat == DownloadFormat.audioOnly
                              ? _videoInfo!.audioSizes[quality] ?? 0
                              : _videoInfo!.videoSizes[quality] ?? 0;
                          return DropdownMenuItem(
                            value: quality,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_getQualityLabel(quality)),
                                Text(
                                  _downloaderService.formatFileSize(size),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedQuality = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Opciones de formato
                      Text(
                        'Formato:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<DownloadFormat>(
                        value: _selectedFormat,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: DownloadFormat.values.map((format) {
                          return DropdownMenuItem(
                            value: format,
                            child: Row(
                              children: [
                                Icon(
                                  format == DownloadFormat.audioOnly
                                      ? Icons.audiotrack
                                      : format == DownloadFormat.videoOnly
                                          ? Icons.videocam
                                          : Icons.movie,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(_getFormatLabel(format)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFormat = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Tamaño estimado
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.storage, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Tamaño estimado: ${_downloaderService.formatFileSize(
                                _selectedFormat == DownloadFormat.audioOnly
                                    ? _videoInfo!.audioSizes[_selectedQuality] ?? 0
                                    : _videoInfo!.videoSizes[_selectedQuality] ?? 0
                              )}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Botón de descarga
              ElevatedButton.icon(
                onPressed: _isDownloading ? null : _downloadVideo,
                icon: _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(_isDownloading ? 'Descargando...' : 'Descargar Video'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Estado
            if (_statusMessage.isNotEmpty)
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(_statusMessage),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Instrucciones
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Instrucciones',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Pega la URL del video\n'
                      '2. Presiona "Obtener Información"\n'
                      '3. Selecciona calidad y formato\n'
                      '4. Presiona "Descargar Video"',
                      textAlign: TextAlign.center,
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
}