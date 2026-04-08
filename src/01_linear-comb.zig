const std = @import("std");
const print = std.debug.print;
const Vector = @import("types.zig").Vector;

pub fn linear_combination(comptime size: usize, comptime T: type, u: []const Vector(size, T), coefs: []const T) Vector(size, T) {
    if (u.len != coefs.len) {
        @panic("linear_combination: u and coefs must have the same length");
    }

    var result: Vector(size, T) = undefined;
    for (0..size) |j| {
        result.data[j] = 0;
    }

    for (0..u.len) |i| {
        for (0..size) |j| {
            if (@typeInfo(T) == .float) {
                result.data[j] = @mulAdd(T, coefs[i], u[i].data[j], result.data[j]);
            } else {
                result.data[j] = coefs[i] * u[i].data[j] + result.data[j];
            }
        }
    }

    return result;
}

pub fn main() void {
    const e1 = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const e2 = Vector(3, f32){ .data = .{ 0.0, 1.0, 0.0 } };
    const e3 = Vector(3, f32){ .data = .{ 0.0, 0.0, 1.0 } };
    const vectors = [_]Vector(3, f32){ e1, e2, e3 };
    const coefs = [_]f32{ 10.0, -2.0, 0.5 };
    const r = linear_combination(3, f32, &vectors, &coefs);
    print("[{d}]\n[{d}]\n[{d}]\n", .{ r.data[0], r.data[1], r.data[2] });

    const v1 = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const v2 = Vector(3, f32){ .data = .{ 0.0, 10.0, -100.0 } };
    const vectors2 = [_]Vector(3, f32){ v1, v2 };
    const coefs2 = [_]f32{ 10.0, -2.0 };
    const r2 = linear_combination(3, f32, &vectors2, &coefs2);
    print("[{d}]\n[{d}]\n[{d}]\n", .{ r2.data[0], r2.data[1], r2.data[2] });
}

test "linear combination - basis vectors" {
    const e1 = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    const e2 = Vector(3, f32){ .data = .{ 0.0, 1.0, 0.0 } };
    const e3 = Vector(3, f32){ .data = .{ 0.0, 0.0, 1.0 } };
    const vectors = [_]Vector(3, f32){ e1, e2, e3 };
    const coefs = [_]f32{ 10.0, -2.0, 0.5 };

    const result = linear_combination(3, f32, &vectors, &coefs);

    try std.testing.expectEqual(@as(f32, 10.0), result.data[0]);
    try std.testing.expectEqual(@as(f32, -2.0), result.data[1]);
    try std.testing.expectEqual(@as(f32, 0.5), result.data[2]);
}

test "linear combination - single vector" {
    const v = Vector(2, f32){ .data = .{ 3.0, 4.0 } };
    const vectors = [_]Vector(2, f32){v};
    const coefs = [_]f32{2.0};

    const result = linear_combination(2, f32, &vectors, &coefs);

    try std.testing.expectEqual(@as(f32, 6.0), result.data[0]);
    try std.testing.expectEqual(@as(f32, 8.0), result.data[1]);
}

test "linear combination - zero coefficients" {
    const v1 = Vector(2, f32){ .data = .{ 1.0, 2.0 } };
    const v2 = Vector(2, f32){ .data = .{ 3.0, 4.0 } };
    const vectors = [_]Vector(2, f32){ v1, v2 };
    const coefs = [_]f32{ 0.0, 0.0 };

    const result = linear_combination(2, f32, &vectors, &coefs);

    try std.testing.expectEqual(@as(f32, 0.0), result.data[0]);
    try std.testing.expectEqual(@as(f32, 0.0), result.data[1]);
}

test "linear combination - two vectors" {
    const v1 = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const v2 = Vector(3, f32){ .data = .{ 0.0, 10.0, -100.0 } };
    const vectors = [_]Vector(3, f32){ v1, v2 };
    const coefs = [_]f32{ 10.0, -2.0 };

    const result = linear_combination(3, f32, &vectors, &coefs);

    try std.testing.expectEqual(@as(f32, 10.0), result.data[0]);
    try std.testing.expectEqual(@as(f32, 0.0), result.data[1]);
    try std.testing.expectEqual(@as(f32, 230.0), result.data[2]);
}
