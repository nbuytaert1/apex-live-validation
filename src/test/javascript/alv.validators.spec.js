/*
 * GENERAL
 */

describe("isEmpty validation", function () {
    it("\"\" is empty (true)", function () {
        var result = alv.validators.isEmpty("");
        expect(result).toBe(true);
    });
    it("\"nick\" is NOT empty (false)", function () {
        var result = alv.validators.isEmpty("nick");
        expect(result).not.toBe(true);
    });
    it("\"   \" is NOT empty - whitespace is not trimmed (false)", function () {
        var result = alv.validators.isEmpty(" ");
        expect(result).not.toBe(true);
    });
    it("\"   nick\" is NOT empty - leading whitespace is not trimmed (false)", function () {
        var result = alv.validators.isEmpty("   nick");
        expect(result).not.toBe(true);
    });
    it("\"nick   \" is NOT empty - trailing whitespace is not trimmed (false)", function () {
        var result = alv.validators.isEmpty("nick   ");
        expect(result).not.toBe(true);
    });
    it("\"\\t\" is NOT empty - tabs are not trimmed (false)", function () {
        var result = alv.validators.isEmpty("\t");
        expect(result).not.toBe(true);
    });
    it("\"\\n\" is NOT empty - new lines are trimmed (false)", function () {
        var result = alv.validators.isEmpty("\n");
        expect(result).not.toBe(true);
    });
    it("\"\\r\" is NOT empty - carriage returns are trimmed (false)", function () {
        var result = alv.validators.isEmpty("\r");
        expect(result).not.toBe(true);
    });
});


describe("isBlank validation", function () {
    it("\"\" is blank (true)", function () {
        var result = alv.validators.isEmpty(alv.util.trim(""));
        expect(result).toBe(true);
    });
    it("\"nick\" is NOT blank (false)", function () {
        var result = alv.validators.isEmpty(alv.util.trim("nick"));
        expect(result).not.toBe(true);
    });
    it("\"   \" is blank - whitespace is trimmed (true)", function () {
        var result = alv.validators.isEmpty(alv.util.trim(" "));
        expect(result).toBe(true);
    });
    it("\"   nick\" is NOT blank - leading whitespace is trimmed (false)", function () {
        var result = alv.validators.isEmpty(alv.util.trim("   nick"));
        expect(result).not.toBe(true);
    });
    it("\"nick   \" is NOT blank - trailing whitespace is trimmed (false)", function () {
        var result = alv.validators.isEmpty(alv.util.trim("nick   "));
        expect(result).not.toBe(true);
    });
    it("\"\\t\" is blank - tabs are trimmed (true)", function () {
        var result = alv.validators.isEmpty(alv.util.trim("\t"));
        expect(result).toBe(true);
    });
    it("\"\\n\" is blank - new lines are trimmed (true)", function () {
        var result = alv.validators.isEmpty(alv.util.trim("\n"));
        expect(result).toBe(true);
    });
    it("\"\\r\" is blank - carriage returns are trimmed (true)", function () {
        var result = alv.validators.isEmpty(alv.util.trim("\r"));
        expect(result).toBe(true);
    });
});


describe("isEqual validation", function () {
    it("\"nick\" equals \"nick\" (true)", function () {
        var result = alv.validators.isEqual("nick", "nick");
        expect(result).toBe(true);
    });
    it("\"nick\" does NOT equal \"eric\" (false)", function () {
        var result = alv.validators.isEqual("nick", "eric");
        expect(result).not.toBe(true);
    });
    it("\"\" equals \"\" (true)", function () {
        var result = alv.validators.isEqual("", "");
        expect(result).toBe(true);
    });
});


