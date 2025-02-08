import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/bills/application/bill_services.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class SelectBillTab extends ConsumerStatefulWidget {
  const SelectBillTab({super.key});

  @override
  SelectBillTabState createState() => SelectBillTabState();
}

class SelectBillTabState extends ConsumerState<SelectBillTab>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get isSelectedBillNull =>
      (ref.watch(selectedBillProvider)?.dueDate == null);

  @override
  Widget build(BuildContext context) {
    // final tabIndex = ref.watch(selectedBillProvider)?.status ?? ref.watch(billTabIndexProvider);

    return Transform.scale(
      scale: 0.9,
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Consumer(
                  builder: (context, watch, child) {
                    return TabBar(
                      splashFactory: NoSplash.splashFactory,
                      indicator: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: AppColors.mainColor1,
                      ),
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.mainColor1,
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'History'),
                      ],
                      onTap: (index) {
                        // ref.read(billTabIndexProvider.notifier).setBillStatus(index);
                        HapticFeedbackService.lightImpact();

                        ref.read(billTabIndexProvider.notifier).state = index;
                        debugPrint('tab index: $index');
                      },
                      controller: _tabController,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
