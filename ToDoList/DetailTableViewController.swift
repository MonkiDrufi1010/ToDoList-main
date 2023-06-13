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
            toDoItem = ToDoItem(name: "", date: Date(), notes: "")
        }
        nameField.text = toDoItem.name
        dataPicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text ?? "not String", date: dataPicker.date, notes: noteView.text)
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
    }
    
    
    
    
}
