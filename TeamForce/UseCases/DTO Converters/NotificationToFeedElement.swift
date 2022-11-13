//
//  NotificationToFeedElement.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.11.2022.
//

struct NotificationToFeedElement: Converter {
   static func convert(_ input: Notification) -> FeedElement? {
      let notify = input
      guard
         let transactData = input.transactionData
      else { return nil }

      let eventTransaction = EventTransaction(
         id: transactData.transactionId,
         photo: transactData.recipientPhoto,
         reason: nil,
         amount: transactData.amount.int,
         updatedAt: notify.updatedAt,
         userLiked: false,
         senderId: transactData.senderId,
         senderFirstName: nil,
         senderSurname: nil,
         senderPhoto: transactData.senderPhoto,
         senderTgName: transactData.senderTgName,
         recipientId: transactData.recipientId,
         recipientFirstName: nil,
         recipientSurname: nil,
         recipientPhoto: transactData.recipientPhoto,
         recipientTgName: transactData.recipientTgName,
         isAnonymous: nil,
         tags: nil
      )

      return FeedElement(
         id: transactData.transactionId,
         time: notify.createdAt,
         eventTypeId: 0,
         eventObjectId: nil,
         eventRecordId: nil,
         objectSelector: nil,
         likesAmount: 0,
         commentsAmount: 0,
         transaction: eventTransaction
      )
   }
}
