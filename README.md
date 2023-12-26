# Zip utility in Zig

Using C Library https://github.com/kuba--/zip 

1. Just copy three files {miniz.h, zip.h, zip.c} to a folder called zip (look at this repo).
2. Modify build.zig to build Zip C library as static library and add it to executable.

```diff
diff --git a/build_original.zig b/build.zig
index 49eb8ac..8bfab17 100644
--- a/build_original.zig
+++ b/build.zig
@@ -36,6 +36,9 @@ pub fn build(b: *std.Build) void {
         .optimize = optimize,
     });

+    const zipLibrary = addZipCLibrary(b, "zip", target, optimize);
+    exe.linkLibrary(zipLibrary);
+
     // This declares intent for the executable to be installed into the
     // standard location when the user invokes the "install" step (the default
     // step when running `zig build`).
@@ -89,3 +92,23 @@ pub fn build(b: *std.Build) void {
     test_step.dependOn(&run_lib_unit_tests.step);
     test_step.dependOn(&run_exe_unit_tests.step);
 }
+
+fn addZipCLibrary(
+    b: *std.Build,
+    name: []const u8,
+    target: std.zig.CrossTarget,
+    optimize: std.builtin.Mode,
+) *std.Build.Step.Compile {
+    const lib = b.addStaticLibrary(.{
+        .name = name,
+        .target = target,
+        .optimize = optimize,
+    });
+
+    lib.addCSourceFiles(.{ .files = &[_][]const u8{"zip/zip.c"}, .flags = &[_][]const u8{ "-Wall", "-O3" } });
+    lib.linkLibC();
+    lib.installHeader("zip/miniz.h", "miniz.h");
+    lib.installHeader("zip/zip.h", "zip.h");
+    b.installArtifact(lib);
+    return lib;
+}
```


3. Run 

 ```sh
    zig build run
```

