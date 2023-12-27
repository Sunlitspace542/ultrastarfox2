@echo off
echo Crunching palettes...
@del col.tmp
@del col2.tmp
@del allcols.col
@copy NUL allcols.col
@call mc col_1 0 4
@call mc col_2 0 4
@call mc a0 4 7
@call mc a1 4 7
@call mc a2 4 7
@call mc a3 4 7
@call mc a4 4 7
@call mc a5 4 7
@call mc a6 4 7
@call mc a7 4 7
@call mc a8 4 7
@call mc a9 4 6
@call mc a11 4 6
@call mc a12 4 7
@call mc a13 4 7
@call mc a14 4 7
@call mc a15 4 7
@call mc a16 4 6
@call mc a17 4 7
@call mc a18 4 7
@call mc a19 4 7
@call mc a20 4 7
@call mc a21 4 7
@call mc a22 4 7
@call mc a23 4 6
@call mc a24 4 6
@call mc a25 4 6
@call mc a26 4 6
@call mc a27 4 6
@call mc a28 4 6
@call mc a29 4 7
@call mc a30 4 7
@call mc a31 4 7
@call mc b0 0 16
@call mc b1 0 16
@call mc b2 0 16
@call mc b3 0 6
@call mc b5 0 16
@call mc b7 0 16
@call mc b8 0 16
@call mc b9 0 16
@call mc b10 0 8
@call mc b11 0 8
@call mc b15 8 16
@call mc b16 0 16
@call mc c0 0 16
@call mc c1 0 16
@call mc w0 8 16
@call mc yaji_0 8 12
cru allcols.col allcols.pac
echo Palette crunching Complete.