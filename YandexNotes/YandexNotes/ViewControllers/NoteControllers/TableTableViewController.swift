//
//  TableTableViewController.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 14/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {
    
    var notebook = FileNotebook()
    var selectedNote: Note? = nil
    var reuseIdentifier = "NoteCell"
    
    @IBOutlet var notesTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBAction func editBarButtonAction(_ sender: UIBarButtonItem) {
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
        
        let editingBarButton = UIBarButtonItem(barButtonSystemItem: isEditing ? .edit : .done, target: self, action: #selector(editBarButtonAction))
        navigationItem.leftBarButtonItem = editingBarButton
    }
    
    @IBAction func addNoteBarButton(_ sender: UIBarButtonItem) {
        selectedNote = nil
        performSegue(withIdentifier: "ShowEditController", sender: nil)
    }
    
    override func viewWillLayoutSubviews() {
        guard let navController = navigationController as? NotesNavController else { return }
        notebook = navController.notebook
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.delaysContentTouches = false
        title = "Notes"
        
        guard let navController = navigationController as? NotesNavController else { return }
        notebook = navController.notebook
        
        notesTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    //MARK: - Supported functions
    private func getNote(at indextPath: IndexPath) -> Note {
        let notes = Array(notebook.notes.values).sorted { (firstNote, secondNote) -> Bool in
            firstNote.title < secondNote.title
        }
        return notes[indextPath.row]
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = getNote(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.noteTitleLabel.text = note.title
        cell.noteContentLable.text = note.content
        cell.noteContentLable.numberOfLines = 5
        cell.noteColorLabel.backgroundColor = note.noteColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = getNote(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowEditController", sender: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditNoteViewController, segue.identifier == "ShowEditController" {
            controller.selectedNote = self.selectedNote
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = getNote(at: indexPath)

        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .left)
            notebook.remove(with: note.uid)
        }, completion: nil)
        guard let navController = navigationController as? NotesNavController else { return }
        navController.commonQueue.addOperation(RemoveNoteOperation(note: note,
                                                         notebook: navController.notebook,
                                                         backendQueue: navController.backendQueue,
                                                         dbQueue: navController.dbQueue))
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
}
