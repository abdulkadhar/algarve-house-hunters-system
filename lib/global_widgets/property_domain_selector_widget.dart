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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              changeDomainType(PropertyDomainType.infocasa);
              widget.onStateChange(domainType);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: domainType == PropertyDomainType.infocasa
                    ? Colors.black
                    : Colors.transparent,
              ),
              child: Text(
                "Infocasa",
                style: ThemeController.normalTextStyle(
                  color: domainType == PropertyDomainType.infocasa
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              changeDomainType(PropertyDomainType.casayes);
              widget.onStateChange(domainType);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: domainType == PropertyDomainType.casayes
                    ? Colors.black
                    : Colors.transparent,
              ),
              child: Text(
                "Casayes",
                style: ThemeController.normalTextStyle(
                  color: domainType == PropertyDomainType.casayes
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
