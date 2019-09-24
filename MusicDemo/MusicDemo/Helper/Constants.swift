//
//  Constants.swift
//  MusicDemo
//
//  Created by  on 23/09/19.
//

import UIKit

final class Constants: NSObject {
    
    static let shared = Constants()
    class func loadSongArray() -> [SongsArray]{
        var arrayData:[SongsArray] = []
        for i in 0..<arraySong.count{
            let obj = SongsArray(name: arrayTitle[i], url: arraySong[i], image: arratImage[i])
            arrayData.append(obj)
        }
        return arrayData
    }

}

// MARK:-  Arral List OF Songs
var arraySong:[String] = ["https://www.swaminarayanbhagwan.org/wp-content/uploads/2019/08/03-Hu-To-Chhu-Mix.mp3" , "https://www.swaminarayanbhagwan.org/wp-content/uploads/2019/08/02-Pritam-Par-Mix.mp3","https://www.swaminarayanbhagwan.org/wp-content/uploads/2018/08/02-Shu-Kahu-Krupa-Tamari.mp3","https://www.swaminarayanbhagwan.org/wp-content/uploads/2019/08/06-Prabhu-Preme-Mix.mp3","https://www.swaminarayanbhagwan.org/wp-content/uploads/2019/08/04-Sahajanand-Sukhkand-Mix.mp3"]
var arrayTitle:[String] = ["Hu To Chhu" , "Pritam Par Varu" , "Shu Kahu Krupa Tamari" , "Prabhu Preme","Sahajanand Sukhkand"]
var arratImage:[String] = ["Khumari.jpg" , "Stuti.jpg"  , "Shukahu.jpg" , "Khumari.jpg","Stuti.jpg"]


