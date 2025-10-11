enum PropertyManagementOption {
  addProperty,
  listProperty,
  crmPortal,
  emailTemplate,
}

class ManagerPropertyManagementScreenController {
  static Map<String, dynamic> unitPropertyInfo = {
    "propertyId": "PPT-BLR-20250625-0001",
    "propertyName": "Property 1",
    "officeNotes": "",
    "contact": "",
    "registrationNotes": "",
    "viewingInformation": "",
    "ourRef": "",
    "ourNotes": "",
    "clientNotes": "",
    "clientLink": "",
    "pool": "",
    "parking": "",
    "propertyLocationName": "Ribeira da Gafa",
    "propertyPrice": "120000",
    "listingRef": "322/M/02127",
    "contactEmail": "vrsa@era.pt",
    "propertyM2": "112",
    "bedsNumber": "32",
    "bathsNumber": "3",
    "plotSize": "515",
    "distanceFromCoast": "12",
    "googleMapLink": "https: //maps.app.goo.gl/jxNqTsRPYpVd9uTu9",
    "propertyDescription": "This the sample property description",
    "propertyImages": [
      "https://plus.unsplash.com/premium_photo-1686090449192-4ab1d00cb735?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://plus.unsplash.com/premium_photo-1687960117069-567a456fe5f3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1483097365279-e8acd3bf9f18?q=80&w=2011&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1516156008625-3a9d6067fab5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1498373419901-52eba931dc4f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1472224371017-08207f84aaae?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ],
    "createdBy": "AGT-BLR-20250625-0001",
    "assignedTo": [
      "CLT-BLR-20250625-0001",
      "CLT-BLR-20250625-0001",
      "CLT-BLR-20250625-0001",
    ]
  };
  static List<Map<String, dynamic>> allPropertyList = [
    {
      "propertyId": "PPT-BLR-20250625-0001",
      "propertyName": "Property 1",
      "officeNotes": "",
      "contact": "",
      "registrationNotes": "",
      "viewingInformation": "",
      "ourRef": "",
      "ourNotes": "",
      "clientNotes": "",
      "clientLink": "",
      "pool": "",
      "parking": "",
      "propertyLocationName": "Ribeira da Gafa",
      "propertyPrice": "120000",
      "listingRef": "322/M/02127",
      "contactEmail": "vrsa@era.pt",
      "propertyM2": "112",
      "bedsNumber": "32",
      "bathsNumber": "3",
      "plotSize": "515",
      "distanceFromCoast": "12",
      "googleMapLink": "https: //maps.app.goo.gl/jxNqTsRPYpVd9uTu9",
      "propertyDescription": "This the sample property description",
      "propertyImages": [
        "https://plus.unsplash.com/premium_photo-1686090449192-4ab1d00cb735?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://plus.unsplash.com/premium_photo-1687960117069-567a456fe5f3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1483097365279-e8acd3bf9f18?q=80&w=2011&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1516156008625-3a9d6067fab5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1498373419901-52eba931dc4f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1472224371017-08207f84aaae?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
      ],
      "createdBy": "AGT-BLR-20250625-0001",
      "assignedTo": [
        "CLT-BLR-20250625-0001",
        "CLT-BLR-20250625-0001",
        "CLT-BLR-20250625-0001",
      ]
    }
  ];
}
