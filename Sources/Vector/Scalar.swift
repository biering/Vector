//
//  Copyright (c) 2019 Christoph Biering. All rights reserved.
//  MIT License (See LICENSE for details)
//
//  https://github.com/chryb/Vector
//

import Foundation

public typealias Scalar = Double

public extension Scalar {
    
    static let halfPi = pi / 2
    static let quarterPi = pi / 4
    static let twoPi = pi * 2
    static let degreesPerRadian = 180 / pi
    static let radiansPerDegree = pi / 180
    static let epsilon: Scalar = 0.0001
    
    static func ~= (lhs: Scalar, rhs: Scalar) -> Bool {
        return Swift.abs(lhs - rhs) < .epsilon
    }
    
    var sign: Scalar {
        return self > 0 ? 1 : -1
    }
}
