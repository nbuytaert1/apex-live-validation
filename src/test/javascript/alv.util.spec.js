describe("alv.util.trim()", function () {
    it("\"nick\" should return \"nick\"", function () {
        var result = alv.util.trim("nick");
        expect(result).toEqual("nick");
    });
    it("\"ni ck\" should return \"ni ck\"", function () {
        var result = alv.util.trim("ni ck");
        expect(result).toEqual("ni ck");
    });
    it("\"\" should return \"\"", function () {
        var result = alv.util.trim("");
        expect(result).toEqual("");
    });
    it("\"  nick\" should return \"nick\"", function () {
        var result = alv.util.trim("  nick");
        expect(result).toEqual("nick");
    });
    it("\"nick    \" should return \"nick\"", function () {
        var result = alv.util.trim("nick    ");
        expect(result).toEqual("nick");
    });
    it("\"  nick    \" should return \"nick\"", function () {
        var result = alv.util.trim("  nick    ");
        expect(result).toEqual("nick");
    });
});