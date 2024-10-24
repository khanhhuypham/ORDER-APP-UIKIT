//
//  CreateNoteViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 01/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreateNoteViewModel: BaseViewModel {
    private(set) weak var view: CreateNoteViewController?

    public var note = BehaviorRelay<Note>(value: Note()!)
    
    func bind(view: CreateNoteViewController){
        self.view = view

    }
    
}
extension CreateNoteViewModel {
    
    func createUpdateNote() -> Observable<APIResponse> {
        var noteRequest:NoteRequest = NoteRequest()
        noteRequest.content = note.value.content
        noteRequest.delete = DEACTIVE
        noteRequest.id = note.value.id
        noteRequest.branch_id = ManageCacheObject.getCurrentBranch().id
       
        return appServiceProvider.rx.request(.createNote(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            noteRequest: noteRequest,
            is_deleted: DEACTIVE
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
