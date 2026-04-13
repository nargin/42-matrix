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
                acc = @mulAdd(T, self.data[i], self.data[i], acc);
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

        // ex08 - trace
        pub fn trace(self: Self) T {
            if (rows != cols) @compileError("trace requires a square matrix");
            var acc: T = 0;
            for (0..rows) |i| {
                acc += self.data[i][i];
            }
            return acc;
        }

        // ex09 - transpose
        pub fn transpose(self: Self) Matrix(cols, rows, T) {
            var a: Matrix(cols, rows, T) = undefined;
            for (0..rows) |i| {
                for (0..cols) |j| {
                    a.data[j][i] = self.data[i][j];
                }
            }
            return a;
        }

        // ex10 - row echelon (RREF)
        pub fn row_echelon(self: Self) Matrix(rows, cols, T) {
            var result: Matrix(rows, cols, T) = self;
            var pivot_row: usize = 0;

            for (0..cols) |col| {
                var found: ?usize = null;
                for (pivot_row..rows) |r| {
                    if (result.data[r][col] != 0) {
                        found = r;
                        break;
                    }
                }
                const pr = found orelse continue;

                if (pr != pivot_row)
                    std.mem.swap([cols]T, &result.data[pr], &result.data[pivot_row]);

                const pivot_val = result.data[pivot_row][col];
                for (0..cols) |c|
                    result.data[pivot_row][c] /= pivot_val;

                for (0..rows) |r| {
                    if (r == pivot_row) continue;
                    const factor = result.data[r][col];
                    for (0..cols) |c|
                        result.data[r][c] = @mulAdd(T, -factor, result.data[pivot_row][c], result.data[r][c]);
                }

                pivot_row += 1;
                if (pivot_row >= rows) break;
            }

            return result;
        }

        // ex11 - determinant
        fn minor(self: Self, comptime skip_row: usize, comptime skip_col: usize) Matrix(rows - 1, cols - 1, T) {
            var result: Matrix(rows - 1, cols - 1, T) = undefined;
            var ri: usize = 0;
            inline for (0..rows) |r| {
                if (r != skip_row) {
                    var ci: usize = 0;
                    inline for (0..cols) |c| {
                        if (c != skip_col) {
                            result.data[ri][ci] = self.data[r][c];
                            ci += 1;
                        }
                    }
                    ri += 1;
                }
            }
            return result;
        }

        pub fn determinant(self: Self) T {
            if (rows != cols) @compileError("determinant requires a square matrix");
            if (rows > 4) @compileError("determinant only supported up to 4x4");

            if (rows == 1) return self.data[0][0];

            if (rows == 2)
                return @mulAdd(T, self.data[0][0], self.data[1][1], -(self.data[0][1] * self.data[1][0]));

            var result: T = 0;
            inline for (0..rows) |j| {
                const sign: T = if (j & 1 == 0) 1 else -1;
                const cofactor = sign * self.minor(0, j).determinant();
                result = @mulAdd(T, self.data[0][j], cofactor, result);
            }
            return result;
        }

        // ex12 - inverse
        pub fn inverse(self: Self) !Matrix(rows, cols, T) {
            if (rows != cols) @compileError("inverse requires a square matrix");
            if (self.determinant() == 0) return error.SingularMatrix;

            var aug: Matrix(rows, 2 * cols, T) = undefined;
            for (0..rows) |i| {
                for (0..cols) |j| {
                    aug.data[i][j] = self.data[i][j];
                    aug.data[i][cols + j] = if (i == j) 1 else 0;
                }
            }

            const reduced = aug.row_echelon();

            var result: Matrix(rows, cols, T) = undefined;
            for (0..rows) |i| {
                for (0..cols) |j| {
                    result.data[i][j] = reduced.data[i][cols + j];
                }
            }

            return result;
        }

        // ex13 - rank
        pub fn rank(self: Self) usize {
            const rref = self.row_echelon();
            var r: usize = 0;
            for (0..rows) |i| {
                for (0..cols) |j| {
                    if (rref.data[i][j] != 0) {
                        r += 1;
                        break;
                    }
                }
            }
            return r;
        }
    };
}
