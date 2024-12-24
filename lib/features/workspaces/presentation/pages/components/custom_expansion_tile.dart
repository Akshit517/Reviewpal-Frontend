import 'package:flutter/material.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Function? onTap;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
    this.onTap,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        children: [
          if (_isExpanded)
            const Positioned(
              left: 7.5,
              top: 16,
              bottom: 8,
              child: VerticalDivider(
                thickness: 3,
                color: DarkThemePalette.fillColor,
                indent: 24,
                endIndent: 8,
              ),
            ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() => _isExpanded = !_isExpanded);
                  if (!_isExpanded && widget.onTap != null) {
                    widget.onTap!();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(children: widget.children),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
