//
//  NoteManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension NoteManagementViewController{
    func registerCell() {
        let noteTableViewCell = UINib(nibName: "NoteTableViewCell", bundle: .main)
        tableView.register(noteTableViewCell, forCellReuseIdentifier: "NoteTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rx.setDelegate(self).disposed(by: rxbag)
        
        tableView.rx.modelSelected(Note.self) .subscribe(onNext: { [self] element in
            print(element)
            presentModalCreateNote(note: element)
        })
        .disposed(by: rxbag)
        
    }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "NoteTableViewCell", cellType: NoteTableViewCell.self))
           {  (row, note, cell) in
               cell.data = note
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}
extension NoteManagementViewController: UITableViewDelegate{
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.viewModel.dataArray.value[indexPath.row]
        self.presentModalCreateNote(note: note)
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var  configuration : UISwipeActionsConfiguration?
        // edit action
        let edit = UIContextualAction(style: .normal,title: "Chỉnh sửa") { [weak self] (action, view, completionHandler) in
            
            let notes = self?.viewModel.dataArray.value
            self?.handleEditNote(note:notes![indexPath.row])
            completionHandler(true)
        }
        edit.backgroundColor = ColorUtils.gray_600()
        edit.image = UIImage(named: "icon-edit")

        // delete action
        let delete = UIContextualAction(style: .normal,title: "Xóa") { [weak self] (action, view, completionHandler) in
            let notes = self?.viewModel.dataArray.value
            self?.handleDeleteNote(note:notes![indexPath.row])
            completionHandler(true)
        }
        delete.backgroundColor = ColorUtils.red_color()
        delete.image = UIImage(named: "icon-cancel-food")
        
        
        
        configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration!.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}

//MARK: -- CALL API
extension NoteManagementViewController {
    func getNotes(){
        viewModel.getNotesManagement().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let notes = Mapper<Note>().mapArray(JSONObject: response.data) {

                    self.viewModel.dataArray.accept(notes.count > 0 ? notes : [])
                    self.no_data_view.isHidden = notes.count > 0 ? true : false
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    func deleteNote(){
        viewModel.deleteNote().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create Note Success...")
                JonAlert.showSuccess(message: "Xóa ghi chú thành công!", duration: 2.0)
                self.getNotes()
            }
        }).disposed(by: rxbag)
}
    
    
}
extension NoteManagementViewController:TechresDelegate{

    func presentModalCreateNote(note:Note = Note()!) {
        let vc = CreateNoteViewController()
        vc.note = note
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)

    }
    
    func callBackReload() {
        self.getNotes()
    }
}

extension NoteManagementViewController{
    public func handleEditNote(note:Note) {
        self.presentModalCreateNote(note: note)
    }

    public func handleDeleteNote(note:Note) {
        print("handleDeleteNote")
        var noteRequest = NoteRequest()
        noteRequest.id = note.id
        noteRequest.delete = ACTIVE
        noteRequest.content = note.content
        viewModel.noteRequest.accept(noteRequest)
        self.deleteNote()
    }
    
}
