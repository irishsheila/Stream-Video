//
//  VideoCell.swift
//  Stream
//
//  Created by Sheila Doherty on 8/22/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    var videoViewModel: VideoViewModel! {
        didSet {
            textLabel?.text = videoViewModel.name
            accessoryType = .disclosureIndicator
        }
    }
    
//    var video: Video! {
//        didSet {
//            textLabel?.text = video.name
//            accessoryType = .disclosureIndicator
//        }
//    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = isHighlighted ? .highlightColor : .white
        textLabel?.textColor = isHighlighted ? UIColor.white : .mainTextBlue
        detailTextLabel?.textColor = isHighlighted ? .white : .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        // cell customization
        textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .black
        detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
