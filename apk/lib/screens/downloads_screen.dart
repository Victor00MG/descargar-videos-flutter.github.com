import 'dart:io';
import 'package:flutter/material.dart';
import '../services/video_downloader_service.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final VideoDownloaderService _downloaderService = VideoDownloaderService();
  List<FileSystemEntity> _downloadedFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedFiles();
  }

  Future<void> _loadDownloadedFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final files = await _downloaderService.getDownloadedFiles();
      setState(() {
        _downloadedFiles = files.where((file) => file is File).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar archivos: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      if (bytes < 1024 * 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } catch (e) {
      return 'Desconocido';
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      _loadDownloadedFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Archivo eliminado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(File file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Archivo'),
        content: Text('¿Estás seguro de que quieres eliminar "${_getFileName(file.path)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteFile(file);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformFromFilename(String filename) {
    if (filename.contains('youtube')) return Icons.play_circle_fill;
    if (filename.contains('tiktok')) return Icons.music_video;
    if (filename.contains('facebook')) return Icons.facebook;
    return Icons.video_library;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Descargas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDownloadedFiles,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _downloadedFiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay descargas',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Los videos descargados aparecerán aquí',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDownloadedFiles,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _downloadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _downloadedFiles[index] as File;
                      final filename = _getFileName(file.path);
                      final fileSize = _getFileSize(file);
                      final platform = _getPlatformFromFilename(filename);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(_getPlatformFromFilename(filename)),
                          ),
                          title: Text(
                            filename,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tamaño: $fileSize'),
                              Text(
                                'Modificado: ${_formatDate(file.lastModifiedSync())}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _showDeleteConfirmation(file);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Eliminar'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Aquí podrías abrir el video con un reproductor
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Video: $filename'),
                                action: SnackBarAction(
                                  label: 'Abrir',
                                  onPressed: () {
                                    // Implementar apertura del video
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}