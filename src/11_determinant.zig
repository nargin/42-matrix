const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;

pub fn main() void {
    const ma = Matrix(2, 2, f32){ .data = .{ .{ 1, -1 }, .{ -1, 1 } } };
    print("determinant({any}) = {d}\n", .{ ma.data, ma.determinant() });
    // 0.0

    const mb = Matrix(3, 3, f32){ .data = .{ .{ 2, 0, 0 }, .{ 0, 2, 0 }, .{ 0, 0, 2 } } };
    print("determinant({any}) = {d}\n", .{ mb.data, mb.determinant() });
    // 8.0

    const mc = Matrix(3, 3, f32){ .data = .{ .{ 8, 5, -2 }, .{ 4, 7, 20 }, .{ 7, 6, 1 } } };
    print("determinant({any}) = {d}\n", .{ mc.data, mc.determinant() });
    // -174.0

    const md = Matrix(4, 4, f32){ .data = .{
        .{ 8, 5, -2, 4 },
        .{ 4, 2.5, 20, 4 },
        .{ 8, 5, 1, 4 },
        .{ 28, -4, 17, 1 },
    } };
    print("determinant({any}) = {d}\n", .{ md.data, md.determinant() });
    // 1032.0
}

test "2x2 singular" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, -1 }, .{ -1, 1 } } };
    try std.testing.expectEqual(@as(f32, 0), m.determinant());
}

test "3x3 diagonal" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 2, 0, 0 }, .{ 0, 2, 0 }, .{ 0, 0, 2 } } };
    try std.testing.expectEqual(@as(f32, 8), m.determinant());
}

test "3x3 general" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 8, 5, -2 }, .{ 4, 7, 20 }, .{ 7, 6, 1 } } };
    try std.testing.expectApproxEqAbs(@as(f32, -174), m.determinant(), 1e-3);
}

test "4x4 general" {
    const m = Matrix(4, 4, f32){ .data = .{
        .{ 8, 5, -2, 4 },
        .{ 4, 2.5, 20, 4 },
        .{ 8, 5, 1, 4 },
        .{ 28, -4, 17, 1 },
    } };
    try std.testing.expectApproxEqAbs(@as(f32, 1032), m.determinant(), 1e-1);
}

test "1x1" {
    const m = Matrix(1, 1, f32){ .data = .{.{5}} };
    try std.testing.expectEqual(@as(f32, 5), m.determinant());
}

test "identity 3x3" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    try std.testing.expectEqual(@as(f32, 1), m.determinant());
}
