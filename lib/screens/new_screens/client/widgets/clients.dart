import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../providers/provider.client.dart';
import 'each_client.dart';

class ClientsWidget extends ConsumerStatefulWidget {
  final double width;
  const ClientsWidget({
    super.key,
    required this.width,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientsWidgetState();
}

class _ClientsWidgetState extends ConsumerState<ClientsWidget> {
  @override
  Widget build(BuildContext context) {
    final clientList = ref.watch(clientListProvider);
    return Column(
      children: List.generate(
        clientList.length,
        (index) => EachClient(
          width: widget.width,
          name: clientList[index].name,
          phoneNumber: clientList[index].phoneNumber,
          email: clientList[index].email,
          onTap: () {
            navigateNamed(context, AppRoutes.clientDetailsRoutes, clientList[index].id.toString());
          },
        ).animate().fade(delay: 400.ms),
      ),
    );
  }
}
