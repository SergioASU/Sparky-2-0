//
//  StationCell.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/24/17.
//  Copyright © 2017 Sergio Corral. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell
{
    
    /*
     *   UIComponents used for the cell in the table view
     
     *   waterPicture will show either a picture of the station or an icon representing quality of water
     
     *   stationNameLabel will show the name of the water station
     
     *   stationRatingLabel will show rating out of 5
     */
    
    @IBOutlet weak var waterPicture: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationRatingLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
