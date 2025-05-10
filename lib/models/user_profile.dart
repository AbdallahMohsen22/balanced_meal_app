enum Gender { male, female , choose}

class UserProfile {
  final Gender gender;
  final double weightKg;
  final double heightCm;
  final int age;
  final double dailyCalories;

  UserProfile({
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.dailyCalories,
  });

  factory UserProfile.calculate({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    double calories;
    if (gender == Gender.female) {
      calories = 655.1 + (9.56 * weightKg) + (1.85 * heightCm) - (4.67 * age);
    } else {
      calories = 666.47 + (13.75 * weightKg) + (5 * heightCm) - (6.75 * age);
    }

    return UserProfile(
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      dailyCalories: calories,
    );
  }
}