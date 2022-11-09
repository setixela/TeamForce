//
//  CommonUseCasePack.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

protocol Retainable {
   var retainer: Retainer { get }
}

// Не забываем Ретайнить ворки

final class ApiUseCase<Asset: AssetProtocol>: InitProtocol, Assetable, WorkBasket, Retainable {
   //

   init() {}

   let retainer = Retainer()

   private var storageUseCase = Asset.storageUseCase

   var safeStringStorage: StringStorageWorker {
      StringStorageWorker(engine: Asset.service.safeStringStorage)
   }

   // MARK: - UseCases

   // Login / Logout
   var login: LoginUseCase.WRK {
      LoginUseCase(
         authApiWorker: loginApiModel
      )
      .retainedWork(retainer)
   }

   var verifyCode: VerifyCodeUseCase.WRK {
      VerifyCodeUseCase(
         verifyCodeApiWorker: verifyCodeApiWorker
      )
      .retainedWork(retainer)
   }

   var logout: LogoutUseCase.WRK {
      LogoutUseCase(
         loadToken: storageUseCase.loadToken,
         logoutApiModel: logoutApiModel
      )
      .retainedWork(retainer)
   }

   // Profile

   var loadProfile: LoadProfileUseCase.WRK {
      LoadProfileUseCase(
         loadToken: storageUseCase.loadToken,
         userProfileApiModel: userProfileApiModel
      )
      .retainedWork(retainer)
   }

   var loadBalance: LoadBalanceUseCase.WRK {
      LoadBalanceUseCase(
         loadToken: storageUseCase.loadToken,
         balanceApiModel: balanceApiModel
      )
      .retainedWork(retainer)
   }

   var userSearch: UserSearchUseCase.WRK {
      UserSearchUseCase(searchUserApiModel: searchUserApiWorker)
         .retainedWork(retainer)
   }

   var getTransactions: GetTransactionsUseCase.WRK {
      GetTransactionsUseCase(
         safeStringStorage: safeStringStorage,
         getTransactionsApiWorker: getTransactionsApiWorker
      )
      .retainedWork(retainer)
   }

   var sendCoin: SendCoinUseCase.WRK {
      SendCoinUseCase(
         sendCoinApiModel: sendCoinApiWorker
      )
      .retainedWork(retainer)
   }

   var getTransactionById: GetTransactionByIdUseCase.WRK {
      GetTransactionByIdUseCase(
         safeStringStorage: safeStringStorage,
         getTransactionByIdApiModel: getTransactionByIdApiWorker
      )
      .retainedWork(retainer)
   }

   var getTransactionsByPeriod: GetTransactionsByPeriodUseCase.WRK {
      GetTransactionsByPeriodUseCase(
         safeStringStorage: safeStringStorage,
         getTransactionsByPeriodApiModel: getTransactionsByPeriodApiWorker
      )
      .retainedWork(retainer)
   }

   var cancelTransactionById: CancelTransactionByIdUseCase.WRK {
      CancelTransactionByIdUseCase(
         safeStringStorage: safeStringStorage,
         cancelTransactionByIdApiWorker: cancelTransactionByIdApiWorker
      )
      .retainedWork(retainer)
   }

   var getUsersList: GetUsersListUseCase.WRK {
      GetUsersListUseCase(
         safeStringStorage: safeStringStorage,
         getUsersListApiWorker: getUsersListApiWorker
      )
      .retainedWork(retainer)
   }

   var getFeed: GetFeedUseCase.WRK {
      GetFeedUseCase(
         safeStringStorage: safeStringStorage,
         getFeedsApiWorker: getFeedsApiWorker
      )
      .retainedWork(retainer)
   }

   var getPeriods: GetPeriodsUseCase.WRK {
      GetPeriodsUseCase(
         safeStringStorage: safeStringStorage,
         getPeriodsApiWorker: getPeriodsApiWorker
      )
      .retainedWork(retainer)
   }

