const std = @import("std");

pub fn Vector(comptime size: usize, comptime T: type) type {
    return struct {
        data: [size]T,

        const Self = @This();

        // ex00 - add, sub, scl
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

        // ex03 - dot product
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

        // ex04 - norms
        pub fn norm_1(self: Self) T {
            var acc: T = 0;
            for (0..size) |i| {
                acc += @abs(self.data[i]);
            }
            return acc;
        }

        pub fn norm(self: Self) T {
            var acc: T = 0;
            for (0..size) |i| {
                acc += std.math.pow(T, self.data[i], 2);
            }
            return @sqrt(acc);
        }

        pub fn norm_inf(self: Self) T {
            var max: T = 0;
            for (0..size) |i| {
                max = @max(max, @abs(self.data[i]));
            }
            return max;
        }
    };
}

pub fn Matrix(comptime rows: usize, comptime cols: usize, comptime T: type) type {
    return struct {
        data: [rows][cols]T,

        const Self = @This();

        // ex00 - add, sub, scl
        pub fn add(self: *Self, other: Self) void {
            for (0..rows) |i| {
                for (0..cols) |j| {
                    self.data[i][j] += other.data[i][j];
                }
            }
        }

        pub fn sub(self: *Self, other: Self) void {
            for (0..rows) |i| {
                for (0..cols) |j| {
                    self.data[i][j] -= other.data[i][j];
                }
            }
        }

        pub fn scl(self: *Self, scale: T) void {
            for (0..rows) |i| {
                for (0..cols) |j| {
                    self.data[i][j] *= scale;
                }
            }
        }
    };
}
