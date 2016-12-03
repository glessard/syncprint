import XCTest

import Dispatch

import syncprint

#if os(Linux)
import func Glibc.random
#else
import func Darwin.C.stdlib.arc4random
#endif

private func coinflip() -> Bool
{
#if os(Linux)
  let i = random()
#else
  let i = arc4random()
#endif

  return (i&0x1) == 0
}

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

    for i in 0..<100
    {
      if coinflip()
      {
        q.async(group: g) { syncprint(i) }
      }
      else
      {
        syncprint(i)
      }
    }

    g.wait()
    syncprintwait()
  }
}
