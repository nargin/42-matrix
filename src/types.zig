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

        // ex07 - matrix manipulation
        pub fn mul_vec(self: Self, vec: Vector(cols, T)) Vector(rows, T) {
            var result: Vector(rows, T) = .{ .data = std.mem.zeroes([rows]T) };
            for (0..rows) |i| {
                for (0..cols) |j| {
                    result.data[i] = @mulAdd(T, self.data[i][j], vec.data[j], result.data[i]);
                }
            }
            return result;
        }

        // src : https://en.wikipedia.org/wiki/Matrix_multiplication_algorithm
        /// Multiplies this matrix (m×n) by another matrix (n×p).
        /// Returns a new matrix of shape (m×p).
        /// Where p is the cols of the second param mat.
        pub fn mul_mat(self: Self, comptime p: usize, mat: Matrix(cols, p, T)) Matrix(rows, p, T) {
            var result: Matrix(rows, p, T) = .{ .data = std.mem.zeroes([rows][p]T) };
            for (0..rows) |i| {
                for (0..p) |j| {
                    for (0..cols) |k| {
                        result.data[i][j] = @mulAdd(T, self.data[i][k], mat.data[k][j], result.data[i][j]);
                    }
                }
            }
            return result;
        }

        // ex08 - trace == diagonale
        pub fn trace(self: Self) T {
            var acc: T = 0;
            for (0..@min(rows, cols)) |i| {
                acc += self.data[i][i];
            }
            return acc;
        }

        // ex09 - transpose rotation main diagonale
        pub fn transpose(self: Self) Matrix(cols, rows, T) {
            var a: Matrix(cols, rows, T) = undefined;
            for (0..rows) |i| {
                for (0..cols) |j| {
                    a.data[j][i] = self.data[i][j];
                }
            }

            return a;
        }

        pub fn row_echelon(self: Self) Matrix(rows, cols, T) {}
    };
}
