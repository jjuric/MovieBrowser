//
//  MovieResponse.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 26/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation

enum MovieResponse<T> {
    case success(T)
    case fail
}
