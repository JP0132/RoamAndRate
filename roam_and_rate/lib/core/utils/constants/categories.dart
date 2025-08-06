import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/models/category_model.dart';

class Categories {
  static final List<CategoryModel> categories = [
    CategoryModel(
      name: "Aboard Holiday",
      icon: FontAwesomeIcons.planeDeparture,
    ),
    CategoryModel(name: "Work", icon: FontAwesomeIcons.briefcase),
    CategoryModel(name: "School", icon: FontAwesomeIcons.school),
    CategoryModel(name: "Home Holiday", icon: FontAwesomeIcons.house),
  ];
}