describe("regExp validation", function () {
    it("\"#FFFFFF\" matches \"#[A-Fa-f0-9]{6}\" (true)", function () {
        var result = alv.validators.regex("#FFFFFF", "#[A-Fa-f0-9]{6}");
        expect(result).toBe(true);
    });
    it("\"FFFFFF\" does NOT match \"#[A-Fa-f0-9]{6}\" (false)", function () {
        var result = alv.validators.regex("FFFFFF", "#[A-Fa-f0-9]{6}");
        expect(result).not.toBe(true);
    });
    it("\"26/07/1990\" matches \"^(3[01]|[12][0-9]|0?[1-9])/(1[0-2]|0?[1-9])/(?:[0-9]{2})?[0-9]{2}$\" (true)", function () {
        var result = alv.validators.regex("26/07/1990", "^(3[01]|[12][0-9]|0?[1-9])/(1[0-2]|0?[1-9])/(?:[0-9]{2})?[0-9]{2}$");
        expect(result).toBe(true);
    });
    it("\"26/JUL/1990\" does NOT match \"^(3[01]|[12][0-9]|0?[1-9])/(1[0-2]|0?[1-9])/(?:[0-9]{2})?[0-9]{2}$\" (false)", function () {
        var result = alv.validators.regex("26/JUL/1990", "^(3[01]|[12][0-9]|0?[1-9])/(1[0-2]|0?[1-9])/(?:[0-9]{2})?[0-9]{2}$");
        expect(result).not.toBe(true);
    });
});


/*
 * ITEM TYPES
 */

describe("isAlphanumeric validation", function () {
    it("\"route66\" contains both alphabetic (lowercase) and numeric characters (true)", function () {
        var result = alv.validators.isAlphanumeric("route66");
        expect(result).toBe(true);
    });
    it("\"Route66\" contains both alphabetic (initcap) and numeric characters (true)", function () {
        var result = alv.validators.isAlphanumeric("Route66");
        expect(result).toBe(true);
    });
    it("\"ROUTE66\" contains both alphabetic (uppercase) and numeric characters (true)", function () {
        var result = alv.validators.isAlphanumeric("ROUTE66");
        expect(result).toBe(true);
    });
    it("\"Route\" contains only alphabetic characters (true)", function () {
        var result = alv.validators.isAlphanumeric("Route");
        expect(result).toBe(true);
    });
    it("\"66\" contains only numeric characters (true)", function () {
        var result = alv.validators.isAlphanumeric("66");
        expect(result).toBe(true);
    });
    it("\"Route 66\" contains a space (false)", function () {
        var result = alv.validators.isAlphanumeric("Route 66");
        expect(result).not.toBe(true);
    });
    it("\"Route_66\" contains an underscore (false)", function () {
        var result = alv.validators.isAlphanumeric("Route_66");
        expect(result).not.toBe(true);
    });
    it("\"\" is empty (true)", function () {
        var result = alv.validators.isAlphanumeric("");
        expect(result).toBe(true);
    });
    it("\"   \" contains whitespace (false)", function () {
        var result = alv.validators.isAlphanumeric("   ");
        expect(result).not.toBe(true);
    });
});


describe("isNumber validation", function () {
    it("\"123\" is a positive number (true)", function () {
        var result = alv.validators.isNumber("123", ".,");
        expect(result).toBe(true);
    });
    it("\"-123\" is a negative number (true)", function () {
        var result = alv.validators.isNumber("-123", ".,");
        expect(result).toBe(true);
    });
    it("\"123.45\" is a positive decimal number (true)", function () {
        var result = alv.validators.isNumber("123.45", ".,");
        expect(result).toBe(true);
    });
    it("\"-123.45\" is a negative decimal number (true)", function () {
        var result = alv.validators.isNumber("-123.45", ".,");
        expect(result).toBe(true);
    });
    it("\"0\" is a number (true)", function () {
        var result = alv.validators.isNumber("0", ".,");
        expect(result).toBe(true);
    });
    it("\".123\" is a number (true)", function () {
        var result = alv.validators.isNumber(".123", ".,");
        expect(result).toBe(true);
    });
    it("\"-.123\" is a number (true)", function () {
        var result = alv.validators.isNumber("-.123", ".,");
        expect(result).toBe(true);
    });
    it("\"00001.23\" is a number (true)", function () {
        var result = alv.validators.isNumber("00001.23", ".,");
        expect(result).toBe(true);
    });
    it("\"xyz\" is NOT a number (false)", function () {
        var result = alv.validators.isNumber("xyz", ".,");
        expect(result).not.toBe(true);
    });
    it("\"1D\" is NOT a number (false)", function () {
        var result = alv.validators.isNumber("1D", ".,");
        expect(result).not.toBe(true);
    });
    it("\"-1D\" is NOT a number (false)", function () {
        var result = alv.validators.isNumber("-1D", ".,");
        expect(result).not.toBe(true);
    });
});


