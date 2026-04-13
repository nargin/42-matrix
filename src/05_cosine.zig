// src : https://www.ibm.com/think/topics/cosine-similarity

const std = @import("std");
const print = std.debug.print;
const Vector = @import("types.zig").Vector;

pub fn angle_cos(u: anytype, v: @TypeOf(u)) @TypeOf(u.data[0]) {
    return u.dot(v) / (u.norm() * v.norm());
}

pub fn main() void {
    const u = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const v = Vector(3, f32){ .data = .{ 0.0, 1.0, 0.0 } };
    print("{d}\n", .{angle_cos(u, v)}); // 0.0 (perpendicular)

    const a = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const b = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    print("{d}\n", .{angle_cos(a, b)}); // 1.0 (same direction)

    const c = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const d = Vector(3, f32){ .data = .{ 4.0, 5.0, 6.0 } };
    print("{d}\n", .{angle_cos(c, d)});
}

test "same direction" {
    const u = Vector(2, f32){ .data = .{ 1, 0 } };
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), angle_cos(u, u), 1e-5);
}

test "perpendicular" {
    const u = Vector(2, f32){ .data = .{ 1, 0 } };
    const v = Vector(2, f32){ .data = .{ 0, 1 } };
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), angle_cos(u, v), 1e-5);
}

test "opposite direction" {
    const u = Vector(2, f32){ .data = .{ -1, 1 } };
    const v = Vector(2, f32){ .data = .{ 1, -1 } };
    try std.testing.expectApproxEqAbs(@as(f32, -1.0), angle_cos(u, v), 1e-5);
}

test "parallel vectors" {
    const u = Vector(2, f32){ .data = .{ 2, 1 } };
    const v = Vector(2, f32){ .data = .{ 4, 2 } };
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), angle_cos(u, v), 1e-5);
}

test "3d general" {
    const u = Vector(3, f32){ .data = .{ 1, 2, 3 } };
    const v = Vector(3, f32){ .data = .{ 4, 5, 6 } };
    try std.testing.expectApproxEqAbs(@as(f32, 0.974631846), angle_cos(u, v), 1e-5);
}
