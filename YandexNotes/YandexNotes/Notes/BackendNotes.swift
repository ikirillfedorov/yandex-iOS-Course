//
//  BackendNotes.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 10/08/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation
import UIKit

enum LoadBackendResult {
    case success
    case failure(NetworkError)
}

class BackendNotes {
    
    static var gistId: String?
    let navContoller = NotesNavController()
    var token = "d7979931ab657bfebe7af6b054d342db4815e6bd"
    let gistsUrl = "https://api.github.com/gists"
    
    var notes: [String: Note] = [:]
    var result: LoadBackendResult = .success
    
    struct Gist: Codable {
        let files: [String: GistFile]
        let id: String
    }
    
    struct GistFile: Codable {
        let filename: String
        let rawUrl: String
        
        enum CodingKeys: String, CodingKey {
            case filename
            case rawUrl = "raw_url"
        }
    }
    
    func getGistContent(completionHandler: @escaping () -> ()) {
        // First URLSession allow get raw_url
        var rawUrl: String?
        let component = URLComponents(string: self.gistsUrl)
        let url = component?.url
        
        guard let newUrl = url else { return }
        var urlRequest = URLRequest(url: newUrl)
        urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!)
                self.result = .failure(.error)
                print(self.result)
                completionHandler()
                return
            }
            guard let data = data else {
                self.result = .failure(.noData)
                print(self.result)
                completionHandler()
                return
            }
            guard let gists = try? JSONDecoder().decode([Gist].self, from: data) else {
                self.result = .failure(.parseError)
                print(self.result)
                completionHandler()
                return
            }
            
            for gist in gists {
                if let file = gist.files["ios-course-notes-db"] {
                    rawUrl = file.rawUrl
                    BackendNotes.gistId = gist.id
                }
            }
            // Second URLSession allow get data from gist by raw_url
            guard let rawUrl = rawUrl else {
                self.result = .failure(.nwErrorOrNotFileExtist)
                BackendNotes.gistId = nil
                print(self.result)
                completionHandler()
                return
            }
            
            let component = URLComponents(string: rawUrl)
            guard let url = component?.url else { return }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("token \(self.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    print(error as Any)
                    self.result = .failure(.error)
                    completionHandler()
                    return
                }
                
                guard let data = data else {
                    self.result = .failure(.noData)
                    print("no data")
                    completionHandler()
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                    self.notes = [:]
                    for item in json {
                        if let note = Note.parse(json: item) {
                            self.notes[note.uid] = note
                        }
                    }
                    self.result = .success
                    completionHandler()
                } catch {
                    print(error)
                    self.result = .failure(.error)
                    completionHandler()
                }
            }.resume()
        }.resume()
    }
    
    
    
    func setContentForGist(notes: [String: Note], completionHandler: @escaping () -> Void) {
        // Update/create GitHub Gist file
        self.notes = notes
        if BackendNotes.gistId != nil {
            // if file exist - update it
            var result = [[String: Any]]()
            for value in self.notes.values {
                result.append(value.json)
            }
            
            let component = URLComponents(string: "\(self.gistsUrl)/\(BackendNotes.gistId!)")
            let url = component?.url
            var request = URLRequest(url: url!)
            request.httpMethod = "PATCH"
            request.setValue("token \(self.token)", forHTTPHeaderField: "Authorization")
            let jsonData = try! JSONSerialization.data(withJSONObject: result, options: [])
            request.httpBody = try! JSONSerialization.data(withJSONObject: ["description": "Notes", "files":["ios-course-notes-db":["content": String(data: jsonData, encoding: .utf8)!, "filename":"ios-course-notes-db"]]])
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        print("ios-course-notes-db was UPDATED")
                        self.result = .success
                        completionHandler()
                    default:
                        print("Status: \(response.statusCode)")
                        self.result = .failure(.error)
                        completionHandler()
                    }
                }
                }.resume()
        } else {
            // if file not exist - create file
            var result = [[String: Any]]()
            for value in self.notes.values {
                result.append(value.json)
            }
            let component = URLComponents(string: "\(self.gistsUrl)")
            let url = component?.url
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("token \(self.token)", forHTTPHeaderField: "Authorization")
            let jsonData = try! JSONSerialization.data(withJSONObject: result, options: [])
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: ["description": "Notes", "public":false, "files":["ios-course-notes-db":["content": String(data: jsonData, encoding: .utf8)!]]])
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        guard let data = data else { return }
                        do {
                            let gist = try JSONDecoder().decode(Gist.self, from: data)
                            BackendNotes.gistId = gist.id
                            print(BackendNotes.gistId!, "ID FROM CREATING REQUEST")
                        } catch {
                            print(error)
                        }
                        print("ios-course-notes-db was CREATED")
                        self.result = .success
                        completionHandler()
                    default:
                        print("Status: \(response.statusCode)")
                        self.result = .failure(.error)
                        completionHandler()
                    }
                }
            }.resume()
        }
    }
}

