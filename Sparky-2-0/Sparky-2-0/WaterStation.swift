//
//  WaterStation.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/27/17.
//  Copyright © 2017 Sergio Corral. All rights reserved.
//

import Foundation

class WaterStation
{
    var key: String? = nil
    var name: String? = nil
    var desc: String? = nil
    var rating: Int? = nil
    var locationLong: Double? = nil
    var locationLat: Double? = nil
    
    init(k:String, n:String, d:String,r:Int,lon:Double,lat:Double)
    {
        key = k
        name = n
        desc = d
        rating = r
        locationLong = lon
        locationLat = lat
    }
}
