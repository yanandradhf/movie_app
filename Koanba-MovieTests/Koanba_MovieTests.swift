//
//  Koanba_MovieTests.swift
//  Koanba-MovieTests
//
//  Created by Yanandra Dhafa on 09/07/24.
//

import XCTest
@testable import Koanba_Movie

final class Koanba_MovieTests: XCTestCase {

    var viewController: HomeViewController!
        var window: UIWindow!
        
        override func setUp() {
            super.setUp()
            
            viewController = HomeViewController()
            viewController.viewModel = MoviesViewModel()
            
            window = UIWindow()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            viewController.loadViewIfNeeded()
            viewController.viewWillAppear(false)
            viewController.viewDidAppear(false)
        }
        
        override func tearDown() {
            viewController = nil
            window = nil
            super.tearDown()
        }
        
        func testTableViewDataSource() {
        
            let dummyMovies = [
                Movie(id: 1, title: "The Conjuring", overview: "Seram banget", releaseDate: "2018-2-20", posterPath: "/Conjuring.jpg", genreNames: ["Horror", "Drama"]),
                Movie(id: 2, title: "Love Heart", overview: "Hati Hati", releaseDate: "2019-03-10", posterPath: "/Heart.jpg", genreNames: ["Drama"])
            ]
            
           
            viewController.viewModel.movies = dummyMovies
            viewController.movieResultsTable.reloadData()
            viewController.movieResultsTable.layoutIfNeeded()
            
            
            let expectation = self.expectation(description: "Wait for table view to reload")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 2, handler: nil)
            
               let numberOfRows = viewController.tableView(viewController.movieResultsTable, numberOfRowsInSection: 0)
               XCTAssertEqual(numberOfRows, 2, "Number of rows in table view should be 2")
               
               guard let cell = viewController.movieResultsTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomTableViewCell else {
                   XCTFail("Cell is not of type CustomTableViewCell")
                   return
               }
               XCTAssertEqual(cell.titleLabel.text, "The Conjuring", "The first cell's text should be 'The Conjuring'")
               
           }
    }
