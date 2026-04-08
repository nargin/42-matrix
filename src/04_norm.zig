const std = @import("std");
const print = std.debug.print;

pub fn Vector(comptime size: usize, comptime T: type) type {
    return struct {
        data: [size]T,

        const Self = @This();

        fn norm_1(self: Self) T {
            var acc: T = 0;
            for (0..size) |i| {
                acc += @abs(self.data[i]);
            }
            return acc;
        }

        fn norm(self: Self) T {
            var acc: T = 0.0;
            for (0..size) |i| {
                acc += std.math.pow(T, self.data[i], 2);
            }
            return @sqrt(acc);
        }

        fn norm_inf(self: Self) T {
            var max: T = 0;
            for (0..size) |i| {
                max = @max(max, @abs(self.data[i]));
            }
            return max;
        }
    };
}

pub fn main() void {
    const e1 = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };

    print("{} {} {}\n", .{ e1.norm_1(), e1.norm(), e1.norm_inf() });
}

test "norm_1 zero vector" {
    const v = Vector(3, f32){ .data = .{ 0.0, 0.0, 0.0 } };
    try std.testing.expectEqual(@as(f32, 0.0), v.norm_1());
}

test "norm_1 positive values" {
    const v = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    try std.testing.expectEqual(@as(f32, 6.0), v.norm_1());
}

test "norm_1 negative values" {
    const v = Vector(3, f32){ .data = .{ -1.0, -2.0, 3.0 } };
    try std.testing.expectEqual(@as(f32, 6.0), v.norm_1());
}

test "norm zero vector" {
    const v = Vector(2, f32){ .data = .{ 0.0, 0.0 } };
    try std.testing.expectEqual(@as(f32, 0.0), v.norm());
}

test "norm 3-4-5 triangle" {
    const v = Vector(2, f32){ .data = .{ 3.0, 4.0 } };
    try std.testing.expectApproxEqAbs(@as(f32, 5.0), v.norm(), 1e-5);
}

test "norm unit vector" {
    const v = Vector(3, f32){ .data = .{ 1.0, 0.0, 0.0 } };
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), v.norm(), 1e-5);
}

test "norm_inf zero vector" {
    const v = Vector(3, f32){ .data = .{ 0.0, 0.0, 0.0 } };
    try std.testing.expectEqual(@as(f32, 0.0), v.norm_inf());
}

test "norm_inf picks largest absolute value" {
    const v = Vector(3, f32){ .data = .{ 1.0, -5.0, 2.0 } };
    try std.testing.expectEqual(@as(f32, 5.0), v.norm_inf());
}

test "norm_inf all negative" {
    const v = Vector(3, f32){ .data = .{ -1.0, -2.0, -3.0 } };
    try std.testing.expectEqual(@as(f32, 3.0), v.norm_inf());
}
