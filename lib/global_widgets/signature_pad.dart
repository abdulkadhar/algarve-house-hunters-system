import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePadWidget extends StatefulWidget {
  @override
  _SignaturePadWidgetState createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveSignature() async {
    final signature = await _controller.toPngBytes();
    if (signature != null) {
      // Upload to server, or save to file
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Signature captured!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Signature(
            controller: _controller,
            height: 200,
            backgroundColor: Colors.grey[200]!,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _controller.clear(),
                child: Text('Clear'),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: saveSignature,
                child: Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
