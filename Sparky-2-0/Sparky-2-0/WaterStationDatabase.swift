//
//  WaterStationDatabase.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/27/17.
//  Copyright © 2017 Sergio Corral. All rights reserved.
//

import Foundation

class WaterStationDatabase
{
    var waterStationArray : Array <WaterStation> = Array()
    
    init()
    {
        
    }
    
    func addWaterStation(w:WaterStation)
    {
        waterStationArray.append(WaterStation)
    }
    
    func search(n:name)->Int
    {
        var index = -1
        var count = 0;
        for station in waterStationArray
        {
            if (station.name == name)
            {
                index = count
                break
            }
            count++
        }
        
        return index
    }

}
