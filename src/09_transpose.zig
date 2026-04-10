const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;

pub fn main() void {
    const ma = Matrix(2, 3, f32){ .data = .{ .{ 2, 5, 3 }, .{ 4, 7, 0 } } };
    print("transpose({any}) = {any}\n", .{ ma.data, ma.transpose().data });

    const mb = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 3, 4 } } };
    print("transpose({any}) = {any}\n", .{ mb.data, mb.transpose().data });

    const mc = Matrix(1, 3, f32){ .data = .{.{ 1, 2, 3 }} };
    print("transpose({any}) = {any}\n", .{ mc.data, mc.transpose().data });

    const md = Matrix(3, 3, f32){ .data = .{ .{ 1, 2, 3 }, .{ 4, 5, 6 }, .{ 7, 8, 9 } } };
    print("transpose({any}) = {any}\n", .{ md.data, md.transpose().data });
}

test "transpose 2x3 matrix" {
    const m = Matrix(2, 3, f32){ .data = .{ .{ 2, 5, 3 }, .{ 4, 7, 0 } } };
    const result = m.transpose();
    try std.testing.expectEqual([3][2]f32{ .{ 2, 4 }, .{ 5, 7 }, .{ 3, 0 } }, result.data);
}

test "transpose square matrix" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 3, 4 } } };
    const result = m.transpose();
    try std.testing.expectEqual([2][2]f32{ .{ 1, 3 }, .{ 2, 4 } }, result.data);
}

test "transpose row vector to column" {
    const m = Matrix(1, 3, f32){ .data = .{.{ 1, 2, 3 }} };
    const result = m.transpose();
    try std.testing.expectEqual([3][1]f32{ .{1}, .{2}, .{3} }, result.data);
}

test "transpose double is identity" {
    const m = Matrix(2, 3, f32){ .data = .{ .{ 1, 2, 3 }, .{ 4, 5, 6 } } };
    try std.testing.expectEqual(m.data, m.transpose().transpose().data);
}
