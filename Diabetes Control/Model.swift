//
//  Model.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 14/10/22.
//


import UIKit

struct Model {
    
    let iconImage: UIImage
    let title: String
    let dateAndTime: String
    let type: String
    
    init(iconImage: UIImage,
         title: String,
         dateAndTime: String,
         type: String) {
        self.iconImage = iconImage
        self.title = title
        self.dateAndTime = dateAndTime
        self.type = type
    }
    
}




