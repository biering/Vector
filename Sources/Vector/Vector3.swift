//
//  Copyright (c) 2019 Christoph Biering. All rights reserved.
//  MIT License (See LICENSE for details)
//
//  https://github.com/chryb/Vector
//

import Foundation

public struct Vector3: Codable {
     var x: Scalar
     var y: Scalar
     var z: Scalar
}

extension Vector3: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        let hash = x.hashValue &+ y.hashValue &+ z.hashValue
        hasher.combine(hash)
    }
    
}

public extension Vector3 {
    
    static let zero = Vector3(0, 0, 0)
    static let x = Vector3(1, 0, 0)
    static let y = Vector3(0, 1, 0)
    static let z = Vector3(0, 0, 1)
    
    var lengthSquared: Scalar {
        return x * x + y * y + z * z
    }
    
    var length: Scalar {
        return sqrt(lengthSquared)
    }
    
    var inverse: Vector3 {
        return -self
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
    
    init(_ x: Scalar, _ y: Scalar, _ z: Scalar) {
        self.init(x: x, y: y, z: z)
    }
    
    init(_ v: [Scalar]) {
        assert(v.count == 3, "array must contain 3 elements, contained \(v.count)")
        self.init(v[0], v[1], v[2])
    }
    
    func toArray() -> [Scalar] {
        return [x, y, z]
    }
    
    func dot(_ v: Vector3) -> Scalar {
        return x * v.x + y * v.y + z * v.z
    }
    
    func cross(_ v: Vector3) -> Vector3 {
        return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)
    }
    
    func normalized() -> Vector3 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    func interpolated(with v: Vector3, by t: Scalar) -> Vector3 {
        return self + (v - self) * t
    }
    
    static prefix func - (v: Vector3) -> Vector3 {
        return Vector3(-v.x, -v.y, -v.z)
    }
    
    static func + (lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func - (lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    static func * (lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }
    
    static func * (lhs: Vector3, rhs: Scalar) -> Vector3 {
        return Vector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }
    
    static func * (lhs: Vector3, rhs: Matrix3) -> Vector3 {
        return Vector3(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32,
            lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33
        )
    }
    
    static func * (lhs: Vector3, rhs: Matrix4) -> Vector3 {
        return Vector3(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31 + rhs.m41,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32 + rhs.m42,
            lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33 + rhs.m43
        )
    }
    
    static func * (v: Vector3, q: Quaternion) -> Vector3 {
        let qv = q.xyz
        let uv = qv.cross(v)
        let uuv = qv.cross(uv)
        return v + (uv * 2 * q.w) + (uuv * 2)
    }
    
    static func / (lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z)
    }
    
    static func / (lhs: Vector3, rhs: Scalar) -> Vector3 {
        return Vector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }
    
    static func == (lhs: Vector3, rhs: Vector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    static func ~= (lhs: Vector3, rhs: Vector3) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z
    }
}
