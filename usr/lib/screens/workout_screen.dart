import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../widgets/workout_card.dart';
import 'workout_detail_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Mock data - em produção, isso viria de um banco de dados
  final List<Workout> _workouts = [
    Workout(
      id: '1',
      name: 'Treino A - Peito e Tríceps',
      description: 'Foco em desenvolvimento de peitoral e tríceps',
      exercises: [
        Exercise(name: 'Supino reto', sets: 4, reps: '8-12', weight: 60),
        Exercise(name: 'Supino inclinado', sets: 3, reps: '10-12', weight: 50),
        Exercise(name: 'Crucifixo', sets: 3, reps: '12-15', weight: 20),
        Exercise(name: 'Tríceps testa', sets: 3, reps: '10-12', weight: 30),
        Exercise(name: 'Tríceps corda', sets: 3, reps: '12-15', weight: 25),
      ],
      completed: false,
    ),
    Workout(
      id: '2',
      name: 'Treino B - Costas e Bíceps',
      description: 'Desenvolvimento de costas e bíceps',
      exercises: [
        Exercise(name: 'Barra fixa', sets: 4, reps: '6-10', weight: 0),
        Exercise(name: 'Remada curvada', sets: 4, reps: '8-12', weight: 70),
        Exercise(name: 'Pulldown', sets: 3, reps: '10-12', weight: 55),
        Exercise(name: 'Rosca direta', sets: 3, reps: '10-12', weight: 30),
        Exercise(name: 'Rosca martelo', sets: 3, reps: '12-15', weight: 25),
      ],
      completed: true,
    ),
    Workout(
      id: '3',
      name: 'Treino C - Pernas',
      description: 'Treino completo de membros inferiores',
      exercises: [
        Exercise(name: 'Agachamento', sets: 4, reps: '8-12', weight: 100),
        Exercise(name: 'Leg press', sets: 4, reps: '10-12', weight: 200),
        Exercise(name: 'Cadeira extensora', sets: 3, reps: '12-15', weight: 60),
        Exercise(name: 'Cadeira flexora', sets: 3, reps: '12-15', weight: 50),
        Exercise(name: 'Panturrilha', sets: 4, reps: '15-20', weight: 80),
      ],
      completed: false,
    ),
  ];

  void _toggleWorkoutCompletion(String workoutId) {
    setState(() {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      workout.completed = !workout.completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Treinos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Adicionar novo treino
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adicionar novo treino')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return WorkoutCard(
            workout: workout,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailScreen(workout: workout),
                ),
              );
            },
            onComplete: () => _toggleWorkoutCompletion(workout.id),
          );
        },
      ),
    );
  }
}