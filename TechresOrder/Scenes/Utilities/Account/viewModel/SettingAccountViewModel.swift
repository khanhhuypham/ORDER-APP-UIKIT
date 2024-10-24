//
//  SettingAccountViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class SettingAccountViewModel: BaseViewModel {
    private(set) weak var view: SettingAccountViewController?
    private var router: SettingAccountRouter?
   
    public var dataSectionArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [])

    
    func bind(view: SettingAccountViewController, router: SettingAccountRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    func makeUpdateProfileViewController(){
        router?.navigateToUpdateProfileViewController()
    }
    func makeChangePasswordViewController(){
        router?.navigateToChangePasswordViewController()
    }
    
    func makeChatChannelViewController(){
        router?.navigateToChatChannelViewController()
    }
    
    func makePravicyPolicyViewController(){
        router?.navigateToPravicyPolicyViewController()
    }
    func makeTermOfUseViewController(){
        router?.navigateToTermOfUseViewController()
    }
    
    func makeSentErrorViewController(){
        router?.navigateToSentErrorViewController()
    }
    func makeFeedbackDeveloperViewController(){
        router?.navigateToFeedBackDeveloperViewController()
    }
    func makeClosedWorkingSessionViewController(){
        router?.navigateToClosedWorkingSessionViewController()
    }
    
    func makeToInformationApplicationViewController(){
        router?.navigateToInformationApplicationViewController()
    }
}
