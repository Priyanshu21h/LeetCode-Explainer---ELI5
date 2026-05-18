import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/ds_data.dart';
import 'topic_detail_screen.dart';

// ─── DS Library ───────────────────────────────────────────────────────────────

class DSLibraryScreen extends StatelessWidget {
  const DSLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScreenHeader(
              icon: Icons.account_tree_rounded,
              title: 'Data Structures',
              subtitle: '${dsTopics.length} topics',
              gradientColors: const [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
              statLabel: 'Arrays → Graphs',
            ),
            const Divider(color: Color(0xFF1E1E30), height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: dsTopics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _TopicListTile(topic: dsTopics[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Algo Library ─────────────────────────────────────────────────────────────

class AlgoLibraryScreen extends StatelessWidget {
  const AlgoLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Group by category
    final Map<String, List<AlgoTopic>> grouped = {};
    for (final t in algoTopics) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    final categories = grouped.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScreenHeader(
              icon: Icons.bolt_rounded,
              title: 'Algorithms',
              subtitle: '${algoTopics.length} algorithms',
              gradientColors: const [Color(0xFFFF6B6B), Color(0xFFFFB347)],
              statLabel: 'Sort → Graph → DP',
            ),
            const Divider(color: Color(0xFF1E1E30), height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: categories.fold<int>(
                    0, (sum, cat) => sum + 1 + grouped[cat]!.length),
                itemBuilder: (context, index) {
                  int cursor = 0;
                  for (final cat in categories) {
                    if (index == cursor) {
                      return _CategoryHeader(category: cat);
                    }
                    cursor++;
                    final items = grouped[cat]!;
                    if (index < cursor + items.length) {
                      final item = items[index - cursor];
                      final isLast = index == cursor + items.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 12 : 8),
                        child: _AlgoListTile(topic: item),
                      );
                    }
                    cursor += items.length;
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ScreenHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String statLabel;
  final List<Color> gradientColors;

  const _ScreenHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.statLabel,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: const BoxDecoration(color: Color(0xFF0D0D1A)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                Text(statLabel,
                    style: GoogleFonts.poppins(
                        color: gradientColors[0],
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: gradientColors[0].withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: gradientColors[0].withAlpha(70), width: 1),
            ),
            child: Text(subtitle,
                style: GoogleFonts.poppins(
                    color: gradientColors[0],
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Category Header ─────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final String category;
  const _CategoryHeader({required this.category});

  static const _catColors = {
    'Search': Color(0xFF3ECFCF),
    'Sorting': Color(0xFFFFB347),
    'Graph': Color(0xFF6C63FF),
    'Technique': Color(0xFFFF6B6B),
  };

  @override
  Widget build(BuildContext context) {
    final color = _catColors[category] ?? const Color(0xFF6C63FF);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            category.toUpperCase(),
            style: GoogleFonts.poppins(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }
}

// ─── DS List Tile ─────────────────────────────────────────────────────────────

class _TopicListTile extends StatelessWidget {
  final DSTopic topic;
  const _TopicListTile({required this.topic});

  static const _diffColors = {
    'Beginner': Color(0xFF4CAF50),
    'Intermediate': Color(0xFFFFB347),
    'Advanced': Color(0xFFFF5252),
  };

  static const _dsIcons = {
    'array': Icons.grid_on_rounded,
    'stack': Icons.layers_rounded,
    'queue': Icons.swap_horiz_rounded,
    'linked_list': Icons.link_rounded,
    'tree': Icons.account_tree_rounded,
    'graph': Icons.hub_rounded,
    'heap': Icons.filter_list_rounded,
    'hashmap': Icons.table_chart_rounded,
  };

  static const _bgColors = {
    'array': Color(0xFF6C63FF),
    'stack': Color(0xFFFF6B6B),
    'queue': Color(0xFFFFB347),
    'linked_list': Color(0xFF3ECFCF),
    'tree': Color(0xFF4CAF50),
    'graph': Color(0xFFE040FB),
    'heap': Color(0xFFFF8A65),
    'hashmap': Color(0xFF29B6F6),
  };

  @override
  Widget build(BuildContext context) {
    final diffColor =
        _diffColors[topic.difficulty] ?? const Color(0xFF6C63FF);
    final iconData = _dsIcons[topic.id] ?? Icons.code_rounded;
    final bgColor = _bgColors[topic.id] ?? const Color(0xFF6C63FF);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailScreen(
            title: topic.name,
            code: topic.code,
            description: topic.description,
            icon: topic.icon,
            difficulty: topic.difficulty,
          ),
        ),
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E1E35), width: 1),
        ),
        child: Row(
          children: [
            // Colored icon block
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: bgColor.withAlpha(25),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Icon(iconData, color: bgColor, size: 24),
            ),
            const SizedBox(width: 12),
            // Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(topic.name,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(topic.description,
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF666688),
                          fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Difficulty badge + arrow
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: diffColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(topic.difficulty,
                        style: GoogleFonts.poppins(
                            color: diffColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF444466), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Algo List Tile ───────────────────────────────────────────────────────────

class _AlgoListTile extends StatelessWidget {
  final AlgoTopic topic;
  const _AlgoListTile({required this.topic});

  static const _diffColors = {
    'Beginner': Color(0xFF4CAF50),
    'Intermediate': Color(0xFFFFB347),
    'Advanced': Color(0xFFFF5252),
  };

  static const _catColors = {
    'Search': Color(0xFF3ECFCF),
    'Sorting': Color(0xFFFFB347),
    'Graph': Color(0xFF6C63FF),
    'Technique': Color(0xFFFF6B6B),
  };

  static const _algoIcons = {
    'binary_search': Icons.search_rounded,
    'bubble_sort': Icons.bubble_chart_rounded,
    'merge_sort': Icons.call_merge_rounded,
    'quick_sort': Icons.flash_on_rounded,
    'dfs': Icons.trending_down_rounded,
    'bfs': Icons.wifi_tethering_rounded,
    'two_pointers': Icons.compare_arrows_rounded,
    'sliding_window': Icons.view_carousel_rounded,
    'dp': Icons.psychology_rounded,
    'dijkstra': Icons.map_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final diffColor =
        _diffColors[topic.difficulty] ?? const Color(0xFF6C63FF);
    final catColor =
        _catColors[topic.category] ?? const Color(0xFF6C63FF);
    final iconData = _algoIcons[topic.id] ?? Icons.bolt_rounded;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailScreen(
            title: topic.name,
            code: topic.code,
            description: topic.description,
            icon: topic.icon,
            difficulty: topic.difficulty,
            category: topic.category,
          ),
        ),
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E1E35), width: 1),
        ),
        child: Row(
          children: [
            // Colored icon block
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: catColor.withAlpha(22),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Icon(iconData, color: catColor, size: 24),
            ),
            const SizedBox(width: 12),
            // Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(topic.name,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(topic.description,
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF666688),
                          fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Badges + arrow
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: diffColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(topic.difficulty,
                        style: GoogleFonts.poppins(
                            color: diffColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF444466), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
