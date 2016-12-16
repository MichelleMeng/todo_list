//
//  TodoModel.swift
//  Todo
//
//  Created by MichelleMeng on 16/11/8.
//  Copyright © 2016年 MichelleMeng. All rights reserved.
//

import UIKit

// 这个 Model 就是 MVC 里的 M

class TodoModel_old: NSObject {
    
    // 任何model都建议有一个id
    var id: String
    
    // image name, 是一个String
    var image: String
    
    var title: String
    var date: NSDate
    
    init(id: String, image: String, title: String, date: NSDate) {
        self.id = id
        self.image = image
        self.title = title
        self.date = date
    }

}

