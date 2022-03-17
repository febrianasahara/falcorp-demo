import '../ui/action_color.dart';
import '../ui/grid_icon.dart';

class ServiceProvider {
	int? id;
	String? name;
	GridIcon? icon;
	ActionColor? color;
	int? displayType;
	List<String>? messages;

	ServiceProvider({this.id, this.name, this.icon, this.color, this.displayType, this.messages});

	ServiceProvider.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		icon = json['icon'] != null ? GridIcon.fromJson(json['icon']) : null;
		color = json['color'] != null ? ActionColor.fromJson(json['color']) : null;
		displayType = json['displayType'];
		   if (json['messages'] != null) {
      messages = <String>[];
      json['messages'].forEach((v) {
        messages!.add(v);
      });
    }
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		if (icon != null) {
      data['icon'] = icon!.toJson();
    }
		if (color != null) {
      data['color'] = color!.toJson();
    }
		data['displayType'] = displayType;
		data['messages'] = messages;
		return data;
	}
}

