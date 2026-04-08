// src : https://www.ibm.com/think/topics/cosine-similarity

const std = @import("std");
const print = std.debug.print;
const Vector = @import("types.zig").Vector;

pub fn angle_cos(comptime size: usize, comptime T: type, a: Vector(size, T), b: Vector(size, T)) T {
    return a.dot(b) / (a.norm() * b.norm());
}

// --- Tests ---

test "perpendicular vectors" {
    const u = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const v = Vector(3, f32){ .data = .{ 0.0, 1.0, 0.0 } };
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), angle_cos(3, f32, u, v), 1e-5);
}

test "same direction" {
    const u = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const v = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), angle_cos(3, f32, u, v), 1e-5);
}

test "opposite directions" {
    const u = Vector(3, f32){ .data = .{ -1.0, 0.0, 0.0 } };
    const v = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    try std.testing.expectApproxEqAbs(@as(f32, -1.0), angle_cos(3, f32, u, v), 1e-5);
}

test "arbitrary vectors" {
    const u = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const v = Vector(3, f32){ .data = .{ 4.0, 5.0, 6.0 } };
    // dot = 32, norm(u) = sqrt(14), norm(v) = sqrt(77)
    const expected: f32 = 32.0 / (@sqrt(@as(f32, 14.0)) * @sqrt(@as(f32, 77.0)));
    try std.testing.expectApproxEqAbs(expected, angle_cos(3, f32, u, v), 1e-5);
}

test "same vector scaled" {
    const u = Vector(2, f32){ .data = .{ 1.0, 2.0 } };
    const v = Vector(2, f32){ .data = .{ 2.0, 4.0 } };
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), angle_cos(2, f32, u, v), 1e-5);
}

pub fn main() void {
    const u = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const v = Vector(3, f32){ .data = .{ 0.0, 1.0, 0.0 } };
    print("{d}\n", .{angle_cos(3, f32, u, v)}); // 0.0 (perpendicular)

    const a = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const b = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    print("{d}\n", .{angle_cos(3, f32, a, b)}); // 1.0 (same direction)

    const c = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const d = Vector(3, f32){ .data = .{ 4.0, 5.0, 6.0 } };
    print("{d}\n", .{angle_cos(3, f32, c, d)});
}
