const std = @import("std");
const print = std.debug.print;
const Vector = @import("types.zig").Vector;

fn cross_product(u: anytype, v: @TypeOf(u)) @TypeOf(u.data[0]) {
    return Vector(3, @TypeOf(u.data[0])){
        u.data[1] * v.data[2] - u.data[2] * v.data[1],
        u.data[2] * v.data[0] - u.data[0] * v.data[2],
        u.data[0] * v.data[1] - u.data[1] * v.data[0],
    };
}

fn main() void {}
