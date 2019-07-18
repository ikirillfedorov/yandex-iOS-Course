//
//  NoteExtensions.swift
//  test
//
//  Created by Kirill Fedorov on 23/06/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation
import UIKit

//Реализуйте расширение структуры Note, которое:
//Содержит функцию для разбора json: static func parse(json: [String: Any]) -> Note?.
//Содержит вычислимое свойство для формирование json: var json: [String: Any].
//Если цвет НЕ белый, сохраняет его в json.
//Если важность «обычная», НЕ сохраняет её в json.
//UIColor, enum, Date сохраняет в json НЕ в виде сложных объектов. То есть допустимы любые скалаярные типы (Int, Double, …), строки, массивы и словари.

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .short
    return formatter
}()



enum ParseError: Error {
    case wrongFormat
}

extension Note {
    
    private enum CodingKeys: String {
        case uid
        case title
        case content
        case noteColor
        case importance
        case destractionDate
    }
    
    static func parse(json: [String: Any]) -> Note? {
        let note: Note?
        do {
            let jsdata = try JSONSerialization.data(withJSONObject: json, options: [])
            
            guard
                let jsdict = try JSONSerialization.jsonObject(with: jsdata, options: []) as? [String: Any],
                let title = jsdict[CodingKeys.title.rawValue] as? String,
                let content = jsdict[CodingKeys.content.rawValue] as? String,
                let importancetring = jsdict[CodingKeys.importance.rawValue] as? String,
                let importance = Importance.init(rawValue: importancetring) else {
                    throw ParseError.wrongFormat
            }
            
            var noteColor: UIColor? = nil
            if let colorComponents = jsdict[CodingKeys.noteColor.rawValue] as? [String: Int],
                let r = colorComponents["red"],
                let g = colorComponents["green"],
                let b = colorComponents["blue"],
                let a = colorComponents["alpha"] {
                noteColor = UIColor.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
            }
            
            var destractionDate: Date?
            if let dateString = jsdict[CodingKeys.destractionDate.rawValue] as? String {
                destractionDate = formatter.date(from: dateString)
            }
            
            let uid = jsdict[CodingKeys.uid.rawValue] as? String
            
            note = Note(uid: uid, title: title, content: content, noteColor: noteColor, importance: importance, destractionDate: destractionDate)
            
        } catch let error {
            note = nil
            print(error)
        }
        return note
    }
    
    var json: [String: Any] {
        var dict: [String: Any] = [
            CodingKeys.uid.rawValue: self.uid,
            CodingKeys.title.rawValue: self.title,
            CodingKeys.content.rawValue: self.content
        ]
        
        if self.importance != .ordinary {
            dict[CodingKeys.importance.rawValue] = self.importance.rawValue
        }
        
        if let date = destractionDate {
            dict[CodingKeys.destractionDate.rawValue] = formatter.string(from: date)
        }
        
        if self.noteColor != .white {
            var fRed: CGFloat = 0
            var fGreen: CGFloat = 0
            var fBlue: CGFloat = 0
            var fAlpha: CGFloat = 0
            self.noteColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
            
            let rgba = [
                "red": Int(fRed * 255),
                "green": Int(fGreen * 255),
                "blue": Int(fBlue * 255),
                "alpha": Int(fAlpha * 255)
            ]
            dict[CodingKeys.noteColor.rawValue] = rgba
        }
        return dict
    }
}

