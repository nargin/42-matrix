const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;

pub fn main() void {
    const ma = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    print("rank({any}) = {d}\n", .{ ma.data, ma.rank() });
    // 3

    const mb = Matrix(3, 4, f32){ .data = .{ .{ 1, 2, 0, 0 }, .{ 2, 4, 0, 0 }, .{ -1, 2, 1, 1 } } };
    print("rank({any}) = {d}\n", .{ mb.data, mb.rank() });
    // 2

    const mc = Matrix(4, 3, f32){ .data = .{
        .{ 8, 5, -2 },
        .{ 4, 7, 20 },
        .{ 7, 6, 1 },
        .{ 21, 18, 7 },
    } };
    print("rank({any}) = {d}\n", .{ mc.data, mc.rank() });
    // 3
}

test "identity rank 3" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    try std.testing.expectEqual(@as(usize, 3), m.rank());
}

test "rank deficient 3x4" {
    const m = Matrix(3, 4, f32){ .data = .{ .{ 1, 2, 0, 0 }, .{ 2, 4, 0, 0 }, .{ -1, 2, 1, 1 } } };
    try std.testing.expectEqual(@as(usize, 2), m.rank());
}

test "4x3 rank 3" {
    const m = Matrix(4, 3, f32){ .data = .{
        .{ 8, 5, -2 },
        .{ 4, 7, 20 },
        .{ 7, 6, 1 },
        .{ 21, 18, 7 },
    } };
    try std.testing.expectEqual(@as(usize, 3), m.rank());
}

test "zero matrix rank 0" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 0, 0, 0 }, .{ 0, 0, 0 }, .{ 0, 0, 0 } } };
    try std.testing.expectEqual(@as(usize, 0), m.rank());
}

test "full rank 2x2" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 3, 4 } } };
    try std.testing.expectEqual(@as(usize, 2), m.rank());
}
