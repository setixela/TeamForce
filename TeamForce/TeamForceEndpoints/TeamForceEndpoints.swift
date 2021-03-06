//
//  EventsEndpoints.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.06.2022.
//

// Api Endpoints
enum TeamForceEndpoints {
	//
	struct AuthEndpoint: EndpointProtocol {
		//
		let method = HTTPMethod.post

		var endPoint: String { "http://176.99.6.251:8888/auth/" }

        let body: [String : Any]
    }

    struct VerifyEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.post

        var endPoint: String { "http://176.99.6.251:8888/verify/" }

        let body: [String : Any]

        let headers: [String : String]
    }

    struct ProfileEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.get

        var endPoint: String { "http://176.99.6.251:8888/user/profile/" }

        let headers: [String : String]
    }

    struct BalanceEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.get

        var endPoint: String { "http://176.99.6.251:8888/user/balance/" }

        let headers: [String : String]
    }
}
