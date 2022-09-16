//
//  CreateContactUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.09.2022.
//
import ReactiveWorks

struct CreateContactUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let createContactApiWorker: CreateContactApiWorker

   var work: Work<CreateContactRequest, Void> {
      Work<CreateContactRequest, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = CreateContactRequest(token: $0,
                                                  contactId: input.contactId,
                                                  contactType: input.contactType,
                                                  profile: input.profile)
               return request
            }
            .doNext(worker: createContactApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
