//
//  TransactSceneWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import Foundation
import ImageIO
import ReactiveWorks
import UIKit

protocol TransactWorksProtocol: TempStorage {
   // api works
   var loadBalance: VoidWork<Balance> { get }
   var searchUser: Work<String, [FoundUser]> { get }
   var sendCoins: VoidWork<(recipient: String, info: SendCoinRequest)> { get }
   var getUserList: Work<Void, [FoundUser]> { get }
   // data works
   var loadTokens: Work<Void, Void> { get }
   // index mapper
   var mapIndexToUser: Work<Int, FoundUser> { get }
   // parsing input
   var coinInputParsing: Work<String, String> { get }
   var reasonInputParsing: Work<String, String> { get }
   //
   var reset: VoidWork<Void> { get }
   //
   var addImage: Work<UIImage, UIImage> { get }
   var removeImage: Work<UIImage, Void> { get }
   //
   var enableTags: Work<Bool, Void> { get }
   var setTags: Work<Set<Tag>, Void> { get }
   var getSelectedTags: Work<Void, Set<Tag>> { get }
   var removeTag: Work<Tag, Void> { get }
}

// Transact Works - (если нужно хранилище временное, то наследуемся от BaseSceneWorks)
final class TransactWorks<Asset: AssetProtocol>: BaseSceneWorks<TransactWorks.Temp, Asset>, TransactWorksProtocol {
   // api works
   private lazy var apiUseCase = Asset.apiUseCase
   private lazy var storageUseCase = Asset.storageUseCase
   // parsing input
   private lazy var coinInputParser = CoinInputCheckerModel()
   private lazy var reasonInputParser = ReasonCheckerModel()

   // storage
   class Temp: InitProtocol {
      required init() {}

      var tokens: (token: String, csrf: String) = ("", "")
      var foundUsers: [FoundUser] = []
      var recipientID = 0
      var recipientUsername = ""
      var isAnonymous = false

      var inputAmountText = ""
      var inputReasonText = ""

      var isCorrectCoinInput = false
      var isCorrectReasonInput = false

      var isTagsEnabled = false
      var tags: Set<Tag> = []

      var images: [UIImage] = []
   }

   // MARK: - Works

   var loadBalance: VoidWork<Balance> { apiUseCase.loadBalance }

