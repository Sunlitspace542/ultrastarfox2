# UltraStarFox2
Star Fox 2 (SNES, 1996/2017), with modifications for easier creation of ROM hacks and general ease-of-use. 

## Notes
- **This codebase is difficult to work with.**  
- The game will not assemble without some files being present in the root of the SF2 directory for some reason.
- PAL version is currently WIP

## Features
- Kando was involved

## Building

Requirements: Microsoft Windows, Python 3

Download repo as ZIP and extract somewhere, or clone the repo with git via the command line.  

to build ROM, run ``build.cmd``  

to build ROM with Logging, run ``build to log.cmd``

to rebuild color palettes, run ``build palette.cmd``  

After building, a debug symbol map will be created at ``SYMBOLS.TXT``.

Build flags can be found in ``SF2/VARS.INC``

## Project Structure
```
ultrastarfox2
├── BIN: exe files needed to assemble game code
├── SF2: Main source code is located here
│   ├── ASM: Main game code located here (65816)
│   ├── BANK: Bank data\ASM files
│   ├── DATA: GFX files
│   │   └── COL: Palette files and Palette Packer
│   ├── EXT: .ext files needed by several .asm files
│   ├── FONT: .bin font files
│   ├── INC: .inc files, arc tangent table
│   ├── MAPS: map scripts
│   ├── MARIO: .MC SuperFX Code files
│   ├── MSG: Message files for English, Japanese, German, and French
│   ├── MSPRITES: contains 4 DAT files (interleaved textures)
│   ├── SHAPES: contains all shape files
│   └── SOUND: sound/music data
└── TOOLS: tools such as packer and ShapeEd
```
