## ARGSFX (ARGSFXX.EXE)
Star Fox 2 uses the ARGSFX assembler. Its syntax is nearly identical to that of SASM, the assembler used for Star Fox.  
However, some SASM functionality is not present in ARGSFX, which may cause trouble if you are trying to use code intended for SASM with ARGSFX.  
Below is the output of running ARGSFX with no specified arguments, for reference purposes:  

```ArgSfx-Extender v1.52 (DBR=OFF) Copyright (c) Argonaut Software Ltd. 1992
Optimising, ClearLines version
Usage: ARGSFXX [options] sourcefile
 Options are:
   -d<value>,"<str>" - Defines a string.
   -e<label>(=value) - Equate label with the optional value.
   -f<name>          - Write file listing to file name.
   -h                - This text.
   -i<name>          - Specifies an incdir name.
   -l                - Turns on listing.
   -m<value>         - Specifies maximum errors before stopping.
   -o<name>          - Write object code to file <name>.
   -p<name>          - Write stdout to file <name>.
   -r                - Display rom listing on screen.
   -s<label>(=value) - Set the label with the optional value.
   -v<filename.SOB>  - Write linkable file <filename.SOB>.
   -x<name>          - Writes symbol listing to file.
   -z                - Generate a .MAP debug file.```