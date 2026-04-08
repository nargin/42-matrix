const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "42-matrix",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.graph.host,
        }),
    });

    b.installArtifact(exe);

    const launch_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the executable");
    run_step.dependOn(&launch_exe.step);
}
