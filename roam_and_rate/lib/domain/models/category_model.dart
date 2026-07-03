import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryModel {
  final String name;
  final FaIconData? icon;

  const CategoryModel({required this.name, this.icon});

  CategoryModel copyWith({String? name, FaIconData? icon}) {
    return CategoryModel(name: name ?? this.name, icon: icon ?? this.icon);
  }
}
