//
//  FirebladePALTests.swift
//  FirebladePALTests
//
//  Created by Christian Treffs on 14.10.21.
//

@testable import FirebladePAL
import XCTest

final class FirebladePALTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Platform.initialize()
    }

    override class func tearDown() {
        super.tearDown()
        Platform.quit()
    }

    func testPlatformSetup() throws {
        #if FRB_ENABLE_PLATFORM_SDL
            XCTAssertEqual(Platform.implementation, .sdl)
        #endif

        #if FRB_ENABLE_PLATFORM_APPL
            XCTAssertEqual(Platform.implementation, .apple)
        #endif
    }

    func testClipboard() throws {
        try Platform.clipboard.setText("Hello World!")
        XCTAssertTrue(Platform.clipboard.hasText())
        XCTAssertEqual(try Platform.clipboard.getText(), "Hello World!")
    }
}