   var getStatByPeriodId: GetStatByPeriodIdUseCase.WRK {
      GetStatByPeriodIdUseCase(
         safeStringStorage: safeStringStorage,
         getStatByPeriodIdApiWorker: getStatByPeriodIdApiWorker
      )
      .retainedWork(retainer)
   }

   var getCurrentPeriod: GetCurrentPeriodUseCase.WRK {
      GetCurrentPeriodUseCase(
         safeStringStorage: safeStringStorage,
         getCurrentPeriodApiWorker: getCurrentPeriodApiWorker
      )
      .retainedWork(retainer)
   }

   var getPeriodByDate: GetPeriodByDateUseCase.WRK {
      GetPeriodByDateUseCase(
         safeStringStorage: safeStringStorage,
         getPeriodByDateApiWorker: getPeriodByDateApiWorker
      )
      .retainedWork(retainer)
   }

   var getPeriodsFromDate: GetPeriodsFromDateUseCase.WRK {
      GetPeriodsFromDateUseCase(
         safeStringStorage: safeStringStorage,
         getPeriodsFromDateApiWorker: getPeriodsFromDateApiWorker
      )
      .retainedWork(retainer)
   }

   var updateProfileImage: UpdateProfileImageUseCase.WRK {
      UpdateProfileImageUseCase(
         safeStringStorage: safeStringStorage,
         updateProfileImageApiWorker: updateProfileImageApiWorker
      )
      .retainedWork(retainer)
   }
   
   var updateContact: UpdateContactUseCase.WRK {
      UpdateContactUseCase(
         safeStringStorage: safeStringStorage,
         updateContactApiWorker: updateContactApiWorker
      )
      .retainedWork(retainer)
   }
   
   var createContact: CreateContactUseCase.WRK {
      CreateContactUseCase(
         safeStringStorage: safeStringStorage,
         createContactApiWorker: createContactApiWorker
      )
      .retainedWork(retainer)
   }
   
   var updateProfile: UpdateProfileUseCase.WRK {
      UpdateProfileUseCase(
         safeStringStorage: safeStringStorage,
         updateProfileApiWorker: updateProfileApiWorker
      )
      .retainedWork(retainer)
   }
   
