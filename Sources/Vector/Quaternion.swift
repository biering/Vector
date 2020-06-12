//
//  Copyright (c) 2019 Christoph Biering. All rights reserved.
//  MIT License (See LICENSE for details)
//
//  https://github.com/chryb/Vector
//

import Foundation

public struct Quaternion {
     public var x: Scalar
     public var y: Scalar
     public var z: Scalar
     public var w: Scalar
}

extension Quaternion: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        let hash = x.hashValue &+ y.hashValue &+ z.hashValue &+ w.hashValue
        hasher.combine(hash)
    }
    
}

public extension Quaternion {
    
    static let zero = Quaternion(0, 0, 0, 0)
    static let identity = Quaternion(0, 0, 0, 1)
    
    var lengthSquared: Scalar {
        return x * x + y * y + z * z + w * w
    }
    
    var length: Scalar {
        return sqrt(lengthSquared)
    }
    
    var inverse: Quaternion {
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
    
    var pitch: Scalar {
        return asin(min(1, max(-1, 2 * (w * y - z * x))))
    }
    
    var yaw: Scalar {
        return atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))
    }
    
    var roll: Scalar {
        return atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))
    }
    
    init(_ x: Scalar, _ y: Scalar, _ z: Scalar, _ w: Scalar) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    init(axisAngle: Vector4) {
        let r = axisAngle.w * 0.5
        let scale = sin(r)
        let a = axisAngle.xyz * scale
        self.init(a.x, a.y, a.z, cos(r))
    }
    
    init(pitch: Scalar, yaw: Scalar, roll: Scalar) {
        let t0 = cos(yaw * 0.5)
        let t1 = sin(yaw * 0.5)
        let t2 = cos(roll * 0.5)
        let t3 = sin(roll * 0.5)
        let t4 = cos(pitch * 0.5)
        let t5 = sin(pitch * 0.5)
        self.init(
            t0 * t3 * t4 - t1 * t2 * t5,
            t0 * t2 * t5 + t1 * t3 * t4,
            t1 * t2 * t4 - t0 * t3 * t5,
            t0 * t2 * t4 + t1 * t3 * t5
        )
    }

    init(rotationMatrix m: Matrix4) {
        let x = sqrt(max(0, 1 + m.m11 - m.m22 - m.m33)) / 2
        let y = sqrt(max(0, 1 - m.m11 + m.m22 - m.m33)) / 2
        let z = sqrt(max(0, 1 - m.m11 - m.m22 + m.m33)) / 2
        let w = sqrt(max(0, 1 + m.m11 + m.m22 + m.m33)) / 2
        self.init(
            x * Double((x * (m.m32 - m.m23)).sign),
            y * Double((y * (m.m13 - m.m31)).sign),
            z * Double((z * (m.m21 - m.m12)).sign),
            w
        )
    }
    
    init(_ v: [Scalar]) {
        assert(v.count == 4, "array must contain 4 elements, contained \(v.count)")
        
        x = v[0]
        y = v[1]
        z = v[2]
        w = v[3]
    }
    
    func toAxisAngle() -> Vector4 {
        let scale = xyz.length
        if scale ~= 0 || scale ~= .twoPi {
            return .z
        } else {
            return Vector4(x / scale, y / scale, z / scale, acos(w) * 2)
        }
    }
    
    func toPitchYawRoll() -> (pitch: Scalar, yaw: Scalar, roll: Scalar) {
        return (pitch, yaw, roll)
    }
    
    func toArray() -> [Scalar] {
        return [x, y, z, w]
    }
    
    func dot(_ v: Quaternion) -> Scalar {
        return x * v.x + y * v.y + z * v.z + w * v.w
    }
    
    func normalized() -> Quaternion {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    func interpolated(with q: Quaternion, by t: Scalar) -> Quaternion {
        let dot = max(-1, min(1, self.dot(q)))
        if dot ~= 1 {
            return (self + (q - self) * t).normalized()
        }
        
        let theta = acos(dot) * t
        let t1 = self * cos(theta)
        let t2 = (q - (self * dot)).normalized() * sin(theta)
        return t1 + t2
    }
    
    static prefix func - (q: Quaternion) -> Quaternion {
        return Quaternion(-q.x, -q.y, -q.z, q.w)
    }
    
    static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z, lhs.w + rhs.w)
    }
    
    static func - (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z, lhs.w - rhs.w)
    }
    
    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z,
            lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x,
            lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
        )
    }
    
    static func * (lhs: Quaternion, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }
    
    static func * (lhs: Quaternion, rhs: Scalar) -> Quaternion {
        return Quaternion(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs, lhs.w * rhs)
    }
    
    static func / (lhs: Quaternion, rhs: Scalar) -> Quaternion {
        return Quaternion(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs, lhs.w / rhs)
    }
    
    static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }
    
    static func ~= (lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z && lhs.w ~= rhs.w
    }
}

