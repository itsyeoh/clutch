//
//  Grade.swift
//  University Application
//
//  Created by Jason Yeoh on 10/16/19.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation

class Grade {
    let cid: Int64!
    let tid: Int64!
    var rawScore: Int!
    var totalScore: Int!
    var percentage: Float
    
    init(cid: Int64, tid: Int64, rawScore: Int, totalScore: Int) {
        self.cid = cid
        self.tid = tid
        self.rawScore = rawScore
        self.totalScore = totalScore
        self.percentage = Float(rawScore)/Float(totalScore)
    }
}
