//
//  TeamForceTests.swift
//  TeamForceTests
//
//  Created by Aleksandr Solovyev on 17.06.2022.
//

import ReactiveWorks
@testable import TeamForce
import XCTest

class WorksTests2: XCTestCase {
   private let retainer = Retainer()

   let works = TransactWorks<ProductionAsset>()

   var failWork: Work<String, String> { Work<String, String> {
      $0.fail($0.input)
   }}

   var stringWork: Work<String, String> { Work<String, String> { work in
      work.success(result: work.unsafeInput)
   }}

   var stringWork2: Work<String, String> { Work<String, String> { work in
      work.success(result: work.unsafeInput)
   }}

   enum Res {
      case fail
      case success
      case loadSuccess

      case recovered
      case recoverfailed

      case mapped
      case none

      case failworkSucces
      case failworkError

      case inputagain

      case stringworksuccess
      case stringworkerror
   }

   func testSaveLoadWork() {
      var result = Res.none
      var resultString = ""
      let exp = expectation(description: "1")

      stringWork
         .retainBy(retainer)
         .doAsync("Hello")
         .doSaveResult()
         .doInput("Again")
         .doNext(work: stringWork2)
         .onSuccess 
            result = .inputagain
            resultString = $0
            //  exp.fulfill()
            print(terminator: Array(repeating: "\n", count: 5).joined())
            log("Again")
         }
         .doLoadResult()
         .onSuccess { (text: String) in
            result = .loadSuccess
            resultString = text
            exp.fulfill()
            print(terminator: Array(repeating: "\n", count: 5).joined())
            log("Hello")
         }
         .doNext(stringWork2)

      wait(for: [exp], timeout: 1)
      XCTAssertEqual(result, .loadSuccess)
      XCTAssertEqual(resultString, "Hello")
   }

//   func testRecover() {
//      var result = Res.none
//      var resultString = ""
//      let exp = expectation(description: "1")
//      let exp2 = expectation(description: "2")
//      let exp3 = expectation(description: "3")
//      let exp4 = expectation(description: "4")
//      let exp5 = expectation(description: "5")
//      let exp6 = expectation(description: "6")
//      // let exp7 = expectation(description: "7")
//
//      stringWork
//         .retainBy(retainer)
//         .doAsync("Hello")
//         .onSuccess {
//            result = .success
//            resultString = $0
//            exp.fulfill()
//         }
//         .doMap {
//            $0 + "World"
//         }
//         .onSuccess {
//            result = .mapped
//            resultString = $0
//            exp2.fulfill()
//         }
//         .doNext(work: failWork)
//         .onSuccess {
//            result = .failworkSucces
//            resultString = $0
//            // exp3.fulfill()
//         }
//         .onFail { (text: String) in
//            result = .failworkError
//            resultString = text
//            exp3.fulfill()
//         }
//         .doRecover()
//         .onSuccess { text in
//            result = .recovered
//            resultString = text + "Recovered"
//            exp4.fulfill()
//         }
//         .onFail { (text: String) in
//            result = .recoverfailed
//            resultString = text
//            exp4.fulfill()
//         }
//         .doSaveResult()
//         .doInput("Again")
//         .onSuccess { (text: String) in
//            result = .inputagain
//            resultString = text
//            exp5.fulfill()
//         }
//         .doLoadResult()
//         .onSuccess { (text: String) in
//            result = .loadSuccess
//            resultString = text + "Loaded"
//            exp6.fulfill()
//         }
   ////         .doNext(work: stringWork)
   ////         .onSuccess {
   ////            result = .stringworksuccess
   ////         }
//
//      wait(for: [exp], timeout: 1)
   ////      XCTAssertEqual(result, .success)
   ////      XCTAssertEqual(resultString, "Hello")
//
//      wait(for: [exp2], timeout: 1)
   ////      XCTAssertEqual(result, .mapped)
   ////      XCTAssertEqual(resultString, "HelloWorld")
//
//      wait(for: [exp3], timeout: 1)
   ////      XCTAssertEqual(result, .failworkError)
   ////      XCTAssertEqual(resultString, "HelloWorld")
//
//      wait(for: [exp4], timeout: 1)
   ////      XCTAssertEqual(result, .recovered)
   ////      XCTAssertEqual(resultString, "HelloWorldRecovered")
//
//      wait(for: [exp5], timeout: 1)
//      XCTAssertEqual(result, .inputagain)
//      XCTAssertEqual(resultString, "Again")
//
//      wait(for: [exp6], timeout: 1)
//      XCTAssertEqual(result, .loadSuccess)
//      XCTAssertEqual(resultString, "HelloWorldRecoveredLoaded")
//   }

//
//   func testSyncWork() {
//      var result = Res.none
//      var resultString = ""
//
//      let exp = expectation(description: "")
//      let work = works.coinInputParsing
//
//      work
//         .doAsync("A")
//         .doRecover()
//         .onSuccess {
//            result = .recovered
//            resultString = $0
//            exp.fulfill()
//         }
//
//      wait(for: [exp], timeout: 1)
//      XCTAssertEqual(result, .recovered)
//      XCTAssertEqual(resultString, "A")
//   }
//
//   func testSyncWork2() {
//      enum Res {
//         case success
//         case recovered
//         case none
//      }
//
//      var result = Res.none
//      var resultString = ""
//
//      let exp = expectation(description: "")
//      let work = works.coinInputParsing
//
//      work
//         .doAsync("5")
//         .onSuccess {
//            result = .success
//            resultString = $0
//            exp.fulfill()
//         }
//         .doRecover()
//         .onSuccess {
//            result = .recovered
//            resultString = "B"
//            exp.fulfill()
//         }
//
//      wait(for: [exp], timeout: 1)
//      XCTAssertEqual(result, .success)
//      XCTAssertEqual(resultString, "5")
//   }
//
//
//
//   func testSyncWork3() {
//      enum Res {
//         case fail
//         case success
//         case loadSuccess
//         case recovered
//         case none
//      }
//
//      var result = Res.none
//      var resultString = ""
//
//      let exp = expectation(description: "")
//      let work = works.coinInputParsing
//
//      work
//         .doAsync("B")
//         .onSuccess {
//            result = .success
//            resultString = $0
//            exp.fulfill()
//            log("111111111")
//         }
//         .onFail { (errt: String) in
//            result = .fail
//            resultString = errt
//            exp.fulfill()
//         }
//         .doRecover()
//      // .
   ////         .doSaveResult()
   ////         .doLoadResult()
   ////         .doNext(work: stringWork)
   ////         .onSuccess { (text: String) in
   ////            result = .loadSuccess
   ////            exp.fulfill()
   ////            resultString = text
   ////            log("222222222")
   ////         }.onFail {
   ////            exp.fulfill()
   ////         }
//
//      wait(for: [exp], timeout: 1)
//      XCTAssertEqual(result, .loadSuccess)
//      XCTAssertEqual(resultString, "B")
//   }
}
