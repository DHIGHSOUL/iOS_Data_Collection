//
//  MainViewController.swift
//  iOSDataCollection
//
//  Created by ROLF J. on 2022/07/25.
//

import UIKit
import SnapKit
import RealmSwift
import Realm
import CoreLocation

class MainViewController: UIViewController {
    
    // Singletone
    static let shared = MainViewController()
    
    // 백그라운드에서 위치 정보를 지속적으로 가져올 Location Manager
    var locationManager = CLLocationManager()
    
    // Main View의 TextField에 값을 지속적으로 표시하기 위한 Timer와 Interval
    var showAccelerationAndRotationTimer = Timer()
    var showAltitudeAndPressureTimer = Timer()
    let showAccelerationAndRotationInterval = 0.1
    let showAltitudeAndPressureInterval = 1.0
    
    // MARK: - Instance member
    // 가속도 표시 변수
    private let accelerationXLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.accX
        
        return label
    }()
    private var showAccelerationXTextField = UITextField()
    private let accelerationYLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.accY
        
        return label
    }()
    private var showAccelerationYTextField = UITextField()
    private let accelerationZLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.accZ
        
        return label
    }()
    private var showAccelerationZTextField = UITextField()
    
    // 회전속도 표시 변수
    private let rotationXLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.gyrX
        
        return label
    }()
    private var showRotationXTextField = UITextField()
    private let rotationYLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.gyrY
        
        return label
    }()
    private var showRotationYTextField = UITextField()
    private let rotationZLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.gyrZ
        
        return label
    }()
    private var showRotationZTextField = UITextField()
    
    // 고도/기압/절대고도 표시 변수
    private let altitudeLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.altitude
        
        return label
    }()
    private var showAltitudeTextField = UITextField()
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.pressure
        
        return label
    }()
    private var showPressureTextField = UITextField()
    
    // 업로드를 확인하기 위한 Label과 변수, Timer와 Interval
    private let uploadLeftLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageChange.MainViewWord.sensorLeftTime

        return label
    }()
    var uploadTimeLabel = UILabel()
    let showUploadTimeInterval = 1.0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        mainViewLayout()
        locationManagerSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showSensorDatas()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        showAccelerationAndRotationTimer.invalidate()
        showAltitudeAndPressureTimer.invalidate()
    }
    
    // MARK: - Method
    // 위치 정보 관련 설정 메소드
    func locationManagerSetting() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    
        if CLLocationManager.locationServicesEnabled() {
            print("위치 정보 읽기 시작")
            locationManager.startUpdatingLocation()
        } else {
            print("위치 정보를 받아올 수 없음")
        }
    }
    
    // 파일을 저장한 번호를 추적하기 위한 인덱스를 저장하는 Realm 라이브러리 생성
    func makeRealm() {
        let realm = try! Realm()
    
        print("Realm DB 생성")
        print(realm.configuration.fileURL ?? "RealmFileNameError")
    }
    
    // Main View의 Layout 지정
    private func mainViewLayout() {
        addViewsInMainView()
        textFieldSetting()
        showAccelerationInViews()
        showRotationInViews()
        showAltitudeInViews()
        showPressureInViews()
        showUploadTimeInViews()
    }
    
    // AddSubView를 한 번에 실시
    private func addViewsInMainView() {
        let mainViews = [accelerationXLabel, accelerationYLabel, accelerationZLabel, showAccelerationXTextField, showAccelerationYTextField, showAccelerationZTextField, rotationXLabel, rotationYLabel, rotationZLabel, showRotationXTextField, showRotationYTextField, showRotationZTextField, altitudeLabel, showAltitudeTextField, pressureLabel, showPressureTextField, uploadLeftLabel, uploadTimeLabel]
        
        for newView in mainViews {
            view.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // textField들의 설정 한 번에 실시
    private func textFieldSetting() {
        let textFields = [showAccelerationXTextField, showAccelerationYTextField, showAccelerationZTextField, showRotationXTextField, showRotationYTextField, showRotationZTextField, showAltitudeTextField, showPressureTextField]
        
        for field in textFields {
            field.textColor = .black
            field.backgroundColor = .white
            field.clipsToBounds = false
            field.isUserInteractionEnabled = false
            field.textAlignment = .center
        }
    }
    
    // 가속도 관련 View들의 위치 결정
    private func showAccelerationInViews() {
        accelerationXLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo((view.frame.width/4))
        }
        showAccelerationXTextField.snp.makeConstraints { make in
            make.top.equalTo(accelerationXLabel.snp.bottom).offset(10)
            make.centerX.equalTo(accelerationXLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        accelerationYLabel.snp.makeConstraints { make in
            make.top.equalTo(showAccelerationXTextField.snp.bottom).offset(20)
            make.centerX.equalTo(showAccelerationXTextField.snp.centerX)
        }
        showAccelerationYTextField.snp.makeConstraints { make in
            make.top.equalTo(accelerationYLabel.snp.bottom).offset(10)
            make.centerX.equalTo(accelerationYLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        accelerationZLabel.snp.makeConstraints { make in
            make.top.equalTo(showAccelerationYTextField.snp.bottom).offset(20)
            make.centerX.equalTo(showAccelerationYTextField.snp.centerX)
        }
        showAccelerationZTextField.snp.makeConstraints { make in
            make.top.equalTo(accelerationZLabel.snp.bottom).offset(10)
            make.centerX.equalTo(accelerationZLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
    }
    
    // 회전속도 관련 View들의 위치 결정
    private func showRotationInViews() {
        rotationXLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo((view.frame.width/1.3))
        }
        showRotationXTextField.snp.makeConstraints { make in
            make.top.equalTo(rotationXLabel.snp.bottom).offset(10)
            make.centerX.equalTo(rotationXLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        rotationYLabel.snp.makeConstraints { make in
            make.top.equalTo(showRotationXTextField.snp.bottom).offset(20)
            make.centerX.equalTo(showRotationXTextField.snp.centerX)
        }
        showRotationYTextField.snp.makeConstraints { make in
            make.top.equalTo(rotationYLabel.snp.bottom).offset(10)
            make.centerX.equalTo(rotationYLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        rotationZLabel.snp.makeConstraints { make in
            make.top.equalTo(showRotationYTextField.snp.bottom).offset(20)
            make.centerX.equalTo(showRotationYTextField.snp.centerX)
        }
        showRotationZTextField.snp.makeConstraints { make in
            make.top.equalTo(rotationZLabel.snp.bottom).offset(10)
            make.centerX.equalTo(rotationZLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
    }
    
    // 고도 관련 View들의 위치 결정
    private func showAltitudeInViews() {
        altitudeLabel.snp.makeConstraints { make in
            make.top.equalTo(showAccelerationZTextField.snp.bottom).offset(20)
            make.centerX.equalTo(showAccelerationZTextField.snp.centerX)
        }
        showAltitudeTextField.snp.makeConstraints { make in
            make.top.equalTo(altitudeLabel.snp.bottom).offset(10)
            make.centerX.equalTo(altitudeLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
    }
    
    // 기압 관련 View들의 위치 결정
    private func showPressureInViews() {
        pressureLabel.snp.makeConstraints { make in
            make.top.equalTo(showRotationZTextField.snp.bottom).offset(20)
            make.centerX.equalTo(showRotationZTextField)
        }
        showPressureTextField.snp.makeConstraints { make in
            make.top.equalTo(pressureLabel.snp.bottom).offset(10)
            make.centerX.equalTo(pressureLabel.snp.centerX)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
    }
    
    // 센서에서 값을 받아와서 textField들에 뿌려주는 메소드
    private func showSensorDatas() {
        showAccelerationAndRotationTimer = Timer.scheduledTimer(timeInterval: showAccelerationAndRotationInterval, target: self, selector: #selector(showAccelerationAndRotationData), userInfo: nil, repeats: true)
        showAltitudeAndPressureTimer = Timer.scheduledTimer(timeInterval: showAltitudeAndPressureInterval, target: self, selector: #selector(showAltitudeAndPressureData), userInfo: nil, repeats: true)
    }
    
    // 업로드 시간을 파악하기 위한 타이머 Label의 위치 결정
    private func showUploadTimeInViews() {
        uploadTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(view)
        }
        uploadTimeLabel.textAlignment = .center
        uploadTimeLabel.clipsToBounds = false
        uploadTimeLabel.font = UIFont.boldSystemFont(ofSize: 25)

        uploadLeftLabel.snp.makeConstraints { make in
            make.bottom.equalTo(uploadTimeLabel.snp.top).offset(-10)
            make.centerX.equalTo(view)
        }
    }
    
    // MARK: - @objc Method
    // 가속도, 각속도 측정값 표시 메소드
    @objc private func showAccelerationAndRotationData() {
        showAccelerationXTextField.text = DataCollectionManager.shared.newAccelerationXData
        showAccelerationYTextField.text = DataCollectionManager.shared.newAccelerationYData
        showAccelerationZTextField.text = DataCollectionManager.shared.newAccelerationZData
        showRotationXTextField.text = DataCollectionManager.shared.newRotationXData
        showRotationYTextField.text = DataCollectionManager.shared.newRotationYData
        showRotationZTextField.text = DataCollectionManager.shared.newRotationZData
    }
    
    // 고도, 기압 측정값 표시 준비 메소드
    @objc private func showAltitudeAndPressureData() {
        showAltitudeTextField.text = DataCollectionManager.shared.newAltitudeData
        showPressureTextField.text = DataCollectionManager.shared.newPressureData
        
        if uploadTimeVariable > 499 {
            uploadTimeLabel.textColor = .white
        } else if uploadTimeVariable > 399 {
            uploadTimeLabel.textColor = .systemBlue
        } else if uploadTimeVariable > 299 {
            uploadTimeLabel.textColor = .green
        } else if uploadTimeVariable > 199 {
            uploadTimeLabel.textColor = .yellow
        } else if uploadTimeVariable > 99 {
            uploadTimeLabel.textColor = .orange
        } else {
            uploadTimeLabel.textColor = .red
        }

        var leftMinute = String()
        var leftSecond = String()
        
        if uploadTimeVariable > 0 {
            leftMinute = String(format: "%02d", uploadTimeVariable/60)
            leftSecond = String(format: "%02d", uploadTimeVariable%60)
        } else {
            leftMinute = "00"
            leftSecond = "00"
        }
        
        let uploadString = "\(leftMinute) : \(leftSecond)"
        uploadTimeLabel.text = uploadString
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    // 위치 정보 이용 권한을 요청하는 메소드
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // 권한을 습득하지 못하면 지속적으로 요청하는 메소드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 권한 획득")
        case .restricted, .notDetermined:
            print("위치 권한이 설정되지 않음")
            requestLocationAuthorization()
        case .denied:
            print("위치 권한 거부")
            requestLocationAuthorization()
        default:
            print("Location authorization is denied")
            return
        }
    }
    
}
