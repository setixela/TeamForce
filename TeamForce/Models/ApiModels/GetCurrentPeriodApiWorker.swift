//
//  GetCurrentPeriodApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//

import ReactiveWorks

final class GetCurrentPeriodApiWorker: BaseApiWorker<String, Period> {
    override func doAsync(work: Wrk) {
        apiEngine?
            .process(endpoint: TeamForceEndpoints.GetCurrentPeriod(headers: [
                "Authorization": work.input.string,
            ]))
            .done { result in
                let decoder = DataToDecodableParser()

                guard
                    let data = result.data,
                    let period: Period = decoder.parse(data)
                else {
                    work.fail()
                    return
                }

                work.success(result: period)
            }
            .catch { _ in
                work.fail()
            }
    }
}
