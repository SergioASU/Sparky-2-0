//
//  DirectionsViewController.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/26/17.
//  Copyright © 2017 Sergio Corral. All rights reserved.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var mapview: MKMapView!
    
    var userLat : Double = 0.0
    var userLong : Double = 0.0
    
    var station: WaterStation = WaterStation()
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self as! CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(station.locationLat!)!, longitude: Double(station.locationLong!)!), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapview.add(route.polyline)
                self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }         // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.red
        polylineRenderer.lineWidth = 2
        return polylineRenderer
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        //userLocation - there is no need for casting, because we are now using CLLocation object
        
        let userLocation:CLLocation = locations[0]
        
        userLat = Double(userLocation.coordinate.latitude)
        
        userLong = Double(userLocation.coordinate.longitude)
    }

    @IBAction func buttonPressed(_ sender: Any)
    {
        openMapForPlace()
    }
    
    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = Double(station.locationLat!)!
        let longitude: CLLocationDegrees = Double(station.locationLong!)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = station.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
