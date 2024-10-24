//
//  OrderBusinessTests.swift
//  OrderBusinessTests
//
//  Created by Pham Khanh Huy on 06/08/2024.
//

import XCTest
@testable import TECHRES_ORDER
final class OrderBusinessTests: XCTestCase {
    var loginVC = LoginViewController()
   
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginVC = LoginViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    
    func testPermission(){
        XCTAssertEqual(permissionUtils.Checking, true)
    }
    

    

    
    /*
         1.Test Case: Kiểm tra giao diện đăng nhập
         Mô tả: Kiểm tra xem giao diện đăng nhập có hiển thị chính xác như thiết kế UI không.
         Bước thực hiện: Mở ứng dụng, xác nhận màn hình đăng nhập được hiển thị đúng theo thiết kế.
         Kết quả mong đợi: Màn hình đăng nhập được hiển thị đúng với các trường đầu vào như tên người dùng, mật khẩu, quên mật khẩu và nút đăng nhập.
         
         2.Test Case: Kiểm tra trường tên người dùng
         Mô tả: Xác nhận tính hợp lệ của trường tên người dùng.
         Bước thực hiện: Nhập tên người dùng hợp lệ và không hợp lệ (rỗng, ký tự đặc biệt, quá dài, quá ngắn, v.v.).
         Kết quả mong đợi: Hệ thống chấp nhận tên người dùng hợp lệ và phản hồi lỗi cho tên người dùng không hợp lệ.
         
         3.Test Case: Kiểm tra trường mật khẩu
         Mô tả: Xác nhận tính hợp lệ của trường mật khẩu.
         Bước thực hiện: Nhập mật khẩu hợp lệ và không hợp lệ (rỗng, quá ngắn, v.v.).
         Kết quả mong đợi: Hệ thống chấp nhận mật khẩu hợp lệ và phản hồi lỗi cho mật khẩu không hợp lệ.
         
         4.Test Case: Kiểm tra nút đăng nhập
         Mô tả: Xác nhận tính năng của nút đăng nhập.
         Bước thực hiện: Nhập tên người dùng và mật khẩu hợp lệ, sau đó nhấn nút đăng nhập. Nhập tên người dùng hoặc mật khẩu không hợp lệ, sau đó nhấn nút đăng nhập.
         Kết quả mong đợi: Nếu tên người dùng và mật khẩu hợp lệ, hệ thống cho phép đăng nhập thành công. Nếu có lỗi, hệ thống hiển thị thông báo lỗi tương ứng.
         
         5.Test Case: Kiểm tra chức năng quên mật khẩu
         Mô tả: Xác nhận tính năng quên mật khẩu hoạt động đúng.
         Bước thực hiện: Nhấp vào liên kết quên mật khẩu. Nhập tên người dùng hoặc địa chỉ email đã đăng ký. Gửi yêu cầu đặt lại mật khẩu.
         Kết quả mong đợi: Hệ thống xử lý yêu cầu đặt lại mật khẩu và thông báo cho người dùng về quá trình thành công hoặc lỗi.
         
         6.Test Case: Đăng nhập thành công
         Mô tả: Kiểm tra xem người dùng có thể đăng nhập thành công bằng thông tin đăng nhập hợp lệ.
         Bước thực hiện: Nhập tên người dùng và mật khẩu hợp lệ. Nhấn nút đăng nhập.
         Kết quả mong đợi: Người dùng được chuyển đến màn hình chính hoặc trang được xác định cho người dùng đã đăng nhập.
         
         7.Test Case: Đăng nhập không thành công với tên người dùng không đúng
         Mô tả: Kiểm tra xem hệ thống phản hồi như thế nào khi tên người dùng không đúng.

     */
    

}
