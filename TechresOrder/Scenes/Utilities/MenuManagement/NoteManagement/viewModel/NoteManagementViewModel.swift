//
//  NoteManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class NoteManagementViewModel: BaseViewModel {
    private(set) weak var view: NoteManagementViewController?
    private var router: NoteManagementRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var is_deleted = BehaviorRelay<Int>(value: ACTIVE)
    var status = BehaviorRelay<Int>(value: 0)
    public var dataArray : BehaviorRelay<[Note]> = BehaviorRelay(value: [])
    var noteRequest = BehaviorRelay<NoteRequest>(value: NoteRequest())
    func bind(view: NoteManagementViewController, router: NoteManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension NoteManagementViewModel{
    func getNotesManagement() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.notesManagement(branch_id:branch_id.value,status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func deleteNote() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createNote(branch_id: branch_id.value, noteRequest: noteRequest.value, is_deleted: is_deleted.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
