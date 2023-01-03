//
//  Category.swift
//  taskapp
//
//  Created by 伊藤敬 on 2022/12/22.
//

import RealmSwift

class Category: Object {
    // 管理用ID。プライマリーキー。
    @objc dynamic var id = 1
    
    // カテゴリー名称
    @objc dynamic var name = ""
    
    // idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
