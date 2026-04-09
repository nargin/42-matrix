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
