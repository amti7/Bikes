//
//  BikeTableViewController.swift
//  Bikes
//
//  Created by Kamil Gacek on 24.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import UIKit

class BikeTableViewController: UITableViewController {
    
    var bikeStationArray: [BikeStation] = []
    
    override func viewDidLoad() {
        var swietokrzyskaBikeStation = BikeStation(id: 1234, district: "Krowodrza", distance: "1000m", address: "Świętokrzyska 32, 31-645", availableBikes: 10, availablePlaces: 50)
        bikeStationArray.append(swietokrzyskaBikeStation)
        
        let nib = UINib(nibName: "BikeCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "BikeCellIdentifier")

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bikeStationArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCellIdentifier", for: indexPath) as? BikeCell else { return UITableViewCell() }
        let station = bikeStationArray[indexPath.row]
        cell.idAndStateLabel.text = String(station.id) + " " + station.district
        cell.distanceLabel.text = station.distance
        cell.addressLabel.text = station.address
        cell.availableBikesLabel.text = String(station.availableBikes)
        cell.availablePlacesLabel.text = String(station.availablePlaces)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 207
    }
    
    
    
}
