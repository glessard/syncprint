import XCTest

import Dispatch

import syncprint

class syncprintTests: XCTestCase
{
  static var allTests: [(String, (syncprintTests) -> () throws -> Void)] {
    return [
      ("testPrint", testPrint),
      ("testSyncPrint", testSyncPrint),
    ]
  }

  func testPrint()
  {
    syncprint("From the main thread")
    DispatchQueue.global(qos: .userInitiated).async { syncprint("From a background thread") }
    syncprintwait()
  }

  func testSyncPrint()
  {
    let q = DispatchQueue.global(qos: .userInitiated)
    let g = DispatchGroup()

    for i in 0..<20
    {
      q.async(group: g) { syncprint(i) }
    }

    g.wait()
    syncprintwait()
  }
}
