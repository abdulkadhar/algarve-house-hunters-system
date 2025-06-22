class PropertyModel {
  final String ourRef;
  final String listingRef;
  final String contactEmail;
  final double price;
  final double propertyM2;
  final String clientLink;
  final String location;
  final int bedsNumber;
  final int bathsNumber;
  final int plotNumber;
  final double distanceFromCoast;
  final String googleMapLink;
  final List<String> propertyImages;
  final String propertyName;
  final String propertyDescription;

  PropertyModel({
    required this.ourRef,
    required this.listingRef,
    required this.contactEmail,
    required this.price,
    required this.propertyM2,
    required this.clientLink,
    required this.location,
    required this.bedsNumber,
    required this.bathsNumber,
    required this.plotNumber,
    required this.distanceFromCoast,
    required this.googleMapLink,
    required this.propertyImages,
    required this.propertyName,
    required this.propertyDescription,
  });
}
