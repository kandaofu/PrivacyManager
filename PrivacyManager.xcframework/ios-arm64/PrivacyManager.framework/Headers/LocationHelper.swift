//
//   LocationHelper.swift
//   PrivacyManager
//
//   Created by Apple on 2025/6/20
//   
//
   

import UIKit
import CoreLocation
 
public class LocationHelper: NSObject ,CLLocationManagerDelegate {
    
    public static var shared = LocationHelper()
    
    public var latitude:Double = 0
    public var longitude:Double = 0
    
    var latitudeKey:String = ""
    var longitudeKey:String = ""
    var administrativeAreaKey:String = ""
    var isoCountryCodeKey:String = ""
    var countryKey:String = ""
    var thoroughfareKey:String = ""
    var localityKey:String = ""
    var subLocalityKey:String = ""
    
    var locationManager = CLLocationManager()
    var locationDidSet:Bool = false
    var locationResult:((_ locationBool:Bool,_ locationInfo:[String:Any]) -> Void)?
    
    public func initKey(latitudeKey:String,longitudeKey:String,administrativeAreaKey:String,isoCountryCodeKey:String,countryKey:String,thoroughfareKey:String,localityKey:String,subLocalityKey:String) {
        self.latitudeKey = latitudeKey
        self.longitudeKey = longitudeKey
        self.administrativeAreaKey = administrativeAreaKey
        self.isoCountryCodeKey = isoCountryCodeKey
        self.countryKey = countryKey
        self.thoroughfareKey = thoroughfareKey
        self.localityKey = localityKey
        self.subLocalityKey = subLocalityKey
    }
    
    public func requestLocationState(){
        locationDidSet = false
        locationStartUpdating()
    }
    
    public func getLocationInfo(locationResult:@escaping((_ locationBool:Bool,_ locationInfo:[String:Any])->Void)){
        self.locationResult = locationResult
        locationDidSet = true
        locationStartUpdating()
        refrenshAuthorizationStatus()
    }
    
    private func locationStartUpdating(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func refrenshAuthorizationStatus(){
        let locationStatus: CLAuthorizationStatus = {
            if #available(iOS 14.0, *) {
                return locationManager.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }()
        if locationStatus == .denied || locationStatus == .restricted{
            locationResult?(false,[:])
            locationResult = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationManager.stopUpdatingLocation()
            return
        }
       
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        guard locationDidSet else {
            locationManager.stopUpdatingLocation()
            return
        }
        
        var locationParams:[String:Any] = [latitudeKey:self.latitude,longitudeKey:self.longitude]
        
        let geocoder = CLGeocoder()
        let locationLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(locationLocation) { locationPlaceMark, error in

            if let error = error {
                print("reverseGeocodeLocation Error: \(error.localizedDescription)")
                self.locationDidSet = false
                self.locationResult?(true,locationParams)
                self.locationResult = nil
                return
            }
            
            guard let locationInfo = locationPlaceMark?.first else {
                self.locationDidSet = false
                self.locationResult?(true,locationParams)
                self.locationResult = nil
                return
            }
            locationParams[self.administrativeAreaKey] = locationInfo.administrativeArea ?? ""
            locationParams[self.isoCountryCodeKey] = locationInfo.isoCountryCode ?? ""
            locationParams[self.countryKey] = locationInfo.country ?? ""
            locationParams[self.thoroughfareKey] = "\(locationInfo.thoroughfare ?? "")\(locationInfo.subThoroughfare ?? "")"
            locationParams[self.localityKey] = locationInfo.locality ?? ""
            locationParams[self.subLocalityKey] = locationInfo.subLocality ?? ""
            self.locationDidSet = false
            self.locationManager.stopUpdatingLocation()
            self.locationResult?(true,locationParams)
            self.locationResult = nil
        }
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        refrenshAuthorizationStatus()
    }
    
    
}
