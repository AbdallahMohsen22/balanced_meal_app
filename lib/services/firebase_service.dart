import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingredient.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> fetchIngredients(String category) async {
    try {
      // For development purposes, we'll simulate fetching from Firebase
      // In a real app, you would use code like:
      // final snapshot = await _firestore.collection(category).get();
      // return snapshot.docs.map((doc) => Ingredient.fromJson(doc.data(), category)).toList();

      // Simulated data based on the provided JSON
      if (category == 'meat') {
        return [
          Ingredient(
            foodName: 'Chicken Breast',
            calories: 165,
            imageUrl: 'https://www.savorynothings.com/wp-content/uploads/2021/02/airy-fryer-chicken-breast-image-8.jpg',
            category: 'Meat',
          ),
          Ingredient(
            foodName: 'Salmon',
            calories: 206,
            imageUrl: 'https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_1:1/k%2F2023-04-baked-salmon-how-to%2Fbaked-salmon-step6-4792',
            category: 'Meat',
          ),
          Ingredient(
            foodName: 'Lean Beef',
            calories: 250,
            imageUrl: 'https://www.mashed.com/img/gallery/the-truth-about-lean-beef/l-intro-1621886574.jpg',
            category: 'Meat',
          ),
          Ingredient(
            foodName: 'Turkey',
            calories: 135,
            imageUrl: 'https://fox59.com/wp-content/uploads/sites/21/2022/11/white-meat.jpg?w=2560&h=1440&crop=1',
            category: 'Meat',
          ),
        ];
      } else if (category == 'vegetable') {
        return [
          Ingredient(
            foodName: 'Broccoli',
            calories: 55,
            imageUrl: 'https://cdn.britannica.com/25/78225-050-1781F6B7/broccoli-florets.jpg',
            category: 'Vegetable',
          ),
          Ingredient(
            foodName: 'Spinach',
            calories: 23,
            imageUrl: 'https://www.daysoftheyear.com/cdn-cgi/image/dpr=1%2Cf=auto%2Cfit=cover%2Cheight=650%2Cq=40%2Csharpen=1%2Cwidth=956/wp-content/uploads/fresh-spinach-day.jpg',
            category: 'Vegetable',
          ),
          Ingredient(
            foodName: 'Carrot',
            calories: 41,
            imageUrl: 'https://cdn11.bigcommerce.com/s-kc25pb94dz/images/stencil/1280x1280/products/271/762/Carrot__40927.1634584458.jpg?c=2',
            category: 'Vegetable',
          ),
          Ingredient(
            foodName: 'Bell Pepper',
            calories: 31,
            imageUrl: 'https://i5.walmartimages.com/asr/5d3ca3f5-69fa-436a-8a73-ac05713d3c2c.7b334b05a184b1eafbda57c08c6b8ccf.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF',
            category: 'Vegetable',
          ),
        ];
      } else if (category == 'carb') {
        return [
          Ingredient(
            foodName: 'Brown Rice',
            calories: 111,
            imageUrl: 'https://assets-jpcust.jwpsrv.com/thumbnails/k98gi2ri-720.jpg',
            category: 'Carb',
          ),
          Ingredient(
            foodName: 'Oats',
            calories: 389,
            imageUrl: 'https://media.post.rvohealth.io/wp-content/uploads/2020/03/oats-oatmeal-732x549-thumbnail.jpg',
            category: 'Carb',
          ),
          Ingredient(
            foodName: 'Sweet Corn',
            calories: 86,
            imageUrl: 'https://m.media-amazon.com/images/I/41F62-VbHSL._AC_UF1000,1000_QL80_.jpg',
            category: 'Carb',
          ),
          Ingredient(
            foodName: 'Black Beans',
            calories: 132,
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwxSM9Ib-aDXTUIATZlRPQ6qABkkJ0sJwDmA&usqp=CAU',
            category: 'Carb',
          ),
        ];
      }

      return [];
    } catch (e) {
      print('Error fetching ingredients: $e');
      throw Exception('Failed to load ingredients');
    }
  }
}