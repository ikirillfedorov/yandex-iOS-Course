//
//  Note.swift
//  test
//
//  Created by Kirill Fedorov on 23/06/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation
import UIKit

enum Importance: String {
    case unimportant
    case ordinary
    case important
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let noteColor: UIColor
    let importance: Importance
    let destractionDate: Date?
    
    init(uid: String?, title: String, content: String, noteColor: UIColor?, importance: Importance, destractionDate: Date?) {
        self.uid = uid ?? UUID().uuidString
        self.title = title
        self.content = content
        self.noteColor = noteColor ?? .white
        self.importance = importance
        self.destractionDate = destractionDate
    }
}
