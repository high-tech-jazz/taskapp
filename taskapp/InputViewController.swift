//
//  InputViewController.swift
//  taskapp
//
//  Created by 伊藤敬 on 2022/12/17.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    let realm = try! Realm()
    var task: Task!
    var cat: Category!
    var selected = 0
    
    var catArray = try! Realm().objects(Category.self).sorted(byKeyPath: "id", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        if task.category > 0 {
            categoryPicker.selectRow(task.category - 1, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue){
        viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.titleTextField.text != "" {
            if task.category != 0 && selected == 0 {
                selected = task.category
            }
            try! realm.write {
                self.task.title = self.titleTextField.text!
                self.task.category = selected
                self.task.contents = self.contentsTextView.text
                self.task.date = self.datePicker.date
                self.realm.add(self.task, update: .modified)
            }
            
            setNotification(task: task)
        }
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと中身を設定（中身がない場合メッセージ無しで音だけの通知になるので「（xxなし）」を表示する）
        if task.title == "" {
            content.title = "(タイトル無し)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容無し)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger(日付マッチ)を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成(identifierが同じだとローカル通知を上書き保存)
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")
        }
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/----------")
                print(request)
                print("----------/")
            }
        }
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = catArray[row].id
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catArray[row].name
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
