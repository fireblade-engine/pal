//
//  FirebladePALTests.swift
//  FirebladePALTests
//
//  Created by Christian Treffs on 14.10.21.
//

@testable import FirebladePAL
import XCTest

final class FirebladePALTests: XCTestCase {
    func testPlatformSetup() throws {
        Platform.initialize()

        #if FRB_ENABLE_PLATFORM_SDL
            XCTAssertEqual(Platform.implementation, .sdl)
        #endif

        #if FRB_ENABLE_PLATFORM_APPL
            XCTAssertEqual(Platform.implementation, .apple)
        #endif

        Platform.quit()
    }
}
