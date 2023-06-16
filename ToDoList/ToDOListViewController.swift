//
//  ViewController.swift
//  ToDoList
//

//

import UIKit

import UserNotifications


class ToDOListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    
//    var toDoArray = ["Learn Swift", "Build App", "Change the word", "Take Pice"]
    
    var toDoItems: [ToDoItem] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        autherizeLocalNotification()
        loadData()
       
    }
    // 通知訊息 但是目前沒有顯示通知 不知道為什麼
    func autherizeLocalNotification() {
        UNUserNotificationCenter.current().requestAuthorization { granted, error in
            guard error == nil else {
                print("😁 Error: \(error?.localizedDescription)")
                return
            }
            if granted {
                print("✋🏻 Notification Antorization Granted!")
                
            } else {
                print("👻 The user has dneied notification!")
            }
            
            
        }
    }
    
    //Notification 新增
    func setCalenderNotification(title: String, subtitle: String, body: String,
                                 badgeNumber: NSNumber?, sound: UNNotificationSound,
                                 date: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create equest
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        //register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("😤 ERROR: \(error.localizedDescription) Yikes")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
            
        }
        
        return notificationID
    }
    
    //Notification 新增
    func setNotifications() {
        guard toDoItems.count > 0 else {return}
        
        // remove all notifications
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        // and let's re-carate them with the update date that we just save
        for index in 0..<toDoItems.count {
            if toDoItems[index].reminderSet {
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalenderNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
        
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        
        let jsonDecoder = JSONDecoder()
        do {
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error: Could not load data: \(error.localizedDescription)")
        }
        
    }
 
    
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        //  可以印出 儲存的路徑
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: documentURL.path) {
            print("todos.json 檔案已成功儲存。")
            print("MyPath: \(documentURL.path)")
        // -------------------------
        } else {
            print("無法找到 todos.json 檔案。")
        }
        
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(toDoItems)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
            
        }catch {
            print("Error: Could not save data \(error.localizedDescription)")
        }
        
        // Notification 新增的 //下面新增 set setNotifications() 這兩行就註解 因為寫在裡面
//        let toDoItem = toDoItems.first!
//        let notificationID = setCalenderNotification(title: toDoItem.name, subtitle: "SUBTITLE world go here", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
        
        //notification 新增
        setNotifications()
        
    }
    
    
    
    /*
     這段程式碼是一個 unwindFromDetail 的方法，用於處理從詳細頁面返回主頁面的情況。
     它的功能是更新主頁面的資料來反映從詳細頁面傳遞過來的變更。

     程式碼中的 segue 參數代表了觸發此方法的 Segue，它是用於連接不同視圖控制器之間的過渡。
     這段程式碼使用了 segue.source 屬性來獲取觸發 Segue 的視圖控制器，
     並透過類型轉換（as? DetailTableViewController）
     確保它是 DetailTableViewController 的實例。

     接下來，
     程式碼使用 tableView.indexPathForSelectedRow
     來獲取當前選中行的 IndexPath，以便更新對應的資料。

     如果 segue.source 是 DetailTableViewController，
     
     且有有效的 selectedIndexPath 和 toDoItem 值，
     則代表從詳細頁面返回主頁面並傳遞了變更。
     這時，程式碼將更新 toDoArray 中指定位置的資料，
     然後使用 tableView.reloadRows(at: [selectedIndexPath], with: .automatic) 方法重新加載該行。

     如果上述條件不滿足，即按下加號跳轉到詳細頁面，
     並在該頁面的 textField 中輸入了文字，
     則在底部新增一個新的資料項。
     程式碼創建一個新的 IndexPath，
     將 toDoItem 添加到 toDoArray 中，
     並使用 tableView.insertRows(at: [newIndexPath], with: .bottom) 方法在表格視圖的底部插入一行。

     這樣，無論是從詳細頁面返回主頁面還是在詳細頁面新增項目，程式碼都會根據不同的情況更新主頁面的資料。
     
     
     在您提供的程式碼中，else 區塊的條件判斷是指當 if 條件判斷不滿足時，
     即表示當以下任何一個條件不成立時：

     source 不能被轉換為 DetailTableViewController。
     selectedIndexPath 為 nil。
     toDoItem 為 nil。
     換句話說，
     當任何一個條件不滿足時，
     程式碼將執行 else 區塊中的邏輯，
     即在按下加號並跳轉到詳細頁面後，在表格視圖的底部新增一個項目。

     我對之前的解釋再次深感抱歉，並感謝您的耐心指正。
     
     */
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        if let source = segue.source as? DetailTableViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow,
           let toDoItem = source.toDoItem {
            toDoItems[selectedIndexPath.row] = toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
//            tableView.beginUpdates()
//            tableView.endUpdates()
        } else {
            // 按加號 在textField輸入的文字,會新增在底部 .buttom
            // 這IndexPath 一定要有 印出[0, 4]
            let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
            print("new: \(newIndexPath)")
            if let source = segue.source as? DetailTableViewController,
               let toDoItem = source.toDoItem {
                toDoItems.append(toDoItem)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                //滾動到最底
                tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
        }
        
        saveData()
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let destination = segue.destination as? DetailTableViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow {
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        } else { // 這段else 不是很懂 表示按加號跳轉頁面,但並不會顯示在textField
            if let selectedIndexPath = tableView.indexPathsForSelectedRows {
                for indexPath in selectedIndexPath {
                    // 取消選定的cell 但是我按加號 都沒選呀
                      tableView.deselectRow(at: indexPath, animated: true)
                    
                }
            }

        }
    }
    
    
    
    
    
    @IBAction func editBarBtnPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarBtn.isEnabled = true
            
            
        }else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarBtn.isEnabled = false
        }
    }
    
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            toDoItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .right)
//
//
//
//        }
//    }
    // 刪除  cell 或這 左滑 可以刪除  deleteRow 這函數
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
   
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
    }
 
    
    
}



extension ToDOListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection \(toDoItems.count)")
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].name
        
        return cell
        
    }
}

