const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;

pub fn main() void {
    const ma = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    print("trace({any}) = {}\n", .{ ma.data, ma.trace() });
    // 2.

    const mb = Matrix(2, 2, f32){ .data = .{ .{ 2, -5 }, .{ 3, 4 } } };
    print("trace({any}) = {}\n", .{ mb.data, mb.trace() });
    // 6.

    const mc = Matrix(3, 3, f32){ .data = .{ .{ -2, -8, 4 }, .{ 1, -23, 4 }, .{ 0, 6, 4 } } };
    print("trace({any}) = {}\n", .{ mc.data, mc.trace() });
    // -21.
}

test "trace identity 2x2" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    try std.testing.expectEqual(@as(f32, 2), m.trace());
}

test "trace 2x2" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 2, -5 }, .{ 3, 4 } } };
    try std.testing.expectEqual(@as(f32, 6), m.trace());
}

test "trace 3x3" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ -2, -8, 4 }, .{ 1, -23, 4 }, .{ 0, 6, 4 } } };
    try std.testing.expectEqual(@as(f32, -21), m.trace());
}

test "trace zero matrix" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 0, 0, 0 }, .{ 0, 0, 0 }, .{ 0, 0, 0 } } };
    try std.testing.expectEqual(@as(f32, 0), m.trace());
}
