import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/data/temp_user_provider.dart';

class ShareWalletSheet extends ConsumerStatefulWidget {
  const ShareWalletSheet({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShareWalletSheetState();
}

class _ShareWalletSheetState extends ConsumerState<ShareWalletSheet> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(userIdProvider);
    final userList = ref.watch(getTempDataProvider).value?.toList();
    if (userList == null) return Container();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.transparent,
                  ),
                  onPressed: null,
                ),
              ),
              const Expanded(
                child: Text(
                  'Users',
                  style: TextStyle(
                    color: AppColors.mainColor1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(userList.length, (index) {
                  final eachUser = userList[index];
                  return Consumer(
                    builder: (context, ref, child) {
                      return CheckboxListTile(
                        tristate: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(eachUser.displayName),
                        subtitle: Text(eachUser.email ?? ""),
                        onChanged: (bool? newValue) {
                          newValue ??= false;
                          ref.watch(tempDataProvider.notifier).updateIsChecked(
                                eachUser,
                                newValue,
                                currentUserId!,
                              );
                        },
                        value: eachUser.isChecked,
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShareWalletTiles extends StatelessWidget {
  final CollaboratorsInfo user;
  const ShareWalletTiles({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(title: Text(user.displayName)),
    );
  }
}
