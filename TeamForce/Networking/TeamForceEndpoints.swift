//
//  EventsEndpoints.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.06.2022.
//

import Foundation

// Api Endpoints
enum TeamForceEndpoints {

   static var urlBase: String { Config.urlBase }
   static var urlMediaBase: String { urlBase + "/media/" }

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
      
      var endPoint: String = urlBase + "/feed/"
      
      let headers: [String : String]
      
      init(offset: Int, limit: Int, headers: [String : String]) {
         endPoint = endPoint + "?offset=" + String(offset) + "&limit=" + String(limit)
         self.headers = headers
      }
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
   
   struct GetTransactionByPeriod: EndpointProtocol {
       //
       let method = HTTPMethod.get

       var endPoint: String = urlBase + "/user/transactions-by-period/"

       var headers: [String : String]
       
       init(id: String, headers: [String : String]) {
           endPoint = endPoint + id + "/"
           self.headers = headers
       }
   }
   
   struct CancelTransaction: EndpointProtocol {
      //
      let method = HTTPMethod.put
      
      var endPoint: String = urlBase + "/cancel-transaction/"
      
      var headers: [String : String]
      
      var body: [String : Any]
      
      init(id: String, headers: [String : String], body: [String : Any]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
         self.body = body
      }
   }
   
   struct GetCurrentPeriod: EndpointProtocol {
      //
      let method = HTTPMethod.get
      
      var endPoint: String { urlBase + "/get-current-period/" }
      
      let headers: [String : String]
   }
   
   struct GetPeriodByDate: EndpointProtocol {
      //
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/get-period-by-date/"}
      
      let body: [String : Any]
      
      let headers: [String : String]
   }
   
   struct GetPeriodsFromDate: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/get-periods/"}
      
      let body: [String : Any]
      
      let headers: [String : String]
   }
   
   struct UpdateProfileImage: EndpointProtocol {
      let method = HTTPMethod.put
      
      var endPoint: String = urlBase + "/update-profile-image/"
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct UpdateProfile: EndpointProtocol {
      let method = HTTPMethod.put
      
      var endPoint: String = urlBase + "/update-profile-by-user/"
      
      var body: [String : Any]
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String], body: [String : Any]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
         self.body = body
      }
   }
   
   struct UpdateContact: EndpointProtocol {
      let method = HTTPMethod.patch
      
      var endPoint: String = urlBase + "/update-contact-by-user/"
      
      var body: [String : Any]
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String], body: [String : Any]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
         self.body = body
      }
   }
   
   struct CreateContact: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/create-contact-by-user/" }
      
      let body: [String : Any]
      
      let headers: [String : String]
   }
   
   struct CreateFewContacts: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/create-few-contacts/" }
      
      let jsonData: Data?
      
      let headers: [String : String]
   }
   
   struct Tags: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String { urlBase + "/tags/" }
      
      let headers: [String : String]
   }
   
   struct TagById: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/tags/"
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct ProfileById: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/profile/"
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct PressLike: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/press-like/" }
      
      var headers: [String : String]
      
      var body: [String : Any]
   }
   
   struct GetTransactionStatistics: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/get-transaction-statistics/" }
      
      var headers: [String : String]
      
      var body: [String : Any]
   }
   
   struct GetComments: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/get-comments/" }
      
      var headers: [String : String]
      
      let jsonData: Data?
   }
   
   struct CreateComment: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/create-comment/" }
      
      var headers: [String : String]
      
      var body: [String : Any]
   }
   
   struct UpdateComment: EndpointProtocol {
      let method = HTTPMethod.put
      
      var endPoint: String = urlBase + "/update-comment/"
      
      var body: [String : Any]
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String], body: [String : Any]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
         self.body = body
      }
   }
   
   struct DeleteComment: EndpointProtocol {
      let method = HTTPMethod.delete
      
      var endPoint: String = urlBase + "/delete-comment/"
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         self.endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct GetLikesByTransaction: EndpointProtocol {
      let method = HTTPMethod.post

      var endPoint: String { urlBase + "/get-likes-by-transaction/" }

      var headers: [String: String]

      let jsonData: Data?
   }
   
   struct GetChallenges: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String { urlBase + "/challenges/" }
      
      var headers: [String : String]
   }
   
   struct GetChallengeById: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/challenges/"
      
      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct GetChallengeContenders: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/challenge-contenders/"
      
      let headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct CreateChallenge: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/create-challenge/" }
      
      let headers: [String : String]
      
      var body: [String : Any]
   }
   
   struct ChallengeWinners: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/challenge-winners/"
      
      let headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct CreateChallengeReport: EndpointProtocol {
      let method = HTTPMethod.post
      
      var endPoint: String { urlBase + "/create-challenge-report/" }
      
      let headers: [String : String]
      
      let body: [String : Any]
   }
   
   struct CheckChallengeReport: EndpointProtocol {
      let method = HTTPMethod.put
      
      var endPoint: String = urlBase + "/check-challenge-report/"
      
      let headers: [String : String]
      
      let jsonData: Data?
      
      init(id: String, headers: [String : String], jsonData: Data?) {
         endPoint = endPoint + id + "/"
         self.headers = headers
         self.jsonData = jsonData
      }
   }
   
   struct SendCoinSettings: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String { urlBase + "/send-coins-settings/" }
      
      let headers: [String : String]
   }
   
   struct ChallengeResult: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/challenge-result/"
      
      let headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         self.endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct ChallengeWinnersReports: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/challenge-winners-reports/"
      
      let headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct ChallengeReport: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/challenge-report/"
      
      let headers: [String : String]
      
      init(id: String, headers: [String : String]) {
         endPoint = endPoint + id + "/"
         self.headers = headers
      }
   }
   
   struct Events: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/events/"
      
      let headers: [String : String]
      
      init(offset: Int, limit: Int, headers: [String : String]) {
         endPoint = endPoint + "?offset=" + String(offset) + "&limit=" + String(limit)
         self.headers = headers
      }
   }
   
   struct EventsTransactions: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/events/transactions/"
      
      let headers: [String : String]
      
      init(offset: Int, limit: Int, headers: [String : String]) {
         endPoint = endPoint + "?offset=" + String(offset) + "&limit=" + String(limit)
         self.headers = headers
      }
   }
   
   struct EventsWinners: EndpointProtocol {
      let method = HTTPMethod.get
   
      var endPoint: String = urlBase + "/events/winners/"
      
      let headers: [String : String]
      
      init(offset: Int, limit: Int, headers: [String : String]) {
         endPoint = endPoint + "?offset=" + String(offset) + "&limit=" + String(limit)
         self.headers = headers
      }
   }
   
   struct EventsChallenges: EndpointProtocol {
      let method = HTTPMethod.get
   
      var endPoint: String = urlBase + "/events/challenges/"
      
      let headers: [String : String]
      
      init(offset: Int, limit: Int, headers: [String : String]) {
         endPoint = endPoint + "?offset=" + String(offset) + "&limit=" + String(limit)
         self.headers = headers
      }
   }
   
   struct EventsTransactById: EndpointProtocol {
      let method = HTTPMethod.get
      
      var endPoint: String = urlBase + "/events/transactions/"

      var headers: [String : String]
      
      init(id: String, headers: [String : String]) {
          endPoint = endPoint + id + "/"
          self.headers = headers
      }
   }
}
