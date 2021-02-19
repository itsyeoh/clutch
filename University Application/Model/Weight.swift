//
//  Weight.swift
//  Clutch
//
//  Created by Jason Yeoh on 10/16/19.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation

class Weight {
    let wid: Int64!
    var cid: Int64!
    var weightName: String!
    var weight: Float!
    
    init(wid: Int64, cid: Int64) {
        self.wid = wid
        self.cid = cid
        self.weightName = ""
        self.weight = 0.0
    }
    
    init(wid: Int64, cid: Int64, weightName: String, weight: Float) {
        self.wid = wid
        self.cid = cid
        self.weightName = weightName
        self.weight = weight
    }
}
