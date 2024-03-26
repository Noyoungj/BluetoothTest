//
//  ViewController.swift
//  BluetoothTest
//
//  Created by 노영재(Youngjae No)_인턴 on 3/25/24.
//

import UIKit
import CoreBluetooth

import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private var peripherals: [CBPeripheral] = []
    private var centralManager: CBCentralManager!
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    private let contentTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private func addSubViews() {
        self.view.addSubview(contentTableView)
        self.view.addSubview(button)
    }
    
    private func setLayouts() {
        button.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing
                .bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(100)
        }
        contentTableView.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.top).offset(-10)
            make.leading
                .trailing.equalTo(button)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.backgroundColor = .white
        contentTableView.register(BluetoothTableViewCell.self, forCellReuseIdentifier: BluetoothTableViewCell.identifier)
        contentTableView.sectionHeaderTopPadding = 0
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        addSubViews()
        setLayouts()
        bind()
    }
    
    private func bind() {
        button.rx.tap.bind { _ in
            if(!self.centralManager.isScanning) {
                self.viewModel.peripheralsList.onNext([])
                print("검색 시작")
                self.centralManager.scanForPeripherals(withServices: nil)
            } else {
                print("검색 종료")
                self.centralManager.stopScan()
            }
        }
        
        viewModel.reloadTableView.subscribe { [weak self] _ in
            self?.contentTableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.peripherals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothTableViewCell.identifier, for: indexPath) as? BluetoothTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleTextLabel.text = self.viewModel.peripherals[indexPath.row].uuidName
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("restting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("power Off")
        case .poweredOn:
            print("power on")
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let model = PeripheralDTO(uuidName: peripheral.identifier.uuidString)
        var list = try! self.viewModel.peripheralsList.value()
        list.append(model)
        self.viewModel.peripheralsList.onNext(list)
    }
}

extension ViewController: CBPeripheralDelegate {
    
}