   var createFewContacts: CreateFewContactsUseCase.WRK {
      CreateFewContactsUseCase(
         safeStringStorage: safeStringStorage,
         createFewContactsApiWorker: createFewContactsApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getTags: GetTagsUseCase.WRK {
      GetTagsUseCase(
         getTagsApiWorker: getTagsApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getTagById: GetTagByIdUseCase.WRK {
      GetTagByIdUseCase(
         getTagByIdApiWorker: getTagByIdApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getProfileById: GetProfileByIdUseCase.WRK {
      GetProfileByIdUseCase(
         safeStringStorage: safeStringStorage,
         getProfileByIdApiWorker: getProfileByIdApiWorker
      )
      .retainedWork(retainer)
   }
   
   var pressLike: PressLikeUseCase.WRK {
      PressLikeUseCase(
         safeStringStorage: safeStringStorage,
         pressLikeApiWorker: pressLikeApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getLikesCommentsStat: GetLikesCommentsStatUseCase.WRK {
      GetLikesCommentsStatUseCase(
         safeStringStorage: safeStringStorage,
         getLikesCommentsStatApiWorker: getLikesCommentsStatApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getComments: GetCommentsUseCase.WRK {
      GetCommentsUseCase(
         safeStringStorage: safeStringStorage,
         getCommentsApiWorker: getCommentsApiWorker
      )
      .retainedWork(retainer)
   }
   
   var createComment: CreateCommentUseCase.WRK {
      CreateCommentUseCase(
         safeStringStorage: safeStringStorage,
         createCommentApiWorker: createCommentApiWorker
      )
      .retainedWork(retainer)
   }
   
   var updateComment: UpdateCommentUseCase.WRK {
      UpdateCommentUseCase(
         safeStringStorage: safeStringStorage,
         updateCommentApiWorker: updateCommentApiWorker
      )
      .retainedWork(retainer)
   }
   
   var deleteComment: DeleteCommentUseCase.WRK {
      DeleteCommentUseCase(
         safeStringStorage: safeStringStorage,
         deleteCommentApiWorker: deleteCommentApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getLikesByTransaction: GetLikesByTransactionUseCase.WRK {
      GetLikesByTransactionUseCase(
         safeStringStorage: safeStringStorage,
         getLikesByTransactionApiWorker: getLikesByTransactionApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getChanllenges: GetChallengesUseCase.WRK {
      GetChallengesUseCase(
         safeStringStorage: safeStringStorage,
         getChallengesApiWorker: getChallengesApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetChallengeById: GetChallengeByIdUseCase.WRK {
      GetChallengeByIdUseCase(
         safeStringStorage: safeStringStorage,
         getChallengeByIdApiWorker: getChallengeByIdApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetChallengeContenders: GetChallengeContendersUseCase.WRK {
      GetChallengeContendersUseCase(
         safeStringStorage: safeStringStorage,
         getChallengeContendersApiWorker: getChallengeContendersApiWorker
      )
      .retainedWork(retainer)
   }

   var createChallenge: CreateChallengeUseCase.WRK {
      CreateChallengeUseCase(
         safeStringStorage: safeStringStorage,
         createChallengeApiWorker: createChallengeApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetChallengeWinners: GetChallengeWinnersUseCase.WRK {
      GetChallengeWinnersUseCase(
         safeStringStorage: safeStringStorage,
         getChallengeWinnersApiWorker: getChallengeWinnersApiWorker
      )
      .retainedWork(retainer)
   }
   
   var CreateChallengeReport: CreateChallengeReportUseCase.WRK {
      CreateChallengeReportUseCase(
         safeStringStorage: safeStringStorage,
         createChallengeReportApiWorker: createChallengeReportApiWorker
      )
      .retainedWork(retainer)
   }
   
   var CheckChallengeReport: CheckChallengeReportUseCase.WRK {
      CheckChallengeReportUseCase(
         safeStringStorage: safeStringStorage,
         checkChallengeReportApiWorker: checkChallengeReportApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetSendCoinSettings: GetSendCoinSettingsUseCase.WRK {
      GetSendCoinSettingsUseCase(
         getSendCoinSettingsApiWorker: getSendCoinSettingsApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetChallengeResult: GetChallengeResultUseCase.WRK {
      GetChallengeResultUseCase(
         safeStringStorage: safeStringStorage,
         getChallengeResultApiWorker: getChallengeResultApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetChallengeWinnersReports: GetChallWinnersReportsUseCase.WRK {
      GetChallWinnersReportsUseCase(
         safeStringStorage: safeStringStorage,
         getChallWinnersReportsApiWorker: getChallWinnersReportsApiWorker
      )
      .retainedWork(retainer)
   }
   
   var GetChallengeReport: GetChallengeReportUseCase.WRK {
      GetChallengeReportUseCase(
         safeStringStorage: safeStringStorage,
         getChallengeReportApiWorker: getChallengeReportApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getEvents: GetEventsUseCase.WRK {
      GetEventsUseCase(
         safeStringStorage: safeStringStorage,
         getEventsApiWorker: getEventsApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getEventsTransact: GetEventsTransactUseCase.WRK {
      GetEventsTransactUseCase(
         safeStringStorage: safeStringStorage,
         getEventsTransactApiWorker: getEventsTransactApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getEventsWinners: GetEventsWinnersUseCase.WRK {
      GetEventsWinnersUseCase(
         safeStringStorage: safeStringStorage,
         getEventsWinnersApiWorker: getEventsWinnersApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getEventsChall: GetEventsChallUseCase.WRK {
      GetEventsChallUseCase(
         safeStringStorage: safeStringStorage,
         getEventsChallApiWorker: getEventsChallApiWorker
      )
      .retainedWork(retainer)
   }
   
   var getEventsTransactById: GetEventsTransactByIdUseCase.WRK {
      GetEventsTransactByIdUseCase(
         safeStringStorage: safeStringStorage,
         getEventsTransactByIdApiModel: getEventsTransactByIdApiWorker
      )
      .retainedWork(retainer)
   }
   
   var setFcmToken: SetFcmTokenUseCase.WRK {
      SetFcmTokenUseCase(
         safeStringStorage: safeStringStorage,
         setFcmTokenApiWorker: setFcmTokenApiWorker
      )
      .retainedWork(retainer)
   }
   
   
   // MARK: - Dependencies

   private var userProfileApiModel: ProfileApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var loginApiModel: AuthApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var verifyCodeApiWorker: VerifyApiModel { .init(apiEngine: Asset.service.apiEngine) }
   private var logoutApiModel: LogoutApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var balanceApiModel: GetBalanceApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var searchUserApiWorker: SearchUserApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var sendCoinApiWorker: SendCoinApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTransactionsApiWorker: GetTransactionsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTransactionByIdApiWorker: GetTransactionByIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getUsersListApiWorker: GetUsersListApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getFeedsApiWorker: GetFeedsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getPeriodsApiWorker: GetPeriodsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getStatByPeriodIdApiWorker: GetStatByPeriodIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTransactionsByPeriodApiWorker: GetTransactionsByPeriodApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var cancelTransactionByIdApiWorker: CancelTransactionByIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getCurrentPeriodApiWorker: GetCurrentPeriodApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getPeriodByDateApiWorker: GetPeriodByDateApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getPeriodsFromDateApiWorker: GetPeriodsFromDateApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var updateProfileImageApiWorker: UpdateProfileImageApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var updateContactApiWorker: UpdateContactApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var createContactApiWorker: CreateContactApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var updateProfileApiWorker: UpdateProfileApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var createFewContactsApiWorker: CreateFewContactsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getTagsApiWorker: GetTagsApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var getTagByIdApiWorker: GetTagByIdApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var getProfileByIdApiWorker: GetProfileByIdApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var pressLikeApiWorker: PressLikeApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var getLikesCommentsStatApiWorker: GetLikesCommentsStatApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getCommentsApiWorker: GetCommentsApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var createCommentApiWorker: CreateCommentApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var updateCommentApiWorker: UpdateCommentApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var deleteCommentApiWorker: DeleteCommentApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var getLikesByTransactionApiWorker: GetLikesByTransactionApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getChallengesApiWorker: GetChallengesApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var getChallengeByIdApiWorker: GetChallengeByIdApiWorker{ .init(apiEngine:
       Asset.service.apiEngine) }
   private var getChallengeContendersApiWorker: GetChallengeContendersApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var createChallengeApiWorker: CreateChallengeApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
   private var getChallengeWinnersApiWorker: GetChallengeWinnersApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var createChallengeReportApiWorker: CreateChallengeReportApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var checkChallengeReportApiWorker: CheckChallengeReportApiWorker {
       .init(apiEngine: Asset.service.apiEngine) }
   private var getSendCoinSettingsApiWorker: GetSendCoinSettingsApiWorker {
       .init(apiEngine: Asset.service.apiEngine) }
   private var getChallengeResultApiWorker: GetChallengeResultApiWorker {
       .init(apiEngine: Asset.service.apiEngine) }
   private var getChallWinnersReportsApiWorker: GetChallWinnersReportsApiWorker {
       .init(apiEngine: Asset.service.apiEngine) }
   private var getChallengeReportApiWorker: GetChallengeReportApiWorker {
       .init(apiEngine: Asset.service.apiEngine) }
   private var getEventsApiWorker: GetEventsApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getEventsTransactApiWorker: GetEventsTransactApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getEventsWinnersApiWorker: GetEventsWinnersApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getEventsChallApiWorker: GetEventsChallApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var getEventsTransactByIdApiWorker: GetEventsTransactByIdApiWorker { .init(apiEngine: Asset.service.apiEngine) }
   private var setFcmTokenApiWorker: SetFcmTokenApiWorker { .init(apiEngine:
       Asset.service.apiEngine) }
}
