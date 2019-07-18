//
//  NoteTableViewCell.swift
//  YandexNotes
//
//  Created by Kirill Fedorov on 14/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteColorLabel: UIView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteContentLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
