//
//  ViewController.swift
//  appTwo
//
//  Created by Eric Fuentes on 8/28/18.
//  Copyright © 2018 Eric Fuentes. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var lat: UITextField!
 
    @IBOutlet weak var longitude: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var radius: UITextField!
    
    @IBOutlet weak var thyerror: UILabel!
    
    
    
//    let URL_IMAGE = URL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
    
    var locationManager: CLLocationManager!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radius.delegate = self
        radius.keyboardType = .numberPad
        // Do any additional setup after loading the view, typically from a nib.
//        roundButton.layer.cornerRadius = 10.0
//        roundButton.layer.masksToBounds = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        thyerror.isHidden = true
       
    }
    
    
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
        
        longitude.text = "\(userLocation.coordinate.latitude)"
        lat.text = "\(userLocation.coordinate.longitude)"
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
//        var coord = locationObj.coordinate
        print("Error \(error)")
    }

   
    
   
    @IBAction func create(_ sender: UIButton) {
        
        self.thyerror.isHidden = true
        
        if let userName = self.userName.text,
            let radius = self.radius.text,
            userName.count > 3,
            radius.count > 0{
            
            print("User: " + userName + " radius: " + radius )
            determineMyCurrentLocation()
           
            let lat = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
            
            let parameters = ["username": userName, "radius": radius, "latitude": lat, "longitude": longitude] as [String : Any]
            
            
            
            guard let url = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(userName).json")else{return}
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
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
                    }catch{
                    print(error)
                    }
                }
            }.resume()
            
//            guard let url = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(userName).json")else{return}
//            let session = URLSession.shared
//            session.dataTask(with: url){ (data, response, error) in
//                if let response = response{
//                    print(response)
//                }
//                if let data = data {
//                    print(data)
//                    do{
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                    }catch{
//                        print(error)
//                    }
//                }
//
//                }.resume()
//        } else {
//            //display error
//
//            print("Error no text")
//        }
        
    }
    
//
//    @IBAction func click(_ sender: Any) {
//
//        let jsonText = "{\"first_name\":\"Sergey\"}"
//        var dictonary:NSDictionary?
//
//        if let data = jsonText.data(using: String.Encoding.utf8) {
//
//            do {
//                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
//
//                if let myDictionary = dictonary
//                {
//                    print(" First name is: \(myDictionary["first_name"]!)")
//                }
//            } catch let error as NSError {
//                print(error)
//            }
//        }
//
//        print("clicked \(jsonText)")
         determineMyCurrentLocation()

//        let session = URLSession(configuration: .default)
//
//        //creating a dataTask
//        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
//
//            //if there is any error
//            if let e = error {
//                //displaying the message
//                print("Error Occurred: \(e)")
//
//            } else {
//                //in case of now error, checking wheather the response is nil or not
//                if (response as? HTTPURLResponse) != nil {
//
//                    //checking if the response contains an image
//                    if let imageData = data {
//
//                        //getting the image
//                        let image = UIImage(data: imageData)
//
//                        DispatchQueue.main.async {
//                            //displaying the image
//                            self.imageView.image = image
//
//                        }
//
//
//                    } else {
//                        print("Image file is currupted")
//                    }
//                } else {
//                    print("No response from server")
//                }
//            }
//        }
//
//        //starting the download tas
//        getImageFromUrl.resume()
//
//    }
    
    
}
    
    @IBAction func upDate(_ sender: UIButton) {
        
        self.thyerror.isHidden = true
        
        if let userName = self.userName.text,
            let radius = self.radius.text,
            userName.count > 3,
            radius.count > 0
        {
            
            guard let urlGet = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(userName).json") else {return}
            
            let session = URLSession.shared
            session.dataTask(with: urlGet) { (data, response, error) in
                
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
                
                self.determineMyCurrentLocation()
                let lat = self.locationManager.location?.coordinate.latitude
                let longitude = self.locationManager.location?.coordinate.longitude
                
                let okay = ["username": userName, "radius": radius, "latitude": lat!, "longitude": longitude!] as [String : Any]
                
                guard let url = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(userName).json")else{return}
                
                var request = URLRequest(url: url)
                request.httpMethod = "PATCH"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: okay, options: []) else {return}
                request.httpBody = httpBody
                
                
                session.dataTask(with: request) { (data, response, error) in
                    
                    if error==nil {
                        DispatchQueue.main.async {
                        self.thyerror.isHidden = false
                        self.thyerror.text = "USER DATA UPDATED"
                            self.thyerror.backgroundColor = UIColor.green }
                    }
                    
                    
                }.resume()
                

            }
                
                
            }.resume()
            
   
        }
    }
    
    @IBAction func status(_ sender: UIButton) {
        
        
        guard let userName = userName.text, userName.count > 3 else {
            self.thyerror.isHidden = false
            self.thyerror.text = "Please provide the username!"
            return
            
        }
        
        self.thyerror.isHidden = true
//        if userName == nil{
//            self.thyerror.isHidden = true}
//        else{
//        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//            self.thyerror.isHidden = false
//        }
//        }
       
        guard let url = URL(string: "https://turntotech.firebaseio.com/digitalleash/\(userName).json") else {return}

        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
   
            if let data = data{
                
                do {
                   let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    let parentLat = dictionary!["latitude"] as! CLLocationDegrees
                    let parentLon = dictionary!["longitude"] as! CLLocationDegrees
                    
                   let parentLoc = CLLocation(latitude: parentLat, longitude: parentLon)
//                    print("parentLat: \(parentLat)")
                    
                    let childLat = dictionary!["current_latitude"] as! CLLocationDegrees
                    let childLon = dictionary!["current_longitude"] as! CLLocationDegrees
                    
                    let childLoc = CLLocation (latitude: childLat, longitude: childLon)
                    
                    let distance = Double(childLoc.distance(from: parentLoc))
                    
                    let radiusString = dictionary!["radius"] as! String
                    let radius = Double(radiusString)
                    
//                    if distance < 50 {
//
//
//
//                    }
                    
                   DispatchQueue.main.async {
                    if distance < radius! {
                    self.performSegue(withIdentifier: "KeepDrinking", sender: nil)
                    }else {
                    self.performSegue(withIdentifier: "outZone", sender: nil)
                    }
                    }
                    
                    
                } catch let error as NSError {
                    print("USER DOES NOT EXIST")
                    print(error)
                    DispatchQueue.main.async {
                    self.thyerror.isHidden = false
                        self.thyerror.text = "USER DOES NOT EXIST"}
                    return
                    
                    //error handling if user not exist in database
                    print(error)
                }
                
                print("DATA: \(data)")
            }
        }.resume()
        
    }

}
//}

