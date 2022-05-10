import 'package:webadmin_onboarding/models/activity_owned.dart';
import 'package:webadmin_onboarding/models/user.dart';

class ActivityOwnedByUser {
  final User user;
  final List<ActivityOwned> activities_owned;

  ActivityOwnedByUser({required this.user, required this.activities_owned});

  dynamic getData(String identifier) {
    if (identifier == 'Email') {
      return user.email;
    } else if (identifier == 'Name') {
      return user.name;
    } else if (identifier == 'Activities Owned') {
      var data = StringBuffer();
      activities_owned.forEach((element) {
        data.write(element.activity_name + '\n');
      });
      return data;
    } else {
      return "not found";
    }
  }
}
