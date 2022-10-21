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
    
    //    init(from decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        //iconImage = try container.decode(UIImage.self, forKey: .iconImage)
    //        let data = try container.decode(Data.self, forKey: .iconImage)
    //        guard let iconImage = UIImage(data: data) else {
    //            throw DiabetesError.notWorking
    //        }
    //        self.iconImage = iconImage
    //        title = try container.decode(String.self, forKey: .title)
    //        dateAndTime = try container.decode(String.self, forKey: .dateAndTime)
    //        type = try container.decode(String.self, forKey: .type)
    //
    //    }
    //
    //    func encode(to encoder: Encoder) throws {
    //        var container = encoder.container(keyedBy: CodingKeys.self)
    //        if let data = iconImage?.pngData() {
    //            try container.encode(data, forKey: .iconImage)
    //
    //        } else {
    //            try container.encodeNil(forKey: .iconImage)
    //        }
    //        try container.encode (title, forKey: .title)
    //        try container.encode (dateAndTime, forKey: .dateAndTime)
    //        try container.encode (type, forKey: .type)
    //    }
    //
    //    enum CodingKeys: String, CodingKey {
    //        case iconImage = "iconImage"
    //        case title, dateAndTime, type
    //    }
        
    
}





