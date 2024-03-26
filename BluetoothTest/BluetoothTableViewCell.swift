//
//  BluetoothTableViewCell.swift
//  BluetoothTest
//
//  Created by 노영재(Youngjae No)_인턴 on 3/25/24.
//

import UIKit

class BluetoothTableViewCell: UITableViewCell {
    static let identifier = "BluetoothTableViewCell"
    
    let titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private func addSubViews() {
        self.contentView.addSubview(titleTextLabel)
    }
    
    private func setLayouts() {
        self.titleTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        addSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
