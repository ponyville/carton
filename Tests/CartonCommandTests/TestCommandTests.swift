// Copyright 2020 Carton contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Created by Cavelle Benjamin on Dec/28/20.
//

import AsyncHTTPClient
@testable import CartonCLI
import TSCBasic
import XCTest

extension TestCommandTests: Testable {}

final class TestCommandTests: XCTestCase {
  private var client: HTTPClient?

  override func tearDown() {
    try? client?.syncShutdown()
    client = nil
  }

  func testWithNoArguments() throws {
    // given I've created a directory
    let package = "TestApp"
    let packageDirectory = testFixturesDirectory.appending(components: package)

    XCTAssertTrue(packageDirectory.exists, "The TestApp directory does not exist")

    AssertExecuteCommand(
      command: "carton test",
      cwd: packageDirectory.url
    )

    // finally, clean up
    let buildDirectory = packageDirectory.appending(component: ".build")
    do { try buildDirectory.delete() } catch {}
  }

  func testEnvironmentDefaultBrowser() throws {
    // given I've created a directory
    let package = "TestApp"
    let packageDirectory = testFixturesDirectory.appending(components: package)

    let expectedTestSuiteCount = 1
    let expectedTestsCount = 1

    let expectedContent =
      """
      Test Suites: \(ControlCode.CSI)32m\(expectedTestSuiteCount) passed\(ControlCode
        .CSI)0m, \(expectedTestSuiteCount) total
      Tests:       \(ControlCode.CSI)32m\(expectedTestsCount) passed\(ControlCode
        .CSI)0m, \(expectedTestsCount) total
      """

    XCTAssertTrue(packageDirectory.exists, "The TestApp directory does not exist")

    // start clean
    do { try packageDirectory.appending(component: ".build").delete() } catch {}

    AssertExecuteCommand(
      command: "carton test",
      cwd: packageDirectory.url,
      expected: expectedContent,
      expectedContains: true
    )

    // finally, clean up
    do { try packageDirectory.appending(component: ".build").delete() } catch {}
  }
}

enum ControlCode {
  static let ESC = "\u{001B}"
  static let CSI = "\(ESC)["
}
