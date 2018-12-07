//
//  Console.swift
//  CSC470Euler
//
//  Created by Jozeee on 11/14/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import Foundation

/// Helper class for debugging.
class Console {
    
    /// Pass #file for file and #line for lineNumber to get a better
    /// debugging statement in the format: "LOG [file name, line lineNumber]: message"
    static func log(file: String, lineNumber: Int, message: String) {
        #if DEBUG
        if let urlFile = URL(string: file), let last = urlFile.pathComponents.last {
            print("LOG [\(last), \(lineNumber)]: \(message)")
        }
        #endif
    }
}
