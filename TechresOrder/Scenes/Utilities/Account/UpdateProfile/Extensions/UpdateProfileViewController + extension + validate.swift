
import UIKit
import RxSwift
import RxRelay
import JonAlert
extension UpdateProfileViewController {
    

    
    func mappingData(){
        
        _ = textfield_phone.rx.text.map{[self] str in
            let phone = String(str!.prefix(11))
            
            textfield_phone.text = phone
            var profile = viewModel.profile.value
            profile.phone_number = phone
            return profile
        }.bind(to:viewModel.profile).disposed(by: rxbag)
        

        
        _ = textfield_email.rx.text.map{[self] email in
            var profile = viewModel.profile.value
            profile.email = email ?? ""
            return profile
        }.bind(to: viewModel.profile).disposed(by: rxbag)
        
        
        _ = textView_address.rx.text.map{String($0!.prefix(255))}.map{[self] address in
 
            height_of_textview_address.constant = textView_address.contentSize.height + 10
            textView_address.text = address
            var profile = viewModel.profile.value
            profile.address = address
            return profile
        }.bind(to: viewModel.profile).disposed(by: rxbag)
        
    }
    

    var isAccountInforValid: Observable<Bool>{
        return Observable.combineLatest(isValidPhone,isValidEmail,isValidAddress, isValidWard,isValidDistrict,isValidCity){$0 && $1 && $2 && $3 && $4 && $5}
    }
    
    private var isValidPhone: Observable<Bool>{
        return viewModel.profile.map{$0.phone_number}.distinctUntilChanged().asObservable().map(){[self](phone) in
 
            if phone.count >= 10 && phone.count <= 11{
                return true
            }else if (phone.prefix(1) != "0") {
                self.showWarningMessage(content: "Số điện thoại không hợp lệ!")
                return false
            }else{
                self.showWarningMessage(content: "Số điện thoại không hợp lệ!")
                return false
            }
         
        }
    }
    
    private var isValidEmail: Observable<Bool>{
        return viewModel.profile.map{$0.email}.distinctUntilChanged().asObservable().map(){[self](email) in
            if Utils.isValidEmail(email){
                return true
            }else {
                self.showWarningMessage(content: "Email không hợp lệ!")
                return false
            }
        }
    }
    
   
    private var isValidAddress: Observable<Bool>{
        return viewModel.profile.map{$0.address}.distinctUntilChanged().asObservable().map(){[self](address) in
            if address.replacingOccurrences(of: " ", with: "").count >= 2 && address.count <= 255 && Utils.isCheckValidateAddress(address: address){
                return true
            }else {
                self.showWarningMessage(content: "Địa chỉ phải từ 2 đến 255 và chỉ chấp nhập các dấu , . - ")
                return false
            }
        }
    }
    
    
    private var isValidWard: Observable<Bool>{
        return viewModel.profile.map{$0.ward_id}.distinctUntilChanged().asObservable().map(){[self](id) in
            
            if id != 0 {
                return true
            }else{
                self.showWarningMessage(content: "Vui lòng chọn phường/xã bạn đang sinh sống")
                return false
            }
        }

    }
    private var isValidDistrict: Observable<Bool>{
        return viewModel.profile.map{$0.district_id}.distinctUntilChanged().asObservable().map(){[self](id) in
            
            if id != 0 {
                return true
            }else{
                self.showWarningMessage(content: "Vui lòng chọn quận/huyện bạn đang sinh sống")
                return false
            }
        }

    }
    
    private var isValidCity: Observable<Bool>{
        return viewModel.profile.map{$0.city_id}.distinctUntilChanged().asObservable().map(){[self](id) in
            
            if id != 0 {
                return true
            }else{
                self.showWarningMessage(content: "Vui lòng chọn thành phố/tỉnh của bạn")
                return false
            }
        }
    }
}




