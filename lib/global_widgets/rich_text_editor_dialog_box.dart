// html_editor_dialog.dart
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class HtmlEditorDialog {
  static Future<String?> showHtmlEditorDialogWeb(
    BuildContext context, {
    String title = 'Edit Content',
    String? initialHtml,
    double editorHeight = 380,
    double maxWidth = 900,
  }) async {
    final controller = HtmlEditorController();

    return showGeneralDialog<String?>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'RichTextEditor',
      barrierColor: Colors.black54,
      // IMPORTANT: no animation (avoid transforms that break iframe focus on web)
      pageBuilder: (ctx, _, __) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Card(
                elevation: 6,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(ctx)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Close',
                            onPressed: () => Navigator.of(ctx).pop(null),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Give the editor a fixed height and avoid wrapping it with Clip/Opacity/Animated* widgets.
                      SizedBox(
                        height: editorHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Theme.of(ctx).dividerColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: HtmlEditor(
                            controller: controller,
                            htmlEditorOptions: HtmlEditorOptions(
                              initialText: initialHtml ?? '',
                              hint: 'Write something…',
                              autoAdjustHeight: false,
                            ),
                            htmlToolbarOptions: const HtmlToolbarOptions(
                              toolbarType: ToolbarType.nativeGrid,
                              defaultToolbarButtons: [
                                StyleButtons(),
                                FontButtons(),
                                ColorButtons(),
                                ListButtons(),
                                ParagraphButtons(),
                                InsertButtons(
                                    audio: false,
                                    video: true,
                                    table: true,
                                    hr: true),
                                OtherButtons(
                                    fullscreen: true,
                                    undo: true,
                                    redo: true,
                                    copy: true,
                                    paste: true),
                              ],
                            ),
                            callbacks: Callbacks(
                              onChangeContent: (html) {
                                // Handy to verify typing actually changes value (open DevTools console)
                                // debugPrint('Editor changed: ${html?.substring(0, math.min(20, html.length))}');
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(null),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Save'),
                            onPressed: () async {
                              final html = await controller.getText();
                              Navigator.of(ctx).pop(html);
                            },
                          ),
                        ],
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
