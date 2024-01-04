import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/functions.dart';
import '../../providers/providers.dart';

class TermsAndConditions extends ConsumerStatefulWidget {
  const TermsAndConditions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends ConsumerState<TermsAndConditions> {
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}