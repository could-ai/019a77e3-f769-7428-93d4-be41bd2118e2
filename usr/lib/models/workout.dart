class Workout {
  final String id;
  final String name;
  final String description;
  final List<Exercise> exercises;
  bool completed;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    this.completed = false,
  });
}

class Exercise {
  final String name;
  final int sets;
  final String reps;
  final double weight;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
  });
}