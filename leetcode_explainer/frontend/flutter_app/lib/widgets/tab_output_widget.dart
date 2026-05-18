import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/explanation_model.dart';

class TabOutputWidget extends StatefulWidget {
  final ExplanationModel explanation;
  const TabOutputWidget({super.key, required this.explanation});

  @override
  State<TabOutputWidget> createState() => _TabOutputWidgetState();
}

class _TabOutputWidgetState extends State<TabOutputWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: const Color(0xFF6C63FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF6C63FF),
          unselectedLabelColor: const Color(0xFF888888),
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Explanation'),
            Tab(text: 'Complexity'),
            Tab(text: 'Dry Run'),
            Tab(text: 'ELI5'),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 420,
        child: TabBarView(controller: _tabController, children: [
          _explanationTab(),
          _complexityTab(),
          _dryRunTab(),
          _eli5Tab(),
        ]),
      ),
    ]);
  }

  Widget _explanationTab() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _gradientCard(Icons.auto_awesome, 'Key Insight',
            widget.explanation.keyInsight,
            const [Color(0xFF6C63FF), Color(0xFF4834DF)]),
        const SizedBox(height: 16),
        _card(Text(widget.explanation.explanation,
            style: GoogleFonts.poppins(color: const Color(0xFFD0D0D0), fontSize: 14, height: 1.7))),
      ]),
    );
  }

  Widget _complexityTab() {
    return SingleChildScrollView(
      child: Column(children: [
        _complexityCard(Icons.timer_outlined, 'Time Complexity',
            widget.explanation.complexity.time, const Color(0xFF6C63FF)),
        const SizedBox(height: 16),
        _complexityCard(Icons.memory, 'Space Complexity',
            widget.explanation.complexity.space, const Color(0xFF00BFA6)),
      ]),
    );
  }

  Widget _complexityCard(IconData icon, String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.poppins(color: color, fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 14),
        Text(value, style: GoogleFonts.poppins(color: const Color(0xFFD0D0D0), fontSize: 14, height: 1.6)),
      ]),
    );
  }

  Widget _dryRunTab() {
    final steps = widget.explanation.dryRun;
    if (steps.isEmpty) {
      return Center(child: Text('No dry run steps.', style: GoogleFonts.poppins(color: const Color(0xFF888888))));
    }
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF6C63FF).withAlpha(26)),
            dataRowColor: WidgetStateProperty.all(const Color(0xFF2D2D2D)),
            border: TableBorder.all(color: const Color(0xFF3D3D3D), borderRadius: BorderRadius.circular(8)),
            columnSpacing: 20,
            headingTextStyle: GoogleFonts.poppins(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w600, fontSize: 13),
            dataTextStyle: GoogleFonts.jetBrainsMono(color: const Color(0xFFD0D0D0), fontSize: 12, height: 1.5),
            columns: const [
              DataColumn(label: Text('Step')),
              DataColumn(label: Text('Line')),
              DataColumn(label: Text('State')),
              DataColumn(label: Text('Note')),
            ],
            rows: steps.map((s) => DataRow(cells: [
              DataCell(Text(s.step.toString(), style: GoogleFonts.poppins(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w700))),
              DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 220), child: Text(s.line))),
              DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 200), child: Text(s.state))),
              DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 250),
                  child: Text(s.note, style: GoogleFonts.poppins(color: const Color(0xFFB0B0B0), fontSize: 12)))),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget _eli5Tab() {
    return SingleChildScrollView(
      child: _gradientCard(Icons.lightbulb, "Explain Like I'm 5",
          widget.explanation.eli5, const [Color(0xFFFF9800), Color(0xFFF44336)]),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF2D2D2D), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }

  Widget _gradientCard(IconData icon, String title, String body, List<Color> colors) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 14),
        Text(body, style: GoogleFonts.poppins(color: Colors.white.withAlpha(230), fontSize: 14, height: 1.7)),
      ]),
    );
  }
}
