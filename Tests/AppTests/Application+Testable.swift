//
//  File.swift
//  
//
//  Created by David Enriquez solis on 05/10/20.
//

import XCTVapor
import App

extension Application {
  static func testable() throws -> Application {
    let app = Application(.testing)
    try configure(app)
    
    try app.autoRevert().wait()
    try app.autoMigrate().wait()

    return app
  }
}

