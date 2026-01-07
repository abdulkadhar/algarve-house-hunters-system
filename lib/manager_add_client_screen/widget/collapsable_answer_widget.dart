import 'package:algarve_house_hunters_system/manager_add_client_screen/model/answer_filed.dart';
import 'package:algarve_house_hunters_system/manager_add_client_screen/model/form_response.dart';
import 'package:flutter/material.dart';

/// Use this in your right 50% column/panel.
class RightPaneSubmissionsAccordion extends StatelessWidget {
  final FormResponse formResponse;
  final ScrollController? scrollController;

  const RightPaneSubmissionsAccordion({
    super.key,
    required this.formResponse,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final subs = formResponse.submissions;

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        // keep it readable on very wide screens
        constraints: const BoxConstraints(maxWidth: 720),
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: subs.length,
            shrinkWrap: true,
            primary: false, // don’t steal primary scroll from the page
            itemBuilder: (context, index) {
              final s = subs[index];

              final first = s.answerTextByName('firstName') ?? '';
              final last = s.answerTextByName('lastName') ?? '';
              final title = (first + ' ' + last).trim().isEmpty
                  ? 'Submission ${s.id}'
                  : '${first.trim()} ${last.trim()}';

              final subtitle =
                  s.createdAt.isNotEmpty ? 'Created: ${s.createdAt}' : s.id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 1,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    // tighter ExpansionTile for side panel
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      childrenPadding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: ExpansionTile(
                    key: PageStorageKey('right_submission_$index'),
                    title: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        Text(subtitle, style: const TextStyle(fontSize: 12)),
                    children: [
                      _RightPaneSubmissionFields(answers: s.sortedAnswers()),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RightPaneSubmissionFields extends StatelessWidget {
  final List<AnswerField> answers;

  const _RightPaneSubmissionFields({required this.answers});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: answers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // avoid nested scroll
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, i) => _RightPaneAnswerTile(field: answers[i]),
    );
  }
}

class _RightPaneAnswerTile extends StatefulWidget {
  final AnswerField field;
  const _RightPaneAnswerTile({required this.field});

  @override
  State<_RightPaneAnswerTile> createState() => _RightPaneAnswerTileState();
}

class _RightPaneAnswerTileState extends State<_RightPaneAnswerTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.field;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.5,
      child: ExpansionTile(
        initiallyExpanded: false,
        onExpansionChanged: (o) => setState(() => _open = o),
        leading: _typeIcon(f.type),
        title: Text(
          f.text.isEmpty ? 'Untitled field' : f.text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 6),
            child: Text(
              'Answer',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
          ),
          // white container with value
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 2, spreadRadius: 0, color: Color(0x11000000))
                ],
              ),
              child: _valueWidget(f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _valueWidget(AnswerField f) {
    final dynamic v =
        (f.prettyFormat != null && f.prettyFormat!.trim().isNotEmpty)
            ? f.prettyFormat
            : f.answer;

    if (f.type == 'control_signature' && v is String && v.startsWith('http')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(v, height: 120, fit: BoxFit.contain),
          ),
        ],
      );
    }

    if (f.type == 'control_appointment') {
      if (v is String && v.trim().isNotEmpty) return Text(v);
      if (f.answer is Map) {
        final map = (f.answer as Map)
            .map((k, val) => MapEntry(k.toString(), val?.toString() ?? ''));
        final lines = map.entries.map((e) => '${e.key}: ${e.value}').join('\n');
        return Text(lines);
      }
    }

    if (v == null || (v is String && v.trim().isEmpty)) {
      return const Text('No answer provided',
          style: TextStyle(color: Colors.grey));
    }
    if (v is String) return Text(v);

    if (v is List) {
      // compact chips look better in side panel
      return Wrap(
        spacing: 6,
        runSpacing: -8,
        children: v
            .map<Widget>((e) => Chip(
                label: Text(e.toString()),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap))
            .toList(),
      );
    }

    if (v is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: v.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
      );
    }

    return Text(v.toString());
  }

  Widget _typeIcon(String type) {
    switch (type) {
      case 'control_textbox':
        return const Icon(Icons.short_text, size: 20);
      case 'control_textarea':
        return const Icon(Icons.notes, size: 20);
      case 'control_radio':
        return const Icon(Icons.radio_button_checked, size: 20);
      case 'control_checkbox':
        return const Icon(Icons.check_box, size: 20);
      case 'control_email':
        return const Icon(Icons.email, size: 20);
      case 'control_button':
        return const Icon(Icons.touch_app, size: 20);
      case 'control_head':
        return const Icon(Icons.title, size: 20);
      case 'control_signature':
        return const Icon(Icons.draw, size: 20);
      case 'control_actionButton':
        return const Icon(Icons.bolt, size: 20);
      case 'control_appointment':
        return const Icon(Icons.schedule, size: 20);
      case 'control_assignee':
        return const Icon(Icons.person, size: 20);
      default:
        return const Icon(Icons.list_alt, size: 20);
    }
  }
}
