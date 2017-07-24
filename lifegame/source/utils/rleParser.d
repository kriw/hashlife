module utils.rleParser;
import std.range;
import std.string;
import std.algorithm;
import std.conv;
import std.stdio;
import std.array;

string replicate(string value, int n) {
    return join(repeat(value, n));
}

string r(string s) {
    string ret = "";
    int n = 0;
    foreach(c ; s) {
        string cs = c.to!string();
        if(canFind("1234567890", c))
            n = 10 * n + cs.to!int();
        else {
            ret ~= n > 0 ? replicate(cs, n) : cs;
            n = 0;
        }
    }
    return ret;
}

string[] decodeRLE(int x, int y, string rle) {
    string[] lines = rle.split("$");
    foreach(i ; iota(max(0, y - lines.length)))
        lines ~= replicate("b", x);
    lines = lines.map!(r).array();
    immutable int l = lines[$-1][0..$-1].length.to!int();
    lines[$-1] = lines[$-1][0..$-1] ~
        replicate(lines[$-1][$-2].to!string(), x - l);
    return lines;
}

string readFile(string filename) {
    string[] ret;
    auto f = File(filename, "r");
    foreach(line ; f.byLine()) {
        if(!canFind(line, "#"))
            ret ~= chomp(line.to!string());
    }
    return join(ret);
}

string[] parse(string filename, int width, int height) {
    auto s = readFile("./Resource/otcametapixel.rle");
    /* decodeRLE(width, height, s).writeln(); */
    return decodeRLE(width, height, s);
}
