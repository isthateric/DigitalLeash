//
//  ViewController.swift
//  childApp
//
//  Created by Eric Fuentes on 9/10/18.
//  Copyright © 2018 Eric Fuentes. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var thyerror: UILabel!
    
    
   
//    let lat = locationManager.location?.coordinate.latitude
//    let lon = locationManager.location?.coordinate.longitude
    var locationManager: CLLocationManager!
    
    var lati: CLLocationDegrees!
    var longi: CLLocationDegrees!
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    // Location manager delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        print("\(userLocation.coordinate.latitude)")
        print("\(userLocation.coordinate.longitude)")
        
        lati = userLocation.coordinate.latitude
        longi = userLocation.coordinate.longitude
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        //        var coord = locationObj.coordinate
        print("Error \(error)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        thyerror.isHidden = true
    }
    
    @IBAction func report(_ sender: UIButton) {
        
        if let username = self.username.text,
            username.count > 3{
            
                guard let urlGet = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(username).json") else {return}

                let session = URLSession.shared
                session.dataTask(with: urlGet) { (data, response, error) in
                    
                    
                    if(error != nil){
                        
                        DispatchQueue.main.async {
                            self.thyerror.isHidden = false
                            self.thyerror.text =  error.debugDescription
                            self.thyerror.backgroundColor = UIColor.red
                        }
                        
                        return;
                        
                    }
                    

                    let backToString = String(data: data!, encoding: String.Encoding.utf8) as String?
                    if backToString == "null" {

                        print("USER DOES NOT EXIST")
                        DispatchQueue.main.async {
                            self.thyerror.isHidden = false
                            self.thyerror.text = "USER DOES NOT EXIST"
                            self.thyerror.backgroundColor = UIColor.red
                        }
                        
                    }
                    else {
                        
                        print("User: " + username)
                        self.determineMyCurrentLocation()
            
                        self.lati = self.locationManager.location?.coordinate.latitude
                        self.longi = self.locationManager.location?.coordinate.longitude
            
                        let childDict = [ "current_latitude": self.lati, "current_longitude": self.longi ] as [String : Any]
            
                        guard let url = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(username).json")else{return}
                        
                        var request = URLRequest(url: url)
                        request.httpMethod = "PATCH"
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        guard let httpBody = try? JSONSerialization.data(withJSONObject: childDict, options: []) else {return}
                        request.httpBody = httpBody
            
                        let session = URLSession.shared
                        session.dataTask(with: request) { (data, response, error) in
                
                            if let response = response {
                                print(response)
                            }
                            if let data = data {
                                do{
                                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                                    print(json)
                        
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "theReporttt", sender: nil)

                                    }
                        
                                }catch{
                                    print(error)
                                }
                            }
                            
                        }.resume()
        
                    }
   
                }.resume()

    }
    }
}
