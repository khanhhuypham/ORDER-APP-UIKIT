//
//  TECHRES_ORDERUITests.swift
//  TECHRES-ORDERUITests
//
//  Created by Pham Khanh Huy on 07/08/2024.
//

import XCTest
import TECHRES_ORDER
final class TECHRES_ORDERUITests: XCTestCase {
    
    let identifiers:[(id:String,text:String)] = {
        let arr = [
            (id:Identifiers.LoginScreen.restaurantNameTextField,text:"tschuvuong"),
            (id:Identifiers.LoginScreen.accountTextField,text:"tr000001"),
            (id:Identifiers.LoginScreen.passwordTextField,text:"0000")
        ]
        return arr
    }()
    
 
    
//    override func setUp() {
//        super.setUp()
//        continueAfterFailure = false
//        XCUIApplication().launch()
//    }
    

    override func tearDown(){
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
    func testLoginSuccessfully() throws {
        let app = XCUIApplication()
        
        app.launch()
        
//        if ManageCacheObject.isLogin(){
//            
//        }else{
            
        for i in self.identifiers{
            let textField = app.textFields[i.id]
            textField.clearAndEnterText(text: i.text)
        }
        
        app.buttons[Identifiers.LoginScreen.loginBtn].tap()
//        }
       
        
        print(String(format: "asd: %@", app.staticTexts))
        XCTAssertTrue(app.staticTexts["Đăng nhập thành công"].isHittable)
    }

}


extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