describe("isDigit validation", function () {
    it("\"123\" contains only digits (true)", function () {
        var result = alv.validators.isDigit("123");
        expect(result).toBe(true);
    });
    it("\"-123\" contains a minus sign (false)", function () {
        var result = alv.validators.isDigit("-123");
        expect(result).not.toBe(true);
    });
    it("\"123xyz\" contains both digits and alphabetic characters (false)", function () {
        var result = alv.validators.isDigit("123xyz");
        expect(result).not.toBe(true);
    });
    it("\"xyz\" contains only alphabetic characters (false)", function () {
        var result = alv.validators.isDigit("xyz");
        expect(result).not.toBe(true);
    });
});


describe("isEmail validation", function () {
    it("should validate nickbuytaert@contribute.be - most simple form (true)", function () {
        var result = alv.validators.isEmail("nickbuytaert@contribute.be");
        expect(result).toBe(true);
    });
    it("should validate NICKBUYTAERT@CONTRIBUTE.BE - e-mail address in uppercase (true)", function () {
        var result = alv.validators.isEmail("NICKBUYTAERT@CONTRIBUTE.BE");
        expect(result).toBe(true);
    });
    it("should NOT validate nick@contribute - local domain name with no TLD (false)", function () {
        var result = alv.validators.isEmail("nick@contribute");
        expect(result).not.toBe(true);
    });
    it("should NOT validate nick.contribute.be - an @ character must separate the local and domain parts (false)", function () {
        var result = alv.validators.isEmail("nick.contribute.be");
        expect(result).not.toBe(true);
    });
    it("should NOT validate nick@buytaert@contribute.be - only one @ is allowed (false)", function () {
        var result = alv.validators.isEmail("nick@buytaert@contribute.be");
        expect(result).not.toBe(true);
    });
    it("should NOT validate @contribute.be - no local part (false)", function () {
        var result = alv.validators.isEmail("@contribute.be");
        expect(result).not.toBe(true);
    });
    it("should NOT validate nickbuytaert - no domain part (false)", function () {
        var result = alv.validators.isEmail("nickbuytaert");
        expect(result).not.toBe(true);
    });

    it("should validate nick_buytaert@contribute.be - underscore in the local part (true)", function () {
        var result = alv.validators.isEmail("nick_buytaert@contribute.be");
        expect(result).toBe(true);
    });
    it("should validate nick-buytaert@contribute.be - dash in the local part (true)", function () {
        var result = alv.validators.isEmail("nick-buytaert@contribute.be");
        expect(result).toBe(true);
    });
    it("should validate nick.buytaert@contribute.be - dot in the local part (true)", function () {
        var result = alv.validators.isEmail("nick.buytaert@contribute.be");
        expect(result).toBe(true);
    });
    it("should validate nick+buytaert@contribute.be - plus sign in the local part (true)", function () {
        var result = alv.validators.isEmail("nick+buytaert@contribute.be");
        expect(result).toBe(true);
    });
    it("should NOT validate nick buytaert@contribute.be - space in the local part (false)", function () {
        var result = alv.validators.isEmail("nick buytaert@contribute.be");
        expect(result).not.toBe(true);
    });
    it("should validate \"nickbuytaert\"@contribute.be - quotation marks in the local part (true)", function () {
        var result = alv.validators.isEmail("\"nickbuytaert\"@contribute.be");
        expect(result).toBe(true);
    });
    it("should validate 1234567890@contribute.be - only numbers in the local part (true)", function () {
        var result = alv.validators.isEmail("1234567890@contribute.be");
        expect(result).toBe(true);
    });

    it("should validate nickbuytaert@contribute-cronos.be - dash in the domain part (true)", function () {
        var result = alv.validators.isEmail("nickbuytaert@contribute-cronos.be");
        expect(result).toBe(true);
    });
    it("should validate nickbuytaert@contribute.cronos.be - dot in the domain part (true)", function () {
        var result = alv.validators.isEmail("nickbuytaert@contribute.cronos.be");
        expect(result).toBe(true);
    });
    it("should NOT validate nickbuytaert@contri bute.be - space in the domain part (false)", function () {
        var result = alv.validators.isEmail("nickbuytaert@contri bute.be");
        expect(result).not.toBe(true);
    });

    it("should validate nickbuytaert@contribute.be - shortest TLD (minimum 2) (true)", function () {
        var result = alv.validators.isEmail("nickbuytaert@contribute.be");
        expect(result).toBe(true);
    });
    it("should validate nickbuytaert@contribute.museum - longest TLD (maximum 6) (true)", function () {
        var result = alv.validators.isEmail("nickbuytaert@contribute.museum");
        expect(result).toBe(true);
    });
});


