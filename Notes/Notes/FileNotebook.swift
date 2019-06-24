//
//  FileNotebook.swift
//  test
//
//  Created by Kirill Fedorov on 23/06/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

//Создайте файл FileNotebook.swift. В нём вам предстоит реализовать записную книжку.
//Записная книжка должна удовлетворять следующим условиям:
//Объявлена как класс: class FileNotebook.
//Содержит закрытую для внешнего изменения, но открытую для получения коллекцию Note.
//Содержит функцию добавления новой заметки: public func add(_ note: Note).
//Содержит функцию удаления заметки на основе uid: public func remove(with uid: String).
//Содержит функцию сохранения всей записной книжки в файл (public func saveToFile(), сигнатура дана для примера).
//Содержит функцию загрузки записной книжки из файла (public func loadFromFile(), сигнатура дана для примера)

import Foundation

class FileNotebook {
    
    private(set) var notes = [Note]()
    
    public func add(_ note: Note) {
        notes.append(note) // добавляем в массив
        saveToFile() // загружаем в директорию
    }
    
    public func remove(with uid: String) {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        var isDir: ObjCBool = false
        let dirurl = path.appendingPathComponent("Notebooks")
        
        guard let noteForRemove = notes.filter( {$0.uid == uid }).first else { return }
        
        let filePath = dirurl.appendingPathComponent(noteForRemove.title)
        if FileManager.default.fileExists(atPath: filePath.path, isDirectory: &isDir), !isDir.boolValue {
            try? FileManager.default.removeItem(at: filePath) //удаляем из директории
            notes = notes.filter( {$0.uid != uid } ) //удаляем из массива
        } else {
            print("no file at path")
        }
    }
    
    public func saveToFile() { // функцию сохранения всей записной книжки в файл
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dirurl = path.appendingPathComponent("Notebooks") // получаем путь к папке
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), !isDir.boolValue { // проверяем есть ли папка с таким названим
        }
        try? FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: true, attributes: nil) // если нету создаем папку с таким названием
        
        for note in notes {
            let noteJSON = note.json // получаем JSON каждой ноты
            let filename = dirurl.appendingPathComponent("\(note.title)").path //путь файла + название
            do {
                let data = try JSONSerialization.data(withJSONObject: noteJSON, options: []) // получаем дату каждого JSON
                FileManager.default.createFile(atPath: filename, contents: data, attributes: nil) //записываем файл по указанному пути с указанным именем
            } catch {
                print("ERROR")
            }
        }
    }
    
    public func loadFromFile() { //функцию загрузки записной книжки из файла
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dirurl = path.appendingPathComponent("Notebooks") // получаем путь к папке
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), isDir.boolValue { // проверяем есть ли папка с таким названим
            do {
                let folderContent = try FileManager.default.contentsOfDirectory(atPath: dirurl.path) //получаем содержимое папки
                for noteName in folderContent { // проходимся по массиву содержания папки
                    guard let jsdata = FileManager.default.contents(atPath: dirurl.appendingPathComponent(noteName).path) else { break } //получаем дату из папки
                    let jsdict = try JSONSerialization.jsonObject(with: jsdata, options: []) as! [String: Any]  //получаем джейсон
                    if let noteFormFolder = Note.parse(json: jsdict) {
                        notes.append(noteFormFolder)
                    }
                }
            } catch {
                print("ERROR")
            }
        }
    }
}
