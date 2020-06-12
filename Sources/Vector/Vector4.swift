//
//  Copyright (c) 2019 Christoph Biering. All rights reserved.
//  MIT License (See LICENSE for details)
//
//  https://github.com/chryb/Vector
//

import Foundation

public struct Vector4 {
     public var x: Scalar
     public var y: Scalar
     public var z: Scalar
     public var w: Scalar
}

extension Vector4: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        let hash = x.hashValue &+ y.hashValue &+ z.hashValue &+ w.hashValue
        hasher.combine(hash)
    }
    
}

public extension Vector4 {
    
    static let zero = Vector4(0, 0, 0, 0)
    static let x = Vector4(1, 0, 0, 0)
    static let y = Vector4(0, 1, 0, 0)
    static let z = Vector4(0, 0, 1, 0)
    static let w = Vector4(0, 0, 0, 1)
    
    var lengthSquared: Scalar {
        return x * x + y * y + z * z + w * w
    }
    
    var length: Scalar {
        return sqrt(lengthSquared)
    }
    
    var inverse: Vector4 {
        return -self
    }
    
    var xyz: Vector3 {
        get {
            return Vector3(x, y, z)
        }
        set(v) {
            x = v.x
            y = v.y
            z = v.z
        }
    }
    
    var xy: Vector2 {
        get {
            return Vector2(x, y)
        }
        set(v) {
            x = v.x
            y = v.y
        }
    }
    
    var xz: Vector2 {
        get {
            return Vector2(x, z)
        }
        set(v) {
            x = v.x
            z = v.y
        }
    }
    
    var yz: Vector2 {
        get {
            return Vector2(y, z)
        }
        set(v) {
            y = v.x
            z = v.y
        }
    }

    init(_ x: Scalar, _ y: Scalar, _ z: Scalar, _ w: Scalar) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    init(_ v: [Scalar]) {
        assert(v.count == 4, "array must contain 4 elements, contained \(v.count)")
        self.init(v[0], v[1], v[2], v[3])
    }
    
    init(_ v: Vector3, w: Scalar) {
        self.init(v.x, v.y, v.z, w)
    }
    
    func toArray() -> [Scalar] {
        return [x, y, z, w]
    }
    
    func toVector3() -> Vector3 {
        if w ~= 0 {
            return xyz
        } else {
            return xyz / w
        }
    }
    
    func dot(_ v: Vector4) -> Scalar {
        return x * v.x + y * v.y + z * v.z + w * v.w
    }
    
    func normalized() -> Vector4 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    func interpolated(with v: Vector4, by t: Scalar) -> Vector4 {
        return self + (v - self) * t
    }
    
    static prefix func - (v: Vector4) -> Vector4 {
        return Vector4(-v.x, -v.y, -v.z, -v.w)
    }
    
    static func + (lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z, lhs.w + rhs.w)
    }
    
    static func - (lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z, lhs.w - rhs.w)
    }
    
    static func * (lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z, lhs.w * rhs.w)
    }
    
    static func * (lhs: Vector4, rhs: Scalar) -> Vector4 {
        return Vector4(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs, lhs.w * rhs)
    }
    
    static func * (lhs: Vector4, rhs: Matrix4) -> Vector4 {
        return Vector4(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31 + lhs.w * rhs.m41,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32 + lhs.w * rhs.m42,
            lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33 + lhs.w * rhs.m43,
            lhs.x * rhs.m14 + lhs.y * rhs.m24 + lhs.z * rhs.m34 + lhs.w * rhs.m44
        )
    }
    
    static func / (lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z, lhs.w / rhs.w)
    }
    
    static func / (lhs: Vector4, rhs: Scalar) -> Vector4 {
        return Vector4(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs, lhs.w / rhs)
    }
    
    static func == (lhs: Vector4, rhs: Vector4) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }
    
    static func ~= (lhs: Vector4, rhs: Vector4) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z && lhs.w ~= rhs.w
    }
}
