const std = @import("std");
const print = std.debug.print;
const Matrix = @import("types.zig").Matrix;
const Vector = @import("types.zig").Vector;

pub fn main() void {
    // mul_vec examples from subject
    const ma = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const va = Vector(2, f32){ .data = .{ 4, 2 } };
    print("mul_vec({any}, {any}) = {any}\n", .{ ma.data, va.data, ma.mul_vec(va).data });
    // [4., 2.]

    const mb = Matrix(2, 2, f32){ .data = .{ .{ 2, 0 }, .{ 0, 2 } } };
    const vb = Vector(2, f32){ .data = .{ 4, 2 } };
    print("mul_vec({any}, {any}) = {any}\n", .{ mb.data, vb.data, mb.mul_vec(vb).data });
    // [8., 4.]

    const mc = Matrix(2, 2, f32){ .data = .{ .{ 2, -2 }, .{ -2, 2 } } };
    const vc = Vector(2, f32){ .data = .{ 4, 2 } };
    print("mul_vec({any}, {any}) = {any}\n", .{ mc.data, vc.data, mc.mul_vec(vc).data });
    // [4., -4.]

    // mul_mat examples from subject
    const a1 = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const b1 = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    print("mul_mat({any}, {any}) = {any}\n", .{ a1.data, b1.data, a1.mul_mat(2, b1).data });
    // [[1., 0.], [0., 1.]]

    const a2 = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const b2 = Matrix(2, 2, f32){ .data = .{ .{ 2, 1 }, .{ 4, 2 } } };
    print("mul_mat({any}, {any}) = {any}\n", .{ a2.data, b2.data, a2.mul_mat(2, b2).data });
    // [[2., 1.], [4., 2.]]

    const a3 = Matrix(2, 2, f32){ .data = .{ .{ 3, -5 }, .{ 6, 8 } } };
    const b3 = Matrix(2, 2, f32){ .data = .{ .{ 2, 1 }, .{ 4, 2 } } };
    print("mul_mat({any}, {any}) = {any}\n", .{ a3.data, b3.data, a3.mul_mat(2, b3).data });
    // [[-14., -7.], [44., 22.]]
}

test "mul_vec identity matrix" {
    const u = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const v = Vector(2, f32){ .data = .{ 4, 2 } };
    const result = u.mul_vec(v);
    try std.testing.expectEqual([2]f32{ 4, 2 }, result.data);
}

test "mul_vec scale matrix" {
    const u = Matrix(2, 2, f32){ .data = .{ .{ 2, 0 }, .{ 0, 2 } } };
    const v = Vector(2, f32){ .data = .{ 4, 2 } };
    const result = u.mul_vec(v);
    try std.testing.expectEqual([2]f32{ 8, 4 }, result.data);
}

test "mul_vec mixed matrix" {
    const u = Matrix(2, 2, f32){ .data = .{ .{ 2, -2 }, .{ -2, 2 } } };
    const v = Vector(2, f32){ .data = .{ 4, 2 } };
    const result = u.mul_vec(v);
    try std.testing.expectEqual([2]f32{ 4, -4 }, result.data);
}

test "mul_mat identity" {
    const a = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const b = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const result = a.mul_mat(2, b);
    try std.testing.expectEqual([2][2]f32{ .{ 1, 0 }, .{ 0, 1 } }, result.data);
}

test "mul_mat identity times matrix" {
    const a = Matrix(2, 2, f32){ .data = .{ .{ 1, 0 }, .{ 0, 1 } } };
    const b = Matrix(2, 2, f32){ .data = .{ .{ 2, 1 }, .{ 4, 2 } } };
    const result = a.mul_mat(2, b);
    try std.testing.expectEqual([2][2]f32{ .{ 2, 1 }, .{ 4, 2 } }, result.data);
}

test "mul_mat general" {
    const a = Matrix(2, 2, f32){ .data = .{ .{ 3, -5 }, .{ 6, 8 } } };
    const b = Matrix(2, 2, f32){ .data = .{ .{ 2, 1 }, .{ 4, 2 } } };
    const result = a.mul_mat(2, b);
    try std.testing.expectEqual([2][2]f32{ .{ -14, -7 }, .{ 44, 22 } }, result.data);
}