   var loadTokens: Work<Void, Void> { .init { [weak self] work in
      self?.storageUseCase.loadBothTokens
         .doAsync()
         .onSuccess {
            Self.store.tokens.token = $0
            Self.store.tokens.csrf = $1
            work.success()
         }.onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getTags: Work<Void, [Tag]> { .init { [weak self] work in
      self?.apiUseCase.getTags
         .doAsync(Self.store.tokens.token)
         .onSuccess {
            print("I got tags \($0)")
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getTagById: Work<Int, Tag> { .init { [weak self] work in
      let request = RequestWithId(token: Self.store.tokens.token,
                                  id: work.unsafeInput)
      self?.apiUseCase.getTagById
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }

   }.retainBy(retainer) }

   var searchUser: Work<String, [FoundUser]> { .init { [weak self] work in
      let request = SearchUserRequest(
         data: work.unsafeInput,
         token: Self.store.tokens.token,
         csrfToken: Self.store.tokens.csrf
      )

      self?.apiUseCase.userSearch
         .doAsync(request)
         .onSuccess { result in
            Self.store.foundUsers = result
            work.success(result: result)
         }.onFail {
            work.fail()
         }
   } }

   var enableTags: Work<Bool, Void> { .init(retainedBy: retainer) { work in
      Self.store.isTagsEnabled = work.unsafeInput
      work.success()
   } }

   var getSelectedTags: Work<Void, Set<Tag>> { .init(retainedBy: retainer) { work in
      work.success(result: Self.store.tags)
   } }

   var setTags: Work<Set<Tag>, Void> { .init(retainedBy: retainer) { work in
      Self.store.tags = work.unsafeInput
      work.success()
   }}

   var removeTag: Work<Tag, Void> { .init(retainedBy: retainer) { work in
      Self.store.tags.remove(work.unsafeInput)
      work.success()
   } }

   var sendCoins: VoidWork<(recipient: String, info: SendCoinRequest)> { .init { [weak self] work in
      var sendImage: UIImage?
      if let image = Self.store.images.first {
         let size = image.size
         let coef = size.width / size.height
         sendImage = image.resized(to: .init(width: 1920, height: 1920 / coef))
      }
      let request = SendCoinRequest(
         token: Self.store.tokens.token,
         csrfToken: Self.store.tokens.csrf,
         recipient: Self.store.recipientID,
         amount: Self.store.inputAmountText,
         reason: Self.store.inputReasonText,
         isAnonymous: Self.store.isAnonymous,
         photo: sendImage,
         tags: Self.store.isTagsEnabled ? Self.store.tags.map { String($0.id) }.joined(separator: " ") : nil
      )

      self?.apiUseCase.sendCoin
         .doAsync(request)
         .onSuccess {
            let tuple = (Self.store.recipientUsername, request)
            work.success(result: tuple)
         }.onFail {
            work.fail()
         }
   } }

   var getUserList: Work<Void, [FoundUser]> { .init { [weak self] work in
      self?.apiUseCase.getUsersList
         .doAsync()
         .onSuccess { result in
            Self.store.foundUsers = result
            work.success(result: result)
         }.onFail {
            work.fail()
         }
   } }

   var mapIndexToUser: Work<Int, FoundUser> { .init { work in

      // TODO: - 2d sections mapping to 1d array error
      let user = Self.store.foundUsers[work.unsafeInput]

      Self.store.recipientUsername = user.name.string
      Self.store.recipientID = user.userId
      work.success(result: user)
   } }

   var coinInputParsing: Work<String, String> { .init { [weak self] work in
      self?.coinInputParser.work
         .retainBy(self?.retainer)
         .doAsync(work.input)
         .onSuccess {
            Self.store.inputAmountText = $0
            Self.store.isCorrectCoinInput = true
            work.success(result: $0)
         }
         .onFail { (text: String) in
            Self.store.inputAmountText = ""
            Self.store.isCorrectCoinInput = false
            work.fail(text)
         }
   } }

   var reasonInputParsing: Work<String, String> { .init { [weak self] work in
      self?.reasonInputParser.work
         .retainBy(self?.retainer)
         .doAsync(work.input)
         .onSuccess {
            Self.store.inputReasonText = $0
            Self.store.isCorrectReasonInput = true
            work.success(result: $0)
         }
         .onFail { (text: String) in
            Self.store.inputReasonText = ""
            Self.store.isCorrectReasonInput = false
            work.fail(text)
         }
   } }

   lazy var reset = VoidWork<Void> { work in
      Self.store.inputAmountText = ""
      Self.store.inputReasonText = ""
      Self.store.isCorrectCoinInput = false
      Self.store.isCorrectReasonInput = false
      Self.store.isAnonymous = false
      Self.store.images = []
      Self.store.isTagsEnabled = false
      Self.store.tags = []
      work.success()
   }

   lazy var anonymousOn = VoidWork<Void> { work in
      Self.store.isAnonymous = true
      work.success()
   }

   lazy var anonymousOff = VoidWork<Void> { work in
      Self.store.isAnonymous = false
      work.success()
   }

   var updateAmount: Work<(String, Bool), Void> { .init { work in
      guard let input = work.input else { return }

      Self.store.inputAmountText = input.0
      Self.store.isCorrectCoinInput = input.1
      work.success()
   }.retainBy(retainer) }

   var updateReason: Work<(String, Bool), Void> { .init { work in
      guard let input = work.input else { return }
      Self.store.inputReasonText = input.0
      Self.store.isCorrectReasonInput = input.1
      work.success()
   }.retainBy(retainer) }

   var isCorrectBothInputs: Work<Void, Void> { .init { work in
      if Self.store.isCorrectReasonInput, Self.store.isCorrectCoinInput {
         work.success()
      } else {
         work.fail()
      }
   }.retainBy(retainer) }
}

extension TransactWorks {
   var addImage: Work<UIImage, UIImage> { .init { work in
      Self.store.images.append(work.unsafeInput)
      work.success(result: work.unsafeInput)
   } }
   var removeImage: Work<UIImage, Void> { .init { work in
      Self.store.images = Self.store.images.filter { $0 !== work.unsafeInput }
      work.success()
   } }
}
