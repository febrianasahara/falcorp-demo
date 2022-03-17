import 'package:airtime_purchase_app/models/data/service_provider.dart';

class ProviderSection {
  String? title;
  List<ServiceProvider>? serviceProviders;

  ProviderSection({this.title, this.serviceProviders});

  ProviderSection.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['serviceProviders'] != null) {
      serviceProviders = <ServiceProvider>[];
      json['serviceProviders'].forEach((v) {
        serviceProviders!.add(ServiceProvider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    if (serviceProviders != null) {
      data['serviceProviders'] =
          serviceProviders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
