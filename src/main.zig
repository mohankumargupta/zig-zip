const std = @import("std");

const zip = @cImport({
    @cInclude("zip.h");
});

pub fn main() !void {
    _ = zip.zip_extract("test.zip", ".", null, null);
}
