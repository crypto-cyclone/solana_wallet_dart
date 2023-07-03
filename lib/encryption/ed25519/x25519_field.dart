class X25519Field {
  static const int SIZE = 10;

  static const int M24 = 0x00FFFFFF;
  static const int M25 = 0x01FFFFFF;
  static const int M26 = 0x03FFFFFF;

  static const List<int> P32 = <int>[
    0xFFFFFFED, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
    0xFFFFFFFF, 0x7FFFFFFF
  ];

  static const List<int> ROOT_NEG_ONE = <int>[
    0x020EA0B0, 0x0386C9D2, 0x00478C4E, 0x0035697F, 0x005E8630,
    0x01FBD7A7, 0x0340264F, 0x01F0B2B4, 0x00027E0E, 0x00570649
  ];

  X25519Field();

  static void add(List<int> x, List<int> y, List<int> z) {
    for (var i = 0; i < SIZE; ++i) {
      z[i] = x[i] + y[i];
    }
  }

  static void addOne(List<int> z, [int zOff = 0]) {
    z[zOff] += 1;
  }

  static void apm(List<int> x, List<int> y, List<int> zp, List<int> zm) {
    for (var i = 0; i < SIZE; ++i) {
      var xi = x[i], yi = y[i];
      zp[i] = xi + yi;
      zm[i] = xi - yi;
    }
  }

  static int areEqual(List<int> x, List<int> y) {
    var d = 0;
    for (var i = 0; i < SIZE; ++i) {
      d |= x[i] ^ y[i];
    }
    d = (d >> 1) | (d & 1);
    return (d - 1) >> 31;
  }

  static bool areEqualVar(List<int> x, List<int> y) {
    return 0 != areEqual(x, y);
  }

  static void carry(List<int> z) {
    var z0 = z[0], z1 = z[1], z2 = z[2], z3 = z[3], z4 = z[4];
    var z5 = z[5], z6 = z[6], z7 = z[7], z8 = z[8], z9 = z[9];

    z2 += (z1 >> 26); z1 &= M26;
    z4 += (z3 >> 26); z3 &= M26;
    z7 += (z6 >> 26); z6 &= M26;
    z9 += (z8 >> 26); z8 &= M26;

    z3 += (z2 >> 25); z2 &= M25;
    z5 += (z4 >> 25); z4 &= M25;
    z8 += (z7 >> 25); z7 &= M25;
    z0 += (z9 >> 25) * 38; z9 &= M25;

    z1 += (z0 >> 26); z0 &= M26;
    z6 += (z5 >> 26); z5 &= M26;

    z2 += (z1 >> 26); z1 &= M26;
    z4 += (z3 >> 26); z3 &= M26;
    z7 += (z6 >> 26); z6 &= M26;
    z9 += (z8 >> 26); z8 &= M26;

    z[0] = z0; z[1] = z1; z[2] = z2; z[3] = z3; z[4] = z4;
    z[5] = z5; z[6] = z6; z[7] = z7; z[8] = z8; z[9] = z9;
  }

  static void cmov(int cond, List<int> x, int xOff, List<int> z, int zOff) {
    for (int i = 0; i < SIZE; ++i) {
      int z_i = z[zOff + i], diff = z_i ^ x[xOff + i];
      z_i ^= (diff & cond);
      z[zOff + i] = z_i;
    }
  }

  static void cnegate(int negate, List<int> z) {
    int mask = 0 - negate;
    for (int i = 0; i < SIZE; ++i) {
      z[i] = (z[i] ^ mask) - mask;
    }
  }

  static void copy(List<int> x, int xOff, List<int> z, int zOff) {
    for (int i = 0; i < SIZE; ++i) {
      z[zOff + i] = x[xOff + i];
    }
  }

  static List<int> create() {
    return List<int>.filled(SIZE, 0);
  }

  static List<int> createTable(int n) {
    return List<int>.filled(SIZE * n, 0);
  }

  static void cswap(int swap, List<int> a, List<int> b) {
    int mask = 0 - swap;
    for (int i = 0; i < SIZE; ++i) {
      int ai = a[i], bi = b[i];
      int dummy = mask & (ai ^ bi);
      a[i] = ai ^ dummy;
      b[i] = bi ^ dummy;
    }
  }

  static void decode(List<int> x, int xOff, List<int> z) {
    decode128(x, xOff, z, 0);
    decode128(x, xOff + 4, z, 5);
    z[9] &= M24;
  }

  static void decodeByte(List<int> x, int xOff, List<int> z) {
    decode128(x, xOff, z, 0);
    decode128(x, xOff + 16, z, 5);
    z[9] &= M24;
  }

  static void decode128(List<int> is_, int off, List<int> z, int zOff) {
    int t0 = is_[off + 0], t1 = is_[off + 1], t2 = is_[off + 2], t3 = is_[off + 3];

    z[zOff + 0] = t0 & M26;
    z[zOff + 1] = ((t1 << 6) | (t0 >> 26)) & M26;
    z[zOff + 2] = ((t2 << 12) | (t1 >> 20)) & M25;
    z[zOff + 3] = ((t3 << 19) | (t2 >> 13)) & M26;
    z[zOff + 4] = t3 >> 7;
  }

  static void decode128Byte(List<int> bs, int off, List<int> z, int zOff) {
    int t0 = decode32(bs, off + 0);
    int t1 = decode32(bs, off + 4);
    int t2 = decode32(bs, off + 8);
    int t3 = decode32(bs, off + 12);

    z[zOff + 0] = t0 & M26;
    z[zOff + 1] = ((t1 << 6) | (t0 >> 26)) & M26;
    z[zOff + 2] = ((t2 << 12) | (t1 >> 20)) & M25;
    z[zOff + 3] = ((t3 << 19) | (t2 >> 13)) & M26;
    z[zOff + 4] = t3 >> 7;
  }

  static int decode32(List<int> bs, int off) {
    int n = bs[off] & 0xFF;
    n |= (bs[++off] & 0xFF) << 8;
    n |= (bs[++off] & 0xFF) << 16;
    n |= bs[++off] << 24;
    return n;
  }

  static void encode(List<int> x, List<int> z, int zOff) {
    encode128(x, 0, z, zOff);
    encode128(x, 5, z, zOff + 4);
  }

  static void encodeByte(List<int> x, List<int> z, int zOff) {
    encode128(x, 0, z, zOff);
    encode128(x, 5, z, zOff + 16);
  }

  static void encode128(List<int> x, int xOff, List<int> is_, int off) {
    int x0 = x[xOff + 0], x1 = x[xOff + 1], x2 = x[xOff + 2], x3 = x[xOff + 3], x4 = x[xOff + 4];

    is_[off + 0] = x0 | (x1 << 26);
    is_[off + 1] = (x1 >> 6) | (x2 << 20);
    is_[off + 2] = (x2 >> 12) | (x3 << 13);
    is_[off + 3] = (x3 >> 19) | (x4 << 7);
  }

  static void encode128Byte(List<int> x, int xOff, List<int> bs, int off) {
    int x0 = x[xOff + 0], x1 = x[xOff + 1], x2 = x[xOff + 2], x3 = x[xOff + 3], x4 = x[xOff + 4];

    int t0 = x0 | (x1 << 26);
    encode32(t0, bs, off + 0);
    int t1 = (x1 >> 6) | (x2 << 20);
    encode32(t1, bs, off + 4);
    int t2 = (x2 >> 12) | (x3 << 13);
    encode32(t2, bs, off + 8);
    int t3 = (x3 >> 19) | (x4 << 7);
    encode32(t3, bs, off + 12);
  }

  static void encode32(int n, List<int> bs, int off) {
    bs[off] = n & 0xFF;
    bs[++off] = (n >> 8) & 0xFF;
    bs[++off] = (n >> 16) & 0xFF;
    bs[++off] = (n >> 24) & 0xFF;
  }

  static void inv(List<int> x, List<int> z) {
    List<int> t = create();
    List<int> u = List<int>.filled(8, 0);

    copy(x, 0, t, 0);
    normalize(t);
    encode(t, u, 0);

    Mod.modOddInverse(P32, u, u);

    decode(u, 0, z);
  }

  static void invVar(List<int> x, List<int> z) {
    List<int> t = create();
    List<int> u = List<int>.filled(8, 0);

    copy(x, 0, t, 0);
    normalize(t);
    encode(t, u, 0);

    Mod.modOddInverseVar(P32, u, u);

    decode(u, 0, z);
  }

  static int isOne(List<int> x) {
    int d = x[0] ^ 1;
    for (int i = 1; i < SIZE; ++i) {
      d |= x[i];
    }
    d = (d >> 1) | (d & 1);
    return (d - 1) >> 31;
  }

  static bool isOneVar(List<int> x) {
    return isOne(x) != 0;
  }

  static int isZero(List<int> x) {
    int d = 0;
    for (int i = 0; i < SIZE; ++i) {
      d |= x[i];
    }
    d = (d >> 1) | (d & 1);
    return (d - 1) >> 31;
  }

  static bool isZeroVar(List<int> x) {
    return isZero(x) != 0;
  }

  void mulArrayAndScalar(List<int> x, int y, List<int> z) {
    int x0 = x[0], x1 = x[1], x2 = x[2], x3 = x[3], x4 = x[4];
    int x5 = x[5], x6 = x[6], x7 = x[7], x8 = x[8], x9 = x[9];
    int c0, c1, c2, c3;

    c0 = (x2 * y); x2 = (c0 & M25); c0 >>= 25;
    c1 = (x4 * y); x4 = (c1 & M25); c1 >>= 25;
    c2 = (x7 * y); x7 = (c2 & M25); c2 >>= 25;
    c3 = (x9 * y); x9 = (c3 & M25); c3 >>= 25;
    c3 *= 38;

    c3 += (x0 * y); z[0] = (c3 & M26); c3 >>= 26;
    c1 += (x5 * y); z[5] = (c1 & M26); c1 >>= 26;

    c3 += (x1 * y); z[1] = (c3 & M26); c3 >>= 26;
    c0 += (x3 * y); z[3] = (c0 & M26); c0 >>= 26;
    c1 += (x6 * y); z[6] = (c1 & M26); c1 >>= 26;
    c2 += (x8 * y); z[8] = (c2 & M26); c2 >>= 26;

    z[2] = x2 + c3;
    z[4] = x4 + c0;
    z[7] = x7 + c1;
    z[9] = x9 + c2;
  }

  void mulArrayAndArray(List<int> x, List<int> y, List<int> z) {
    int x0 = x[0], y0 = y[0];
    int x1 = x[1], y1 = y[1];
    int x2 = x[2], y2 = y[2];
    int x3 = x[3], y3 = y[3];
    int x4 = x[4], y4 = y[4];

    int u0 = x[5], v0 = y[5];
    int u1 = x[6], v1 = y[6];
    int u2 = x[7], v2 = y[7];
    int u3 = x[8], v3 = y[8];
    int u4 = x[9], v4 = y[9];

    int a0  = x0 * y0;
    int a1  = x0 * y1 + x1 * y0;
    int a2  = x0 * y2 + x1 * y1 + x2 * y0;
    int a3  = x1 * y2 + x2 * y1;
    a3 <<= 1;
    a3 += x0 * y3 + x3 * y0;
    int a4  = x2 * y2;
    a4 <<= 1;
    a4 += x0 * y4 + x1 * y3 + x3 * y1 + x4 * y0;
    int a5  = x1 * y4 + x2 * y3 + x3 * y2 + x4 * y1;
    a5 <<= 1;
    int a6  = x2 * y4 + x4 * y2;
    a6 <<= 1;
    a6 += x3 * y3;
    int a7  = x3 * y4 + x4 * y3;
    int a8  = x4 * y4;
    a8 <<= 1;

    int b0  = u0 * v0;
    int b1  = u0 * v1 + u1 * v0;
    int b2  = u0 * v2 + u1 * v1 + u2 * v0;
    int b3  = u1 * v2 + u2 * v1;
    b3 <<= 1;
    b3 += u0 * v3 + u3 * v0;
    int b4  = u2 * v2;
    b4 <<= 1;
    b4 += u0 * v4 + u1 * v3 + u3 * v1 + u4 * v0;
    int b5  = u1 * v4 + u2 * v3 + u3 * v2 + u4 * v1;
    int b6  = u2 * v4 + u4 * v2;
    b6 <<= 1;
    b6 += u3 * v3;
    int b7  = u3 * v4 + u4 * v3;
    int b8  = u4 * v4;

    a0 -= b5 * 76;
    a1 -= b6 * 38;
    a2 -= b7 * 38;
    a3 -= b8 * 76;

    a5 -= b0;
    a6 -= b1;
    a7 -= b2;
    a8 -= b3;

    x0 += u0; y0 += v0;
    x1 += u1; y1 += v1;
    x2 += u2; y2 += v2;
    x3 += u3; y3 += v3;
    x4 += u4; y4 += v4;

    int c0  = x0 * y0;
    int c1  = x0 * y1 + x1 * y0;
    int c2  = x0 * y2 + x1 * y1 + x2 * y0;
    int c3  = x1 * y2 + x2 * y1;
    c3 <<= 1;
    c3 += x0 * y3 + x3 * y0;
    int c4  = x2 * y2;
    c4 <<= 1;
    c4 += x0 * y4 + x1 * y3 + x3 * y1 + x4 * y0;
    int c5  = x1 * y4 + x2 * y3 + x3 * y2 + x4 * y1;
    c5 <<= 1;
    int c6  = x2 * y4 + x4 * y2;
    c6 <<= 1;
    c6 += x3 * y3;
    int c7  = x3 * y4 + x4 * y3;
    int c8  = x4 * y4;
    c8 <<= 1;

    int z8, z9;
    int t;

    t = a8 + (c3 - a3);
    z8 = t & M26; t >>= 26;
    t += (c4 - a4) - b4;
    z9 = t & M25; t >>= 25;
    t = a0 + (t + c5 - a5) * 38;
    z[0] = t & M26; t >>= 26;
    t += a1 + (c6 - a6) * 38;
    z[1] = t & M26; t >>= 26;
    t += a2 + (c7 - a7) * 38;
    z[2] = t & M25; t >>= 25;
    t += a3 + (c8 - a8) * 38;
    z[3] = t & M26; t >>= 26;
    t += a4 + b4 * 38;
    z[4] = t & M25; t >>= 25;
    t += a5 + (c0 - a0);
    z[5] = t & M26; t >>= 26;
    t += a6 + (c1 - a1);
    z[6] = t & M26; t >>= 26;
    t += a7 + (c2 - a2);
    z[7] = t & M25; t >>= 25;
    t += z8;
    z[8] = t & M26; t >>= 26;
    z[9] = z9 + t;
  }

  void negate(List<int> x, List<int> z) {
    for (int i = 0; i < SIZE; ++i) {
      z[i] = -x[i];
    }
  }

  void normalize(List<int> z) {
    int x = ((z[9] >> 23) & 1);
    reduce(z, x);
    reduce(z, -x);
    // assert z[9] >> 24 == 0;
  }

  void one(List<int> z) {
    z[0] = 1;
    for (int i = 1; i < SIZE; ++i) {
      z[i] = 0;
    }
  }

  void powPm5d8(List<int> x, List<int> rx2, List<int> rz) {
    // z = x^((p-5)/8) = x^FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD
    // (250 1s) (1 0s) (1 1s)
    // Addition chain: [1] 2 3 5 10 15 25 50 75 125 [250]

    List<int> x2 = rx2;
    sqr(x, x2);
    mulArrayAndArray(x, x2, x2);

    List<int> x3 = create();
    sqr(x2, x3);
    mulArrayAndArray(x, x3, x3);

    List<int> x5 = x3;
    sqr(x3, 2, x5);
    mulArrayAndArray(x2, x5, x5);

    List<int> x10 = create();
    sqr(x5, 5, x10);
    mulArrayAndArray(x5, x10, x10);

    List<int> x15 = create();
    sqr(x10, 5, x15);
    mulArrayAndArray(x5, x15, x15);

    List<int> x25 = x5;
    sqr(x15, 10, x25);
    mulArrayAndArray(x10, x25, x25);

    List<int> x50 = x10;
    sqr(x25, 25, x50);
    mulArrayAndArray(x25, x50, x50);

    List<int> x75 = x15;
    sqr(x50, 25, x75);
    mulArrayAndArray(x25, x75, x75);

    List<int> x125 = x25;
    sqr(x75, 50, x125);
    mulArrayAndArray(x50, x125, x125);

    List<int> x250 = x50;
    sqr(x125, 125, x250);
    mulArrayAndArray(x125, x250, x250);

    List<int> t = x125;
    sqr(x250, 2, t);
    mulArrayAndArray(t, x, rz);
  }

  void reduce(List<int> z, int x) {
    int t = z[9], z9 = t & M24;
    t = (t >> 24) + x;

    int cc = t * 19;
    cc += z[0]; z[0] = cc & M26; cc >>= 26;
    cc += z[1]; z[1] = cc & M26; cc >>= 26;
    cc += z[2]; z[2] = cc & M25; cc >>= 25;
    cc += z[3]; z[3] = cc & M26; cc >>= 26;
    cc += z[4]; z[4] = cc & M25; cc >>= 25;
    cc += z[5]; z[5] = cc & M26; cc >>= 26;
    cc += z[6]; z[6] = cc & M26; cc >>= 26;
    cc += z[7]; z[7] = cc & M25; cc >>= 25;
    cc += z[8]; z[8] = cc & M26; cc >>= 26;
    z[9] = z9 + cc;
  }
}