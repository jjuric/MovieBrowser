//
//  OnboardingViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 14/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class OnboardingViewModel {
    
    var onClose: (() -> Void)?
    
    func closeOnboarding() {
        onClose?()
    }
}
