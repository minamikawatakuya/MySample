
import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var addStr:String = "アロハ"
    var addStrTmp:String = ""
    var dispStr:String = ""
    var count:Int = 0
    var arryHoge:[String] = []
    
    // 緯度
    var latitudeNow: String = ""
    // 経度
    var longitudeNow: String = ""
    
    // 緯度(小作駅)
    var latitudeOzakueki: Double = 35.776332
    // 経度(小作駅)
    var longitudeOzakueki: Double = 139.301929
    
    // 自宅から駅までの距離
    var distanceFromHome: Double = 0.0
    
    // ロケーションマネージャ
    var locationManager: CLLocationManager!

    @IBOutlet weak var dispTextView: UITextView!
    
    @IBOutlet weak var idoLabel: UILabel!
    @IBOutlet weak var keidoLabel: UILabel!
    @IBOutlet weak var disLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispTextView.text = ""
        
        // ロケーションマネージャのセットアップ
        setupLocationManager()
        
    }
    
    
    @IBAction func pushButton(_ sender: Any) {
        
        updateArr(arr: self.arryHoge)
        self.dispStr = ""
        for i in 0..<self.arryHoge.count {
            self.dispStr += self.arryHoge[i]
            self.dispStr += "\n"
        }
        dispTextView.text = self.dispStr
        
    }
    
    func updateArr(arr: [String]){
        
        addStrTmp = self.addStr
        addStrTmp += String(self.count)
        arryHoge.append(addStrTmp)
        if( arryHoge.count > 6 ){
            arryHoge.removeFirst()
        }
        count += 1
        
    }
    

    @IBAction func pushClear(_ sender: Any) {
        dispTextView.text = ""
        dispStr = ""
        count = 0
        arryHoge = []
        idoLabel.text = "緯度: 000.000000"
        keidoLabel.text = "経度: 000.000000"
        disLabel.text = "距離: 0.0"
    }
    
    @IBAction func getHerePosition(_ sender: Any) {
        //現在地の緯度、経度を取得して、表示
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            getDistance(lat: latitudeNow,lon: longitudeNow)
            idoLabel.text = "緯度: " + latitudeNow
            keidoLabel.text = "経度: " + longitudeNow
            disLabel.text = "距離: " + String(distanceFromHome)
        }
    }
    
    // 距離の取得
    func getDistance(lat:String,lon:String){
        let latD: Double = atof(lat)
        let lonD: Double = atof(lon)
        let posHere: CLLocation = CLLocation(latitude: latD, longitude: lonD)
        let posEki: CLLocation = CLLocation(latitude: latitudeOzakueki, longitude: longitudeOzakueki)
        distanceFromHome = posEki.distance(from: posHere)
    }
    
    // ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        // 位置情報取得許可ダイアログの表示
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            // 位置情報取得を開始
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: CLLocationManagerDelegate {

    // 位置情報が更新された際、位置情報を格納する
    // - Parameters:
    //   - manager: ロケーションマネージャ
    //   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
    }
}

