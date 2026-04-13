const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;

pub fn main() void {
    const ma = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    print("row_echelon({any}) =\n{any}\n\n", .{ ma.data, ma.row_echelon().data });

    const mb = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 3, 4 } } };
    print("row_echelon({any}) =\n{any}\n\n", .{ mb.data, mb.row_echelon().data });

    const mc = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 2, 4 } } };
    print("row_echelon({any}) =\n{any}\n\n", .{ mc.data, mc.row_echelon().data });

    const md = Matrix(3, 5, f32){ .data = .{
        .{ 8, 5, -2, 4, 28 },
        .{ 4, 2.5, 20, 4, -4 },
        .{ 8, 5, 1, 4, 17 },
    } };
    print("row_echelon({any}) =\n{any}\n\n", .{ md.data, md.row_echelon().data });
}

test "identity stays identity" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    try std.testing.expectEqual(m.data, m.row_echelon().data);
}

test "2x2 full rank" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 3, 4 } } };
    const expected = [2][2]f32{ .{ 1, 0 }, .{ 0, 1 } };
    try std.testing.expectEqual(expected, m.row_echelon().data);
}

test "2x2 rank deficient (dependent rows)" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 2, 4 } } };
    const expected = [2][2]f32{ .{ 1, 2 }, .{ 0, 0 } };
    try std.testing.expectEqual(expected, m.row_echelon().data);
}

test "3x5 general case (subject example)" {
    const m = Matrix(3, 5, f32){ .data = .{
        .{ 8, 5, -2, 4, 28 },
        .{ 4, 2.5, 20, 4, -4 },
        .{ 8, 5, 1, 4, 17 },
    } };
    const result = m.row_echelon();
    const expected = [3][5]f32{
        .{ 1, 0.625, 0, 0, -12.1666667 },
        .{ 0, 0, 1, 0, -3.6666667 },
        .{ 0, 0, 0, 1, 29.5 },
    };
    const eps = 1e-4;
    for (0..3) |i|
        for (0..5) |j|
            try std.testing.expectApproxEqAbs(expected[i][j], result.data[i][j], eps);
}

test "zero matrix stays zero" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 0, 0 }, .{ 0, 0 } } };
    const expected = [2][2]f32{ .{ 0, 0 }, .{ 0, 0 } };
    try std.testing.expectEqual(expected, m.row_echelon().data);
}

test "1x1 non-zero normalizes to 1" {
    const m = Matrix(1, 1, f32){ .data = .{.{5}} };
    const expected = [1][1]f32{.{1}};
    try std.testing.expectEqual(expected, m.row_echelon().data);
}
