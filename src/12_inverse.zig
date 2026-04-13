const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;

pub fn main() void {
    const ma = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    print("inverse({any}) =\n{any}\n\n", .{ ma.data, (ma.inverse() catch unreachable).data });
    // [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]

    const mb = Matrix(3, 3, f32){ .data = .{ .{ 2, 0, 0 }, .{ 0, 2, 0 }, .{ 0, 0, 2 } } };
    print("inverse({any}) =\n{any}\n\n", .{ mb.data, (mb.inverse() catch unreachable).data });
    // [[0.5, 0.0, 0.0], [0.0, 0.5, 0.0], [0.0, 0.0, 0.5]]

    const mc = Matrix(3, 3, f32){ .data = .{ .{ 8, 5, -2 }, .{ 4, 7, 20 }, .{ 7, 6, 1 } } };
    print("inverse({any}) =\n{any}\n\n", .{ mc.data, (mc.inverse() catch unreachable).data });
    // [[0.649, 0.097, -0.655], [-0.781, -0.126, 0.965], [0.143, 0.074, -0.206]]
}

test "identity inverse is identity" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 } } };
    const result = try m.inverse();
    try std.testing.expectEqual(m.data, result.data);
}

test "scaled identity" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 2, 0, 0 }, .{ 0, 2, 0 }, .{ 0, 0, 2 } } };
    const result = try m.inverse();
    const expected = [3][3]f32{ .{ 0.5, 0, 0 }, .{ 0, 0.5, 0 }, .{ 0, 0, 0.5 } };
    for (0..3) |i|
        for (0..3) |j|
            try std.testing.expectApproxEqAbs(expected[i][j], result.data[i][j], 1e-5);
}

test "3x3 general" {
    const m = Matrix(3, 3, f32){ .data = .{ .{ 8, 5, -2 }, .{ 4, 7, 20 }, .{ 7, 6, 1 } } };
    const result = try m.inverse();
    const expected = [3][3]f32{
        .{ 0.649425287, 0.097701149, -0.655172414 },
        .{ -0.781609195, -0.126436782, 0.965517241 },
        .{ 0.143678161, 0.074712644, -0.206896552 },
    };
    for (0..3) |i|
        for (0..3) |j|
            try std.testing.expectApproxEqAbs(expected[i][j], result.data[i][j], 1e-4);
}

test "singular matrix returns error" {
    const m = Matrix(2, 2, f32){ .data = .{ .{ 1, 2 }, .{ 2, 4 } } };
    try std.testing.expectError(error.SingularMatrix, m.inverse());
}
