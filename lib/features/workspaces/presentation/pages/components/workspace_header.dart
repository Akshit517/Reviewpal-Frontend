import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/presentation/widgets/effects/shimmer_loading_effect.dart';
import '../../../../../core/presentation/widgets/pillbox/pillbox.dart';
import '../../../domain/entities/workspace/workspace_entity.dart';
import '../../blocs/workspace/single_member/single_workspace_member_cubit.dart';
import 'settings_bottomsheet.dart';

class WorkspaceHeader extends StatelessWidget {
  final Workspace workspace;
  final bool isDesktop;

  const WorkspaceHeader({
    super.key,
    required this.isDesktop,
    required this.workspace,
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
            child: Row(
              children: [
                Flexible(
                  child: Tooltip(
                    message: workspace.name,
                    child: Text(
                      workspace.name,
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: BlocBuilder<SingleWorkspaceMemberCubit,
                      SingleWorkspaceMemberState>(
                    builder: (context, state) {
                      if (state.isLoading == false &&
                          state.isSuccess == false) {
                        return const PillBox(text: "ERR");
                      } else if (state.isLoading == false &&
                          state.isSuccess == true) {
                        String role = state.member!.role;
                        role = (role == "workspace_admin") ? "ADMIN" : "MEMBER";
                        return PillBox(
                          text: role,
                          backgroundColor: (role == 'ADMIN')
                              ? const Color.fromARGB(255, 105, 67, 67)
                              : const Color.fromARGB(255, 52, 74, 44),
                          textColor: (role == 'ADMIN')
                              ? const Color.fromARGB(255, 255, 184, 184)
                              : const Color.fromARGB(255, 217, 253, 173),
                        );
                      } else {
                        return const ShimmerLoading(
                            isLoading: true, child: PillBox(text: ""));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SettingsBottomsheet(workspace: workspace),
              );
            },
            icon: SvgPicture.asset("assets/icons/settings.svg"),
          ),
        ],
      ),
    );
  }
}
