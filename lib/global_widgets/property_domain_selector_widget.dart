import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

enum PropertyDomainType { infocasa, casayes }

class PropertyDomainSelectorWidget extends StatefulWidget {
  final PropertyDomainType initialValue;
  final Function(PropertyDomainType) onStateChange;
  const PropertyDomainSelectorWidget({
    super.key,
    this.initialValue = PropertyDomainType.infocasa,
    required this.onStateChange,
  });

  @override
  State<PropertyDomainSelectorWidget> createState() =>
      _PropertyDomainSelectorWidgetState();
}

class _PropertyDomainSelectorWidgetState
    extends State<PropertyDomainSelectorWidget> {
  PropertyDomainType domainType = PropertyDomainType.infocasa;

  void changeDomainType(PropertyDomainType data) {
    domainType = data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    changeDomainType(widget.initialValue);
    print('eidget domain state value: $domainType');
  }

  Widget _option(String label, PropertyDomainType type) {
    final bool selected = domainType == type;
    return InkWell(
      onTap: () {
        changeDomainType(type);
        widget.onStateChange(domainType);
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selected ? Colors.black : Colors.transparent,
        ),
        child: Text(
          label,
          style: ThemeController.normalTextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w800,
            size: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _option("Infocasa", PropertyDomainType.infocasa),
          _option("Casayes", PropertyDomainType.casayes),
        ],
      ),
    );
  }
}
