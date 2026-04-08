const std = @import("std");
const Vector = @import("types.zig").Vector;
const Matrix = @import("types.zig").Matrix;

// lerp(u, v, t) = u + t * (v - u)
// Works on f32 scalars, Vectors, and Matrices.
pub fn lerp(comptime V: type, u: V, v: V, t: f32) V {
    switch (@typeInfo(V)) {
        .float => {
            const tc: V = @floatCast(t);
            return @mulAdd(V, tc, v - u, u);
        },
        .@"struct" => {
            var result: V = undefined;
            for (0..u.data.len) |i| {
                const Elem = @TypeOf(u.data[i]);
                switch (@typeInfo(Elem)) {
                    // Vector: data is [size]T
                    .float => {
                        const tc: Elem = @floatCast(t);
                        result.data[i] = @mulAdd(Elem, tc, v.data[i] - u.data[i], u.data[i]);
                    },
                    // Matrix: data is [rows][cols]T
                    .array => |arr| {
                        for (0..arr.len) |j| {
                            const tc: arr.child = @floatCast(t);
                            result.data[i][j] = @mulAdd(arr.child, tc, v.data[i][j] - u.data[i][j], u.data[i][j]);
                        }
                    },
                    else => @compileError("lerp: unsupported element type"),
                }
            }
            return result;
        },
        else => @compileError("lerp: unsupported type"),
    }
}

pub fn main() void {
    std.debug.print("{d}\n", .{lerp(f32, 0.0, 1.0, 0.0)});
    std.debug.print("{d}\n", .{lerp(f32, 0.0, 1.0, 1.0)});
    std.debug.print("{d}\n", .{lerp(f32, 0.0, 1.0, 0.5)});
    std.debug.print("{d}\n", .{lerp(f32, 21.0, 42.0, 0.3)});

    const u = Vector(2, f32){ .data = .{ 2.0, 1.0 } };
    const v = Vector(2, f32){ .data = .{ 4.0, 2.0 } };
    const rv = lerp(Vector(2, f32), u, v, 0.3);
    std.debug.print("[{d}]\n[{d}]\n", .{ rv.data[0], rv.data[1] });

    const um = Matrix(2, 2, f32){ .data = .{ .{ 2.0, 1.0 }, .{ 3.0, 4.0 } } };
    const vm = Matrix(2, 2, f32){ .data = .{ .{ 20.0, 10.0 }, .{ 30.0, 40.0 } } };
    const rm = lerp(Matrix(2, 2, f32), um, vm, 0.5);
    std.debug.print("[{d}, {d}]\n[{d}, {d}]\n", .{ rm.data[0][0], rm.data[0][1], rm.data[1][0], rm.data[1][1] });
}

test "lerp scalar t=0 returns u" {
    try std.testing.expectEqual(@as(f32, 0.0), lerp(f32, 0.0, 1.0, 0.0));
}

test "lerp scalar t=1 returns v" {
    try std.testing.expectEqual(@as(f32, 1.0), lerp(f32, 0.0, 1.0, 1.0));
}

test "lerp scalar t=0.5 returns midpoint" {
    try std.testing.expectEqual(@as(f32, 0.5), lerp(f32, 0.0, 1.0, 0.5));
}

test "lerp scalar arbitrary" {
    try std.testing.expectApproxEqAbs(@as(f32, 27.3), lerp(f32, 21.0, 42.0, 0.3), 1e-5);
}

test "lerp vector t=0.3" {
    const u = Vector(2, f32){ .data = .{ 2.0, 1.0 } };
    const v = Vector(2, f32){ .data = .{ 4.0, 2.0 } };
    const result = lerp(Vector(2, f32), u, v, 0.3);
    try std.testing.expectApproxEqAbs(@as(f32, 2.6), result.data[0], 1e-5);
    try std.testing.expectApproxEqAbs(@as(f32, 1.3), result.data[1], 1e-5);
}

test "lerp vector t=0 returns u" {
    const u = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const v = Vector(3, f32){ .data = .{ 4.0, 5.0, 6.0 } };
    const result = lerp(Vector(3, f32), u, v, 0.0);
    try std.testing.expectEqual(u.data, result.data);
}

test "lerp vector t=1 returns v" {
    const u = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const v = Vector(3, f32){ .data = .{ 4.0, 5.0, 6.0 } };
    const result = lerp(Vector(3, f32), u, v, 1.0);
    try std.testing.expectEqual(v.data, result.data);
}

test "lerp matrix t=0.5" {
    const u = Matrix(2, 2, f32){ .data = .{ .{ 2.0, 1.0 }, .{ 3.0, 4.0 } } };
    const v = Matrix(2, 2, f32){ .data = .{ .{ 20.0, 10.0 }, .{ 30.0, 40.0 } } };
    const result = lerp(Matrix(2, 2, f32), u, v, 0.5);
    try std.testing.expectApproxEqAbs(@as(f32, 11.0), result.data[0][0], 1e-5);
    try std.testing.expectApproxEqAbs(@as(f32, 5.5), result.data[0][1], 1e-5);
    try std.testing.expectApproxEqAbs(@as(f32, 16.5), result.data[1][0], 1e-5);
    try std.testing.expectApproxEqAbs(@as(f32, 22.0), result.data[1][1], 1e-5);
}
