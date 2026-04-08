const std = @import("std");
const print = std.debug.print;

pub fn Vector(comptime size: usize, comptime T: type) type {
    return struct {
        data: [size]T,

        const Self = @This();

        pub fn add(self: *Self, other: Self) void {
            for (0..size) |i| {
                self.data[i] += other.data[i];
            }
        }

        pub fn sub(self: *Self, other: Self) void {
            for (0..size) |i| {
                self.data[i] -= other.data[i];
            }
        }

        pub fn scl(self: *Self, scale: T) void {
            for (0..size) |i| {
                self.data[i] *= scale;
            }
        }

        pub fn dot(self: *const Self, other: Self) T {
            var acc: T = 0;
            for (0..size) |i| {
                if (@typeInfo(T) == .float) {
                    acc = @mulAdd(T, self.data[i], other.data[i], acc);
                } else {
                    acc += self.data[i] * other.data[i];
                }
            }
            return acc;
        }
    };
}

pub fn main() void {
    const e1 = Vector(3, f32){ .data = .{ 0.0, 0.0, 0.0 } };
    const e2 = Vector(3, f32){ .data = .{ 1.0, 1.0, 1.0 } };
    const e3 = Vector(3, f32){ .data = .{ -1.0, 0.0, 6.0 } };
    const e4 = Vector(3, f32){ .data = .{ 3.0, 0.0, 2.0 } };

    print("scalar: {}\n", .{e1.dot(e2)});
    print("scalar: {}\n", .{e2.dot(e2)});
    print("scalar: {}\n", .{e3.dot(e2)});
    print("scalar: {}\n", .{e3.dot(e4)});
}

test "dot product - zero vector" {
    const u = Vector(3, f32){ .data = .{ 0.0, 0.0, 0.0 } };
    const v = Vector(3, f32){ .data = .{ 1.0, 1.0, 1.0 } };
    try std.testing.expectEqual(@as(f32, 0.0), u.dot(v));
}

test "dot product - same vector" {
    const u = Vector(3, f32){ .data = .{ 1.0, 1.0, 1.0 } };
    try std.testing.expectEqual(@as(f32, 3.0), u.dot(u));
}

test "dot product - basic" {
    const u = Vector(3, f32){ .data = .{ 1.0, 2.0, 3.0 } };
    const v = Vector(3, f32){ .data = .{ 4.0, 5.0, 6.0 } };
    try std.testing.expectEqual(@as(f32, 32.0), u.dot(v));
}

test "dot product - negative result" {
    const u = Vector(3, f32){ .data = .{ -1.0, 0.0, 6.0 } };
    const v = Vector(3, f32){ .data = .{ 3.0, 0.0, 2.0 } };
    try std.testing.expectEqual(@as(f32, 9.0), u.dot(v));
}

test "dot product - integer type" {
    const u = Vector(3, i32){ .data = .{ 1, 2, 3 } };
    const v = Vector(3, i32){ .data = .{ 4, 5, 6 } };
    try std.testing.expectEqual(@as(i32, 32), u.dot(v));
}
