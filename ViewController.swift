//
//  ViewController.swift
//  mapView
//
//  Created by 맥 14 on 2017. 5. 12..
//  Copyright © 2017년 yangjung. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var lblLoInfo1: UILabel!
    @IBOutlet weak var lblLoInfo2: UILabel! // 각각의 아울렛 변수 설정
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lblLoInfo1.text = ""
        lblLoInfo2.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도 최고 설정
        locationManager.requestWhenInUseAuthorization() // 위치 데이터에 대한 사용자 승인 요청
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        myMap.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goLocation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue : CLLocationDegrees, delta span :Double)-> CLLocationCoordinate2D{
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpanMake(span, span)
        let pRegion = MKCoordinateRegionMake(pLocation, spanValue)
        myMap.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    func setAnnotation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue : CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubtitle:String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitude: latitudeValue, longitude: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last // 위치 업데이트시 마지막 위치 값 찾기
        goLocation(latitude: (pLocation?.coordinate.latitude)!, longitude: (pLocation?.coordinate.longitude)!, delta: 0.01)// 지도를 100배 확대
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country // 상수의 나라값 대입
            var address:String = country!
            
            if pm!.locality != nil{
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil{
                address += " "
                address += pm!.thoroughfare!
            
            }
            
            self.lblLoInfo1.text = "현재 위치" // 레이블에 현재 위치 표시
            self.lblLoInfo2.text = address // 문자열값 표시
        })
        
        locationManager.stopUpdatingLocation() // 마지막 위치 업데이트 멈춤
    }
    
    // 특정 위치의 위도와 경도 값 찾기
    // http://www.iegate.net/maps/rgeogoogle.php
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
        
            // 현재 위치 표시
            self.lblLoInfo1.text = ""
            self.lblLoInfo2.text = ""
            locationManager.startUpdatingLocation()
            // 레이블 값 초기화 , 기존 작성되어있던 텍스트 삭제 후 현재 위치 표시
        } else if sender.selectedSegmentIndex == 1 {
        
            // 남이섬
            
            setAnnotation(latitude: 37.7913541, longitude: 127.52554179999993 , delta: 1, title: "춘천 남이섬", subtitle: "강원도 춘천시 남산면 남이섬길1")
            self.lblLoInfo1.text = "보고 계신 위치"
            self.lblLoInfo2.text = "춘천 남이섬"
            
        } else if sender.selectedSegmentIndex == 2 {
        
            // 제주도
            
            setAnnotation(latitude: 33.4890113, longitude: 126.49830229999998, delta: 1, title: "제주도", subtitle: "제주특별자치도")
            self.lblLoInfo1.text = "보고 계신 위치"
            self.lblLoInfo2.text = "제주특별자치도"
        } else if sender.selectedSegmentIndex == 3 {
        
            // 우리집
            setAnnotation(latitude: 35.1568124 , longitude: 129.05881550000004, delta: 1, title: "우리집", subtitle: "부산광역시 부전동")
            self.lblLoInfo1.text = "보고 계신 위치"
            self.lblLoInfo2.text = "부산광역시 부전동"
        }
    }
}

