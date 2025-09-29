import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData? icon;

  const CategoryModel({required this.name, this.icon});

  CategoryModel copyWith({String? name, IconData? icon}) {
    return CategoryModel(name: name ?? this.name, icon: icon ?? this.icon);
  }
}
