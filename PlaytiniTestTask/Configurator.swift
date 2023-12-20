//
//  Configurator.swift
//  PlaytiniTestTask
//
//  Created by Anton Honcharenko on 20.12.2023.
//

import UIKit

class AppConfigurator {
    static let shared = AppConfigurator()
    
    let barrierAnimationDuration: Double = 0.2
    let circleRotationAnimationDuration: Double = 1.0
    let maxCircleWight: Double = UIScreen().bounds.width
    let maxCollisionCount: Int = 5
    
}
