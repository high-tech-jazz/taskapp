//
//  Task.swift
//  taskapp
//
//  Created by 伊藤敬 on 2022/12/19.
//

import RealmSwift

class Task: Object {
    // 管理用ID。プライマリーキー。
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    // 日時
    @objc dynamic var date = Date()
    
    // カテゴリー
    @objc dynamic var category = 0
    
    // idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
