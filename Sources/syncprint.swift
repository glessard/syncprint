//
//  syncprint.swift
//
//  Created by Guillaume Lessard on 2014-08-22.
//  Copyright (c) 2014, 2015 Guillaume Lessard. All rights reserved.
//
//  https://github.com/glessard/syncprint
//  https://gist.github.com/glessard/826241431dcea3655d1e
//

import Dispatch
import class Foundation.Thread

import Atomics

private let printQueue = DispatchQueue(label: "com.tffenterprises.syncprint")
private let printGroup = DispatchGroup()

private var silenceOutput = AtomicBool(false)

///  A wrapper for `Swift.print()` that executes all requests on a serial queue.
///  Useful for logging from multiple threads.
///
///  Writes a basic thread identifier (main or back), the textual representation
///  of `item`, and a newline character onto the standard output.
///
///  The textual representation is from the `String` initializer, `String(item)`
///
///  - parameter item: the item to be printed

public func syncprint(_ item: Any)
{
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
  let thread = Thread.current.isMainThread ? "[main]" : "[back]"
#else
  // Thread.current.isMainThread is not implemented in corelibs-foundation
  let thread = "[]"
#endif

  printQueue.async(group: printGroup) {
    // Read silenceOutput atomically
    if silenceOutput.value == false
    {
      print(thread, item, separator: " ")
    }
  }
}

///  Block until all tasks created by syncprint() have completed.

public func syncprintwait()
{
  // Wait at most 200ms for the last messages to print out.
  let res = printGroup.wait(timeout: DispatchTime.now() + 0.2)
  if res == .timedOut
  {
    silenceOutput.store(true)
    printGroup.notify(queue: printQueue) {
      print("Skipped output")
      silenceOutput.store(false)
    }
  }
}
