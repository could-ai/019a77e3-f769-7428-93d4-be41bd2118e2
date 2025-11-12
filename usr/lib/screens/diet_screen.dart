import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  // Mock data - dados do plano alimentar
  final List<Meal> _meals = [
    Meal(
      id: '1',
      name: 'Café da Manhã',
      time: '08:00',
      foods: [
        Food(name: 'Ovos mexidos', calories: 200, protein: 18, carbs: 2, fat: 14),
        Food(name: 'Pão integral', calories: 150, protein: 6, carbs: 28, fat: 2),
        Food(name: 'Banana', calories: 105, protein: 1, carbs: 27, fat: 0),
        Food(name: 'Café com leite', calories: 80, protein: 4, carbs: 6, fat: 4),
      ],
      completed: true,
    ),
    Meal(
      id: '2',
      name: 'Lanche da Manhã',
      time: '10:30',
      foods: [
        Food(name: 'Iogurte grego', calories: 150, protein: 15, carbs: 8, fat: 6),
        Food(name: 'Granola', calories: 120, protein: 3, carbs: 20, fat: 4),
      ],
      completed: true,
    ),
    Meal(
      id: '3',
      name: 'Almoço',
      time: '13:00',
      foods: [
        Food(name: 'Arroz integral', calories: 220, protein: 5, carbs: 45, fat: 2),
        Food(name: 'Frango grelhado', calories: 280, protein: 42, carbs: 0, fat: 12),
        Food(name: 'Brócolis', calories: 55, protein: 4, carbs: 11, fat: 0),
        Food(name: 'Salada verde', calories: 30, protein: 2, carbs: 6, fat: 0),
      ],
      completed: false,
    ),
    Meal(
      id: '4',
      name: 'Lanche da Tarde',
      time: '16:00',
      foods: [
        Food(name: 'Whey protein', calories: 120, protein: 24, carbs: 3, fat: 1),
        Food(name: 'Pasta de amendoim', calories: 190, protein: 8, carbs: 7, fat: 16),
      ],
      completed: false,
    ),
    Meal(
      id: '5',
      name: 'Jantar',
      time: '19:30',
      foods: [
        Food(name: 'Batata doce', calories: 180, protein: 4, carbs: 41, fat: 0),
        Food(name: 'Peixe assado', calories: 250, protein: 40, carbs: 0, fat: 10),
        Food(name: 'Legumes', calories: 80, protein: 3, carbs: 16, fat: 1),
      ],
      completed: false,
    ),
  ];

  int get _totalCalories => _meals
      .expand((meal) => meal.foods)
      .fold(0, (sum, food) => sum + food.calories);

  int get _totalProtein => _meals
      .expand((meal) => meal.foods)
      .fold(0, (sum, food) => sum + food.protein);

  int get _totalCarbs => _meals
      .expand((meal) => meal.foods)
      .fold(0, (sum, food) => sum + food.carbs);

  int get _totalFat => _meals
      .expand((meal) => meal.foods)
      .fold(0, (sum, food) => sum + food.fat);

  int get _consumedCalories => _meals
      .where((meal) => meal.completed)
      .expand((meal) => meal.foods)
      .fold(0, (sum, food) => sum + food.calories);

  void _toggleMealCompletion(String mealId) {
    setState(() {
      final meal = _meals.firstWhere((m) => m.id == mealId);
      meal.completed = !meal.completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _totalCalories > 0 ? _consumedCalories / _totalCalories : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Dieta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adicionar nova refeição')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Card de resumo nutricional
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Calorias Diárias',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_consumedCalories / $_totalCalories kcal',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientInfo('Proteína', _totalProtein, 'g', Colors.white),
                    _buildNutrientInfo('Carboidrato', _totalCarbs, 'g', Colors.white),
                    _buildNutrientInfo('Gordura', _totalFat, 'g', Colors.white),
                  ],
                ),
              ],
            ),
          ),
          // Lista de refeições
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                return MealCard(
                  meal: _meals[index],
                  onToggleComplete: () => _toggleMealCompletion(_meals[index].id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, int value, String unit, Color color) {
    return Column(
      children: [
        Text(
          '$value$unit',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}