//
//  PrinterUtilsTest.swift
//  TechresOrderTests
//
//  Created by Pham Khanh Huy on 06/08/2024.
//

import XCTest

@testable import TECHRES_ORDER
class PrinterUtilsTest: XCTestCase {
    
    func testPermission(){
      
        XCTAssertEqual(permissionUtils.Checking, true)
    }

}
