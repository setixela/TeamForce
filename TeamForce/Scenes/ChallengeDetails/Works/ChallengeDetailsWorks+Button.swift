//
//  ChallengeDetailsWorks+Button.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.11.2022.
//

import Foundation

import ReactiveWorks

extension ChallengeDetailsWorks {
   var filterButtonWork: Work<Button7Event, Button7Result> { .init { [weak self] work in
      guard let self, let button = work.input else { return }

      // TODO: - В документации не забыть написать про возможную ошибку в очереди асинк синк
      // ^ я забыл о чем речь )
      switch button {
      case .didTapButton1:
         self.getChallengeById
            .doCancel(
               self.getChallengeResult,
               self.getChallengeContenders,
               self.getChallengeWinnersReports,
               self.getComments,
               self.getLikesByChallenge
            )
            .doAsync()
            .onSuccess { work.success(.result1($0)) }
            .onFail { work.fail() }

      case .didTapButton2:
         self.getChallengeResult
            .doCancel(
               self.getChallengeById,
               self.getChallengeContenders,
               self.getChallengeWinnersReports,
               self.getComments,
               self.getLikesByChallenge
            )
            .doAsync()
            .onSuccess { work.success(.result2($0)) }
            .onFail { work.fail() }

      case .didTapButton3:
//         self.amIOwnerCheck
//            .doCancel(
//               self.getChallengeById,
//               self.getChallengeResult,
//               self.getChallengeWinnersReports,
//               self.getComments,
//               self.getLikesByChallenge
//            )
//            .doAsync()
//            .onSuccess {
               self.getChallengeContenders
                  .doAsync()
                  .onSuccess { work.success(.result3($0)) }
                  .onFail { work.fail() }
//            }
//            .onFail { work.fail() }

      case .didTapButton4:
         self.getChallengeWinnersReports
            .doCancel(
               self.getChallengeById,
               self.getChallengeResult,
               self.getChallengeContenders,
               self.getComments,
               self.getLikesByChallenge
            )
            .doAsync()
            .onSuccess { work.success(.result4($0)) }
            .onFail { work.fail() }

      case .didTapButton5:
         self.getComments
            .doCancel(
               self.getChallengeById,
               self.getChallengeResult,
               self.getChallengeWinnersReports,
               self.getChallengeContenders,
               self.getLikesByChallenge
            )
            .doAsync()
            .onSuccess { work.success(.result5($0)) }
            .onFail { work.fail() }
      case .didTapButton6:
         break
      case .didTapButton7:
         self.getLikesByChallenge
            .doCancel(
               self.getChallengeById,
               self.getChallengeResult,
               self.getChallengeWinnersReports,
               self.getChallengeContenders,
               self.getComments
            )
            .doAsync()
            .onSuccess { work.success(.result7($0)) }
            .onFail { work.fail() }
      }
   }.retainBy(retainer) }
}