describe("isUrl validation", function () {
    it("should validate https://www.google.be/ (true)", function () {
        var result = alv.validators.isUrl("https://www.google.be/");
        expect(result).toBe(true);
    });
    it("should validate http://www.google.be/ (true)", function () {
        var result = alv.validators.isUrl("http://www.google.be/");
        expect(result).toBe(true);
    });
    it("should validate ftp://www.google.be/ (true)", function () {
        var result = alv.validators.isUrl("ftp://www.google.be/");
        expect(result).toBe(true);
    });
    it("should NOT validate htp://www.google.be/ (false)", function () {
        var result = alv.validators.isUrl("htp://www.google.be/");
        expect(result).not.toBe(true);
    });
    it("should NOT validate www.google.be/ (false)", function () {
        var result = alv.validators.isUrl("www.google.be/");
        expect(result).not.toBe(true);
    });
    it("should NOT validate google.be (false)", function () {
        var result = alv.validators.isUrl("google.be");
        expect(result).not.toBe(true);
    });
});


describe("isDate validation", function () {
    it("should validate 01/01/2013 - first day of the year (true)", function () {
        var result = alv.validators.isDate("01/01/2013", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
    it("should validate 31/12/2013 - last day of the year (true)", function () {
        var result = alv.validators.isDate("31/12/2013", "DD/MM/YYYY");
        expect(result).toBe(true);
    });

    it("should validate 31/01/2013 - 31 days in January (true)", function () {
        var result = alv.validators.isDate("31/01/2013", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
    it("should NOT validate 31/04/2013 - 30 days in April (false)", function () {
        var result = alv.validators.isDate("31/04/2013", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });

    it("should validate 29/02/2016 - leap year, 29 days in February (true)", function () {
        var result = alv.validators.isDate("29/02/2016", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
    it("should NOT validate 29/02/2013 - no leap year, no 29 days in February (false)", function () {
        var result = alv.validators.isDate("29/02/2013", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });

    it("should NOT validate 00/01/2013 - 00 as day part (false)", function () {
        var result = alv.validators.isDate("00/02/2013", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });
    it("should NOT validate 01/13/2013 - no more than twelve months in a year (false)", function () {
        var result = alv.validators.isDate("01/13/2013", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });
    it("should NOT validate 01/01/13 - DD/MM/YY notation (false)", function () {
        var result = alv.validators.isDate("01/01/13", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });

    it("should NOT validate xyz (false)", function () {
        var result = alv.validators.isDate("xyz", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });
    it("should validate 01-01-2013 - dashes instead of slashes (true)", function () {
        var result = alv.validators.isDate("01-01-2013", "DD-MM-YYYY");
        expect(result).toBe(true);
    });
    it("should validate 01.01.2013 - dots instead of slashes (true)", function () {
        var result = alv.validators.isDate("01.01.2013", "DD.MM.YYYY");
        expect(result).toBe(true);
    });
});


/*
 * STRINGS
 */

describe("minLength validation", function () {
    it("\"nick\" has a minimum length of 2 (true)", function () {
        var result = alv.validators.minLength("nick", 2);
        expect(result).toBe(true);
    });
    it("\"ni\" has a minimum length of 2 (true)", function () {
        var result = alv.validators.minLength("ni", 2);
        expect(result).toBe(true);
    });
    it("\"n\" does NOT have a minimum length of 2 (false)", function () {
        var result = alv.validators.minLength("n", 2);
        expect(result).not.toBe(true);
    });
    it("\"\" does NOT have a minimum length of 2, but is empty (true)", function () {
        var result = alv.validators.minLength("", 2);
        expect(result).toBe(true);
    });
    it("\"   \" has a minimum length of 2 (true)", function () {
        var result = alv.validators.minLength("   ", 2);
        expect(result).toBe(true);
    });
});


describe("maxLength validation", function () {
    it("\"nick\" exceeds the maximum length of 2 (false)", function () {
        var result = alv.validators.maxLength("nick", 2);
        expect(result).not.toBe(true);
    });
    it("\"ni\" does NOT exceed the maximum length of 2 (true)", function () {
        var result = alv.validators.maxLength("ni", 2);
        expect(result).toBe(true);
    });
    it("\"n\" does NOT exceed the maximum length of 2 (true)", function () {
        var result = alv.validators.maxLength("n", 2);
        expect(result).toBe(true);
    });
    it("\"\" does NOT exceed the maximum length of 2 (true)", function () {
        var result = alv.validators.maxLength("", 2);
        expect(result).toBe(true);
    });
    it("\"   \" exceeds the maximum length of 2 (false)", function () {
        var result = alv.validators.maxLength("   ", 2);
        expect(result).not.toBe(true);
    });
});


describe("rangeLength validation", function () {
    it("\"nick\" lies between 2 and 6 characters (true)", function () {
        var result = alv.validators.rangeLength("nick", 2, 6);
        expect(result).toBe(true);
    });
    it("\"ni\" lies between 2 and 6 characters (true)", function () {
        var result = alv.validators.rangeLength("ni", 2, 6);
        expect(result).toBe(true);
    });
    it("\"nickii\" lies between 2 and 6 characters (true)", function () {
        var result = alv.validators.rangeLength("nickii", 2, 6);
        expect(result).toBe(true);
    });
    it("\"n\" does NOT lie between 2 and 6 characters (false)", function () {
        var result = alv.validators.rangeLength("n", 2, 6);
        expect(result).not.toBe(true);
    });
    it("\"nick buytaert\" does NOT lie between 2 and 6 characters (false)", function () {
        var result = alv.validators.rangeLength("nick buytaert", 2, 6);
        expect(result).not.toBe(true);
    });
    it("\"\" does NOT lie between 2 and 6 characters, but is empty (true)", function () {
        var result = alv.validators.rangeLength("", 2, 6);
        expect(result).toBe(true);
    });
    it("\"   \" lies between 2 and 6 characters (true)", function () {
        var result = alv.validators.rangeLength("   ", 2, 6);
        expect(result).toBe(true);
    });
});


/*
 * NUMBERS
 */

describe("minNumber validation", function () {
    it("3 is greater than the minimum length of 2 (true)", function () {
        var result = alv.validators.minNumber(3, 2);
        expect(result).toBe(true);
    });
    it("2 equals the minimum length of 2 (true)", function () {
        var result = alv.validators.minNumber(2, 2);
        expect(result).toBe(true);
    });
    it("1 is less than the minimum length of 2 (false)", function () {
        var result = alv.validators.minNumber(1, 2);
        expect(result).not.toBe(true);
    });
});


describe("maxNumber validation", function () {
    it("3 is greater than the maximum length of 2 (false)", function () {
        var result = alv.validators.maxNumber(3, 2);
        expect(result).not.toBe(true);
    });
    it("2 equals the maximum length of 2 (true)", function () {
        var result = alv.validators.maxNumber(2, 2);
        expect(result).toBe(true);
    });
    it("1 is less than the maximum length of 2 (true)", function () {
        var result = alv.validators.maxNumber(1, 2);
        expect(result).toBe(true);
    });
});


describe("rangeNumber validation", function () {
    it("4 lies between 2 and 6 (true)", function () {
        var result = alv.validators.rangeNumber(4, 2, 6);
        expect(result).toBe(true);
    });
    it("2 lies between 2 and 6 (true)", function () {
        var result = alv.validators.rangeNumber(4, 2, 6);
        expect(result).toBe(true);
    });
    it("6 lies between 2 and 6 (true)", function () {
        var result = alv.validators.rangeNumber(4, 2, 6);
        expect(result).toBe(true);
    });
    it("1 does NOT lie between 2 and 6 (false)", function () {
        var result = alv.validators.rangeNumber(1, 2, 6);
        expect(result).not.toBe(true);
    });
    it("7 does NOT lie between 2 and 6 (false)", function () {
        var result = alv.validators.rangeNumber(7, 2, 6);
        expect(result).not.toBe(true);
    });
});


/*
 * CHECKBOXES
 */

// need html mock


/*
 * DATES
 */

describe("minDate validation", function () {
    it("31/07/1990 lies after 26/07/1990 (true)", function () {
        var result = alv.validators.minDate("31/07/1990", "26/07/1990", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
    it("26/07/1990 does NOT lie after 31/07/1990 (false)", function () {
        var result = alv.validators.minDate("26/07/1990", "31/07/1990", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });
    it("26/07/1990 is the same date as 26/07/1990 (true)", function () {
        var result = alv.validators.minDate("26/07/1990", "26/07/1990", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
});


describe("maxDate validation", function () {
    it("26/07/1990 lies before 01/01/1990 (true)", function () {
        var result = alv.validators.maxDate("01/01/1990", "26/07/1990", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
    it("26/07/1990 does NOT lie before 01/01/1990 (false)", function () {
        var result = alv.validators.maxDate("26/07/1990", "01/01/1990", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });
    it("26/07/1990 is the same date as 26/07/1990 (true)", function () {
        var result = alv.validators.maxDate("26/07/1990", "26/07/1990", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
});


describe("rangeDate validation", function () {
    it("26/07/1990 lies between 01/01/1990 and 01/01/1991 (true)", function () {
        var result = alv.validators.rangeDate("26/07/1990", "01/01/1990", "01/01/1991", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
    it("26/07/1990 does NOT lie between 01/01/1990 and 31/01/1990 (false)", function () {
        var result = alv.validators.rangeDate("26/07/1990", "01/01/1990", "31/01/1990", "DD/MM/YYYY");
        expect(result).not.toBe(true);
    });
    it("26/07/1990 lies between 26/07/1990 and 26/07/1990 (true)", function () {
        var result = alv.validators.rangeDate("26/07/1990", "26/07/1990", "26/07/1990", "DD/MM/YYYY");
        expect(result).toBe(true);
    });
});
