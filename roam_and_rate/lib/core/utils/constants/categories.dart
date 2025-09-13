import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';

class Categories {
  static final List<CategoryModel> tripCategories = [
    CategoryModel(
      name: "Aboard Holiday",
      icon: FontAwesomeIcons.planeDeparture,
    ),
    CategoryModel(name: "Work", icon: FontAwesomeIcons.briefcase),
    CategoryModel(name: "School", icon: FontAwesomeIcons.school),
    CategoryModel(name: "Home Holiday", icon: FontAwesomeIcons.house),
  ];

  static final List<CategoryModel> expenseCategories = [
    CategoryModel(name: "Food & Drink", icon: FontAwesomeIcons.bowlFood),
    CategoryModel(
      name: "Tourist Attraction",
      icon: FontAwesomeIcons.mapLocationDot,
    ),
    CategoryModel(name: "Accommodation", icon: FontAwesomeIcons.hotel),
    CategoryModel(name: "Shopping", icon: FontAwesomeIcons.bagShopping),
    CategoryModel(name: "Nature & Outdoors", icon: FontAwesomeIcons.tree),
    CategoryModel(name: "Wellness", icon: FontAwesomeIcons.spa),
    CategoryModel(name: "Transport", icon: FontAwesomeIcons.taxi),
    CategoryModel(name: "Other", icon: FontAwesomeIcons.alignJustify),
  ];
}
