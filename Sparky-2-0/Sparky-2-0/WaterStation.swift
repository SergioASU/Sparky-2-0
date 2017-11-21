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
    var rating: String? = nil
    var locationLong: String? = nil
    var locationLat: String? = nil
    var url: String? = nil
    
    init(){}
    init(k:String, n:String, d:String,r:String,lon:String,lat:String, u:String)
    {
        key = k
        name = n
        desc = d
        rating = r
        locationLong = lon
        locationLat = lat
        url = u
    }
}
