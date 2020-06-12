//
//  Copyright (c) 2019 Christoph Biering. All rights reserved.
//  MIT License (See LICENSE for details)
//
//  https://github.com/chryb/Vector
//

import Foundation

public struct Matrix3: Codable {
     public var m11: Scalar
     public var m12: Scalar
     public var m13: Scalar
     public var m21: Scalar
     public var m22: Scalar
     public var m23: Scalar
     public var m31: Scalar
     public var m32: Scalar
     public var m33: Scalar
}

extension Matrix3: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        var hash = m11.hashValue &+ m12.hashValue &+ m13.hashValue
        hash = hash &+ m21.hashValue &+ m22.hashValue &+ m23.hashValue
        hash = hash &+ m31.hashValue &+ m32.hashValue &+ m33.hashValue
        hasher.combine(hash)
    }

}

public extension Matrix3 {
    
    static let identity = Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)
    
    init(_ m11: Scalar, _ m12: Scalar, _ m13: Scalar,
                _ m21: Scalar, _ m22: Scalar, _ m23: Scalar,
                _ m31: Scalar, _ m32: Scalar, _ m33: Scalar) {
        self.m11 = m11 // 0
        self.m12 = m12 // 1
        self.m13 = m13 // 2
        self.m21 = m21 // 3
        self.m22 = m22 // 4
        self.m23 = m23 // 5
        self.m31 = m31 // 6
        self.m32 = m32 // 7
        self.m33 = m33 // 8
    }
    
    init(scale: Vector2) {
        self.init(
            scale.x, 0, 0,
            0, scale.y, 0,
            0, 0, 1
        )
    }
    
    init(translation: Vector2) {
        self.init(
            1, 0, 0,
            0, 1, 0,
            translation.x, translation.y, 1
        )
    }
    
    init(rotation radians: Scalar) {
        let cs = cos(radians)
        let sn = sin(radians)
        self.init(
            cs, sn, 0,
            -sn, cs, 0,
            0, 0, 1
        )
    }
    
    init(_ m: [Scalar]) {
        assert(m.count == 9, "array must contain 9 elements, contained \(m.count)")
        self.init(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8])
    }
    
    func toArray() -> [Scalar] {
        return [m11, m12, m13, m21, m22, m23, m31, m32, m33]
    }
    
    var adjugate: Matrix3 {
        return Matrix3(
            m22 * m33 - m23 * m32,
            m13 * m32 - m12 * m33,
            m12 * m23 - m13 * m22,
            m23 * m31 - m21 * m33,
            m11 * m33 - m13 * m31,
            m13 * m21 - m11 * m23,
            m21 * m32 - m22 * m31,
            m12 * m31 - m11 * m32,
            m11 * m22 - m12 * m21
        )
    }
    
    var determinant: Scalar {
        return (m11 * m22 * m33 + m12 * m23 * m31 + m13 * m21 * m32)
            - (m13 * m22 * m31 + m11 * m23 * m32 + m12 * m21 * m33)
    }
    
    var transpose: Matrix3 {
        return Matrix3(m11, m21, m31, m12, m22, m32, m13, m23, m33)
    }
    
    var inverse: Matrix3 {
        return adjugate * (1 / determinant)
    }
    
    func interpolated(with m: Matrix3, by t: Scalar) -> Matrix3 {
        return Matrix3(
            m11 + (m.m11 - m11) * t,
            m12 + (m.m12 - m12) * t,
            m13 + (m.m13 - m13) * t,
            m21 + (m.m21 - m21) * t,
            m22 + (m.m22 - m22) * t,
            m23 + (m.m23 - m23) * t,
            m31 + (m.m31 - m31) * t,
            m32 + (m.m32 - m32) * t,
            m33 + (m.m33 - m33) * t
        )
    }
    
    static prefix func - (m: Matrix3) -> Matrix3 {
        return m.inverse
    }
    
    static func * (lhs: Matrix3, rhs: Matrix3) -> Matrix3 {
        return Matrix3(
            lhs.m11 * rhs.m11 + lhs.m21 * rhs.m12 + lhs.m31 * rhs.m13,
            lhs.m12 * rhs.m11 + lhs.m22 * rhs.m12 + lhs.m32 * rhs.m13,
            lhs.m13 * rhs.m11 + lhs.m23 * rhs.m12 + lhs.m33 * rhs.m13,
            lhs.m11 * rhs.m21 + lhs.m21 * rhs.m22 + lhs.m31 * rhs.m23,
            lhs.m12 * rhs.m21 + lhs.m22 * rhs.m22 + lhs.m32 * rhs.m23,
            lhs.m13 * rhs.m21 + lhs.m23 * rhs.m22 + lhs.m33 * rhs.m23,
            lhs.m11 * rhs.m31 + lhs.m21 * rhs.m32 + lhs.m31 * rhs.m33,
            lhs.m12 * rhs.m31 + lhs.m22 * rhs.m32 + lhs.m32 * rhs.m33,
            lhs.m13 * rhs.m31 + lhs.m23 * rhs.m32 + lhs.m33 * rhs.m33
        )
    }
    
    static func * (lhs: Matrix3, rhs: Vector2) -> Vector2 {
        return rhs * lhs
    }
    
    static func * (lhs: Matrix3, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }
    
    static func * (lhs: Matrix3, rhs: Scalar) -> Matrix3 {
        return Matrix3(
            lhs.m11 * rhs, lhs.m12 * rhs, lhs.m13 * rhs,
            lhs.m21 * rhs, lhs.m22 * rhs, lhs.m23 * rhs,
            lhs.m31 * rhs, lhs.m32 * rhs, lhs.m33 * rhs
        )
    }
    
    static func == (lhs: Matrix3, rhs: Matrix3) -> Bool {
        if lhs.m11 != rhs.m11 { return false }
        if lhs.m12 != rhs.m12 { return false }
        if lhs.m13 != rhs.m13 { return false }
        if lhs.m21 != rhs.m21 { return false }
        if lhs.m22 != rhs.m22 { return false }
        if lhs.m23 != rhs.m23 { return false }
        if lhs.m31 != rhs.m31 { return false }
        if lhs.m32 != rhs.m32 { return false }
        if lhs.m33 != rhs.m33 { return false }
        return true
    }
    
    static func ~= (lhs: Matrix3, rhs: Matrix3) -> Bool {
        if !(lhs.m11 ~= rhs.m11) { return false }
        if !(lhs.m12 ~= rhs.m12) { return false }
        if !(lhs.m13 ~= rhs.m13) { return false }
        if !(lhs.m21 ~= rhs.m21) { return false }
        if !(lhs.m22 ~= rhs.m22) { return false }
        if !(lhs.m23 ~= rhs.m23) { return false }
        if !(lhs.m31 ~= rhs.m31) { return false }
        if !(lhs.m32 ~= rhs.m32) { return false }
        if !(lhs.m33 ~= rhs.m33) { return false }
        return true
    }
}
