//
//  ViewController.swift
//  LocalizableGenerator
//
//  Created by Ines SK on 26/2/2024.
//

import UIKit
import CoreXLSX
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Generator.shared.readXLSX(filepath: "/Users/repr/Downloads/Book.xlsx")
    }
}

