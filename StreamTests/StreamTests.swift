//
//  StreamTests.swift
//  StreamTests
//
//  Created by Sheila Doherty on 8/22/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import XCTest
@testable import Stream

class StreamTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVidoViewModel(){
        let video = Video(name: "My Test Video Name", urlString: "http://www.test.com/")
        let videoViewModel = VideoViewModel(video: video)
        XCTAssertEqual(video.name, videoViewModel.name)
        XCTAssertEqual(video.urlString, videoViewModel.urlString)
    }

}
