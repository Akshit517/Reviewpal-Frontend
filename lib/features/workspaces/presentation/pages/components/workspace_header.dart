import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkspaceHeader extends StatelessWidget {
  final String name;
  final bool isDesktop;

  const WorkspaceHeader({
    super.key,
    required this.name,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/icons/settings.svg"),
          ),
        ],
      ),
    );
  }
}
