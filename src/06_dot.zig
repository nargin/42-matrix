const std = @import("std");
const print = std.debug.print;
const Vector = @import("types.zig").Vector;

fn cross_product(u: anytype, v: @TypeOf(u)) @TypeOf(u) {
    const res = Vector(3, @TypeOf(u.data[0])){ .data = .{
        u.data[1] * v.data[2] - u.data[2] * v.data[1],
        u.data[2] * v.data[0] - u.data[0] * v.data[2],
        u.data[0] * v.data[1] - u.data[1] * v.data[0],
    } };
    return res;
}

pub fn main() void {
    const e1 = Vector(3, i32){ .data = .{ 1, 2, 3 } };
    const e2 = Vector(3, i32){ .data = .{ 4, 5, 6 } };
    print("cross({any}, {any}) = {any}\n", .{ e1.data, e2.data, cross_product(e1, e2).data });

    const i = Vector(3, f32){ .data = .{ 1, 0, 0 } };
    const j = Vector(3, f32){ .data = .{ 0, 1, 0 } };
    const k = Vector(3, f32){ .data = .{ 0, 0, 1 } };
    print("cross({any}, {any}) = {any}\n", .{ i.data, j.data, cross_product(i, j).data });
    print("cross({any}, {any}) = {any}\n", .{ j.data, k.data, cross_product(j, k).data });
    print("cross({any}, {any}) = {any}\n", .{ k.data, i.data, cross_product(k, i).data });

    const parallel1 = Vector(3, f32){ .data = .{ 1, 2, 3 } };
    const parallel2 = Vector(3, f32){ .data = .{ 2, 4, 6 } };
    print("cross({any}, {any}) = {any} (parallel)\n", .{ parallel1.data, parallel2.data, cross_product(parallel1, parallel2).data });

    const anticomm1 = Vector(3, f32){ .data = .{ 3, -3, 1 } };
    const anticomm2 = Vector(3, f32){ .data = .{ 4, 9, 2 } };
    print("cross({any}, {any}) = {any}\n", .{ anticomm1.data, anticomm2.data, cross_product(anticomm1, anticomm2).data });
    print("cross({any}, {any}) = {any} (reversed)\n", .{ anticomm2.data, anticomm1.data, cross_product(anticomm2, anticomm1).data });
}

test "cross product of standard basis vectors" {
    const i = Vector(3, f32){ .data = .{ 1, 0, 0 } };
    const j = Vector(3, f32){ .data = .{ 0, 1, 0 } };
    const k = Vector(3, f32){ .data = .{ 0, 0, 1 } };

    const ixj = cross_product(i, j);
    try std.testing.expectEqual([3]f32{ 0, 0, 1 }, ixj.data);

    const jxk = cross_product(j, k);
    try std.testing.expectEqual([3]f32{ 1, 0, 0 }, jxk.data);

    const kxi = cross_product(k, i);
    try std.testing.expectEqual([3]f32{ 0, 1, 0 }, kxi.data);
}

test "cross product anticommutativity" {
    const u = Vector(3, f32){ .data = .{ 1, 2, 3 } };
    const v = Vector(3, f32){ .data = .{ 4, 5, 6 } };

    const uxv = cross_product(u, v);
    const vxu = cross_product(v, u);

    for (0..3) |i| {
        try std.testing.expectApproxEqAbs(uxv.data[i], -vxu.data[i], 1e-6);
    }
}

test "cross product with parallel vectors is zero" {
    const u = Vector(3, f32){ .data = .{ 1, 2, 3 } };
    const v = Vector(3, f32){ .data = .{ 2, 4, 6 } };

    const result = cross_product(u, v);
    try std.testing.expectEqual([3]f32{ 0, 0, 0 }, result.data);
}

test "cross product known result" {
    const u = Vector(3, i32){ .data = .{ 1, 2, 3 } };
    const v = Vector(3, i32){ .data = .{ 4, 5, 6 } };

    const result = cross_product(u, v);
    // (2*6 - 3*5, 3*4 - 1*6, 1*5 - 2*4) = (-3, 6, -3)
    try std.testing.expectEqual([3]i32{ -3, 6, -3 }, result.data);
}
