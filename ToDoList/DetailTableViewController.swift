//
//  DetailTableViewController.swift
//  ToDoList

//

import UIKit

class DetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var saveBarbBtn: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    var toDoItem: ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", date: Date(), notes: "", reminderSet: false)
           
        }
       
        upDateUserInterFace()
    }
    
    func upDateUserInterFace() {
//        if let name = nameField.text, !name.isEmpty {
//              nameField.text = toDoItem.name
//          }
        if nameField.text?.isEmpty ?? true {
                nameField.text = toDoItem.name
            }
        dataPicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        
        reminderSwitch.isOn = toDoItem.reminderSet
        dateLabel.textColor = reminderSwitch.isOn ? .black : .gray
        
//        reminderSwitch.isOn = toDoItem.reminderSet
//        if reminderSwitch.isOn {
//            dateLabel.textColor = .black
//        } else {
//            dateLabel.textColor = .gray
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //判斷是否空字串, 是空字串 就不會新增空白的 cell
//        if nameField.text?.isEmpty ?? true {
//                   toDoItem = nil
//               } else {
//                   toDoItem = ToDoItem(name: nameField.text ?? "", date: dataPicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn)
//               }
//
        
        toDoItem = ToDoItem(name: nameField.text ?? "not String", date: dataPicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn)
//        toDoItem = ToDoItem(name: nameField.text ?? "not String", date: dataPicker.date, notes: noteView.text)
    }
    
    @IBAction func cencelBarBtn(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }else {
            //navig 推回上一頁 要用 pop
            //            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }
        
    }
  
    @IBAction func reminderSwitchChange(_ sender: UISwitch) {
        
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    
    
    
}

extension DetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case IndexPath(row: 1, section: 1):
            print("indexPath1: \(indexPath)")
            print("dataPicker H : \(dataPicker.frame.height)")
            print("Reminder switch isOn: \(reminderSwitch.isOn)")
            return reminderSwitch.isOn ? dataPicker.frame.height : 0
        case IndexPath(row: 0, section: 2):
            print("indexPath2: \(indexPath)")
            return 200

        default:
            return 44
        }
    }
}
