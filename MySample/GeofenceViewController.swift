
import UIKit
import CoreLocation

class GeofenceViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    
    var dispStr:String = ""
    var arryHoge:[String] = []
    
    @IBOutlet weak var dispTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pushGeofenceStart(_ sender: Any) {
        
        // LocationManagerのインスタンスの生成
        locationManager = CLLocationManager()

        // LocationManagerの位置情報変更などで呼ばれるfunctionを自身で受けるように設定
        locationManager.delegate = self

        // 位置情報取得をユーザーに認証してもらう
        locationManager.requestAlwaysAuthorization()

        // モニタリング開始：このファンクションは適宜ボタンアクションなどから呼ぶ様にする。
        self.startGeofenceMonitering()
        
    }
    
    func startGeofenceMonitering() {

        // 位置情報の取得開始
        locationManager.startUpdatingLocation()

        // モニタリングしたい場所の緯度経度を設定
        let moniteringCordinate = CLLocationCoordinate2DMake(35.776332, 139.301929) // 小作駅の緯度経度

        // モニタリングしたい領域を作成
        let moniteringRegion = CLCircularRegion.init(center: moniteringCordinate, radius: 400.0, identifier: "OzakuEki")

        // モニタリング開始
        locationManager.startMonitoring(for: moniteringRegion)
    }
    
    func updateArr( addTxt: String ){
        
        arryHoge.append(addTxt)
        if( arryHoge.count > 10 ){
            arryHoge.removeFirst()
        }
        
    }
    
    func updateDispStr(){
        
        //updateArr(arr: self.arryHoge)
        self.dispStr = ""
        for i in 0..<self.arryHoge.count {
            self.dispStr += self.arryHoge[i]
            self.dispStr += "\n"
        }
        dispTextView.text = self.dispStr
        
    }
    
    // 位置情報取得認可
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザー認証未選択")
            break
        case .denied:
            print("ユーザーが位置情報取得を拒否しています。")
            //位置情報取得を促す処理を追記
            break
        case .restricted:
            print("位置情報サービスを利用できません")
            break
        case .authorizedWhenInUse:
            print("アプリケーション起動時のみ、位置情報の取得を許可されています。")
            break
        case .authorizedAlways:
            print("このアプリケーションは常時、位置情報の取得を許可されています。")
            break
        @unknown default:
            //<#fatalError()#>
            dismiss(animated: true, completion: nil)
        }
    }
    
    // ジオフェンスモニタリング

    // モニタリング開始成功時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        let strTmp = "モニタリング開始"
        updateArr( addTxt: strTmp )
        updateDispStr()
    }

    // モニタリングに失敗したときに呼ばれる
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        let strTmp = "モニタリングに失敗しました。"
        updateArr( addTxt: strTmp )
        updateDispStr()
    }

    // ジオフェンス領域に侵入時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let strTmp = "設定したジオフェンスに入りました。"
        updateArr( addTxt: strTmp )
        updateDispStr()
    }

    // ジオフェンス領域から出たときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let strTmp = "設定したジオフェンスから出ました。"
        updateArr( addTxt: strTmp )
        updateDispStr()
    }

    // ジオフェンスの情報が取得できないときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let strTmp = "モニタリングエラーです。"
        updateArr( addTxt: strTmp )
        updateDispStr()
    }
    
    
    
}
