//
//  SongsArray.swift
//  MusicDemo
//
//  Created by  on 23/09/19.
//

import UIKit

class SongsArray: NSObject {
 
    var name:String?
    var songUrl:String?
    var albbumImage:String?
    
    init(name:String , url:String , image:String)
    {
        self.name = name
        self.songUrl = url
        self.albbumImage = image
    }
}

private var AssociatedObjectHandle1: UInt8 = 0
extension SongsArray   {
    var isSelected:Bool{
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle1) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle1, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
