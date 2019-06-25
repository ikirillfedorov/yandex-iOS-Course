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
    
    private(set) var notes = [String: Note]()
    
    private let folderName = "NoteBooks"
    private let fileName = "NoteBook"
    private let fileManager = FileManager.default
    
    private var dirUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("NoteBook")

    //MARK - help functions
    private func getDirectoryUrl(folderName: String) -> URL {
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent(folderName)
    }
    
    private func getPath() -> URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    
    public func add(_ noteBook: Note) {
        notes[noteBook.uid] = noteBook // добавляем в массив
    }
    
    public func remove(with uid: String) {
        notes[uid] = nil //если нота в дикшенари по такому ключу есть, удаляем ее
    }
    
    public func saveToFile() { // функцию сохранения всей записной книжки в файл
        let path = getPath() //получаем путь к папке Caches
        let dirurl = path.appendingPathComponent(folderName) // получаем путь к папке
        var isDir: ObjCBool = false
        print(dirurl)
        if !(fileManager.fileExists(atPath: dirurl.path, isDirectory: &isDir) && isDir.boolValue) { // проверяем есть ли папка с таким названим по указаному пути
            try? fileManager.createDirectory(at: dirurl, withIntermediateDirectories: true, attributes: nil) // если нету создаем папку с таким названием по указанному пути
        }
        let filePath = dirurl.appendingPathComponent(fileName).path //создаем путь файла + название
        do {
            let data = try JSONSerialization.data(withJSONObject: notes.map { $0.value.json }, options: []) // получаем масств дат JSON
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil) //записываем файл по указанному пути с указанным именем
        } catch let error {
            print(error)
        }
    }
    
    public func loadFromFile() { //функцию загрузки записной книжки из файла
        let path = getPath() //получаем путь к папке
        let dirurl = path.appendingPathComponent(folderName) // получаем путь к папке
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: path.path, isDirectory: &isDir), isDir.boolValue { // проверяем есть ли папка с таким названим
            do {
                let filePath = dirurl.appendingPathComponent(fileName).path //получаем путь к файлу
                guard let jsdata = fileManager.contents(atPath: filePath) else { return } //получаем дату из папки
                let jsArray = try JSONSerialization.jsonObject(with: jsdata, options: []) as! [[String: Any]]  //получаем джейсон
                
                for json in jsArray { // проходимся по массиву джейсонов
                    if let note = Note.parse(json: json) { //анрапаем
                        notes[note.uid] = note // если джейсон не нил добавляем в словарь элемент типа [String: Note] (ключ uid)
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
}
