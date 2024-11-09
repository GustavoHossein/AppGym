//
//  DateFilterViewController.swift
//  GymApp
//
//  Created by Gustavo Hossein on 11/9/24.
//

import UIKit

class DateFilterViewController: UIViewController {
    var onDateSelected: ((String) -> Void)?
    
    private let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selecione a Data"
        view.backgroundColor = .white
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        
        let filterButton = UIButton(type: .system)
        filterButton.setTitle("Filtrar", for: .normal)
        filterButton.addTarget(self, action: #selector(applyDateFilter), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(datePicker)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            filterButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func applyDateFilter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        onDateSelected?(selectedDate)
        navigationController?.popViewController(animated: true)
    }
}
