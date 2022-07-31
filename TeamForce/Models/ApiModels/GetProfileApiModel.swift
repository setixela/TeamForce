//
//  GetProfileApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation

final class GetProfileApiModel: BaseApiAsyncModel<TokenRequest, UserData> {
    override func doAsync(work: Work<TokenRequest, UserData>) {
        guard let request = work.input else { return }

        apiEngine?
            .process(endpoint: TeamForceEndpoints.ProfileEndpoint(headers: [
                "Authorization": request.token,
            ]))
            .done { result in
                let decoder = DataToDecodableParser()

                guard
                    let data = result.data,
                    let user: UserData = decoder.parse(data)
                else {
                    work.fail(())
                    return
                }
                work.success(result: user)
            }
            .catch { error in
                work.fail(())
            }
    }
}
