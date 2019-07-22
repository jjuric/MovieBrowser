//
//  TutorialViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 11/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class TutorialViewModel {
    var onGotPreviousVC: ((UIViewController) -> UIViewController)?
    var onGotNextVC: ((UIViewController) -> UIViewController)?
    var onClose: (() -> Void)?
    var onSwipe:((UIViewController) -> Int)?
    
    func getPreviousVC(for current: UIViewController) -> UIViewController? {
        return onGotPreviousVC?(current)
    }
    
    func getNextVC(for current: UIViewController) -> UIViewController? {
        return onGotNextVC?(current)
    }
    
    func closeTutorial() {
        onClose?()
    }
    
    func swipe(for previous: UIViewController) -> Int? {
        return onSwipe?(previous)
    }
    
}
