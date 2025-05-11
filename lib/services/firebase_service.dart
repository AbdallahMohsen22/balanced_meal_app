import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balanced_meal/models/ingredient.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> fetchIngredients(String category) async {
    try {
      final snapshot = await _firestore
          .collection('ingredients')
          .where('category', isEqualTo: category.toLowerCase())
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('No ingredients found for category: $category');
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Ingredient(
          id: doc.id,
          foodName: data['food_name'] ?? 'Unknown',
          calories: (data['calories'] ?? 0).toInt(),
          imageUrl: data['image_url'] ?? '',
          category: data['category'] ?? '',
          quantity: 0,
        );
      }).toList();
    } on FirebaseException catch (e) {
      debugPrint('Firestore error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }
}