//
//  EventsEndpoints.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.06.2022.
//

// Api Endpoints
enum TeamForceEndpoints {
    private static var urlBase: String { "http://176.99.6.251:8888" }
    //
    struct AuthEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.post

        var endPoint: String { urlBase + "/auth/" }

        let body: [String: Any]
    }

    struct VerifyEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.post

        var endPoint: String { urlBase + "/verify/" }

        let body: [String: Any]

        let headers: [String: String]
    }

    struct ProfileEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.get

        var endPoint: String { urlBase + "/user/profile/" }

        let headers: [String: String]
    }

    struct BalanceEndpoint: EndpointProtocol {
        //
        let method = HTTPMethod.get

        var endPoint: String { urlBase + "/user/balance/" }

        let headers: [String: String]
    }

    struct SearchUser: EndpointProtocol {
        //
        let method = HTTPMethod.post

        var endPoint: String { urlBase + "/search-user/" }

        let body: [String: Any]

        let headers: [String: String]
    }
    
    struct Logout: EndpointProtocol {
        //
        let method = HTTPMethod.get
        
        var endPoint: String { urlBase + "/logout/" }
    }
    
    struct SendCoin: EndpointProtocol {
        //
        let method = HTTPMethod.post
        
        var endPoint: String { urlBase + "/send-coins/" }
        
        let body: [String : Any]
        
        let headers: [String : String]
        
    }
    
    struct GetTransactions: EndpointProtocol {
        //
        let method = HTTPMethod.get
        
        var endPoint: String { urlBase + "/user/transactions/" }
        
        let headers: [String : String]
    }
    
    struct GetTransactionById: EndpointProtocol {
        //
        let method = HTTPMethod.get

        var endPoint: String = urlBase + "/user/transactions/"

        var headers: [String : String]
        
        init(id: String, headers: [String : String]) {
            endPoint = endPoint + id + "/"
            self.headers = headers
        }
    }
   
   struct UsersList: EndpointProtocol {
      //
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/users-list/"}
      
      let body: [String : Any]
      
      let headers: [String : String]
   }
   
   struct Feed: EndpointProtocol {
      //
      let method = HTTPMethod.get
      
      var endPoint: String { urlBase + "/feed/" }
      
      let headers: [String : String]
   }
   
   struct Periods: EndpointProtocol {
      //
      let method = HTTPMethod.get
      
      var endPoint: String { urlBase + "/periods/" }
      
      let headers: [String : String]
   }
   
   struct StatPeriodById: EndpointProtocol {
      //
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/user/stat/"
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
}
