import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum DownloadQuality { low, medium, high, highest }
enum DownloadFormat { videoOnly, audioOnly, videoWithAudio }

class VideoInfo {
  final String title;
  final String thumbnail;
  final String duration;
  final Map<DownloadQuality, int> videoSizes; // Tamaño en bytes
  final Map<DownloadQuality, int> audioSizes;
  final String platform;

  VideoInfo({
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.videoSizes,
    required this.audioSizes,
    required this.platform,
  });
}

class VideoDownloaderService {
  final Dio _dio = Dio();
  late String _downloadPath;

  VideoDownloaderService() {
    _initializeDownloadPath();
  }

  Future<void> _initializeDownloadPath() async {
    final directory = await getApplicationDocumentsDirectory();
    _downloadPath = '${directory.path}/downloads';
    final downloadDir = Directory(_downloadPath);
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
  }

  Future<bool> _requestPermissions() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  String _detectPlatform(String url) {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return 'youtube';
    } else if (url.contains('tiktok.com')) {
      return 'tiktok';
    } else if (url.contains('facebook.com') || url.contains('fb.watch')) {
      return 'facebook';
    }
    return 'unknown';
  }

  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    try {
      final platform = _detectPlatform(url);
      
      switch (platform) {
        case 'youtube':
          return await _getYoutubeInfo(url);
        case 'tiktok':
          return await _getTiktokInfo(url);
        case 'facebook':
          return await _getFacebookInfo(url);
        default:
          return {
            'success': false,
            'message': 'Plataforma no soportada'
          };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener información: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> downloadVideo(
    String url, 
    DownloadQuality quality, 
    DownloadFormat format
  ) async {
    try {
      await _initializeDownloadPath();
      
      if (!await _requestPermissions()) {
        return {
          'success': false,
          'message': 'Permisos de almacenamiento requeridos'
        };
      }

      final platform = _detectPlatform(url);
      
      switch (platform) {
        case 'youtube':
          return await _downloadYoutube(url, quality, format);
        case 'tiktok':
          return await _downloadTiktok(url, quality, format);
        case 'facebook':
          return await _downloadFacebook(url, quality, format);
        default:
          return {
            'success': false,
            'message': 'Plataforma no soportada'
          };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> _getYoutubeInfo(String url) async {
    try {
      final apiUrl = 'https://youtube-dl-api.herokuapp.com/api/info?url=$url';
      final response = await _dio.get(apiUrl);
      
      if (response.statusCode == 200) {
        final data = response.data;
        final title = data['title'] ?? 'Video de YouTube';
        final thumbnail = data['thumbnail'] ?? '';
        final duration = _formatDuration(data['duration'] ?? 0);
        
        // Simular diferentes calidades y tamaños
        final videoSizes = {
          DownloadQuality.low: (data['filesize'] ?? 10000000) ~/ 4,
          DownloadQuality.medium: (data['filesize'] ?? 10000000) ~/ 2,
          DownloadQuality.high: (data['filesize'] ?? 10000000),
          DownloadQuality.highest: (data['filesize'] ?? 10000000) * 2,
        };
        
        final audioSizes = {
          DownloadQuality.low: (data['filesize'] ?? 10000000) ~/ 10,
          DownloadQuality.medium: (data['filesize'] ?? 10000000) ~/ 8,
          DownloadQuality.high: (data['filesize'] ?? 10000000) ~/ 6,
          DownloadQuality.highest: (data['filesize'] ?? 10000000) ~/ 5,
        };
        
        final videoInfo = VideoInfo(
          title: title,
          thumbnail: thumbnail,
          duration: duration,
          videoSizes: videoSizes,
          audioSizes: audioSizes,
          platform: 'youtube',
        );
        
        return {
          'success': true,
          'videoInfo': videoInfo,
        };
      }
      
      return {
        'success': false,
        'message': 'No se pudo obtener información del video'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener información de YouTube: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> _getTiktokInfo(String url) async {
    try {
      final apiUrl = 'https://tikwm.com/api/?url=$url';
      final response = await _dio.get(apiUrl);
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final title = data?['title'] ?? 'Video de TikTok';
        final thumbnail = data?['cover'] ?? '';
        final duration = _formatDuration(data?['duration'] ?? 0);
        
        // TikTok generalmente tiene tamaños más pequeños
        final videoSizes = {
          DownloadQuality.low: 2000000,
          DownloadQuality.medium: 5000000,
          DownloadQuality.high: 8000000,
          DownloadQuality.highest: 12000000,
        };
        
        final audioSizes = {
          DownloadQuality.low: 500000,
          DownloadQuality.medium: 800000,
          DownloadQuality.high: 1200000,
          DownloadQuality.highest: 1500000,
        };
        
        final videoInfo = VideoInfo(
          title: title,
          thumbnail: thumbnail,
          duration: duration,
          videoSizes: videoSizes,
          audioSizes: audioSizes,
          platform: 'tiktok',
        );
        
        return {
          'success': true,
          'videoInfo': videoInfo,
        };
      }
      
      return {
        'success': false,
        'message': 'No se pudo obtener información del video'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener información de TikTok: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> _getFacebookInfo(String url) async {
    try {
      // Simulamos información para Facebook
      final videoSizes = {
        DownloadQuality.low: 8000000,
        DownloadQuality.medium: 15000000,
        DownloadQuality.high: 25000000,
        DownloadQuality.highest: 40000000,
      };
      
      final audioSizes = {
        DownloadQuality.low: 1000000,
        DownloadQuality.medium: 1500000,
        DownloadQuality.high: 2000000,
        DownloadQuality.highest: 2500000,
      };
      
      final videoInfo = VideoInfo(
        title: 'Video de Facebook',
        thumbnail: '',
        duration: '00:00',
        videoSizes: videoSizes,
        audioSizes: audioSizes,
        platform: 'facebook',
      );
      
      return {
        'success': true,
        'videoInfo': videoInfo,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener información de Facebook: ${e.toString()}'
      };
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  Future<Map<String, dynamic>> _downloadYoutube(
    String url, 
    DownloadQuality quality, 
    DownloadFormat format
  ) async {
    try {
      final apiUrl = 'https://youtube-dl-api.herokuapp.com/api/info?url=$url';
      final response = await _dio.get(apiUrl);
      
      if (response.statusCode == 200) {
        final data = response.data;
        final title = data['title'] ?? 'video_youtube';
        final videoUrl = data['formats']?.first['url'];
        
        if (videoUrl != null) {
          final extension = format == DownloadFormat.audioOnly ? 'mp3' : 'mp4';
          final qualityStr = _getQualityString(quality);
          final filename = '${_sanitizeFilename(title)}_${qualityStr}.$extension';
          final filepath = '$_downloadPath/$filename';
          
          await _dio.download(videoUrl, filepath);
          
          return {
            'success': true,
            'message': 'YouTube descargado: $title',
            'filepath': filepath
          };
        }
      }
      
      return {
        'success': false,
        'message': 'No se pudo obtener el video de YouTube'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al descargar de YouTube: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> _downloadTiktok(
    String url, 
    DownloadQuality quality, 
    DownloadFormat format
  ) async {
    try {
      final apiUrl = 'https://tikwm.com/api/?url=$url';
      final response = await _dio.get(apiUrl);
      
      if (response.statusCode == 200) {
        final data = response.data;
        final videoUrl = data['data']?['play'];
        final title = data['data']?['title'] ?? 'video_tiktok';
        
        if (videoUrl != null) {
          final extension = format == DownloadFormat.audioOnly ? 'mp3' : 'mp4';
          final qualityStr = _getQualityString(quality);
          final filename = '${_sanitizeFilename(title)}_${qualityStr}.$extension';
          final filepath = '$_downloadPath/$filename';
          
          await _dio.download(videoUrl, filepath);
          
          return {
            'success': true,
            'message': 'TikTok descargado: $title',
            'filepath': filepath
          };
        }
      }
      
      return {
        'success': false,
        'message': 'No se pudo obtener el video de TikTok'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al descargar de TikTok: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> _downloadFacebook(
    String url, 
    DownloadQuality quality, 
    DownloadFormat format
  ) async {
    try {
      final apiUrl = 'https://facebook-video-downloader.p.rapidapi.com/facebook-video-downloader';
      
      final response = await _dio.post(
        apiUrl,
        data: {'url': url},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final videoUrl = data['hd_url'] ?? data['sd_url'];
        
        if (videoUrl != null) {
          final extension = format == DownloadFormat.audioOnly ? 'mp3' : 'mp4';
          final qualityStr = _getQualityString(quality);
          final filename = 'facebook_${DateTime.now().millisecondsSinceEpoch}_${qualityStr}.$extension';
          final filepath = '$_downloadPath/$filename';
          
          await _dio.download(videoUrl, filepath);
          
          return {
            'success': true,
            'message': 'Facebook descargado: $filename',
            'filepath': filepath
          };
        }
      }
      
      return {
        'success': false,
        'message': 'No se pudo obtener el video de Facebook'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al descargar de Facebook: ${e.toString()}'
      };
    }
  }

  String _getQualityString(DownloadQuality quality) {
    switch (quality) {
      case DownloadQuality.low:
        return '360p';
      case DownloadQuality.medium:
        return '480p';
      case DownloadQuality.high:
        return '720p';
      case DownloadQuality.highest:
        return '1080p';
    }
  }

  String _sanitizeFilename(String filename) {
    return filename
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(' ', '_')
        .substring(0, filename.length > 50 ? 50 : filename.length);
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<List<FileSystemEntity>> getDownloadedFiles() async {
    await _initializeDownloadPath();
    final directory = Directory(_downloadPath);
    if (await directory.exists()) {
      return directory.listSync();
    }
    return [];
  }
}