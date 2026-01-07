import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
// image_viewer_dialog.dart
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// NOTE: This import is okay because you're targeting Flutter Web.
// If you also target mobile/desktop, split this into a conditional import.
import 'dart:html' as html;

import 'package:flutter/services.dart';

class GlobalWidgets {
  static Widget getTextLabelWidget(
    String labelText, {
    bool isMandatory = true,
  }) =>
      Text.rich(
        TextSpan(
          text: labelText,
          style: ThemeController.getFormLabelTextStyle(),
          children: isMandatory
              ? <InlineSpan>[
                  TextSpan(
                    text: ' *',
                    style: ThemeController.getFormLabelTextStyle(
                        textColor: Colors.red),
                  )
                ]
              : [],
        ),
      );

  static Future<void> showImageViewerDialog(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
    String? title,
    bool showThumbnails = true,
  }) {
    assert(imageUrls.isNotEmpty, "imageUrls cannot be empty");
    initialIndex = initialIndex.clamp(0, imageUrls.length - 1);
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _ImageViewerDialog(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          title: title,
          showThumbnails: showThumbnails,
        ),
      ),
    );
  }
}

class _NetworkImageWithLoader extends StatelessWidget {
  const _NetworkImageWithLoader({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        final total = progress.expectedTotalBytes;
        final loaded = progress.cumulativeBytesLoaded;
        final value = (total != null && total > 0) ? loaded / total : null;
        return SizedBox.expand(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (value != null) ...[
                  const SizedBox(height: 8),
                  Text('${(value * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ],
            ),
          ),
        );
      },
      errorBuilder: (ctx, err, stack) => SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.broken_image, color: Colors.white54, size: 40),
              SizedBox(height: 8),
              Text('Failed to load image',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.url,
    required this.selected,
    required this.onTap,
  });

  final String url;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.lightBlueAccent : Colors.white24,
            width: selected ? 2 : 1,
          ),
          color: const Color(0xFF101114),
        ),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported, color: Colors.white38),
          ),
        ),
      ),
    );
  }
}

class _ImageViewerDialog extends StatefulWidget {
  const _ImageViewerDialog({
    required this.imageUrls,
    required this.initialIndex,
    this.title,
    required this.showThumbnails,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String? title;
  final bool showThumbnails;

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  late int _index;
  TransformationController _tfController = TransformationController();

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  void dispose() {
    _tfController.dispose();
    super.dispose();
  }

  void _next() {
    setState(() {
      _index = (_index + 1) % widget.imageUrls.length;
      _resetZoom();
    });
  }

  void _prev() {
    setState(() {
      _index = (_index - 1 + widget.imageUrls.length) % widget.imageUrls.length;
      _resetZoom();
    });
  }

  void _jumpTo(int i) {
    if (i == _index) return;
    setState(() {
      _index = i.clamp(0, widget.imageUrls.length - 1);
      _resetZoom();
    });
  }

  void _resetZoom() {
    _tfController.value = Matrix4.identity();
  }

  void _downloadCurrent() {
    if (!kIsWeb) return;
    final url = widget.imageUrls[_index];
    final anchor = html.AnchorElement(href: url)
      ..download = url.split('/').last
      ..target = '_blank';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;
    final current = images[_index];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = min(constraints.maxWidth, 1400.0);
        final maxH = min(constraints.maxHeight, 900.0);

        return Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowLeft): const _LeftIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowRight): const _RightIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (intent) {
                  Navigator.of(context).maybePop();
                  return null;
                },
              ),
              _LeftIntent: CallbackAction<_LeftIntent>(
                onInvoke: (intent) {
                  _prev();
                  return null;
                },
              ),
              _RightIntent: CallbackAction<_RightIntent>(
                onInvoke: (intent) {
                  _next();
                  return null;
                },
              ),
            },
            child: Focus(
              autofocus: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxW,
                  maxHeight: maxH,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF101114),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        color: const Color(0xFF17181C),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title ?? 'Image Viewer',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (images.length > 1)
                              Text(
                                '${_index + 1} / ${images.length}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            const SizedBox(width: 12),
                            IconButton(
                              tooltip: 'Reset Zoom',
                              icon: const Icon(Icons.center_focus_strong,
                                  color: Colors.white70),
                              onPressed: _resetZoom,
                            ),
                            if (kIsWeb)
                              IconButton(
                                tooltip: 'Download',
                                icon: const Icon(Icons.download,
                                    color: Colors.white70),
                                onPressed: _downloadCurrent,
                              ),
                            IconButton(
                              tooltip: 'Close (Esc)',
                              icon: const Icon(Icons.close,
                                  color: Colors.white70),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                          ],
                        ),
                      ),

                      // Main image area with left/right arrows
                      Expanded(
                        child: Stack(
                          children: [
                            // Image canvas
                            Positioned.fill(
                              child: Center(
                                child: InteractiveViewer(
                                  transformationController: _tfController,
                                  minScale: 0.5,
                                  maxScale: 5.0,
                                  boundaryMargin: const EdgeInsets.all(80),
                                  child: _NetworkImageWithLoader(url: current),
                                ),
                              ),
                            ),

                            // Left arrow
                            if (images.length > 1)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _NavButton(
                                  icon: Icons.chevron_left,
                                  onTap: _prev,
                                ),
                              ),

                            // Right arrow
                            if (images.length > 1)
                              Align(
                                alignment: Alignment.centerRight,
                                child: _NavButton(
                                  icon: Icons.chevron_right,
                                  onTap: _next,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Thumbnails
                      if (widget.showThumbnails && images.length > 1)
                        Container(
                          height: 96,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          color: const Color(0xFF17181C),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) => _Thumbnail(
                              url: images[i],
                              selected: i == _index,
                              onTap: () => _jumpTo(i),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 36, color: Colors.white),
        ),
      ),
    );
  }
}

// Keyboard intents
class _LeftIntent extends Intent {
  const _LeftIntent();
}

class _RightIntent extends Intent {
  const _RightIntent();
}
