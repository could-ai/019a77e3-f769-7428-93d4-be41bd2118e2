class Meal {
  final String id;
  final String name;
  final String time;
  final List<Food> foods;
  bool completed;

  Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.foods,
    this.completed = false,
  });

  int get totalCalories => foods.fold(0, (sum, food) => sum + food.calories);
  int get totalProtein => foods.fold(0, (sum, food) => sum + food.protein);
  int get totalCarbs => foods.fold(0, (sum, food) => sum + food.carbs);
  int get totalFat => foods.fold(0, (sum, food) => sum + food.fat);
}

class Food {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  Food({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}