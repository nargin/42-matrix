const std = @import("std");
const Utils = @import("types.zig");
pub const Vector = Utils.Vector;
pub const Matrix = Utils.Matrix;

pub fn main() void {
    var u = Vector(2, f32){ .data = .{ 2.0, 3.0 } };
    const v = Vector(2, f32){ .data = .{ 5.0, 7.0 } };
    u.add(v);
    std.debug.print("[{d}]\n[{d}]\n", .{ u.data[0], u.data[1] });

    var us = Vector(2, f32){ .data = .{ 2.0, 3.0 } };
    us.sub(v);
    std.debug.print("[{d}]\n[{d}]\n", .{ us.data[0], us.data[1] });

    var uscl = Vector(2, f32){ .data = .{ 2.0, 3.0 } };
    uscl.scl(2.0);
    std.debug.print("[{d}]\n[{d}]\n", .{ uscl.data[0], uscl.data[1] });

    var m = Matrix(2, 2, f32){ .data = .{ .{ 1.0, 2.0 }, .{ 3.0, 4.0 } } };
    const n = Matrix(2, 2, f32){ .data = .{ .{ 7.0, 4.0 }, .{ -2.0, 2.0 } } };
    m.add(n);
    std.debug.print("[{d}, {d}]\n[{d}, {d}]\n", .{ m.data[0][0], m.data[0][1], m.data[1][0], m.data[1][1] });
}

test "vector add" {
    var u = Vector(2, f32){ .data = .{ 2.0, 3.0 } };
    const v = Vector(2, f32){ .data = .{ 5.0, 7.0 } };
    u.add(v);
    try std.testing.expectEqual(@as(f32, 7.0), u.data[0]);
    try std.testing.expectEqual(@as(f32, 10.0), u.data[1]);
}

test "vector sub" {
    var u = Vector(2, f32){ .data = .{ 2.0, 3.0 } };
    const v = Vector(2, f32){ .data = .{ 5.0, 7.0 } };
    u.sub(v);
    try std.testing.expectEqual(@as(f32, -3.0), u.data[0]);
    try std.testing.expectEqual(@as(f32, -4.0), u.data[1]);
}

test "vector scl" {
    var u = Vector(2, f32){ .data = .{ 2.0, 3.0 } };
    u.scl(2.0);
    try std.testing.expectEqual(@as(f32, 4.0), u.data[0]);
    try std.testing.expectEqual(@as(f32, 6.0), u.data[1]);
}

test "vector scl by zero" {
    var u = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    u.scl(0.0);
    try std.testing.expectEqual(@as(f32, 0.0), u.data[0]);
    try std.testing.expectEqual(@as(f32, 0.0), u.data[1]);
    try std.testing.expectEqual(@as(f32, 0.0), u.data[2]);
}

test "matrix add" {
    var u = Matrix(2, 2, f32){ .data = .{ .{ 1.0, 2.0 }, .{ 3.0, 4.0 } } };
    const v = Matrix(2, 2, f32){ .data = .{ .{ 7.0, 4.0 }, .{ -2.0, 2.0 } } };
    u.add(v);
    try std.testing.expectEqual(@as(f32, 8.0), u.data[0][0]);
    try std.testing.expectEqual(@as(f32, 6.0), u.data[0][1]);
    try std.testing.expectEqual(@as(f32, 1.0), u.data[1][0]);
    try std.testing.expectEqual(@as(f32, 6.0), u.data[1][1]);
}

test "matrix sub" {
    var u = Matrix(2, 2, f32){ .data = .{ .{ 1.0, 2.0 }, .{ 3.0, 4.0 } } };
    const v = Matrix(2, 2, f32){ .data = .{ .{ 7.0, 4.0 }, .{ -2.0, 2.0 } } };
    u.sub(v);
    try std.testing.expectEqual(@as(f32, -6.0), u.data[0][0]);
    try std.testing.expectEqual(@as(f32, -2.0), u.data[0][1]);
    try std.testing.expectEqual(@as(f32, 5.0), u.data[1][0]);
    try std.testing.expectEqual(@as(f32, 2.0), u.data[1][1]);
}

test "matrix scl" {
    var u = Matrix(2, 2, f32){ .data = .{ .{ 1.0, 2.0 }, .{ 3.0, 4.0 } } };
    u.scl(2.0);
    try std.testing.expectEqual(@as(f32, 2.0), u.data[0][0]);
    try std.testing.expectEqual(@as(f32, 4.0), u.data[0][1]);
    try std.testing.expectEqual(@as(f32, 6.0), u.data[1][0]);
    try std.testing.expectEqual(@as(f32, 8.0), u.data[1][1]);
}
