//
//  BikeTableViewController.swift
//  Bikes
//
//  Created by Kamil Gacek on 24.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import UIKit
import CoreLocation

class BikeTableViewController: UITableViewController, CLLocationManagerDelegate  {
    
    var bikeStationArray: [BikeStation] = []
    var tableViewIndexToNextView = 0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let nib = UINib(nibName: "BikeCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "BikeCellIdentifier")
        retrieveParamsByObjectMapper(withPath: "http://www.poznan.pl/mim/plan/map_service.html?mtype=pub_transport&co=stacje_rowerowe")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
    
    func calculateDistanceBetweenUserAndStation(stationLat: CLLocationDegrees, stationLong: CLLocationDegrees) -> Int{
        if let userLocation = locationManager.location {
            let dist =  Int(distance(lat1: userLocation.coordinate.latitude ,lon1: userLocation.coordinate.longitude, lat2: stationLat, lon2: stationLong, unit: "K") * 1000)
            return dist
        }
        return Int()
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    func deg2rad(deg:Double) -> Double {
        return deg * M_PI / 180
    }
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / M_PI
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bikeStationArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCellIdentifier", for: indexPath) as? BikeCell else { return UITableViewCell() }
        let station = bikeStationArray[indexPath.row]
        cell.idAndStateLabel.text = String(describing: station.id) + " " + station.name
        cell.distanceLabel.text = station.distance
        cell.availableBikesLabel.text = String(describing: station.availableBikes)
        cell.availablePlacesLabel.text = String(describing: station.availablePlaces)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewIndexToNextView = indexPath.row
        performSegue(withIdentifier: "ShowMapSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: MapWithStationViewController = segue.destination as! MapWithStationViewController
        DestViewController.selectedBikeStation = bikeStationArray[tableViewIndexToNextView]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 207
    }
    
    func retrieveParamsByObjectMapper(withPath: String){
        guard let url = URL(string: withPath) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {
                    print("error")
                    return
                }
                guard let features = json["features"] as? Array<Any> else { return }
                for feature in features {
                    guard let dict = feature as? Dictionary<String,Any> else { return }
                    guard let bikeStation = BikeStation(JSON: dict) else { return }
                    let distance = self?.calculateDistanceBetweenUserAndStation(stationLat: CLLocationDegrees(bikeStation.coordinateY), stationLong: CLLocationDegrees(bikeStation.coordinateX))
                    if let distance = distance {
                         bikeStation.distance = String(distance) + "m"
                    }
                    self?.bikeStationArray.append(bikeStation)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                fatalError("Error: Unnable to parse JSON...")
            }
            }.resume()
    }
}
