;                            ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;             ษออออออออออออออต             ฦออออออออออออออป
;             บ              ณ PATH MACROS ณ              บ
;             ศออออออออออออออต             ฦออออออออออออออผ
;                            ภฤฤฤฤฤฤฤฤฤฤฤฤฤู


;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต MISCELLANEOUS MACROS ฦอออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               บ
;บ                                                                           บ
;บ START_PATH      name               ; define the beginning of a path       บ
;บ P_END                              ; end of path                          บ
;บ P_DEBRIS        shape              ; debris explosions to use <shape>     บ
;บ P_EXPLODE                          ; explodes the object                  บ
;บ P_REMOVE                           ; remove object                        บ
;บ P_DEBUG                            ; causes a 'blink'                     บ
;บ P_PRINT         alvar,mode,user    ; displays the value in alvar          บ
;บ                                    ; mode = d,b, or h (bin, dec, hex)     บ
;บ P_SETANIM       value              ; initialise animation to value        บ
;บ P_ADDANIM       rate,max           ; adds [rate] to anim, max=last frame  บ
;บ P_SETCOLANIM    value              ; initialise colouranimation to value  บ
;บ P_ADDCOLANIM    rate,max           ; adds [rate] to colour anim           บ
;บ P_SPRITE        colour[,size]      ; makes shape a software sprite        บ
;บ P_TEXT          addr,color[,size]  ; change path type to message          บ
;บ P_TRAIL         OFF|num            ; (use with P_TEXT) num = trail col    บ
;บ P_TRIGGER       addr,trigger|OFF   ; trigger routine if (see 'TRIGGERS')  บ
;บ P_FORCE         addr               ; sets address to begin execution      บ
;บ                                    ; AFTER current trigger routine has    บ
;บ                                    ; finished (if breaks DO-NEXT, then    บ
;บ                                    ; next RETURN is invalid!)             บ
;บ                                    ; (must only use from triggered code)  บ
;บ P_START65816                       ; begin 65816 code                     บ
;บ P_END65816                         ; end 65816 code                       บ
;บ P_JSL65816      routine            ; call 65816 code                      บ
;บ P_SWITCHOUT     addr|A             ; switch out of 65816 to <routine>     บ
;บ P_PARTICLES                        ; create particles shower              บ
;บ P_SOUND         num                ; trigger continuous sound effect      บ
;บ P_SOUNDEFFECT         num          ; trigger one-shot sound effect        บ
;บ P_SOUNDEFTDIST        num          ; trigger sound effect from dist(n,m,l)บ
;บ P_SOUNDEFTPOS         num          ; trigger sound effect from L/C/R      บ
;บ P_SOUNDEFTDISTPOS     num          ; trigger sound effect from dist(n,m,l)บ
;บ                                    ;                & left/center/right   บ
;บ P_SOUNDEFTNEAR        num          ; trigger sound effect from near dist  บ
;บ P_SOUNDEFTNEARPOS     num          ; trigger sound effect from L/C/R(near)บ
;บ P_SOUNDEFTVIS         num          ; trigger sound effect visible		บ
;บ P_SOUNDEFTDIRECT      num,flag     ; trigger sound effect direct          บ
;บ 		       ;flag = (nearL,nearC,nearR,midL,midC,midR,far)   บ
;บ P_BECOME                           ; becomes the last shape created       บ
;บ P_BECOMESHAPE                      ; become shape                         บ
;บ P_BECOMEMOTHER                     ; become mother                        บ
;บ P_BECOMECHILD   num|[alvar,addr]   ; become the child specified           บ
;บ                                    ; this allows access to a child's      บ
;บ                                    ; variables                            บ
;บ                                    ; If an alvar is specified it will     บ
;บ                                    ; jump to addr if the child isn't      บ
;บ                                    ; found                                บ
;บ P_UNBECOME                         ; back to normal                       บ
;บ P_RADAROBJ      num                ; set the object for the radar display บ
;บ P_CLEARSTACK                       ; clears the stack (housekeeping)      บ
;บ P_BEGINDEMO                        ; begin path controlled demo sequence  บ
;บ P_ENDDEMO                          ; end path controlled demo sequence    บ
;บ P_ACTIVE        ON|OFF             ; active during demo sequence?         บ
;บ P_SETCAMERA     [IMMEDIATE]        ; set camera to current position       บ
;บ P_RANGECHECK    ON|OFF[,MAP]       ; turns off view range checking        บ
;บ P_SETSWITCH     alvar,[alvar]      ; sets switch to alvar (must be 1-16)  บ
;บ                                    ; If the second alvar is specified     บ
;บ                                    ; the flags will be set in that and    บ
;บ                                    ; not the global map switch            บ
;บ P_CLRSWITCH     alvar,[alvar]      ; clears switch                        บ
;บ P_IFSWITCH      alvar[,alvar],addr ; if switch number 'alvar' is set then บ
;บ                                    ; jump to addr                         บ
;บ P_SETTYPE       colltype           ; set collision type:                  บ
;บ P_CLRTYPE       colltype           ; clr collision type:                  บ
;บ                                    ; enemy1 or enemy2                     บ
;บ P_AREA          alvar|val,ON|OFF   ; turn an area on or off (blockmap)    บ
;บ P_SETCLIP       <y>                ; y position to y-clip at              บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;
;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต MODE MACROS ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                        บ
;บ                                                                           บ
;บ P_RELTOPLAYER   ON|OFF             ; make z relative to player            บ
;บ P_ALWAYSGENVECS ON|OFF             ; always generate vectors              บ
;บ P_SPACESHIP     ON|OFF             ; y rotation is relative to z rotation บ
;บ P_SMOKE         ON|OFF             ; turn smoke on/off                    บ
;บ P_INVINCIBLE    ON|OFF             ; turn invincibility off or on         บ
;บ P_ZREMOVE       ON|OFF             ; automatic removal of shape when z<0  บ
;บ P_INVISIBLE     ON|OFF             ; shape invisible and no collisions    บ
;บ P_HITFLASH      ON|OFF             ; hit flash on or off (on is default)  บ
;บ P_COLLISIONS    ON|OFF             ;  collision detection on or off       บ
;บ P_SHADOW        ON|OFF             ; shadow on or off (default=on)        บ
;บ P_BOOST         ON|OFF             ; software sprite boost on/off         บ
;บ P_POLLEN        ON|OFF             ; pollen on or off                     บ
;บ P_LOCKPLAYER    ON|OFF             ; lock the position relative to player บ
;บ P_SLOPE         ON|OFF             ; Switch slope object on or off        บ
;บ P_CLIPPING      ON|OFF             ; Switch on plane clipping             บ
;บ P_MOVEPLAYER    ON|OFF             ; move the player with the current obj บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต FRIEND MACROS ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                      บ
;บ                                                                           บ
;บ P_FRIEND                           ; define path as a friend's path       บ
;บ P_IFFRIEND      friend,address     ; if friend then goes to address       บ
;บ P_NOTFRIEND     friend,address     ; if not friend then goes to address   บ
;บ P_MSG           num|alvar[,METER]  ; Displays msg <num> (METER shows hp)  บ
;บ P_DAMAGE                           ; takes one unit of damage from friend บ
;บ P_ALMOSTDEAD    address            ; if friend almost dead then goto addr บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต CREATION MACROS ฦออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                    บ
;บ                                                                           บ
;บ P_SPAWN         x,y,z,             ; creates a new path object            บ
;บ                 xrot,yrot,zrot,    ; xyz rotation (relative to original)  บ
;บ                 shape,path,        ; shape and path name                  บ
;บ                 hp,ap              ; hit points and attack points         บ
;บ                 [,LINK]            ; links newly created shape            บ
;บ                 [,n]               ; n = child number (use child macros)  บ
;บ P_QSPAWN        shape,path,hp,ap   ; short version of above (x,y,etc = 0) บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต GENERAL PROGRAM FLOW MACROS ฦออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                        บ
;บ                                                                           บ
;บ P_WAIT          frames             ; wait for some time                   บ
;บ P_GOTO          addr               ; goto specified addr (waits 1 frame)  บ
;บ P_IGOTO         addr               ; immediately goto specified address   บ
;บ P_GOSUB         addr|alvar         ; nested gosub (alvar must be word)    บ
;บ P_RETURN                           ; return to gosub call                 บ
;บ P_RANDOMGOTO    addr               ; will go to address (50% of the time) บ
;บ P_LOOP          num,address        ; loop to addr <num>+1 times, (0-255)  บ
;บ P_DO            num|alvar          ; do until NEXT <num> times, (0-65535) บ
;บ P_NEXT                             ; repeat DO loop (nested) (1 frame)    บ
;บ P_INEXT                            ; repeat DO loop (0 frame)             บ
;บ P_BREAK         [addr]             ; break DO-NEXT loop, goto addr        บ
;บ P_IFLEVEL       number,addr        ; if level=number then go to addr      บ
;บ P_IFNOTLEVEL    number,addr        ; if level!=number then go to addr     บ
;บ P_HITGROUND     ground,addr        ; when hits [ground] goes to addr      บ
;บ P_NOTHITGROUND  ground,addr        ; if not hitting [ground] goes to addr บ
;บ P_HITWALL       address            ; goes to addr when hits tunnel walls  บ
;บ P_SETSTRAT      address            ; sets strategy (active immediately)   บ
;บ P_IFHITFLAG     addr[,1[,2]]...    ; check for hitflags (and clear them)  บ
;บ                                    ; if none specified, checks for any    บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต PLAYER MACROS ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                      บ
;บ                                                                           บ
;บ P_PLAYER        <number>           ; set which player to check            บ
;บ P_PLAYERDEAD    addr               ; if player is dead then go to addr    บ
;บ P_LEFTOFPLAYER  addr               ; if left of player go to addr         บ
;บ P_RIGHTOFPLAYER addr               ; if right of player go to addr        บ
;บ P_ABOVEPLAYER   addr               ; if above player go to addr           บ
;บ P_BELOWPLAYER   addr               ; if below player go to addr           บ
;บ P_BEHINDPLAYER  addr               ; if behind player go to addr          บ
;บ P_BEHINDKPLAYER  addr              ; if behind player go to addr (kawa)   บ
;บ P_WAITFACEPLAYER                   ; turns to the player (until finished) บ
;บ P_FACEPLAYER    [IMMEDIATE]        ; face player (1 iteration)            บ
;บ P_FACEPLAYER    Y                  ; face player (only Y rotation)        บ
;บ P_GOTOPOS       x,y,z,maxspeed     ; goes to position relative to player  บ
;บ P_DISTLESS      value,addr         ; if distance from player < value      บ
;บ P_DISTMORE      value,addr         ; if distance from player > value      บ
;บ P_WITHINRADIUS  radius,addr        ; if player is within <radius>         บ
;บ P_IFPLAYER      n,addr             ; if player n then goto (see P_PLAYER) บ
;บ P_SWAPPLAYER                       ; swaps the player      (see P_PLAYER) บ
;บ P_PLAYERINCONE  range,addr         ; is player within -range๘<->range๘?   บ
;บ P_SCORE         num                ; add to player's score                บ
;บ P_MOVEINPLAYER  num|alvar          ; move towards or away from the player บ
;บ P_CIRCLEPLAYER  angle|alvar        ; rotates object around player (y-rot) บ
;บ P_COPYPLAYERPOS                    ; copy the player's position           บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต  BOSS MACROS  ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                      บ
;บ                                                                           บ
;บ P_BOSSMODELIST  bossname           ; Initialises the boss mode definitionsบ
;บ                                    ; You must follow this with a list of  บ
;บ                                    ; P_BOSSMODE's                         บ
;บ P_BOSSMODE      addr[,name]        ; Define a boss mode                   บ
;บ P_JUMPBOSSMODE                     ; Jump to the current boss mode        บ
;บ P_SETBOSSMODE   name               ; Set boss into a particular mode      บ
;บ P_NEXTBOSSMODE                     ; Set the next boss mode               บ
;บ P_BOSSFLAGLIST                     ; Initialise flag list for this boss   บ
;บ                                    ; This must be specified somewhere     บ
;บ                                    ; AFTER the P_BOSSMODELIST definition  บ
;บ P_BOSSFLAG      name               ; define a boss flag                   บ
;บ P_IFBOSSFLAG    name,ON|OFF,addr   ; if boss flag on or off then jump     บ
;บ P_SETBOSSFLAG   name,ON|OFF        ; set a boss flag                      บ
;บ P_CLRBOSSFLAGS                     ; clear all boss flags                 บ
;บ P_STOREBOSSMODE                    ; store current boss mode (one level)  บ
;บ P_RESTOREBOSSMODE                  ; restore previously stored mode       บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต WEAPON MACROS ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                      บ
;บ                                                                           บ
;บ P_WEAPON        weaponname         ; sets default weapon for path object  บ
;บ P_FIRE          [CANHIT]           ; fires default weapon                 บ
;บ P_FIRE          ATPLAYER,[CANHIT]  ; fires default weapon at player       บ
;บ P_FIRE          ATSHAPE,[CANHIT]   ; fires default weapon at found shape  บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต VARIABLE MACROS ฦออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                    บ
;บ                                                                           บ
;บ P_CHASE         var,value          ; smoothly set var to value            บ
;บ P_CHASE         var1,var2          ; smoothly set var to another var      บ
;บ P_WAITCHASE     var,value          ; smoothly set var (until finished)    บ
;บ P_SET           var,value          ; immediately set var                  บ
;บ P_SET           var1,var2          ; set var1 = var2                      บ
;บ P_ZERO          var                ; zero var                             บ
;บ P_SETRANDOM     var[,rndmask]      ; set var to random value              บ
;บ                                    ; (rndmask = 1,3,7,15,31...65535)      บ
;บ P_ADD           var,value          ; add value to var (sign extended)     บ
;บ P_ADD           var,var            ; add var to var (sign extended)       บ
;บ P_GADD          dest,source        ; add global to alvar storing result   บ
;บ                                    ; in dest                              บ
;บ P_GINC          B|W,global var     ; increment global by 1                บ
;บ P_GDEC          B|W,global var     ; decrement global by 1                บ
;บ P_INC           var                ; increment var by 1                   บ
;บ P_DEC           var                ; decrement var by 1                   บ
;บ P_NEG           var                ; negate var                           บ
;บ P_DIV2          var                ; signed divide by 2                   บ
;บ P_SETVEL        velocity           ; change speed (will remake vectors)   บ
;บ P_ACCEL         velocity,rate      ; change speed by rate (smooth setvel) บ
;บ P_IFSAME        var,value,addr     ; if var=value then go to addr         บ
;บ P_IFSAME        var,var,addr       ; if var=var then go to addr           บ
;บ P_IFNOTSAME     var,value,addr     ; if var!=value then go to addr        บ
;บ P_IFNOTSAME     var,var,addr       ; if var!=var then go to addr          บ
;บ P_IFZERO        var,addr           ; if var=0 then go to addr             บ
;บ P_IFNOTZERO     var,addr           ; if var!=0 then go to addr            บ
;บ P_IFBETWEEN     min,var,max,addr   ; if min>var>max then go to addr       บ
;บ P_IFNOTBETWEEN  min,var,max,addr   ; if min<var | var>max then go to addr บ
;บ P_IFLARGER      var1,var2,addr     ; if var1>var2 goto <addr> (signed)    บ
;บ P_IFSMALLER     var1,var2,addr     ; if var1<var2 goto <addr> (signed)    บ
;บ P_IMPORT        var,global var     ; var = global var                     บ
;บ P_EXPORT        global var,var     ; global var = var                     บ
;บ                                    ; global var must be same size as var; บ
;บ                                    ; ie. a byte=byte or word=word         บ
;บ                                    ; see 'GLOBAL VARIABLES'               บ
;บ P_INDEX         dest,table,index   ; indexes into a table (see 'TABLES')  บ
;บ P_AUTOINDEX     B|W,d,t,i,max      ; same as P_INDEX but increments 'i'   บ
;บ                                    ; up until 'max'-1 then loops back to 0บ
;บ                                    ; also value is ADDED to 'd'           บ
;บ                                    ; Table size is specified with B or W  บ
;บ P_PUSH          var                ; pushes var onto the stack            บ
;บ P_PULL          var                ; pulls var from the stack (see stack) บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต LINKING MACROS ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                     บ
;บ                                                                           บ
;บ P_LINK          shape              ; link path to next path created       บ
;บ P_FINDSHAPE     shape              ; finds the shape specified            บ
;บ P_FINDNEXTSHAPE shape              ; finds the next closest shape         บ
;บ P_FACESHAPE     [IMMEDIATE]        ; faces the found or linked shape      บ
;บ P_GOTOSHAPEPOS  x,y,z,maxspeed     ; goes to a relative position          บ
;บ P_IMMUNE                           ; immune to collisions                 บ
;บ P_SHAPEDISTLESS value,address      ; if distance from shape < value       บ
;บ P_SHAPEDEAD     address            ; if shape is dead, goes to address    บ
;บ P_SPAWN         ...,LINK           ; see <CREATION MACROS>                บ
;บ P_FLAGSHAPE                        ; set flag for linked shape            บ
;บ                                    ; (only if linked shape is path obj)   บ
;บ P_IFFLAG        addr               ; if flag set goto addr (clears flag)  บ
;บ P_SHAPEINRADIUS radius,address     ; if linked shape is within radius     บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต CHILD MACROS ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                       บ
;บ                                                                           บ
;บ P_SPAWN         ...,n              ; see spawn command above              บ
;บ P_CHILDDEAD     n,address          ; if CHILD n is dead, goto address     บ
;บ P_FLAGCHILD     n                  ; flag child (from child or mother)    บ
;บ P_FLAGMOTHER                       ; flag mother (from child)             บ
;บ P_IFFLAG        addr               ; if flag set goto addr (clears flag)  บ
;บ P_UNLINKCHILD   n                  ; make child into normal object        บ
;บ P_REMOVE        n                  ; remove child n                       บ
;บ P_CIRCLE        angle|alvar        ; rotates child around mother (y-rot)  บ
;บ P_MOVEIN        n|alvar            ; move closer to mother by val|alvar   บ
;บ P_SETID         n|alvar            ; set child id number                  บ
;บ P_BECOMEINERT                      ; changes into an inert object         บ
;บ P_STAMPSTART                       ; set the restart routine for inerts   บ
;บ P_ADJUSTROT                        ; adjusts world rotation to child rot  บ
;บ                                    ; eg. P_FACEPLAYER would normally      บ
;บ                                    ; not work, however if followed by     บ
;บ                                    ; P_ADJUSTROT it will                  บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป  
;บ                                                                           บ
;บ Note #1: NEVER use FINDSHAPE, LINK, or FINDNEXTSHAPE with CHILD macros    บ
;บ Note #2: P_GOTO P_NEXT, and P_LOOP AUTOMATICALLY do a P_WAIT 1            บ
;บ Note #3: P_TRIGGER should NOT be used from within a trigger subroutine    บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต VALID 'VAR's ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                       บ
;บ                                                                           บ
;บ                worldx              ; object's x                           บ
;บ                worldy              ; object's y                           บ
;บ                rotx                ; object's x rotation                  บ
;บ                roty                ; object's y rotation                  บ
;บ                rotz                ; object's z rotation                  บ
;บ                hp                  ; object's hp                          บ
;บ                ap                  ; object's ap                          บ
;บ                shape               ; object's shape                       บ
;บ                coltab              ; object's colour table                บ
;บ                tx                  ; tx map x coordinate (or sprite size) บ
;บ                ty                  ; tx map y coordinate                  บ
;บ                area                ; set to -1 for permanent existance    บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                     
;ษออออต VARS AVAILABLE FOR CHILD MACROS ฦออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                    บ
;บ                                                                           บ
;บ                childx              ; relative x                           บ
;บ                childy              ; relative y                           บ
;บ                childz              ; relative z (relative to mother)      บ
;บ                childrotx           ; x rotation                           บ
;บ                childroty           ; y rotation                           บ
;บ                childrotz           ; z rotation                           บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                       
;ษออออต TEMPORARY VARIABLES AVAILABLE FOR GENERAL USE ฦออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                      บ
;บ                                                                           บ
;บ                pbyte1              ; temporary byte #1                    บ
;บ                pbyte2              ; temporary byte #2                    บ
;บ                pword1              ; temporary word #1                    บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต CURRENT VALID WEAPONS ARE (USE WITH 'P_WEAPON') ฦออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                    บ
;บ                                                                           บ
;บ  SlowElaser         ; Elaser (use for ground based objects)               บ
;บ  RelSlowElaserHome  ; Relative slow laser (homes towards player)          บ
;บ  RelSlowElaser      ; Relative slow laser                                 บ
;บ  hmissile1          ; Normal homing missile                               บ
;บ  chickhmissile1     ; Chicken missile                                     บ
;บ  missile1           ; Straight firing missile                             บ
;บ  plasma             ; Plasma ball                                         บ
;บ  shortplasma        ; Plasma ball (disappears quicker)                    บ
;บ  Hplasma            ; Homing plasma ball                                  บ
;บ  ovalbeam           ; Oval (ellipse) beam                                 บ
;บ  ringlaser          ; Ring laser                                          บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต TRIGGERS ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤู                                                           บ
;บ                                                                           บ
;บ  Always             - calls the routine on every game frame               บ
;บ  2,4,8,...,128      - ... once every n frames                             บ
;บ  WhenHit            - ... if hit                                          บ
;บ  WhenHitByPlayer    - ... if shot by player                               บ
;บ  WhenFlagged        - ... if flag is set (clears the flag automatically)  บ
;บ  WhenDead           - ... if hp=0 (explodes anyway, but you can spawn)    บ
;บ  WhenShapeDead      - ... if the LINK'd or FOUND shape dies               บ
;บ  WhenThrough        - ... if a player goes through the object             บ
;บ                       (sets P_PLAYER n automatically)                     บ
;บ  WhenSteppedOn      - ... if stepped on by the player (must be a slope)   บ
;บ                       (AL_SLOPENUM specifies which polygon)               บ
;บ                       (automatically does P_PLAYER to set which player)   บ
;บ                                                                           บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                           บ
;บ  Note: TRIGGER should not use P_WAIT, P_GOTO, P_LOOP, P_WAITxxxx          บ
;บ  (anything which causes the next game frame to be displayed -             บ
;บ  doing so will cause a blue BLINK |^) )                                   บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต GLOBAL VARIABLES ฦอออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                   บ
;บ                                                                           บ
;บ Global variables are available for use by all strategies; they are        บ
;บ completely independent of the strategy that uses them.. ie. if one        บ
;บ strategy changes a global variable, another strategy can read or change   บ
;บ it.  Use IMPORT to copy a global variable into an alien variable.         บ
;บ Use EXPORT to copy an alien variable into a global variable.              บ
;บ                                                                           บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                           บ
;บ  gbyte1        = global byte 1                                            บ
;บ  gbyte2        = global byte 2                                            บ
;บ  gbyte3        = global byte 3                                            บ
;บ  gword1        = global word 1                                            บ
;บ  gword2        = global word 2                                            บ
;บ  gword3        = global word 3                                            บ
;บ                                                                           บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                           บ
;บ Note: you can ONLY copy a byte into a byte or a word into a word,         บ
;บ ie.  you cannot copy a byte into a word or vice versa.                    บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฟ
;ษออออต TABLES ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤู                                                             บ
;บ                                                                           บ
;บ The INDEX feature allows you to retrieve data from tables.  The index     บ
;บ should be a byte alien variable, if it is a word then only the bottom     บ
;บ 8 bits are utilised.                                                      บ
;บ If the destination is a word then the index is automatically multiplied   บ
;บ by 2 thus assuming you are indexing into a table of words.                บ
;บ                                                                           บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                           บ
;บ There are some default tables you can use:                                บ
;บ                                                                           บ
;บ   sintab - sin table (index should be 0-255, destination must be a byte)  บ
;บ   costab - cos table (index should be 0-255, destination must be a byte)  บ
;บ                                                                           บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                           บ
;บ Example:                                                                  บ
;บ                                                                           บ
;บ   P_SET   pbyte1,5                                                        บ
;บ   P_INDEX pword1,mytab,pbyte1                                             บ
;บ   ...                                                                     บ
;บ                                                                           บ
;บ mytab                                                                     บ
;บ   dw      0,500,400,300,200,400,500                                       บ
;บ                                                                           บ
;บ This will set pword1 = mytab+5*2 (400)                                    บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต THE STACK ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤู                                                          บ
;บ                                                                           บ
;บ The stack is used for DO-NEXT loops and GOSUB-RETURN subroutines.         บ
;บ It is also used for the PUSH/PULL commands therefore there is of          บ
;บ course some possibility of a clash.  You cannot PULL a variable           บ
;บ from a level different to that from which it was PUSHed.                  บ
;บ                                                                           บ
;บ ie.  P_DO    5                                                            บ
;บ      P_PUSH  pbyte1                                                       บ
;บ      ...                                                                  บ
;บ      P_PULL  pbyte1                                                       บ
;บ      P_NEXT                                                               บ
;บ                                                                           บ
;บ is valid, but:                                                            บ
;บ                                                                           บ
;บ      P_DO    5                                                            บ
;บ      P_PUSH  pbyte1                                                       บ
;บ      ...                                                                  บ
;บ      P_NEXT                                                               บ
;บ      P_PULL  pbyte1                                                       บ
;บ                                                                           บ
;บ is invalid and will probably crash                                        บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต PLAYER wo CONTROL suru MACROS ฦออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                      บ
;บ                                                                           บ
;บ P_FORCEJUMP     	value	; player(ROBOT) wo jump saseru. (normal 5)	บ
;บ P_FORCETRANSFORM	type	; player wo transform saseru.(ARWING,ROBOT,UFO) บ
;บ P_PLRTRANSLOCK	P_FORCETRANSFORM no ato ni tsukau.	                บ
;บ P_PLRTRANSLOCKOFF                                                         บ
;บ P_INCSPWEAP	num	; special weapon no kazu wo huyasu.(max15)      บ
;บ P_SETSPWEAP	type	; special weapon no type wo set suru.           บ
;บ			;(pbyte2 wo tsukau!)                            บ
;บ                           ; missile1                                      บ
;บ                           ; dummy                                         บ
;บ                           ; flamethrower                                  บ
;บ                           ; smartplasma                                   บ
;บ P_INCSPWEAP	num,addr; special weapon no kazu wo huyasu.(max15)      บ
;บ 			(P_SETSPWEAP 1 kai set sitaato ni tsukau!       บ
;บ                           kazu ga sudeni max ni natte itara,addr ni jump. บ
;บ                                                                           บ
;บ P_PLRSHIELD	frame(max255)   ; player no shield wo set suru.         บ
;บ P_PLRTURN		on/off	; starfox1 mode on/off. on:turn dekinai         บ
;บ P_PLRFORCETURN	roty,width				                บ
;บ                                                                           บ
;บ	roty 	: 1 houkou mode no muki                                 บ
;บ	width	: idou no haba(hankei)                                  บ
;บ                                                                           บ
;บ P_PLRFORCEWAY	roty,width,length				        บ
;บ                                                                           บ
;บ	roty 	: 1 houkou mode no muki                                 บ
;บ	width	: idou no haba(hankei)                                  บ
;บ	length	: check suru nagasa                                     บ
;บ P_PLRBURN pos     ;pos = L(wing),C(body),R(wing),ALL                      บ
;บ                   ; player ga moeru.                                      บ                 บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต PLAYER no WEAPON no MACROS ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                       บ
;บ P_FINDENEMYSHAPE    maxradius,range,addr; find enemy shape                              บ
;บ P_OBJINCONE          range,addr         ; is "objct(al_ptr)" within -range๘<->range๘?   บ
;บ                                                                                         บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต EFFECT MACRO ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤ ฤฤฤู                                                       บ
;บ                                                                           บ
;บ P_HITFLASHTRIG		; set hitflash flag                             บ
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต CAMERA MACRO ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                         บ
;บ                                                                             บ
;บ P_SHOCKCAM	1or2,value	; camera wo sindou saseru.value=128 kurai.บ
;บ P_SHOCKCAM	1or2,value	; camera wo sindou saseru.value=128 kurai.บ
;บ                                                                             บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต ENEMY MARKER MACRO ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                                       บ
;บ                                                                                                 บ
;บ  P_SETMARKER	1or2,offdist	; enemy marker wo set suru.                                   บ
;บ  P_ROBOTCAMYOFS   offset(16bit)   ; robot no view no offset. (-) de ue wo muki                  บ
;บ                                                                                                 บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;     ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
;ษออออต PLAYER no STATUS wo check suruMACROS ฦอออออออออออออออออออออออออออออออป
;บ    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                               บ
;บ                                                                           บ
;บ P_IFARWING     	addr	; if player is arwing  then goto addr           บ
;บ P_IFROBOT     	addr	; if player is robot   then goto addr           บ
;บ P_IFUFO     		addr	; if player is ufo     then goto addr   บ
;บ P_IFPLAYERFULLHP 	addr	; if player's HP = max then goto addr           บ
;บ P_IFPILOT		name(FOX,FALCO....),addr	;if pilot = pilot then jmp addr
;บ P_NOTPILOT	name,addr			;if pilot != pilot then jmp addr
;บ P_IFPLAYERBOOST   addr    ; if player using "boost" then goto addr
;บ P_IFPLAYERBRAKE   addr    ; if player using "brake" then goto addr
;บ                                                                           บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ















;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------

pnastyon	MACRO
	IFNE	pathnasty
	nastyon
	ENDC
	ENDM

pnastyoff	MACRO
	IFNE	pathnasty
	nastyoff
	ENDC
	ENDM


promnastyon	MACRO
	IFNE	pathnasty
	romnastyon
	ENDC
	ENDM

promnastyoff	MACRO
	IFNE	pathnasty
	romnastyoff
	ENDC
	ENDM

pramnastyon	MACRO
	IFNE	pathnasty
	ramnastyon
	ENDC
	ENDM

pramnastyoff	MACRO
	IFNE	pathnasty
	ramnastyoff
	ENDC
	ENDM

_pc_nasty	equ	0

pathcmd	macro
	SHORTA
	LONGI
	endm

getparam	macro	[offset]
	IFEQ	LONGA
	jsr	getparam{offset}8
	ELSEIF
	jsr	getparam{offset}16
	ENDC
	endm

getparam_codegen	macro	[offset,mode]
getparam{offset}{mode}

	sty	xs

	IFEQ	{mode}-8

	ldy	#{offset}
	a8
	promnastyoff
	a8
	lda.l	[path_pcptr],y
	sta	pathparam
	promnastyon

	ELSEIF

	ldy	#{offset}
	a8
	promnastyoff
	a16
	lda.l	[path_pcptr],y
	sta	pathparam
	a8
	promnastyon
	a16

	ENDC

	lda	pathparam
	ldy	xs
	rts

	endm

pathcode	MACRO	[code]
	IFD	_x_p_{code}
	db	p_{code}
	ELSEIF
	IFD	_x_ep_{code}
	db	p_extracommands
	db	ep_{code}
	ELSEIF
	error	<No such path code {code}>
	ENDC
	ENDC
	ENDM
;--------------------------------------------------------------------

; nullify path info macros:
	IFEQ	pathinfo

pathmac_start	MACRO
	ENDM
;--------------------------------------------------------------------
pathmac_end	MACRO
	ENDM

;--------------------------------------------------------------------
	ELSEIF
; path info macros:

	FCLOSE

	FOPEN	pathinfo.asm
	printf	"; ------------ PATH MACRO INFORMATION ------------%n"
	FCLOSE

;--------------------------------------------------------------------

	STRING	pathmacname[80]

pathmac_start	MACRO
	STRING	pathmacname="%c"
	run	" IFND pathmac_%$pathmacname"

	FOPEN	+pathinfo.asm

	printf	" printf %q[20]%$pathmacname: %q,pathmac_%$pathmacname,%q %q,pathmacmem_%$pathmacname,%q%%n%q%n"
	
	FCLOSE

	run	"pathmac_%$pathmacname = 1"
	run	"pathmacmem_%$pathmacname = 0"

	ELSEIF

	run	"pathmac_%$pathmacname = pathmac_%$pathmacname+1"
	ENDC
__pms	=	*

		ENDM
;--------------------------------------------------------------------
pathmac_end	MACRO
	run	"pathmacmem_%$pathmacname = pathmacmem_%$pathmacname+*-__pms"
	ENDM

;--------------------------------------------------------------------

	ENDC

;--------------------------------------------------------------------

addalvaroffset	MACRO	[param]
	IFNE	LONGA
	printf	"addalvaroffset needs a8 %l%n"
	ENDC
	getparam	{param}
	jsr	_paddalvaroffset
		ENDM
	
	

;--------------------------------------------------------------------

psetalvars	MACRO	[code,alvar,var]
	IFEQ	size_al_{alvar}-1
	IFEQ	size_al_{var}-1
	pathcode	{code}BB
	ELSEIF
	pathcode	{code}BW
	ENDC
	ELSEIF

	IFEQ	size_al_{var}-1
	pathcode	{code}WB
	ELSEIF
	pathcode	{code}WW
	ENDC
	ENDC

	PALVAROFFSET	{alvar}
	PALVAROFFSET	{var}

	ENDM
;--------------------------------------------------------------------

numpaths	=	0

start_path	MACRO	[name]

p{name}
path_{name}	equ	*-paths

numpaths	=	numpaths+1
	ENDM

;--------------------------------------------------------------------
PCHKSIZE	MACRO	[alvar,size]
	defs	1,"word"
	IFEQ	{size}-1
	defs	1,"byte"
	ENDC

	IFNE	size_al_{alvar}-{size}
	printf	"%00%31%01Error: Size of alvar must be a %$1 (%l: %c).%n%00"
	ERROR+
	ENDC
	ENDM
;--------------------------------------------------------------------
PADDR	MACRO	[addr]
	dw	({addr})&$7fff+((({addr})>>16)&1)*$8000
	ENDM
;--------------------------------------------------------------------
PNARG	MACRO	[n1,n2]
	IFEQ	NARG-1
	IFNE	MYNARG-{n1}
	printf	"%00%31%01Error: Incorrect parameters specified (%l: %c).%n%00"
	ERROR+
	ENDC
	ELSEIF
	IFNE	MYNARG<{n1}
	printf	"%00%31%01Error: Incorrect parameters specified (%l: %c).%n%00"
	ERROR+
	ENDC
	IFNE	MYNARG>{n2}
	printf	"%00%31%01Error: Incorrect parameters specified (%l: %c).%n%00"
	ERROR+
	ENDC
	ENDC
	ENDM

;--------------------------------------------------------------------
PALVAR	MACRO	[alvar]
	IFND	al_{alvar}
	printf	"%00%31%01Error: No such alien variable - {alvar} (%l: %c).%n%00"
	ERROR+
	ENDC
	ENDM

;--------------------------------------------------------------------
PALVAROFFSET	MACRO	[alvar]
	IFEQ	al_{alvar}&$ffffff00
	db	al_{alvar}
	ELSEIF
	db	((al_{alvar}-alx_start)!128)&BM
	ENDC
	ENDM
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------

P_RELTOPLAYER	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	reltoplayer{onoff}

	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_INVISIBLE		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	invisible{onoff}

	pathmac_end
		ENDM


;--------------------------------------------------------------------

P_SPACESHIP		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	spaceship{onoff}

	pathmac_end
		ENDM


;--------------------------------------------------------------------

P_HELICOPTER		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	error	<P_HELICOPTER IS OBSOLETE!!>
	pathcode	zaco{onoff}

	pathmac_end
		ENDM



;--------------------------------------------------------------------
P_WAIT		MACRO	[numframes]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFC	"{numframes}","1"
	pathcode	wait1
	ELSEIF
	pathcode	wait
	db	{numframes}
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------

P_ALWAYSGENVECS	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	alwaysgenvecs{onoff}

	pathmac_end
	ENDM

;--------------------------------------------------------------------

P_SETVEL		MACRO	[velocity]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	setvel
	db	{velocity}

	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_LOOP		MACRO	[number,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	loop
	db	{number}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_INC	MACRO	[alvar]
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	incb
	ELSEIF
	pathcode	incw
	ENDC

	PALVAROFFSET	{alvar}

	ENDM
;--------------------------------------------------------------------
P_DEC	MACRO	[alvar]
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	decb
	ELSEIF
	pathcode	decw
	ENDC

	PALVAROFFSET	{alvar}

	ENDM

;--------------------------------------------------------------------

P_ADD		MACRO	[alvar,num]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	PALVAR	{alvar}

	IFC	"1","{num}"
	P_INC	{alvar}
	ELSEIF
	IFC	"-1","{num}"
	P_DEC	{alvar}
	ELSEIF

	IFD	al_{num}

	psetalvars	<addv>,{alvar},{num}

	ELSEIF

	IFEQ	size_al_{alvar}-1
padddone	=	0

	IFEQ	al_rotx-al_{alvar}
padddone	=	1
	pathcode	addrotx
	ENDC

	IFEQ	al_roty-al_{alvar}
padddone	=	1
	pathcode	addroty
	ENDC

	IFEQ	al_rotz-al_{alvar}
padddone	=	1
	pathcode	addrotz
	ENDC

	IFEQ	padddone
	pathcode	addb
	PALVAROFFSET	{alvar}
	ENDC

	db	{num}
	ELSEIF
padddone	=	0

	IFEQ	({num}+128)&$ffffff00

	IFEQ	al_worldx-al_{alvar}
padddone	=	1
	pathcode	addworldx
	ENDC

	IFEQ	al_worldy-al_{alvar}
padddone	=	1
	pathcode	addworldy
	ENDC

	IFEQ	al_worldz-al_{alvar}
padddone	=	1
	pathcode	addworldz
	ENDC

	IFEQ	padddone
	pathcode	addws
	PALVAROFFSET	{alvar}
	ENDC
	db	{num}

	ELSEIF

	pathcode	addw
	PALVAROFFSET	{alvar}
	dw	{num}
	ENDC

	ENDC

	ENDC
	ENDC
	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_FACEPLAYER		MACRO	[y]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	pathcode	faceplayer{y}

	pathmac_end
		ENDM
;--------------------------------------------------------------------

P_WAITFACEPLAYER		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	waitfaceplayer

	pathmac_end
		ENDM
;--------------------------------------------------------------------

P_FIRELASER		MACRO	[option]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	P_WEAPON	RELSLOWELASER
	P_FIRE		{option}

	pathmac_end
		ENDM
;--------------------------------------------------------------------

P_FIREMISSILE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	P_WEAPON	HMISSILE1
	P_FIRE		ATPLAYER

	pathmac_end
		ENDM
;--------------------------------------------------------------------

P_CHASE		MACRO	[alvar,val]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFD	al_{val}

	psetalvars	<chasev>,{alvar},{val}

	ELSEIF

	IFEQ	size_al_{alvar}-1
	pathcode	achaseB
	db	{val}
	PALVAROFFSET	{alvar}
	ELSEIF
	pathcode	achaseW
	dw	{val}
	PALVAROFFSET	{alvar}
	ENDC

	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_WAITCHASE		MACRO	[alvar,val]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	waitachaseB
	db	{val}
	PALVAROFFSET	{alvar}
	ELSEIF
	pathcode	waitachaseW
	dw	{val}
	PALVAROFFSET	{alvar}
	ENDC


	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_END		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	end
	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_SET		MACRO	[alvar,val]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFC	"{val}","0"

	P_ZERO	{alvar}

	ELSEIF

	IFD	al_{val}
; set alvar to another alvar

	psetalvars	setv,{alvar},{val}

	ELSEIF
; set alvar to immediate
	IFEQ	size_al_{alvar}-1
	pathcode	setb
	db	{val}
	PALVAROFFSET	{alvar}
	ELSEIF
	pathcode	setw
	dw	{val}
	PALVAROFFSET	{alvar}
	ENDC

	ENDC
	ENDC
	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_ZERO		MACRO	[alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFEQ	size_al_{alvar}-1
	pathcode	set0b
	ELSEIF
	pathcode	set0w
	ENDC

	PALVAROFFSET	{alvar}

	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_FINDSHAPE		MACRO	[shape]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	findshape
	dw	{shape}

	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_FINDNEXTSHAPE	MACRO	[shape]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	findnextshape
	dw	{shape}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_FACESHAPE		MACRO	[immed]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	pathcode	faceshape{immed}
	pathmac_end
		ENDM
;--------------------------------------------------------------------

P_EXPLODE		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	explode

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_REMOVE		MACRO	[child]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	IFEQ	NARG
	pathcode	remove
	ELSEIF
	pathcode	removechild
	db	{child}
	ENDC

	pathmac_end
		ENDM
;--------------------------------------------------------------------


P_GOTOPOS		MACRO	[x,y,z,speed]
	pathmac_start
MYNARG	=	NARG
	PNARG	4

	pathcode	gotopos
	dw	{x},{y},{z}
	db	{speed}

	pathmac_end
		ENDM

;--------------------------------------------------------------------


P_GOTOSHAPEPOS	MACRO	[x,y,z,speed]
	pathmac_start
MYNARG	=	NARG
	PNARG	4

	pathcode	gotoshapepos
	dw	{x},{y},{z}
	db	{speed}

	pathmac_end
		ENDM

;--------------------------------------------------------------------

P_IMMUNE		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	immune

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_GOTO		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	goto
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IGOTO		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	igoto
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_DISTLESS		MACRO	[value,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	distless
	dw	{value}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SHAPEDISTLESS	MACRO	[value,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	shapedistless
	dw	{value}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_DISTMORE		MACRO	[value,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifnot

	P_DISTLESS	{value},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SHAPEDISTMORE	MACRO	[value,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifnot

	P_SHAPEDISTLESS	{value},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ACCEL		MACRO	[speed,rate]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	accel
	db	{speed}
	db	{rate}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_HITGROUND		MACRO	[groundheight,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	hitground
	dw	{groundheight}
	PADDR	{addr}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_NOTHITGROUND		MACRO	[groundheight,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifnot

	P_HITGROUND	{groundheight},{addr}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_HITWALL		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	hitwall
	PADDR	{addr}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_SETANIM		MACRO	[value]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	initanim
	db	{value}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ADDANIM		MACRO	[rate,limit]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	addanim
	db	{rate},{limit}
	

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_DEBRIS		MACRO	[shape]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	debris
	dw	{shape}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_FRIEND		MACRO	[friend]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	IFEQ	NARG-1
	pathcode	friend
	db	friend_{friend}
	ELSEIF
	pathcode	friend
	db	friend_anyone
	ENDC

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_LINK		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	link

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SHAPEDEAD		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	shapedead
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFLEVEL		MACRO	[level,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	iflevel
	db	{level}
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFNOTLEVEL		MACRO	[level,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifnot

	P_IFLEVEL	{level},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_LEFTOFPLAYER	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	leftofplayer
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_RIGHTOFPLAYER	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	rightofplayer
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_BEHINDPLAYER	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	behindplayer
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ABOVEPLAYER	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	aboveplayer
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_BELOWPLAYER	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	belowplayer
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_NOTFRIEND		MACRO	[friend,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	notfriend
	db	friend_{friend}
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFFRIEND		MACRO	[friend,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifnot

	P_NOTFRIEND	{friend},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
pm__meter
P_MSG		MACRO	[msg,meter]
	pathmac_start
MYNARG	=	NARG

	IFD	al_{msg}
	PNARG	1

	pathcode	msgalvar
	PALVAROFFSET	{msg}

	ELSEIF
	PNARG	1,2
	
	IFND	pm__{meter}
	pathcode	msg
	ELSEIF
	pathcode	msgwithmeter
	ENDC
	db	{msg}
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_DAMAGE		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	damage
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ALMOSTDEAD		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	almostdead
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SMOKE		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	smoke{onoff}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_RANDOMGOTO		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	randomgoto
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFSAME		MACRO	[alvar,val,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	3
	PALVAR	{alvar}

	IFC	"{val}","0"

	P_IFZERO	{alvar},{addr}

	ELSEIF

	IFD	al_{val}

	IFNE	size_al_{alvar}-size_al_{val}
	ERROR	<P_IFSAME: var1 and var2 must be same size>
	ENDC

	IFEQ	size_al_{alvar}-1
	pathcode	ifsamebb
	ELSEIF
	pathcode	ifsameww
	ENDC

	PALVAROFFSET	{alvar}
	PALVAROFFSET	{val}

	PADDR	{addr}
	

	ELSEIF

	IFEQ	size_al_{alvar}-1
	pathcode	ifsameb
	PALVAROFFSET	{alvar}
	db	{val}
	PADDR	{addr}
	ELSEIF
	pathcode	ifsamew
	PALVAROFFSET	{alvar}
	dw	{val}
	PADDR	{addr}
	ENDC

	ENDC

	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_IFZERO		MACRO	[alvar,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	ifzerob
	PALVAROFFSET	{alvar}
	PADDR	{addr}
	ELSEIF
	pathcode	ifzerow
	PALVAROFFSET	{alvar}
	PADDR	{addr}
	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_IFNOTZERO		MACRO	[alvar,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	ifnotzerob
	PALVAROFFSET	{alvar}
	PADDR	{addr}
	ELSEIF
	pathcode	ifnotzerow
	PALVAROFFSET	{alvar}
	PADDR	{addr}
	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_IFNOTSAME		MACRO	[alvar,val,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	3
	PALVAR	{alvar}

	IFC	"0","{val}"

	P_IFNOTZERO	{alvar},{addr}

	ELSEIF

	pathcode	ifnot

	P_IFSAME	{alvar},{val},{addr}

	ENDC

	pathmac_end
		ENDM


;--------------------------------------------------------------------
P_IFBETWEEN		MACRO	[val1,alvar,val2,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	4
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	ifbetweenB
	PALVAROFFSET	{alvar}
	db	{val1},{val2}
	PADDR	{addr}
	ELSEIF
	pathcode	ifbetweenW
	PALVAROFFSET	{alvar}
	dw	{val1},{val2}
	PADDR	{addr}
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFNOTBETWEEN	MACRO	[val1,alvar,val2,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	4
	PALVAR	{alvar}

	pathcode	ifnot

	P_IFBETWEEN	{val1},{alvar},{val2},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_INVINCIBLE		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	invincible{onoff}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ZREMOVE		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	zremove{onoff}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PLAYERDEAD		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	playerdead
	PADDR	{addr}
	pathmac_end
		ENDM

;--------------------------------------------------------------------
__psp_link	equ	0
__psp_	equ	0

P_SPAWN		MACRO	[x,y,z,xrot,yrot,zrot,shape,path,hp,ap,linkonoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	10,11

	IFD	__psp_{linkonoff}
	pathcode	spawn{linkonoff}
	ELSEIF
	pathcode	spawnchild
	ENDC

	dw	{shape}
	dw	path_{path}
	db	{xrot},{yrot},{zrot}
	db	{hp},{ap}
	dw	({x}),({y}),({z})

	IFND	__psp_{linkonoff}
	db	{linkonoff}
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_QSPAWN		MACRO	[shape,path,hp,ap]
	pathmac_start
MYNARG	=	NARG
	PNARG	4
	pathcode	qspawn
	dw	{shape}
	dw	path_{path}
	db	{hp},{ap}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_DEBUG		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	debug
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_WEAPON		MACRO	[weapon]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	weapon
	db	WEAPON_{weapon}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
pft_canhit	=	0
pft_	=	0
pft_atplayer	=	0
pft_atshape	=	0
P_FIRE		MACRO	[opt1,opt2]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,2

	IFNE	NARG<2
	pathcode	fire{opt1}
	ELSEIF
	pathcode	fire{opt1}{opt2}
	ENDC


	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_CHILDDEAD		MACRO	[child,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	childdead
	db	{child}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_LINKCHILD		MACRO	[child]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	linkchild
	db	{child}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_FLAGCHILD		MACRO	[child]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	flagchild
	db	{child}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_FLAGMOTHER		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	flagmother

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFFLAG		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	ifflag
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_FLAGSHAPE		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	flagshape

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_TEXT		MACRO	[text,colour,size]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3
	pathcode	text
	dw	{text}&WM
	db	{colour}
	IFEQ	NARG-3
	db	{size}
	ELSEIF
	db	0
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
pt_off
P_TRAIL		MACRO	[colour]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	trail
	IFD	pt_{colour}
	db	0
	ELSEIF
	db	{colour}
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_GOSUB		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	IFD	al_{addr}
	PCHKSIZE	{addr},2
	pathcode	gosubalvar
	PALVAROFFSET	{addr}
	ELSEIF
	pathcode	gosub
	PADDR	{addr}
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_RETURN		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	return
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_DO		MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	doalvarb
	ELSEIF
	pathcode	doalvarw
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	IFEQ	({num})&$ffffff00
	pathcode	doq
	db	{num}
	ELSEIF
	pathcode	do
	dw	{num}
	ENDC
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_NEXT		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	next
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_INEXT		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	inext
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_BREAK		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1
	IFEQ	NARG-1
	pathcode	break
	PADDR	{addr}
	ELSEIF
	pathcode	breakc
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------

; timing triggers:

trigger_always	equ	0
trigger_2		equ	1
trigger_4		equ	2
trigger_8		equ	3
trigger_16		equ	4
trigger_32		equ	5
trigger_64		equ	6
trigger_128		equ	7

; event triggers:

trigger_whenhit	equ	8
trigger_whenhitbyplayer equ	9
trigger_whenflagged	equ	10
trigger_whenshapedead equ	11
trigger_whendead	equ	12
trigger_whenthrough	equ	13
trigger_whensteppedon equ	14

trigger_off		equ	-1

P_TRIGGER		MACRO	[addr,trigger]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2

	IFEQ	trigger_off-trigger_{trigger}
	pathcode	alwaysoff
	PADDR	{addr}
	ELSEIF
	
	pathcode	always
	PADDR	{addr}
	db	trigger_{trigger}

	ENDC

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_FORCE	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	force
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SPRITE	MACRO	[colour,size]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2

	pathcode	sprite
	db	{colour}
	IFEQ	NARG-2
	db	{size}
	ELSEIF
	db	0
	ENDC

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_HITFLASH	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	hitflash{onoff}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETSTRAT	MACRO	[strat]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	setstrat
	dw	{strat}&WM
	db	{strat}>>16
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_NEG	MACRO	[alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	negB
	dw	al_{alvar}
	ELSEIF
	pathcode	negW
	dw	al_{alvar}
	ENDC
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETRANDOM	MACRO	[alvar,rndmask]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2
	PALVAR	{alvar}

	IFEQ	NARG-1

	IFEQ	size_al_{alvar}-1
	pathcode	setrandomB
	dw	al_{alvar}
	db	-1
	ELSEIF
	pathcode	setrandomW
	dw	al_{alvar}
	dw	-1
	ENDC

	ELSEIF

	IFEQ	size_al_{alvar}-1
	pathcode	setrandomB
	dw	al_{alvar}
	db	{rndmask}
	ELSEIF
	pathcode	setrandomW
	dw	al_{alvar}
	dw	{rndmask}
	ENDC

	
	ENDC

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFHITFLAG	MACRO	[addr,1,2,3,4,5,6,7,8]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,9

	pathcode	ifhitflag
	PADDR	{addr}
	IFEQ	NARG-1
pifhitmask	=	255
	ELSEIF
pifhitmask	=	0
	REPT	NARG-1
	irs	1,"{1}","{2}","{3}","{4}","{5}","{6}","{7}","{8}"
	run	"pifhitmask = pifhitmask!(1<<(%$1-1)"
	ENDR
	ENDC

;	printf	pifhitmask,"%n"
	db	pifhitmask

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COLLISIONS	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	collisions{onoff}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SHADOW	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	shadow{onoff}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_START65816	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	start65816
	SHORTA
	LONGI
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_END65816	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	a16
	lda	#.\@&$7fff+((.\@>>16)&1)*$8000
	rtl
.\@
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SWITCHOUT	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

psw_A	=	0
	IFND	psw_{addr}

	IFEQ	LONGA
	a16
	ENDC

	lda	#{addr}&$7fff+(({addr}>>16)&1)*$8000

	ENDC

	rtl
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PARTICLES	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	particle

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_UNLINKCHILD	MACRO	[child]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	IFEQ	NARG-1
	pathcode	unlinkchild
	db	{child}
	ELSEIF
	pathcode	unlinkself
	ENDC
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IMPORT		MACRO	[alvar,var]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	importb
	ELSEIF
	pathcode	importw
	ENDC
	PALVAROFFSET	{alvar}
	dw	{var}&WM
	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_EXPORT		MACRO	[var,alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	exportb
	ELSEIF
	pathcode	exportw
	ENDC
	PALVAROFFSET	{alvar}
	dw	{var}&WM
	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_DIV2		MACRO	[alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	div2b
	ELSEIF
	pathcode	div2w
	ENDC

	dw	al_{alvar}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_INDEX		MACRO	[alvar,table,index]
	pathmac_start
MYNARG	=	NARG
	PNARG	3
	PALVAR	{alvar}
	PALVAR	{index}

	IFEQ	size_al_{alvar}-1
	pathcode	indexb
	ELSEIF
	pathcode	indexw
	ENDC

	dw	{table}&WM
	db	{table}>>16
	PALVAROFFSET	{index}
	PALVAROFFSET	{alvar}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_AUTOINDEX		MACRO	[size,alvar,table,index,max]
	pathmac_start
MYNARG	=	NARG
	PNARG	5
	PALVAR	{alvar}
	PALVAR	{index}

_pa_b	=	1
_pa_w	=	2
	IFEQ	_pa_{size}-1

	IFEQ	size_al_{alvar}-1
	pathcode	autoindexbb
	ELSEIF
	pathcode	autoindexbw
	ENDC
	ELSEIF
	error	<Only B may be used currently>
	pathcode	autoindexw

	ENDC

	dw	{table}&WM
	db	{table}>>16
	PALVAROFFSET	{index}
	PALVAROFFSET	{alvar}
	db	({max})&255

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PUSH		MACRO	[alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	pushb
	ELSEIF
	pathcode	pushw
	ENDC

	PALVAROFFSET	{alvar}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PULL		MACRO	[alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	pullb
	ELSEIF
	pathcode	pullw
	ENDC

	PALVAROFFSET	{alvar}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_WITHINRADIUS	MACRO	[val,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	withinrange
	dw	{val}
	PADDR	{addr}
	
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SHAPEINRADIUS	MACRO	[val,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	shapeinrange
	dw	{val}
	PADDR	{addr}
	
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_JSL65816		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	P_START65816
	jsl	{addr}
	P_END65816
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_BOOST		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	P_GOSUB	pboost{onoff}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
	string	_p_bc[10]
_p_uid	=	0

P_BECOMECHILD	MACRO	[child,addr]
	pathmac_start
MYNARG	=	NARG

	IFD	al_{child}

	PNARG	1,2

	pathcode	becomechildb
	PALVAROFFSET	{child}
	IFEQ	MYNARG-1
	defs	_p_bc,"_p_u",_p_uid
	run	" dw %$_p_bc"
	ELSEIF
	PADDR	{addr}
	ENDC

	ELSEIF

	PNARG	1,2

	pathcode	becomechild
	db	{child}
	IFEQ	MYNARG-1
	defs	_p_bc,"_p_u",_p_uid
	run	" dw %$_p_bc"
	ELSEIF
	PADDR	{addr}
	ENDC

	ENDC

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_BECOMEMOTHER	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	becomemother
	
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_BECOMESHAPE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	becomeshape
	
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_UNBECOME		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	unbecome

	defs	_p_bc,"_p_u",_p_uid
	run	"%$_p_bc = (*)&$7fff+(((*)>>16)&1)*$8000"

_p_uid	=	_p_uid+1
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_BECOME		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	become
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETCOLANIM		MACRO	[val]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	initcolanim
	db	{val}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_ADDCOLANIM		MACRO	[val,endval]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	addcolanim
	db	{val},{endval}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
pollenon	=	0
pollenoff	=	1
P_POLLEN		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFEQ	pollen{onoff}
	P_JSL65816	makepollen_srou_l
	ELSEIF
	ENDC

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SCORE	MACRO	[score]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{score}
	IFEQ	size_al_{score}-1
	pathcode	scoreb
	ELSEIF
	pathcode	scorew
	ENDC
	PALVAROFFSET	{score}

	ELSEIF

	pathcode	score
	dw	{score}

	ENDC

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PLAYER	MACRO	[number]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	player{number}

	pathmac_end
	ENDM
	
;--------------------------------------------------------------------
P_IFPLAYER	MACRO	[number,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifplayer
	db	{number}
	PADDR	{addr}

	pathmac_end
	ENDM
;--------------------------------------------------------------------

P_SWAPPLAYER		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	swapplayer

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_LOCKPLAYER		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	lockplayer{onoff}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PLAYERINCONE	MACRO	[range,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	playerincone
	db	{range}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_CIRCLE		MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	circleB
	ELSEIF
	pathcode	circleW
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	pathcode	circle
	db	{num}

	ENDC

	pathmac_end
		ENDM


;--------------------------------------------------------------------
P_CIRCLEPLAYER	MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	circleplayerB
	ELSEIF
	pathcode	circleplayerW
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	pathcode	circleplayer
	db	{num}

	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_MOVEIN		MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	moveinB
	ELSEIF
	pathcode	moveinW
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	pathcode	movein
	db	{num}

	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_MOVEINPLAYER	MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	moveinonplayerB
	ELSEIF
	pathcode	moveinonplayerW
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	pathcode	moveinonplayer
	db	{num}

	ENDC

	pathmac_end
		ENDM


;--------------------------------------------------------------------
P_SETID	MACRO	[num]
	P_SET	sbyte1,{num}
	ENDM
;--------------------------------------------------------------------
P_SLOPE	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	P_GOSUB	pslope{onoff}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_RADAROBJ	MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	P_SET	radarobj,{num}
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_BECOMEINERT	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	becomeinert
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_RELATIVE	MACRO		[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	relative{onoff}
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_STAMPSTART	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	stampstart
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_PRINT	MACRO	[alvar,mode,who]
	pathmac_start

MYNARG	=	NARG
	PNARG	2,3
	P_start65816
	IFEQ	size_al_{alvar}-2
	a16
	ENDC

	lda	al_{alvar},x

	defs	1,"%p"
	IFEQ	NARG-2
	run	" print{mode} <%$1",".{alvar}>"
	ELSEIF
	run	" print{mode} <%$1",".{alvar}>,{who}"
	ENDC

	P_end65816
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CLEARSTACK	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	clearstack
	pathmac_end
	ENDM
;--------------------------------------------------------------------


;--------------------------------------------------------------------
P_FORCEJUMP	MACRO	[val]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	forcejump
	db	{val}
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_FORCETRANSFORM	MACRO	[type]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	trans{type}
	pathmac_end
	ENDM

P_PLRTRANSLOCK	MACRO

	pathmac_start

MYNARG	=	NARG
	PNARG	0

	pathcode	plrtranslock

	pathmac_end
	ENDM


P_PLRTRANSLOCKOFF	MACRO

	pathmac_start

MYNARG	=	NARG
	PNARG	2,3

	pathcode	plrtranslockoff

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_IFARWING	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifplrarwing
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFROBOT	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifplrrobot
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFUFO	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifplrufo
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SHOCKCAM	MACRO	[cam,value]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	shockcam{cam}
	dw	{value}
	pathmac_end
	ENDM

;--------------------------------------------------------------------

P_HITFLASHTRIG	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	hitflashtrig
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_BEGINDEMO	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	begindemo
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_ENDDEMO	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	enddemo
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_ACTIVE	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	active{onoff}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETCAMERA	MACRO	[immed]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1
	pathcode	setcamera{immed}
	pathmac_end
	ENDM

;--------------------------------------------------------------------

P_SETMARKER	MACRO	[1or2]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	setmarker{1or2}
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_IFPLAYERFULLHP	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifplrfullhp
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------

P_CLIPPING	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	clipping{onoff}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_POOL	MACRO	[height]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	pool
	db	{height}

	pathmac_end 
	ENDM
;--------------------------------------------------------------------
P_SOUNDEFFECT	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	sound
	db	sport3_{sound}

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_SOUND	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	sound2
	db	sport2_{sound}

	pathmac_end
	ENDM
	
;--------------------------------------------------------------------
P_SOUNDEFTDIST	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	sounddist
	db	sport3_{sound}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SOUNDEFTPOS	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	soundpos
	db	sport3_{sound}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SOUNDEFTNEAR	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	soundnear
	db	sport3_{sound}

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_SOUNDEFTNEARPOS	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	soundnearpos
	db	sport3_{sound}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SOUNDEFTDISTPOS	MACRO	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	sounddistpos
	db	sport3_{sound}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SOUNDEFTVIS	macro	[sound]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	soundvis
	db	sport3_{sound}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SOUNDEFTDIRECT	macro	[sound,flag]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	sounddirect
	db	sport3_{sound}
	db	ksf_{flag}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_BEHINDKPLAYER	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

 	pathcode	behindkplayer
	PADDR	{addr}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_RANGECHECK	MACRO	[onoff,map]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2

	pathcode	rangecheck{onoff}{map}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFPILOT	MACRO	[name,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	ifpilot
	db		ep_{name}
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_NOTPILOT	MACRO	[name,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	notpilot
	db	ep_{name}
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETSWITCH		MACRO	[alvar,alvar2]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2

	PALVAR	{alvar}

	IFEQ	MYNARG-2

	PALVAR	{alvar2}

	pathcode	setswitchv
	PALVAROFFSET	{alvar}
	PALVAROFFSET	{alvar2}

	ELSEIF

	pathcode	setswitch
	PALVAROFFSET	{alvar}

	ENDC
	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_CLRSWITCH		MACRO	[alvar,alvar2]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2

	PALVAR	{alvar}

	IFEQ	MYNARG-2

	PALVAR	{alvar2}

	pathcode	clrswitchv
	PALVAROFFSET	{alvar}
	PALVAROFFSET	{alvar2}

	ELSEIF

	pathcode	clrswitch
	PALVAROFFSET	{alvar}

	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_IFSWITCH		MACRO	[alvar,addr,addr2]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3

	PALVAR	{alvar}

	IFEQ	MYNARG-3

	PALVAR	{addr}

	pathcode	ifswitchv
	PALVAROFFSET	{alvar}
	PALVAROFFSET	{addr}
	PADDR	{addr2}

	ELSEIF

	pathcode	ifswitch
	PALVAROFFSET	{alvar}
	PADDR	{addr}

	ENDC
	pathmac_end
		ENDM

;--------------------------------------------------------------------

;--------------------------------------------------------------------
P_PLRTURN	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	plrturn{onoff}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PLRFORCETURN	MACRO	[var,width]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	plrforceturn
	db	{var}
	dw	{width}

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_PLRFORCEWAY	MACRO	[roty,width,length]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3

	pathcode	plrforceway
	db	{roty}
	dw	{width}

	IFEQ	NARG-3
	dw	{length}
	ELSEIF
	dw	{width}
	ENDC

	pathmac_end
	ENDM

;--------------------------------------------------------------------
	string	bossname[30]

P_BOSSMODELIST	MACRO	[bossname]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

_pb_ncount	=	0

	string	bossname="{bossname}"
	
{bossname}list
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_BOSSMODE		MACRO	[addr,name]
	pathmac_start

MYNARG	=	NARG
	PNARG	1,2

	IFEQ	MYNARG-2
pbm_{name}	equ	_pb_ncount
	ENDC
_pb_ncount	=	_pb_ncount+2
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_JUMPBOSSMODE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	P_START65816
	a16
	txy
	ldx	bossmode
	run	" lda.l %$bossname","list,x"
	tyx
	P_SWITCHOUT	A

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SETBOSSMODE	MACRO	[name]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	P_START65816
	lda	#pbm_{name}
	sta	bossmode
	P_END65816

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_NEXTBOSSMODE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	nextbossmode

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_BOSSFLAGLIST	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	run	" defflaglist %$bossname"
	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_BOSSFLAG		MACRO	[name]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	defflag	{name}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_IFBOSSFLAG		MACRO	[name,onoff,addr]
	pathmac_start
MYNARG	=	NARG

psbf_flags	=	0
psbf_cnt	=	0

	REPT	NARG

	irs	1,"\1","\2","\3","\4","\5","\6","\7","\8","\9","\a","\b","\c","\d","\e","\f","\g","\h"

	IFEQ	psbf_cnt-(NARG-1)
	dw	psbf_flags
	run	" PADDR %$1"
	ELSEIF
	IFEQ	psbf_cnt-(NARG-2)
	run	" pathcode	ifbossflag%$1"
	ELSEIF
	run	"psbf_flags = psbf_flags!%$bossname","_%$1"
	ENDC
	ENDC
psbf_cnt	=	psbf_cnt+1
	ENDR

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_SETBOSSFLAG	MACRO	[name,onoff]
	pathmac_start

psbf_flags	=	0
psbf_cnt	=	0

	REPT	NARG

	irs	1,"\1","\2","\3","\4","\5","\6","\7","\8","\9","\a","\b","\c","\d","\e","\f","\g","\h"

	IFEQ	psbf_cnt-(NARG-1)
	run	" pathcode	setbossflag%$1"
	dw	psbf_flags
	ELSEIF
	run	"psbf_flags = psbf_flags!%$bossname","_%$1"
	ENDC

psbf_cnt	=	psbf_cnt+1
	ENDR

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_CLRBOSSFLAGS	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	clrbossflag

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_SETTYPE		MACRO	[type]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	P_START65816
	s_set_colltype	x,{type}
	P_END65816

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_CLRTYPE		MACRO	[type]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	P_START65816
	s_clr_colltype	x,{type}
	P_END65816

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_AREA		MACRO	[area,onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

_pa_on	=	0
_pa_off	=	128

	P_START65816
	IFD	al_{area}
	lda	al_{area},x
	ora	#_pa_{onoff}
	ELSEIF
	lda	#({area})!_pa_{onoff}
	ENDC
	jsl	ClearBlockmapArea_l
	P_END65816

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_GINC	MACRO	[size,var]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

_pg_b	=	1
_pg_w	=	2

	IFEQ	_pg_{size}-1
	pathcode	gincb
	ELSEIF
	pathcode	gincw
	ENDC

	dw	({var})&WM

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_GDEC	MACRO	[size,var]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

_pg_b	=	1
_pg_w	=	2

	IFEQ	_pg_{size}-1
	pathcode	gdecb
	ELSEIF
	pathcode	gdecw
	ENDC

	dw	({var})&WM

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_GADD	MACRO	[dst,src]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	IFD	al_{dst}

	IFEQ	size_al_{dst}-1
	pathcode	addbg
	ELSEIF
	pathcode	addwg
	ENDC

	PALVAROFFSET	{dst}
	dw		({src})&WM

	ELSEIF

	IFEQ	size_al_{src}-1
	pathcode	addgb
	ELSEIF
	pathcode	addgw
	ENDC

	dw		({dst})&WM
	PALVAROFFSET	{src}

	ENDC

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYPLAYERPOS	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	copyplayerpos

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFLARGER	MACRO	[alvar1,alvar2,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	3

	PALVAR	{alvar1}
	PALVAR	{alvar2}

	IFEQ	size_al_{alvar1}-1
	pathcode	iflargerb
	ELSEIF
	pathcode	iflargerw
	ENDC

	IFNE	size_al_{alvar1}-size_al_{alvar2}
	error	<P_IFLARGER: var1 and var2 must be same size>
	ENDC

	PALVAROFFSET	{alvar1}
	PALVAROFFSET	{alvar2}

	PADDR	{addr}

	pathmac_end

	ENDM
;--------------------------------------------------------------------
P_IFSMALLER	MACRO	[alvar1,alvar2,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	3

	PALVAR	{alvar1}
	PALVAR	{alvar2}

	IFEQ	size_al_{alvar1}-1
	pathcode	iflargerb
	ELSEIF
	pathcode	iflargerw
	ENDC

	IFNE	size_al_{alvar1}-size_al_{alvar2}
	error	<P_IFSMALLER: var1 and var2 must be same size>
	ENDC

	PALVAROFFSET	{alvar2}
	PALVAROFFSET	{alvar1}

	PADDR	{addr}

	pathmac_end

	ENDM
;--------------------------------------------------------------------
P_SETCLIP	MACRO	[y]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	P_STAR65816
	ramnastyoff
	a16
	lda	#{y}
	sta.l	m_groundlevel

	P_END65816

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFPLAYERBOOST	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifplrboost
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFPLAYERBRAKE	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifplrbrake
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_FINDENEMYSHAPE	MACRO	[maxradius,range,addr]
	pathmac_start

MYNARG	=	NARG
	PNARG	3

	pathcode	findenemyshape

	dw	{maxradius}
	db	{range}
	dw	{addr}-paths

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SWAPVAR	MACRO	[var1,var2]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	P_START65816
	a16
	lda	al_{var1},x
	pha
	lda	al_{var2},x
	sta	al_{var1},x
	pla
	sta	al_{var2},x
	a8
	P_END65816

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_OBJINCONE	MACRO	[range,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	objincone
	db	{range}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
;--------------------------------------------------------------------
P_PLRBURN	MACRO	[LCR]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	plrburn

	db	exal_dmgeffect_burnning_{LCR}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_MOVEPLAYER	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	moveplayer{onoff}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_ADJUSTROT	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	adjustrot

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_STOREBOSSMODE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	P_START65816
	a16
	lda	bossmode
	sta	bossmodestore
	P_END65816

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_RESTOREBOSSMODE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	P_START65816
	a16
	lda	bossmodestore
	sta	bossmode
	P_END65816

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_SETSPWEAP	MACRO	[type]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	setspweap
	db		spweap_{type}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_INCSPWEAP	MACRO	[val,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	incspweap
	db	{val}&$0f
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PLRSHIELD	MACRO	[frame]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	plrshield
	db		{frame}>>3
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_ROBOTCAMYOFS	MACRO	[value]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	camrbyofs
	dw		{value}
	pathmac_end
	ENDM
;--------------------------------------------------------------------

