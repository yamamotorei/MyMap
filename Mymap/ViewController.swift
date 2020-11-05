//
//  ViewController.swift
//  Mymap
//
//  Created by 山本怜 on 2020/11/05.
//

import UIKit
import MapKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputText.delegate = self
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
        textField.resignFirstResponder()
        //値がある場合のみ入力された文字をデバッグ（アンラップ）
        if let searchKey = textField.text{
            print(searchKey)
            //CLGeocorderインスタンスを取得
            let geocorder = CLGeocoder()
            //入力された文字から位置情報を取得
            geocorder.geocodeAddressString(searchKey, completionHandler:{ (placemarks,error) in
                
                if let unwrapPlacemarks = placemarks {
                    //1件目の情報を取り出す
                    if let firstPlacemark = unwrapPlacemarks.first{
                        //位置情報を取り出す
                        if let location = firstPlacemark.location{
                            //位置情報から緯度経度をtargetCoordinateに取り出す
                            let targetCoordinate = location.coordinate
                            //結果をデバッグに表示
                            print(targetCoordinate)
                            //MKpointAnnitationインスタンス取得、ピン生成
                            let pin = MKPointAnnotation()
                            //ピンを置く場所に緯度経度を生成
                            pin.coordinate = targetCoordinate
                            //ピンのタイトルを取得
                            pin.title = searchKey
                            //ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            //緯度経度を中心にして半径５００mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            })
        }
        return true
    }
    
    @IBAction func changeMapButton(_ sender: Any) {
        
        if dispMap.mapType == .standard{
            dispMap.mapType = .satellite
        }else if dispMap.mapType == .satellite{
            dispMap.mapType = .hybrid
        }else if dispMap.mapType == .hybrid{
            dispMap.mapType = .satelliteFlyover
        }else if dispMap.mapType == .satelliteFlyover{
            dispMap.mapType = .hybridFlyover
        }else if dispMap.mapType == .hybridFlyover{
            dispMap.mapType = .mutedStandard
        }else{
            dispMap.mapType = .standard
        }
    }
    

}

