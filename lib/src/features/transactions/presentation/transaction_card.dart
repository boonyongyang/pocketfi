import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/user_info.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/tags/application/tag_services.dart';
import 'package:pocketfi/src/features/tags/data/tag_repository.dart';
import 'package:pocketfi/src/features/tags/domain/tag.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class TransactionCard extends ConsumerWidget {
  final Transaction transaction;
  final VoidCallback onTapped;
  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = getCategoryWithCategoryName(transaction.categoryName);
    final transactionType = transaction.type;
    // final userInfo = getUserInfoWithUserId(transaction.userId);
    final allTags = ref.watch(userTagsProvider).value ?? [];
    // final selectedTags = getTagsWithTagNames(
    //   transaction.tags,
    //   allTags.toList(),
    // );
    final selectedTags = transaction.tags;

    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(10.0),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: category.color),
                      child: Center(
                        // heightFactor: 2.0,
                        child: category.icon,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.categoryName.isEmpty
                                ? Strings.transfer
                                : transaction.categoryName,
                            style: const TextStyle(
                              // fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                          Visibility(
                            visible: transaction.walletName != 'Personal',
                            child: FutureBuilder<UserInfo>(
                              future: getUserInfoWithUserId(transaction.userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<UserInfo> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final displayName =
                                      snapshot.data!.displayName;
                                  final shortenedName = displayName.length > 8
                                      // ? '${displayName.substring(0, 8)}...'
                                      ? displayName.substring(0, 9)
                                      : displayName;
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                        size: 14,
                                      ),
                                      Text(
                                        shortenedName.toLowerCase(),
                                        style: const TextStyle(
                                          // fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          if (selectedTags.isNotEmpty)
                            ShowTags(
                              tags: getTagsWithTagNames(selectedTags, allTags),
                            ),
                          // const SizedBox(height: 20.0),

                          Visibility(
                            visible:
                                transaction.description?.isNotEmpty ?? false,
                            child: Text(transaction.description!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                )),
                          ),
                          // ! here cast probelm not sure
                          if (transaction.transactionImage?.thumbnailUrl !=
                              null)
                            Image.network(
                              transaction.transactionImage!.thumbnailUrl!,
                              height: 100,
                              // width: 100,
                              fit: BoxFit.cover,
                            )
                          else
                            const SizedBox(),
                          // Text(transaction.createdAt!.toIso8601String()),
                          // Text(transaction.walletName),
                          Row(
                            children: [
                              Icon(
                                Icons.wallet,
                                color: Colors.grey[600],
                                size: 14,
                              ),
                              Text(
                                transaction.walletName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // format date to dd/mm/yyyy
                          // Text(DateFormat('d MMM').format(transaction.date)),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  // '${transactionType == TransactionType.expense ? TransactionType.expense.symbol : transactionType == TransactionType.income ? TransactionType.income.symbol : TransactionType.transfer.symbol}MYR ${transaction.amount}',
                  '${transactionType.symbol}MYR ${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: transactionType.color,
                    // color: transactionType == TransactionType.expense
                    //     ? TransactionType.expense.color
                    //     : transactionType == TransactionType.income
                    //         ? TransactionType.income.color
                    //         : TransactionType.transfer.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowTags extends StatelessWidget {
  const ShowTags({
    Key? key,
    required this.tags,
  }) : super(key: key);

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    final tagWidgets = tags
        .map((tag) => ActionChip(
              visualDensity:
                  const VisualDensity(horizontal: -4.0, vertical: -4.0),
              label: Text(tag.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mainColor1,
                  )),
              onPressed: () => Fluttertoast.showToast(
                msg: "This is ${tag.name} tag.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: AppColors.mainColor1,
                fontSize: 16.0,
              ),
            ))
        .toList();

    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(
        (tagWidgets.length / 3).ceil(),
        (index) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tagWidgets
              .skip(index * 3)
              .take(3)
              .toList()
              .map((widget) => Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: widget,
                  ))
              .toList(),
        ),
      ),
    );
  }
}


// class ShowTags extends StatelessWidget {
//   const ShowTags({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ActionChip(
//           visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
//           // materialTapTargetSize:
//           //     MaterialTapTargetSize.shrinkWrap,
//           label: const Text('Lunch'),
//           onPressed: () => Fluttertoast.showToast(
//             msg: "Lunch!",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Colors.white,
//             textColor: AppColors.mainColor1,
//             fontSize: 16.0,
//           ),
//         ),
//         const SizedBox(width: 5),
//         const Chip(
//           visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
//           label: Text('Foodpanda'),
//         ),
//       ],
//     );
//   }
// }
