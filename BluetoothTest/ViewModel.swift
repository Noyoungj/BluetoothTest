//
//  ViewModel.swift
//  BluetoothTest
//
//  Created by 노영재(Youngjae No)_인턴 on 3/25/24.
//

import CoreBluetooth
import RxSwift
import RxCocoa

final class ViewModel {
    var peripherals : [PeripheralDTO] = []
    
    let reloadTableView = PublishRelay<Void>()
    var peripheralsList: BehaviorSubject<[PeripheralDTO]> = BehaviorSubject(value: [])
    
    init() {
        peripheralsList.subscribe { peripherals in
            self.peripherals = peripherals
            
            self.reloadTableView.accept(Void())
        }
    }
}

struct PeripheralDTO {
    var uuidName: String = ""
}
