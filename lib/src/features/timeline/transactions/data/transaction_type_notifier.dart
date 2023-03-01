import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/firebase_collection_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/timeline/transactions/domain/transaction_payload.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/domain/file_type.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:pocketfi/src/features/timeline/transactions/image_upload/image_constants.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class TransactionTypeNotifier extends StateNotifier<TransactionType> {
  TransactionTypeNotifier() : super(TransactionType.expense);

  void setTransactionType(int index) {
    state = TransactionType.values[index];
  }
}

class CreateNewTransactionNotifier extends StateNotifier<IsLoading> {
  CreateNewTransactionNotifier() : super(false);

  set isLoading(bool isLoading) => state = isLoading;

  Future<bool> createNewTransaction({
    required UserId userId,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String categoryName,
    required String walletId,
    required File? file,
    String? note,
  }) async {
    isLoading = true;

    // FIXME temp solution to get the *first* wallet id
    // final walletId = await FirebaseFirestore.instance
    //     .collection(FirebaseCollectionName.users)
    //     .doc(userId)
    //     .collection(FirebaseCollectionName.wallets)
    //     .limit(1)
    //     .get()
    //     .then((value) => value.docs.first.id);

    final transactionId = documentIdFromCurrentDate();
    try {
      if (file == null) {
      } else {
        late Uint8List thumbnailUint8List;
        // decode the image
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          // return false;
          throw const CouldNotBuildThumbnailException();
        }

        // create thumbnail
        final thumbnail = img.copyResize(
          fileAsImage,
          // width: Constants.imageThumbnailWidth,
          height: ImageConstants.imageThumbnailHeight,
        );
        // encode the thumbnail
        final thumbnailData = img.encodeJpg(thumbnail);
        // convert the thumbnail to a Uint8List
        thumbnailUint8List = Uint8List.fromList(thumbnailData);

        // calculate the aspect ratio
        final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

        // calculate references
        final fileName = const Uuid().v4();

        // create references to the thumbnail and the image itself
        final thumbnailRef = FirebaseStorage.instance
            .ref()
            .child(userId)
            .child('transactions')
            .child(FirebaseCollectionName.thumbnails)
            .child(fileName);

        // create references to the original file in
        final originalFileRef = FirebaseStorage.instance
            .ref()
            .child(userId)
            .child('transactions')
            .child('images')
            .child(fileName);

        // upload the thumbnail
        final thumbnailUploadTask =
            await thumbnailRef.putData(thumbnailUint8List);
        final thumbnailStorageId = thumbnailUploadTask.ref.name;

        // upload the original file
        final originalFileUploadTask = await originalFileRef.putFile(file);
        final originalFileStorageId = originalFileUploadTask.ref.name;
        final payload = TransactionPayload(
          userId: userId,
          amount: amount,
          date: date,
          type: type,
          categoryName: categoryName,
          // walletName: walletName,
          description: note,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
        );

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.users)
            .doc(userId)
            .collection(FirebaseCollectionName.wallets)
            .doc(walletId)
            .collection(FirebaseCollectionName.transactions)
            .doc(transactionId)
            .set(payload);
        debugPrint('Transaction added $payload');
      }

      return true;
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}
