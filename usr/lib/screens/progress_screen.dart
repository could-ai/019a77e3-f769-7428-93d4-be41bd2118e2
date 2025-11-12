import 'package:flutter/material.dart';
import '../models/progress_entry.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Mock data - histórico de progresso
  final List<ProgressEntry> _weightHistory = [
    ProgressEntry(date: DateTime(2024, 1, 1), value: 85.0),
    ProgressEntry(date: DateTime(2024, 1, 8), value: 84.5),
    ProgressEntry(date: DateTime(2024, 1, 15), value: 84.0),
    ProgressEntry(date: DateTime(2024, 1, 22), value: 83.5),
    ProgressEntry(date: DateTime(2024, 1, 29), value: 83.0),
  ];

  final List<ProgressEntry> _bodyFatHistory = [
    ProgressEntry(date: DateTime(2024, 1, 1), value: 22.0),
    ProgressEntry(date: DateTime(2024, 1, 8), value: 21.5),
    ProgressEntry(date: DateTime(2024, 1, 15), value: 21.0),
    ProgressEntry(date: DateTime(2024, 1, 22), value: 20.5),
    ProgressEntry(date: DateTime(2024, 1, 29), value: 20.0),
  ];

  String _selectedMetric = 'weight';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedData = _selectedMetric == 'weight' ? _weightHistory : _bodyFatHistory;
    final currentValue = selectedData.isNotEmpty ? selectedData.last.value : 0.0;
    final initialValue = selectedData.isNotEmpty ? selectedData.first.value : 0.0;
    final change = currentValue - initialValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Progresso'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adicionar nova medição')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seletor de métrica
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'weight',
                  label: Text('Peso'),
                  icon: Icon(Icons.monitor_weight_outlined),
                ),
                ButtonSegment(
                  value: 'bodyFat',
                  label: Text('% Gordura'),
                  icon: Icon(Icons.percent),
                ),
              ],
              selected: {_selectedMetric},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedMetric = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),
            // Card de estatísticas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          'Atual',
                          currentValue,
                          _selectedMetric == 'weight' ? 'kg' : '%',
                          theme,
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: theme.dividerColor,
                        ),
                        _buildStatColumn(
                          'Inicial',
                          initialValue,
                          _selectedMetric == 'weight' ? 'kg' : '%',
                          theme,
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: theme.dividerColor,
                        ),
                        _buildStatColumn(
                          'Mudança',
                          change.abs(),
                          _selectedMetric == 'weight' ? 'kg' : '%',
                          theme,
                          isChange: true,
                          isPositive: change < 0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Gráfico
            Text(
              'Histórico',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ProgressChart(data: selectedData),
            const SizedBox(height: 24),
            // Lista de medições
            Text(
              'Medições Recentes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...selectedData.reversed.map((entry) {
              final dateStr = '${entry.date.day}/${entry.date.month}/${entry.date.year}';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      _selectedMetric == 'weight'
                          ? Icons.monitor_weight
                          : Icons.percent,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    '${entry.value} ${_selectedMetric == 'weight' ? 'kg' : '%'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(dateStr),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Excluir medição')),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    double value,
    String unit,
    ThemeData theme, {
    bool isChange = false,
    bool isPositive = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isChange)
              Icon(
                isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                size: 16,
                color: isPositive ? Colors.green : Colors.red,
              ),
            Text(
              '${value.toStringAsFixed(1)}$unit',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isChange
                    ? (isPositive ? Colors.green : Colors.red)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}