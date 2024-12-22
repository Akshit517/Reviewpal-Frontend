import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/resources/pallete/dark_theme_palette.dart';

class WorkspaceHomeWidget extends StatelessWidget {
  final String workspaceId;

  const WorkspaceHomeWidget({Key? key, required this.workspaceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Container(
          color: DarkThemePalette.backgroundSurface, // Background surface
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8.0 : isTablet ? 16.0 : 24.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildCategory("IMG 2023-24"),
                    _buildCategory("IMG 2024-25"),
                    _buildCategory("IMG 2022-23"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategory(String category) {
    return CustomExpansionTile(
      title: category,
      children: [
        _buildSubcategory("Linux"),
        _buildSubcategory("Git"),
        _buildSubcategory("OOPS"),
      ],
    );
  }

  Widget _buildSubcategory(String subcategory) {
    return CustomExpansionTile(
      title: subcategory,
      children: [
        _buildSubSubcategoryOption("Assignment"),
        _buildSubSubcategoryOption("Doubts"),
      ],
    );
  }

  Widget _buildSubSubcategoryOption(String option) {
    return InkWell(
      onTap: () {
        debugPrint('Tapped on $option');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset(
                'assets/icons/hash.svg',
                    ),
            ),
      Text(
        option,
        style: const TextStyle(color: Colors.grey),)
      ]))
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 4,
          top: 16,
          bottom: _isExpanded ? 0 : null,
          child: const VerticalDivider(
            thickness: 3,
            color: DarkThemePalette.fillColor,
            indent: 12,
            endIndent: 8,
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Column(
                  children: widget.children,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
