;                            �������������Ŀ
;             ��������������͵             ��������������ͻ
;             �              � PATH MACROS �              �
;             ��������������͵             ��������������ͼ
;                            ���������������

pathinfo	=	0

;     ����������������������Ŀ
;����͵ MISCELLANEOUS MACROS �����������������������������������������������ͻ
;�    ������������������������                                               �
;�                                                                           �
;� START_PATH      name               ; define the beginning of a path       �
;� P_END                              ; end of path                          �
;� P_DEBRIS        shape              ; debris explosions to use <shape>     �
;� P_EXPLODE                          ; explodes the object                  �
;� P_REMOVE                           ; remove object                        �
;� P_DEBUG                            ; causes a 'blink'                     �
;� P_PRINT         alvar,mode,user    ; displays the value in alvar          �
;�                                    ; mode = d,b, or h (bin, dec, hex)     �
;� P_SETANIM       value              ; initialise animation to value        �
;� P_ADDANIM       rate,max           ; adds [rate] to anim, max=last frame  �
;� P_SETCOLANIM    value              ; initialise colouranimation to value  �
;� P_ADDCOLANIM    rate,max           ; adds [rate] to colour anim           �
;� P_SPRITE        colour[,size]      ; makes shape a software sprite        �
;� P_TEXT          addr,color[,size]  ; change path type to message          �
;� P_TRAIL         OFF|num            ; (use with P_TEXT) num = trail col    �
;� P_TRIGGER       (ALL)addr,type|OFF[,cnt]; trigger routine if (see 'TRIGGERS')  �
;�                                    ; Optionally the trigger can be        �
;�                                    ; automatically removed after 'cnt'    �
;�                                    ; game frames                          �
;� P_RTRIGGER                         ; same as trigger but address must     �
;�                                    ; be within +256 bytes                 �
;� P_IFLASTTRIG    addr               ; if this is last trigger to occur     �
;�                                    ; before being removed goto 'addr'     �
;�                                    ; (this will only work for ALWAYS)     �
;�                                    ; check the 'TIMER' trigger type       �
;� P_FORCE         addr               ; sets address to begin execution      �
;�                                    ; AFTER current trigger routine has    �
;�                                    ; finished (all DO-NEXT and GOSUB-     �
;�                                    ; RETURN loops are cleared             �
;�                                    ; (must only use from triggered code)  �
;� P_FORCEGOSUB    addr               ; Same as FORCE however, P_RETURN will �
;�                                    ; return to the point it was FORCE'd   �
;�                                    ; (must only use from triggered code)  �
;� P_START65816                       ; begin 65816 code                     �
;� P_END65816                         ; end 65816 code                       �
;� P_JSL65816      routine            ; call 65816 code                      �
;� P_SWITCHOUT     addr|A             ; switch out of 65816 to <routine>     �
;� P_PARTICLES     type,amount,life   ; create particles shower              �
;�                                    ; type can be gravity or normal        �
;�                                    ; amount is amount added every frame   �
;�                                    ; life is how long you want to last    �
;� P_SOUND         num                ; trigger continuous sound effect      �
;� P_SOUNDEFFECT         num          ; trigger one-shot sound effect        �
;� P_SOUNDEFTDIST        num          ; trigger sound effect from dist(n,m,l)�
;� P_SOUNDEFTPOS         num          ; trigger sound effect from L/C/R      �
;� P_SOUNDEFTDISTPOS     num          ; trigger sound effect from dist(n,m,l)�
;�                                    ;                & left/center/right   �
;� P_SOUNDEFTNEAR        num          ; trigger sound effect from near dist  �
;� P_SOUNDEFTNEARPOS     num          ; trigger sound effect from L/C/R(near)�
;� P_SOUNDEFTVIS         num          ; trigger sound effect visible		�
;� P_SOUNDEFTDIRECT      num,flag     ; trigger sound effect direct          �
;� 		       ;flag = (nearL,nearC,nearR,midL,midC,midR,far)   �
;� P_SOUNDPLACE     place             ; set sound place                      �
;� P_BECOME                           ; becomes the last shape created       �
;� P_BECOMESHAPE                      ; become shape                         �
;� P_BECOMEMOTHER                     ; become mother                        �
;� P_BECOMECHILD   num|[alvar,addr]   ; become the child specified           �
;�                                    ; this allows access to a child's      �
;�                                    ; variables                            �
;�                                    ; If an alvar is specified it will     �
;�                                    ; jump to addr if the child isn't      �
;�                                    ; found                                �
;� P_UNBECOME                         ; back to normal                       �
;� P_RADAROBJ      num                ; set the object for the radar display �
;� P_CLEARSTACK                       ; clears the stack (housekeeping)      �
;� P_BEGINDEMO                        ; begin path controlled demo sequence  �
;� P_ENDDEMO                          ; end path controlled demo sequence    �
;� P_ACTIVE        ON|OFF             ; active during demo sequence?         �
;� P_SETCAMERA     [IMMEDIATE]        ; set camera to current position       �
;� P_RANGECHECK    ON|OFF[,MAP]       ; turns off view range checking        �
;� P_SETSWITCH     alvar,[alvar]      ; sets switch to alvar (must be 1-16)  �
;�                                    ; If the second alvar is specified     �
;� P_COPYVIEWPOS   ;view's worldx,y,z --> current obj's worldx,y,z           �
;� P_COPYVIEWROTS  ;view's rotx,y,z   --> current obj's rotx,y,z             �
;� P_COPYVIEWPOS_demo ;(demo) view's worldx,y,z --> current obj's worldx,y,z �
;� P_COPYVIEWROTS_demo;(demo) view's rotx,y,z   --> current obj's rotx,y,z   �
;�                                    ; the flags will be set in that and    �
;�                                    ; not the global map switch            �
;� P_CLRSWITCH     alvar,[alvar]      ; clears switch                        �
;� P_IFSWITCH      alvar[,alvar],addr ; if switch number 'alvar' is set then �
;�                                    ; jump to addr                         �
;� P_SETTYPE       colltype           ; set collision type:                  �
;� P_CLRTYPE       colltype           ; clr collision type:                  �
;�                                    ; enemy1 or enemy2                     �
;� P_AREA          alvar|val,ON|OFF   ; turn an area on or off (blockmap)    �
;� P_SETCLIP       <y>                ; y position to y-clip at              �
;� P_SCENERY                          ; turns into scenery.. no strategy!    �
;� P_WOBBLE                           ; wobble the alien from side to side   �
;�                                    ; should be used once per frame        �
;�                                                                           �
;���������������������������������������������������������������������������ͼ
;     �������������Ŀ
;����͵ MODE MACROS ��������������������������������������������������������ͻ
;�    ���������������                                                        �
;�                                                                           �
;� P_RELTOPLAYER   ON|OFF             ; make z relative to player            �
;� P_ALWAYSGENVECS ON|OFF             ; always generate vectors              �
;� P_SPACESHIP     ON|OFF             ; y rotation is relative to z rotation �
;� P_INVINCIBLE    ON|OFF             ; turn invincibility off or on         �
;� P_ZREMOVE       ON|OFF             ; automatic removal of shape when z<0  �
;� P_INVISIBLE     ON|OFF             ; shape invisible and no collisions    �
;� P_HITFLASH      ON|OFF             ; hit flash on or off (on is default)  �
;� P_COLLISIONS    ON|OFF             ;  collision detection on or off       �
;� P_SHADOW        ON|OFF             ; shadow on or off (default=on)        �
;� P_BOOST         ON|OFF             ; software sprite boost on/off         �
;� P_POLLEN        ON|OFF             ; pollen on or off                     �
;� P_LOCKPLAYER    ON|OFF             ; lock the position relative to player �
;� P_SLOPE         ON|OFF             ; Switch slope object on or off        �
;� P_CLIPPING      ON|OFF|plane       ; Switch on plane clipping             �
;� P_MOVEPLAYER    ON|OFF             ; move the player with the current obj �
;� P_GROUNDOBJ     ON|OFF             ; force Z sort for ground object       �
;� P_FIREOBJ       ON|OFF             ; player ni hi wo tsukeru object       �
;� P_QUADVECS      ON|OFF             ; multiply vectors by 4?               �
;� P_PASSSOUND     ON|OFF   ; player to surechigatta toki no SOUND no ON|OFF �
;� P_ENEMYDMGSE    name	; hit sitatokino damage sound                   �
;�                           ; bs_cry_1(dragon)                              �
;�                           ; en_cry_2(seibutsu small)                      �
;�                           ; en_cry_3(seibutsu large)                      �
;� P_ENEMYRBDSE    name	; hit sitatokino damage sound                   �
;�                           ; reboundlaser2(STARWOLF)                              �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ���������������Ŀ
;����͵ FRIEND MACROS ������������������������������������������������������ͻ
;�    �����������������                                                      �
;�                                                                           �
;� P_FRIEND                           ; define path as a friend's path       �
;� P_IFFRIEND      friend,address     ; if friend then goes to address       �
;� P_NOTFRIEND     friend,address     ; if not friend then goes to address   �
;� P_MSG           num|alvar[,METER]  ; Displays msg <num> (METER shows hp)  �
;� P_DAMAGE                           ; takes one unit of damage from friend �
;� P_ALMOSTDEAD    address            ; if friend almost dead then goto addr �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     �����������������Ŀ
;����͵ CREATION MACROS ����������������������������������������������������ͻ
;�    �������������������                                                    �
;�                                                                           �
;� P_SPAWN         x,y,z,             ; creates a new path object            �
;�                 xrot,yrot,zrot,    ; xyz rotation (relative to original)  �
;�                 shape,path,        ; shape and path name                  �
;�                 hp,ap              ; hit points and attack points         �
;�                 [,LINK]            ; links newly created shape            �
;�                 [,n]               ; n = child number (use child macros)  �
;� P_QSPAWN        shape,path,hp,ap   ; short version of above (x,y,etc = 0) �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     �����������������������������Ŀ
;����͵ GENERAL PROGRAM FLOW MACROS ����������������������������������������ͻ
;�    �������������������������������                                        �
;�                                                                           �
;� P_WAIT          frames|alvar       ; wait for some time                   �
;� P_GOTO          addr               ; goto specified addr (waits 1 frame)  �
;� P_IGOTO         addr               ; immediately goto specified address   �
;� P_GOSUB         addr|alvar         ; nested gosub (alvar must be word)    �
;� P_RETURN                           ; return to gosub call                 �
;� P_RANDOMGOTO    addr               ; will go to address (50% of the time) �
;� P_LOOP          num,address        ; loop to addr <num>+1 times, (0-255)  �
;� P_DO            num|alvar          ; do until NEXT <num> times, (0-65535) �
;� P_NEXT                             ; repeat DO loop (nested) (1 frame)    �
;� P_INEXT                            ; repeat DO loop (0 frame)             �
;� P_BREAK         [addr]             ; break DO-NEXT loop, goto addr        �
;� P_IFLEVEL       number,addr        ; if level=number then go to addr      �
;� P_IFNOTLEVEL    number,addr        ; if level!=number then go to addr     �
;� P_HITGROUND     ground,addr        ; when hits [ground] goes to addr      �
;� P_NOTHITGROUND  ground,addr        ; if not hitting [ground] goes to addr �
;� P_HITWALL       address            ; goes to addr when hits tunnel walls  �
;� P_SETSTRAT      address            ; sets strategy (active immediately)   �
;� P_IFHITFLAG     addr[,1[,2]]...    ; check for hitflags (and clear them)  �
;�                                    ; if none specified, checks for any    �
;� P_ANDFRAMEGOTO     and,addr    	 ; gameframe&and=0 then goto addr       �
;� P_CHAINPOS         zofs                                                   �
;� P_HITSLOPE      addr  ; if hit slope then goto addr(osoi kamo)            �
;� P_IFAREAOUT     addr  ; AREA out sitara ADDR ni jump.                     �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ���������������Ŀ
;����͵ PLAYER MACROS ������������������������������������������������������ͻ
;�    �����������������                                                      �
;�                                                                           �
;� P_PLAYER        <number>           ; set which player to check            �
;� P_PLAYERDEAD    addr               ; if player is dead then go to addr    �
;� P_LEFTOFPLAYER  addr               ; if left of player go to addr         �
;� P_RIGHTOFPLAYER addr               ; if right of player go to addr        �
;� P_ABOVEPLAYER   addr               ; if above player go to addr           �
;� P_BELOWPLAYER   addr               ; if below player go to addr           �
;� P_BEHINDPLAYER  addr               ; if behind player go to addr          �
;� P_BEHINDKPLAYER  addr              ; if behind player go to addr (kawa)   �
;� P_WAITFACEPLAYER                   ; turns to the player (until finished) �
;� P_FACEPLAYER    [IMMEDIATE]        ; face player (1 iteration)            �
;� P_FACEPLAYER    Y                  ; face player (only Y rotation)        �
;� P_FACEVIEW      [IMMEDIATE]        ; face view (only Y rotation)          �
;� P_GOTOPOS       x,y,z,maxspeed     ; goes to position relative to player  �
;� P_DISTLESS      value,addr         ; if distance from player < value      �
;� P_DISTMORE      value,addr         ; if distance from player > value      �
;� P_ZDISTLESS     value,addr         ; if distance from player < value      �
;� P_ZDISTMORE     value,addr         ; if distance from player > value      �
;� P_WITHINRADIUS  radius,addr        ; if player is within <radius>         �
;� P_IFPLAYER      n,addr             ; if player n then goto (see P_PLAYER) �
;� P_SWAPPLAYER                       ; swaps the player      (see P_PLAYER) �
;� P_PLAYERINCONE  range,addr         ; is player within -range�<->range�?   �
;� P_INPLAYERSCONE -range,+range,addr ; is object in player's view cone?     �
;� P_SCORE         num                ; add to player's score                �
;� P_MOVEINPLAYER  num|alvar          ; move towards or away from the player �
;� P_CIRCLEPLAYER  angle|alvar        ; rotates object around player (y-rot) �
;� P_COPYPLAYERPOS                    ; copy the player's position           �
;� P_REBOUNDLASER		; player no laser wo hanekaesu.                 �
;� P_FACEPLAYEROFS xofs,yofs,zofs   face playerpos+xofs<<4+yofs<<4+zofs<<4   �
;�                                                                           �
;�                                                                           �
;�                                                                           �
;���������������������������������������������������������������������������ͼ
;     �����������������������Ŀ
;����͵ PLAYER'S WEPON MACROS ����������������������������������������������ͻ
;�    �������������������������                                              �
;� *al_ptr = player's pointer                                                �
;�                                                                           �
;� P_PWEAPINCLMT     ; player no weapon no limitter(sonzai dekiru kazu)      �
;�                   ; wo INCRIMENT suru.                                    �
;� P_PWEAPDECLMT     ; player no weapon no limitter(sonzai dekiru kazu)      �
;�                   ; wo DECRIMENT suru.                                    �
;� P_PWEAPHIT   addr0,addr1,addr2 ; If hit slope or obj                      �
;�	               ; gimen ni atatta toki addr0                     �
;�	               ; damage wo ataetara   addr1                     �
;�	               ; rebound saretara     addr2                     �
;�                                                                           �
;���������������������������������������������������������������������������ͼ
;     �������������������Ŀ
;����͵ DEMO CAMERA MACRO ��������������������������������������������������ͻ
;�    ���������������������                                                  �
;�                                                                           �
;� P_CAMPANSHAPE     num,reduce,[immediate]; pan with shape                  �
;� P_CAMPANPLAYER    num,reduce,[immediate]; pan with player                 �
;� P_CAMPANDEMOSHAPE num,reduce,[immediate]; pan with "demoobjptr"           �
;� P_COPYPOS2VIEW    num,[immediate]  ; copy pos to view (1 or 2)            �
;� P_COPYROT2VIEW    num,[immediate]  ; copy rot to view (1 or 2)            �
;� P_SETBG		name	; change bg                                     �
;�                                                                           �
;� P_NEXTMAP    	; set mapptr & mapbank 2 next map                       �
;�                                                                           �
;�                                                                           �
;�    �������������������Ŀ                                                  �
;����͵ DEMO PLAYER MACRO ��������������������������������������������������͹
;�    ���������������������                                                  �
;� P_COPYPOS2PLAYER   ;copy worldx,y,z  to player                            �
;� P_COPYROT2PLAYER   ;copy rot  x,y,z  to player                            �
;�    ������������������Ŀ                                                   �
;����͵ DEMO SHAPE MACRO ���������������������������������������������������͹
;�    ��������������������                                                   �
;�                                                                           �
;� P_SETDEMO    num           ; set demo mode number                         �
;� P_DEMOSETMAP               ; map no objct wo set suru.                    �
;� P_DEMOEND                  ; end demo & set map                           �
;� P_IFDEMOEND     addr          ; demo ga owattara REMOVE suru...           �
;� P_IFNOTDEMO  num,addr      ; if demomode != num then goto addr            �
;� P_IFSAMEDEMO num,addr      ; if demomode  = num then goto addr            �
;� P_DEMOSHAPE		 ; current obj pointer wo demoobjptr ni set     �
;� P_CLRDEMOSHAPE	; Clear demo no toki ni camara ga miru you ni naru.     �
;� P_PLAYERSHAPE	; player no shape(only arwing) wo copy suru.            �
;�                                                                           �
;�                                                                           �
;���������������������������������������������������������������������������ͼ
;     ���������������Ŀ
;����͵  BOSS MACROS  ������������������������������������������������������ͻ
;�    �����������������                                                      �
;�                                                                           �
;� P_BOSSMODELIST  bossname           ; Initialises the boss mode definitions�
;�                                    ; You must follow this with a list of  �
;�                                    ; P_BOSSMODE's                         �
;� P_BOSSMODE      addr[,name]        ; Define a boss mode                   �
;� P_JUMPBOSSMODE                     ; Jump to the current boss mode        �
;� P_SETBOSSMODE   name               ; Set boss into a particular mode      �
;� P_NEXTBOSSMODE                     ; Set the next boss mode               �
;� P_BOSSFLAGLIST                     ; Initialise flag list for this boss   �
;�                                    ; This must be specified somewhere     �
;�                                    ; AFTER the P_BOSSMODELIST definition  �
;� P_BOSSFLAG      name               ; define a boss flag                   �
;� P_IFBOSSFLAG    name,ON|OFF,addr   ; if boss flag on or off then jump     �
;� P_SETBOSSFLAG   name,ON|OFF        ; set a boss flag                      �
;� P_CLRBOSSFLAGS                     ; clear all boss flags                 �
;� P_STOREBOSSMODE                    ; store current boss mode (one level)  �
;� P_RESTOREBOSSMODE                  ; restore previously stored mode       �
;� P_SETBOSSNAME   <name>             ; set the boss's name for the hp meter �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ���������������Ŀ
;����͵ WEAPON MACROS ������������������������������������������������������ͻ
;�    �����������������                                                      �
;�                                                                           �
;� P_WEAPON        weaponname         ; sets default weapon for path object  �
;� P_FIRE          [CANHIT]           ; fires default weapon                 �
;� P_FIRE          ATPLAYER,[CANHIT]  ; fires default weapon at player       �
;� P_FIRE          ATSHAPE,[CANHIT]   ; fires default weapon at found shape  �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     �����������������Ŀ
;����͵ VARIABLE MACROS ����������������������������������������������������ͻ
;�    �������������������                                                    �
;�                                                                           �
;� P_CHASE         var,value          ; smoothly set var to value            �
;� P_CHASE         var1,var2          ; smoothly set var to another var      �
;� P_WAITCHASE     var,value          ; smoothly set var (until finished)    �
;� P_SET           var,value          ; immediately set var                  �
;� P_SET           var1,var2          ; set var1 = var2                      �
;� P_ZERO          var                ; zero var                             �
;� P_SETRANDOM     var[,rndmask]      ; set var to random value              �
;�                                    ; (rndmask = 1,3,7,15,31...65535)      �
;� P_ADDRANDOM     var,rndmask        ; add var to random value              �
;�                                    ; (rndmask = 1,3,7,15,31...32767)      �
;� P_ADD           var,value          ; add value to var (sign extended)     �
;� P_ADD           var,var            ; add var to var (sign extended)       �
;� P_GADD          dest,source        ; add global to alvar storing result   �
;�                                    ; in dest                              �
;� P_GSET          B|W,global var,#   ; set global to immediate value        �
;� P_GINC          B|W,global var     ; increment global by 1                �
;� P_GDEC          B|W,global var     ; decrement global by 1                �
;� P_INC           var                ; increment var by 1                   �
;� P_DEC           var                ; decrement var by 1                   �
;� P_NEG           var                ; negate var                           �
;� P_DIV2          var                ; signed divide by 2                   �
;� P_SHIFTR        var                ; unsigned divide by 2                 �
;� P_SETVEL        velocity           ; change speed (will remake vectors)   �
;� P_ACCEL         velocity,rate      ; change speed by rate (smooth setvel) �
;� P_IFSAME        var,value,addr     ; if var=value then go to addr         �
;� P_IFSAME        var,var,addr       ; if var=var then go to addr           �
;� P_IFNOTSAME     var,value,addr     ; if var!=value then go to addr        �
;� P_IFNOTSAME     var,var,addr       ; if var!=var then go to addr          �
;� P_IFZERO        var,addr           ; if var=0 then go to addr             �
;� P_IFNOTZERO     var,addr           ; if var!=0 then go to addr            �
;� P_IFBETWEEN     min,var,max,addr   ; if min>var>max then go to addr       �
;� P_IFNOTBETWEEN  min,var,max,addr   ; if min<var | var>max then go to addr �
;� P_IFLARGER      var1,var2,addr     ; if var1>var2 goto <addr> (signed)    �
;� P_IFSMALLER     var1,var2,addr     ; if var1<var2 goto <addr> (signed)    �
;� P_IMPORT        var,global var     ; var = global var                     �
;� P_EXPORT        global var,var     ; global var = var                     �
;�                                    ; global var must be same size as var; �
;�                                    ; ie. a byte=byte or word=word         �
;�                                    ; see 'GLOBAL VARIABLES'               �
;� P_INDEX         dest,table,index   ; indexes into a table (see 'TABLES')  �
;� P_AUTOINDEX     B|W,d,t,i,max      ; same as P_INDEX but increments 'i'   �
;�                                    ; up until 'max'-1 then loops back to 0�
;�                                    ; also value is ADDED to 'd'           �
;�                                    ; Table size is specified with B or W  �
;� P_PUSH          var                ; pushes var onto the stack            �
;� P_PULL          var                ; pulls var from the stack (see stack) �
;�                                                                           �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ����������������Ŀ
;����͵ LINKING MACROS �����������������������������������������������������ͻ
;�    ������������������                                                     �
;�                                                                           �
;� P_LINK          shape              ; link path to next path created       �
;� P_FINDSHAPE     shape              ; finds the shape specified            �
;� P_FINDNEXTSHAPE shape              ; finds the next closest shape         �
;� P_FACESHAPE     [IMMEDIATE]        ; faces the found or linked shape      �
;� P_GOTOSHAPEPOS  x,y,z,maxspeed     ; goes to a relative position          �
;� P_IMMUNE                           ; immune to collisions                 �
;� P_SHAPEDISTLESS value,address      ; if distance from shape < value       �
;� P_SHAPEDEAD     address            ; if shape is dead, goes to address    �
;� P_SPAWN         ...,LINK           ; see <CREATION MACROS>                �
;� P_FLAGSHAPE                        ; set flag for linked shape            �
;�                                    ; (only if linked shape is path obj)   �
;� P_IFFLAG        addr               ; if flag set goto addr (clears flag)  �
;� P_SHAPEINRADIUS radius,address     ; if linked shape is within radius     �
;� P_MOVEINSHAPE   val|var            ; move closer to found shape           �
;� P_CIRCLESHAPE   val|var            ; move around found shape              �
;� P_LINKTOBECOME                     ; sets shape obj to last created obj   �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ��������������Ŀ
;����͵ CHILD MACROS �������������������������������������������������������ͻ
;�    ����������������                                                       �
;�                                                                           �
;� P_SPAWN         ...,n              ; see spawn command above              �
;� P_CHILDDEAD     n,address          ; if CHILD n is dead, goto address     �
;� P_FLAGCHILD     n                  ; flag child (from child or mother)    �
;� P_FLAGMOTHER                       ; flag mother (from child)             �
;� P_IFFLAG        addr               ; if flag set goto addr (clears flag)  �
;� P_UNLINKCHILD   n                  ; make child into normal object        �
;� P_REMOVE        n                  ; remove child n                       �
;� P_CIRCLE        angle|alvar        ; rotates child around mother (y-rot)  �
;� P_MOVEIN        n|alvar            ; move closer to mother by val|alvar   �
;� P_SETID         n|alvar            ; set child id number                  �
;� P_BECOMEINERT                      ; changes into an inert object         �
;� P_STAMPSTART                       ; set the restart routine for inerts   �
;� P_ADJUSTROT                        ; adjusts world rotation to child rot  �
;�                                    ; eg. P_FACEPLAYER would normally      �
;�                                    ; not work, however if followed by     �
;�                                    ; P_ADJUSTROT it will                  �
;� P_POSCHILDREN   ON|OFF             ; turn automatic positioning of childs �
;� P_IFCHILD       n|alvar,addr       ; if current object is child 'n'       �
;� P_IFNOTCHILD    n|alvar,addr       ; if current object is NOT child 'n'   �
;� P_RELATIVE      ON|OFF             ; relative to mother object?           �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;���������������������������������������������������������������������������ͻ  
;�                                                                           �
;� Note #1: NEVER use FINDSHAPE, LINK, or FINDNEXTSHAPE with CHILD macros    �
;� Note #2: P_GOTO P_NEXT, and P_LOOP AUTOMATICALLY do a P_WAIT 1            �
;� Note #3**P_TRIGGER should NOT be used from within a trigger subroutine    �
;� Note #4: Note #3 is now OBSOLETE                                          �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ��������������Ŀ
;����͵ VALID 'VAR's �������������������������������������������������������ͻ
;�    ����������������                                                       �
;�                                                                           �
;�                worldx              ; object's x                           �
;�                worldy              ; object's y                           �
;�                rotx                ; object's x rotation                  �
;�                roty                ; object's y rotation                  �
;�                rotz                ; object's z rotation                  �
;�                hp                  ; object's hp                          �
;�                ap                  ; object's ap                          �
;�                shape               ; object's shape                       �
;�                coltab              ; object's colour table                �
;�                tx                  ; tx map x coordinate (or sprite size) �
;�                ty                  ; tx map y coordinate                  �
;�                area                ; set to -1 for permanent existance    �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ���������������������������������Ŀ                                     
;����͵ VARS AVAILABLE FOR CHILD MACROS ������������������������������������ͻ
;�    �����������������������������������                                    �
;�                                                                           �
;�                childx              ; relative x                           �
;�                childy              ; relative y                           �
;�                childz              ; relative z (relative to mother)      �
;�                childrotx           ; x rotation                           �
;�                childroty           ; y rotation                           �
;�                childrotz           ; z rotation                           �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     �����������������������������������������������Ŀ                       
;����͵ TEMPORARY VARIABLES AVAILABLE FOR GENERAL USE ����������������������ͻ
;�    �������������������������������������������������                      �
;�                                                                           �
;�                pbyte1              ; temporary byte #1                    �
;�                pbyte2              ; temporary byte #2                    �
;�                pword1              ; temporary word #1                    �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     �������������������������������������������������Ŀ
;����͵ CURRENT VALID WEAPONS ARE (USE WITH 'P_WEAPON') ��������������������ͻ
;�    ���������������������������������������������������                    �
;�                                                                           �
;�  SlowElaser         ; Elaser (use for ground based objects)               �
;�  RelSlowElaserHome  ; Relative slow laser (homes towards player)          �
;�  RelSlowElaser      ; Relative slow laser                                 �
;�  hmissile1          ; Normal homing missile                               �
;�  chickhmissile1     ; Chicken missile                                     �
;�  missile1           ; Straight firing missile                             �
;�  plasma             ; Plasma ball                                         �
;�  shortplasma        ; Plasma ball (disappears quicker)                    �
;�  Hplasma            ; Homing plasma ball                                  �
;�  ovalbeam           ; Oval (ellipse) beam                                 �
;�  ringlaser          ; Ring laser                                          �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ����������Ŀ
;����͵ TRIGGERS �����������������������������������������������������������ͻ
;�    ������������                                                           �
;�                                                                           �
;�  Always             - calls the routine on every game frame               �
;�  2,4,8,...,128      - ... once every n frames                             �
;�  WhenHit            - ... if hit                                          �
;�  WhenHitByPlayer    - ... if shot by player                               �
;�  WhenFlagged        - ... if flag is set (clears the flag automatically)  �
;�  WhenDead           - ... if hp=0 (explodes anyway, but you can spawn)    �
;�  WhenShapeDead      - ... if the LINK'd or FOUND shape dies               �
;�  WhenThrough        - ... if a player goes through the object             �
;�                       (sets P_PLAYER n automatically)                     �
;�  WhenSteppedOn      - ... if stepped on by the player (must be a slope)   �
;�                       (AL_SLOPENUM specifies which polygon)               �
;�                       (automatically does P_PLAYER to set which player)   �
;�  AboveSea           - player has burst through from under                 �
;�  BelowSea           - player has dived down under                         �
;�  Timer              - the trigger routine is called after 'cnt' frames    �
;�                                                                           �
;���������������������������������������������������������������������������͹
;�                                                                           �
;�  Note: TRIGGER should not use P_WAIT, P_GOTO, P_LOOP, P_WAITxxxx          �
;�  (anything which causes the next game frame to be displayed -             �
;�  doing so will cause a blue BLINK |^) )                                   �
;�                                                                           �
;�  Extra: TRIGGER can now be used from within a TRIGGER subroutine          �
;�  Also, the new extra parameter is a 'life' count, after n frames the      �
;�  trigger will be removed (0-255)                                          �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ������������������Ŀ
;����͵ GLOBAL VARIABLES ���������������������������������������������������ͻ
;�    ��������������������                                                   �
;�                                                                           �
;� Global variables are available for use by all strategies; they are        �
;� completely independent of the strategy that uses them.. ie. if one        �
;� strategy changes a global variable, another strategy can read or change   �
;� it.  Use IMPORT to copy a global variable into an alien variable.         �
;� Use EXPORT to copy an alien variable into a global variable.              �
;�                                                                           �
;���������������������������������������������������������������������������͹
;�                                                                           �
;�  gbyte1        = global byte 1                                            �
;�  gbyte2        = global byte 2                                            �
;�  gbyte3        = global byte 3                                            �
;�  gword1        = global word 1                                            �
;�  gword2        = global word 2                                            �
;�  gword3        = global word 3                                            �
;�                                                                           �
;���������������������������������������������������������������������������͹
;�                                                                           �
;� Note: you can ONLY copy a byte into a byte or a word into a word,         �
;� ie.  you cannot copy a byte into a word or vice versa.                    �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ��������Ŀ
;����͵ TABLES �������������������������������������������������������������ͻ
;�    ����������                                                             �
;�                                                                           �
;� The INDEX feature allows you to retrieve data from tables.  The index     �
;� should be a byte alien variable, if it is a word then only the bottom     �
;� 8 bits are utilised.                                                      �
;� If the destination is a word then the index is automatically multiplied   �
;� by 2 thus assuming you are indexing into a table of words.                �
;�                                                                           �
;���������������������������������������������������������������������������͹
;�                                                                           �
;� There are some default tables you can use:                                �
;�                                                                           �
;�   sintab - sin table (index should be 0-255, destination must be a byte)  �
;�   costab - cos table (index should be 0-255, destination must be a byte)  �
;�                                                                           �
;���������������������������������������������������������������������������͹
;�                                                                           �
;� Example:                                                                  �
;�                                                                           �
;�   P_SET   pbyte1,5                                                        �
;�   P_INDEX pword1,mytab,pbyte1                                             �
;�   ...                                                                     �
;�                                                                           �
;� mytab                                                                     �
;�   dw      0,500,400,300,200,400,500                                       �
;�                                                                           �
;� This will set pword1 = mytab+5*2 (400)                                    �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     �����������Ŀ
;����͵ THE STACK ����������������������������������������������������������ͻ
;�    �������������                                                          �
;�                                                                           �
;� The stack is used for DO-NEXT loops and GOSUB-RETURN subroutines.         �
;� It is also used for the PUSH/PULL commands therefore there is of          �
;� course some possibility of a clash.  You cannot PULL a variable           �
;� from a level different to that from which it was PUSHed.                  �
;�                                                                           �
;� ie.  P_DO    5                                                            �
;�      P_PUSH  pbyte1                                                       �
;�      ...                                                                  �
;�      P_PULL  pbyte1                                                       �
;�      P_NEXT                                                               �
;�                                                                           �
;� is valid, but:                                                            �
;�                                                                           �
;�      P_DO    5                                                            �
;�      P_PUSH  pbyte1                                                       �
;�      ...                                                                  �
;�      P_NEXT                                                               �
;�      P_PULL  pbyte1                                                       �
;�                                                                           �
;� is invalid and will probably crash                                        �
;�                                                                           �
;���������������������������������������������������������������������������ͼ
;     �������������������������������Ŀ
;����͵ PLAYER wo CONTROL suru MACROS ��������������������������������������ͻ
;�    ���������������������������������                                      �
;�                                                                           �
;� P_FORCEJUMP     	value	; player(ROBOT) wo jump saseru. (normal 5)	�
;� P_FORCETRANSFORM	type	; player wo transform saseru.(ARWING,ROBOT,UFO) �
;� P_PLRTRANSLOCK	P_FORCETRANSFORM no ato ni tsukau.	                �
;� P_PLRTRANSLOCKOFF                                                         �
;� P_INCSPWEAP	num	; special weapon no kazu wo huyasu.(max15)      �
;� P_SETSPWEAP	type	; special weapon no type wo set suru.           �
;�			;(pbyte2 wo tsukau!)                            �
;�                           ; missile1                                      �
;�                           ; dummy                                         �
;�                           ; flamethrower                                  �
;�                           ; smartplasma                                   �
;� P_INCSPWEAP	num,addr; special weapon no kazu wo huyasu.(max15)      �
;� 			(P_SETSPWEAP 1 kai set sitaato ni tsukau!       �
;�                           kazu ga sudeni max ni natte itara,addr ni jump. �
;�                                                                           �
;� P_PLRSHIELD	frame(max255)   ; player no shield wo set suru.         �
;� P_PLRTURN		on/off	; starfox1 mode on/off. on:turn dekinai         �
;� P_PLRFORCETURN	roty,width				                �
;�                                                                           �
;�	roty 	: 1 houkou mode no muki                                 �
;�	width	: idou no haba(hankei)                                  �
;�                                                                           �
;� P_PLRFORCEWAY	roty,width,length				        �
;�                                                                           �
;�	roty 	: 1 houkou mode no muki                                 �
;�	width	: idou no haba(hankei)                                  �
;�	length	: check suru nagasa                                     �
;� P_PLRBURN pos     ;pos = L(wing),C(body),R(wing),ALL                      �
;�                   ; player ga moeru.                                      �                 �
;� P_IFPLRTURN	on/off,addr ; player ga turn dekiruka check             �
;� P_PLRCONTROL	on/off	    ; player no control wo on/off suru.         �
;� P_TAMEHOMON	; player no tamedama no HOMING wo ON ni suru.           �
;� P_IFTAMEHOMON	addr ; player no homing ga ON nara addr ni JUMP suru.   �
;�                                                                           �
;�                                                                           �
;���������������������������������������������������������������������������ͼ

;     ����������������������������Ŀ
;����͵ PLAYER no WEAPON no MACROS �������������������������������������������������������ͻ
;�    ������������������������������                                                       �
;� P_FINDENEMYSHAPE    maxradius,range,addr; find enemy shape                              �
;� P_OBJINCONE          range,addr         ; is "objct(al_ptr)" within -range�<->range�?   �
;� P_PLRWEAPLEVELUP	;player no laser no levelup(normal -> twin -> twinbeam) �
;� P_IFPLRWEAPLEVEL	level,addr ;if player's laser level = "level(0,1,2)" then goto addr   �
;�                                                                                         �
;�����������������������������������������������������������������������������������������ͼ
;     ������������������������Ŀ
;����͵ GAME SEQUENCE no MACRO ����������������������������������������������ͻ
;�    ��������������������������                                              �
;� P_CLEARSEQUENCE     ; set clear sequence.                                    �
;�                                                                            �
;����������������������������������������������������������������������������ͼ
;     ��������������Ŀ
;����͵ EFFECT MACRO �������������������������������������������������������ͻ
;�    ����������� ����                                                       �
;�                                                                           �
;� P_HITFLASHTRIG		; set hitflash flag                             �
;� P_CIRCLEWINDOW	stepoffset[,mode]	; circle window on              �
;�                   mode=big(big window),warp(blue window)                  �
;� P_CIRCLEWINDOWPOS	; circle window no position wo kaerutoki tsukau..       �               �
;� P_SCREENFLASH	; screen wo flash suru.(Don't use with P_CIRCLEWINDOW)  �
;�                                                                           �
;���������������������������������������������������������������������������ͼ
;     ��������������Ŀ
;����͵ CAMERA MACRO ���������������������������������������������������������ͻ
;�    ����������������                                                         �
;�                                                                             �
;� P_SHOCKCAM	1or2,value	; camera wo sindou saseru.value=128 kurai.�
;� P_SHOCKCAM	1or2,value	; camera wo sindou saseru.value=128 kurai.�
;�                                                                             �
;�����������������������������������������������������������������������������ͼ
;     ��������������������Ŀ
;����͵ ENEMY MARKER MACRO �����������������������������������������������������������������������ͻ
;�    ����������������������                                                                       �
;�                                                                                                 �
;�  P_SETMARKER	1or2,offdist	; enemy marker wo set suru.                                   �
;�  P_ROBOTCAMYOFS   offset(16bit)   ; robot no view no offset. (-) de ue wo muki                  �
;�                                                                                                 �
;�������������������������������������������������������������������������������������������������ͼ
;     ��������������������������������������Ŀ
;����͵ PLAYER no STATUS wo check suruMACROS �������������������������������ͻ
;�    ����������������������������������������                               �
;�                                                                           �
;� P_IFARWING     	addr	; if player is arwing  then goto addr           �
;� P_IFROBOT     	addr	; if player is robot   then goto addr           �
;� P_IFUFO     		addr	; if player is ufo     then goto addr   �
;� P_IFPLAYERFULLHP 	addr	; if player's HP = max then goto addr           �
;� P_IFPILOT		name(FOX,FALCO....),addr	;if pilot = pilot then jmp addr
;� P_NOTPILOT	name,addr			;if pilot != pilot then jmp addr
;� P_IFPLAYERBOOST   addr    ; if player using "boost" then goto addr
;� P_IFPLAYERBRAKE   addr    ; if player using "brake" then goto addr
;�                                                                           �
;���������������������������������������������������������������������������ͼ














temptempvar	=	0

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
	SHORTA

	ldy	#{offset}
	promnastyoff
	lda.l	[path_pcptr],y
	sta	pathparam
	promnastyon

	ELSEIF

	LONGA
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

pathmac_embed_start	MACRO
	ENDM

pathmac_embed_end	MACRO
	ENDM

;--------------------------------------------------------------------
	ELSEIF
; path info macros:

	FCLOSE

	FOPEN	ASM\pathinfo.asm
	printf	"; ------------ PATH MACRO INFORMATION ------------%n"
	FCLOSE

;--------------------------------------------------------------------

	STRING	pathmacname[80]
	STRING	pathmacnameembed[80]
	STRING	pathmacnamelast[80]

pathmac_layer	=	0

pathmac_start	MACRO

	STRING	pathmacnamelast="%$pathmacname"
	STRING	pathmacname="%c"

	IFEQ	pathmac_layer-1
	pathmac_embed_start
	ENDC

pathmac_layer	=	pathmac_layer+1

	run	" IFND pathmac_%$pathmacname"

	FOPEN	+ASM\pathinfo.asm

	printf	" printf %q[20]%$pathmacname: %q,pathmac_%$pathmacname,%q %q,pathmacmem_%$pathmacname,%q        (average=%q,pathmacmem_%$pathmacname/pathmac_%$pathmacname,%q)%%n%q%n"
	
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
pathmac_layer	=	pathmac_layer-1
	IFEQ	pathmac_layer-1
	pathmac_embed_end
	ENDC
	ENDM

;--------------------------------------------------------------------

pathmac_embed_start	MACRO
	STRING	pathmacnameembed="%$pathmacnamelast"
	ENDM
;--------------------------------------------------------------------
pathmac_embed_end	MACRO
	STRING	pathmacname="%$pathmacnameembed"
	ENDM
;--------------------------------------------------------------------

	ENDC

;--------------------------------------------------------------------

addalvaroffset	MACRO	[param]
	IFNE	LONGA
	error	<addalvaroffset needs a8>
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
	pathmac_start

p{name}
path_{name}	equ	*-paths

numpaths	=	numpaths+1
	pathmac_end
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

	IFD	al_{numframes}
	PALVAR	{numframes}

	pathcode	waitB
	palvaroffset	{numframes}

	ELSEIF

	IFC	"{numframes}","1"
	pathcode	wait1
	ELSEIF
	pathcode	wait
	db	{numframes}
	ENDC
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

P_QUADVECS	MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	quadvecs{onoff}

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

P_FACEVIEW		MACRO	[immed]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	pathcode	faceview{immed}

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
P_ZDISTLESS		MACRO	[value,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	zdistless
	dw	{value}
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ZDISTMORE		MACRO	[value,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifnot

	P_ZDISTLESS	{value},{addr}

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

	IFEQ	{value}
	pathcode	initanim0
	ELSEIF
	pathcode	initanim
	db	{value}
	ENDC

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
P_POSCHILDREN		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	poschildren{onoff}
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

totalsaved	=	0

P_SPAWN		MACRO	[x,y,z,xrot,yrot,zrot,shape,path,hp,ap,linkonoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	10,11

psp_allrot0	=	0

	IFD	__psp_{linkonoff}
	pathcode	spawn{linkonoff}
	ELSEIF

	IFC	"0","{xrot}"
	IFC	"0","{yrot}"
	IFC	"0","{zrot}"
psp_allrot0	=	1
	ENDC
	ENDC
	ENDC

	IFEQ		psp_allrot0
	pathcode	spawnchild
	ELSEIF
	pathcode	spawnchildrot0
	ENDC
	ENDC

	dw	{shape}
	dw	path_{path}

	IFEQ	psp_allrot0
	db	{xrot},{yrot},{zrot}
	ENDC

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
trigger_belowsea	equ	15
trigger_abovesea	equ	16
trigger_timer	equ	17

trigger_off		equ	-1
trigger_all		equ	-2

P_TRIGGER		MACRO	[addr,trigger,cnt]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3

	IFEQ	trigger_off-trigger_{trigger}
	IFD	trigger_{addr}
	IFEQ	trigger_{addr}-trigger_all
	pathcode	alwaysoff_all
	ELSEIF
	error	<incorrect parameter>
	ENDC
	ELSEIF
	pathcode	alwaysoff
	PADDR	{addr}
	ENDC
	ELSEIF

	IFEQ	MYNARG-2
	IFEQ	trigger_always-trigger_{trigger}
	pathcode	trigalways
	PADDR	{addr}
	ELSEIF
	pathcode	always
	PADDR	{addr}
	db	trigger_{trigger}
	ENDC
	ELSEIF

	pathcode	alwayscnt
	PADDR	{addr}
	db	trigger_{trigger}
	db	{cnt}
	ENDC

	ENDC


	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_RTRIGGER		MACRO	[addr,trigger,cnt]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3

	IFEQ	trigger_off-trigger_{trigger}
	error	<Use P_TRIGGER to turn off trigger>
	MEXIT
	ELSEIF

	IFEQ	MYNARG-2
	pathcode	always_r

	IFD	{addr}
	error	<P_RTRIGGER can only forward reference addresses>
	ENDC

	db	(({addr})&$7fff+((({addr})>>16)&1)*$8000)-(((*-1)&$7fff+(((*-1)>>16)&1)*$8000))
	db	trigger_{trigger}
;	ENDC
	ELSEIF
	error	<Use P_TRIGGER for timer triggers>

	ENDC

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
P_FORCEGOSUB	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	forcegosub
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
	PALVAROFFSET	{alvar}
	ELSEIF
	pathcode	negW
	PALVAROFFSET	{alvar}
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
	PALVAROFFSET	{alvar}
	db	-1
	ELSEIF
	pathcode	setrandomW
	PALVAROFFSET	{alvar}
	dw	-1
	ENDC

	ELSEIF

	IFEQ	size_al_{alvar}-1
	pathcode	setrandomB
	PALVAROFFSET	{alvar}
	db	{rndmask}
	ELSEIF
	pathcode	setrandomW
	PALVAROFFSET	{alvar}
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
part_type_normal	=	4
part_type_gravity	=	3

P_PARTICLES	MACRO		[type,amount,life]
	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	particle
	db	part_type_{type}
	db	{amount}

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
	IFEQ	(({var}-path_zero_page)&255)-({var}-path_zero_page)
	  pathcode	importbq
	  PALVAROFFSET	{alvar}
	  db	{var}-path_zero_page
	ELSEIF
	  pathcode	importb
	  PALVAROFFSET	{alvar}
	  dw	{var}&WM
;	  printf "IMPORT NOT ZERO PAGE - {var}%n"
	ENDC
	ELSEIF
	IFEQ	(({var}-path_zero_page)&255)-({var}-path_zero_page)
	  pathcode	importwq
	  PALVAROFFSET	{alvar}
	  db	{var}-path_zero_page
	ELSEIF
	  pathcode	importw
	  PALVAROFFSET	{alvar}
	  dw	{var}&WM
;	  printf "IMPORT NOT ZERO PAGE - {var}%n"
	ENDC
	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_EXPORT		MACRO	[var,alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	IFEQ	(({var}-path_zero_page)&255)-({var}-path_zero_page)
	  pathcode	exportbq
	  PALVAROFFSET	{alvar}
	  db	{var}-path_zero_page
	ELSEIF
	  pathcode	exportb
	  PALVAROFFSET	{alvar}
	  dw	{var}&WM
	ENDC
	ELSEIF
	IFEQ	(({var}-path_zero_page)&255)-({var}-path_zero_page)
	  pathcode	exportwq
	  PALVAROFFSET	{alvar}
	  db	{var}-path_zero_page
	ELSEIF
	  pathcode	exportw
	  PALVAROFFSET	{alvar}
	  dw	{var}&WM
	ENDC
	ENDC
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

	PALVAROFFSET	{alvar}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_SHIFTR		MACRO	[alvar]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	shiftrb
	ELSEIF
	pathcode	shiftrw
	ENDC

	PALVAROFFSET	{alvar}

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
	IFEQ	size_al_{index}-1
	pathcode	indexb
	ELSEIF
	pathcode	indexbw
	ENDC
	ELSEIF
	IFEQ	size_al_{index}-1
	pathcode	indexw
	ELSEIF
	pathcode	indexww
	ENDC
	ENDC

	dw	({table})&WM
	db	({table})>>16
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

	dw	({table})&WM
	db	({table})>>16
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
P_BECOMESHAPE	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	0,1

	pathcode	becomeshape
	IFEQ	MYNARG
	defs	_p_bc,"_p_u",_p_uid
	run	" dw %$_p_bc"
	ELSEIF
	PADDR	{addr}
	ENDC

	
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
P_INPLAYERSCONE	MACRO	[range,range2,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	3

	pathcode	inplayerscone
	db	{range}
	db	{range2}
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
P_CIRCLESHAPE	MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	circleshapeB
	ELSEIF
	pathcode	circleshapeW
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	pathcode	circleshape
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
P_MOVEINSHAPE	MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	IFD	al_{num}
	IFEQ	size_al_{num}-1
	pathcode	moveinonshapeB
	ELSEIF
	pathcode	moveinonshapeW
	ENDC
	PALVAROFFSET	{num}
	ELSEIF

	pathcode	moveinonshape
	db	{num}

	ENDC

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_SETID	MACRO	[num]
	pathmac_start
	P_SET	sbyte1,{num}
	pathmac_end
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
	pathcode	radarobj
	db	{num}
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
	IFD	plane_{onoff}
	P_SET	clip,plane_{onoff}
	ELSEIF
	pathcode	clipping{onoff}
	ENDC
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
P_PLRFORCEWAY	MACRO	[roty,width,height,length]
	pathmac_start
MYNARG	=	NARG
	PNARG	4


	IFD	al_{roty}
	p_export	y3,{roty}
	ELSEIF
	p_setvar	b,y3,{roty}
	ENDC

	IFD	al_{width}
	p_export	x2,{width}
	ELSEIF
	p_setvar	w,x2,{width}
	ENDC

	IFD	al_{height}
	p_export	y2,{height}
	ELSEIF
	p_setvar	w,y2,{height}
	ENDC

	IFD	al_{length}
	p_export	z2,{length}
	ELSEIF
	p_setvar	w,z2,{length}
	ENDC

	pathcode	plrforceway

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

pbm_start	=	0

	pathcode	setbossmode
	db	pbm_{name}

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

	pathcode	settype
	db	colltype_{type}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_CLRTYPE		MACRO	[type]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	clrtype
	db	~(colltype_{type})

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

	pathcode	swapvar
	PALVAROFFSET	{var1}
	PALVAROFFSET	{var2}

;;	P_START65816
;;	a16
;;	lda	al_{var1},x
;;	pha
;;	lda	al_{var2},x
;;	sta	al_{var1},x
;;	pla
;;	sta	al_{var2},x
;;	a8
;;	P_END65816

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
P_SCENERY		MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	scenery

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETBOSSNAME	MACRO	[name]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	P_GSET	W,bossname,{name}&WM

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_IFCHILD		MACRO	[var,addr]
	pathmac_start

	P_IFSAME	sbyte1,{var},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_IFNOTCHILD		MACRO	[var,addr]
	pathmac_start

	P_IFNOTSAME	sbyte1,{var},{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PLRWEAPLEVELUP	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	plrweaplevelup
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CLEARSEQUENCE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	clearsequence
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_LINKTOBECOME	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	P_IMPORT	ptr,becomelastobj
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_GROUNDOBJ		MACRO	[onoff]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	groundobj{onoff}
	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PLAYERSHAPE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	playershape
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFPLRWEAPLEVEL	MACRO	[level,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	ifplrweaplevel
	db	{level}
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_ANDFRAMEGOTO	MACRO	[var,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	andframegoto
	db	{var}
	PADDR	{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CHAINPOS		MACRO	[var,loose]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2


	IFD	al_{var}
	pathcode	chainposalvar{loose}
	PALVAROFFSET	{var}
	ELSEIF
	pathcode	chainpos{loose}
	db	{var}
	ENDC
	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_PWEAPINCLMT	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	pweapinclmt
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PWEAPDECLMT	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	pweapdeclmt
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CLRDEMOSHAPE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	clrdemoshape
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_DEMOSHAPE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	demoshape
	pathmac_end
	ENDM
;--------------------------------------------------------------------
;--------------------------------------------------------------------
P_COPYPLAYERROTS	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	copyplayerrot
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETDEMO	MACRO	[num]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	setdemo
	db		{num}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_DEMOEND	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	demoend
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_DEMOSETMAP	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	demosetmap
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFDEMOEND	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	ifdemoend
	PADDR		{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFNOTDEMO	MACRO	[num,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	ifnotdemo
	db		{num}
	PADDR		{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFSAMEDEMO	MACRO	[num,addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	2
	pathcode	ifsamedemo
	db		{num}
	PADDR		{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SOUNDPLACE	MACRO	[place]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	setsndplace
	dw		sport3_place_{place}&WM
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PWEAPHIT		MACRO	[addr0,addr1,addr2]
	pathmac_start
MYNARG	=	NARG
	PNARG	3
	pathcode	pweaphit
	PADDR		{addr0}
	PADDR		{addr1}
	PADDR		{addr2}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
;--------------------------------------------------------------------
P_REBOUNDLASER	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	reboundlaser
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYROT2PLAYER	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	copyrot2player

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_COPYPOS2PLAYER	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	copypos2player

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_COPYPOS2VIEW	MACRO	[num,immediate]
;!
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2
	pathcode	copypos2view{immediate}
	dw		viewblk{num}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYROT2VIEW	MACRO	[num,immediate]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2
	pathcode	copyrot2view{immediate}
	dw		viewblk{num}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYVIEWPOS	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	copyviewpos
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYVIEWROTS	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	copyviewrots
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYVIEWPOS_demo	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	copyviewpos_demo
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_COPYVIEWROTS_demo	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	copyviewrots_demo
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CAMPANSHAPE	MACRO	[num,reduce,immediate]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2
	pathcode	campanshape{immediate}
	dw		viewblk{num}
	db		{reduce}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CAMPANDEMOSHAPE	MACRO	[num,reduce,immediate]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3
	pathcode	campandemoshape{immediate}
	dw		viewblk{num}
	db		{reduce}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CAMPANPLAYER	MACRO	[num,reduce,immediate]
	pathmac_start
MYNARG	=	NARG
	PNARG	2,3
	pathcode	campanplayer{immediate}
	dw		viewblk{num}
	db		{reduce}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SETBG	MACRO	[name]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	setbg
	dw	bg_{name}-bglists
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_HITSLOPE	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1
	pathcode	hitslope
	PADDR		{addr}
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CIRCLEWINDOW	MACRO	[step,big]
	pathmac_start
MYNARG	=	NARG
	PNARG	1,2

	pathcode	{big}circlewindow
	dw		{step}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_CIRCLEWINDOWPOS	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0
	pathcode	circlewindowpos
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_SCREENFLASH	MACRO
	pathmac_start
MYNARG	=	NARG
	pathcode	scrflash
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_FADEIN	MACRO
	pathmac_start
MYNARG	=	NARG
	pathcode	fadein
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_FADEOUT	MACRO
	pathmac_start
MYNARG	=	NARG
	pathcode	fadeout
	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_NEXTMAP	MACRO
	pathmac_start
MYNARG	=	NARG
	pathcode	nextmap
	pathmac_end
	ENDM


;--------------------------------------------------------------------
P_FACEPLAYEROFS		MACRO	[xofs,yofs,zofs]
	pathmac_start
MYNARG	=	NARG
	PNARG	3

	IFD	al_{xofs}
	p_export	pathx1,{xofs}
	ELSEIF
	p_setvar	b,pathx1,{xofs}
	ENDC

	IFD	al_{yofs}
	p_export	pathy1,{yofs}
	ELSEIF
	p_setvar	b,pathy1,{yofs}
	ENDC

	IFD	al_{zofs}
	p_export	pathz1,{zofs}
	ELSEIF
	p_setvar	b,pathz1,{zofs}
	ENDC

	pathcode	faceplayerofs

	pathmac_end

	ENDM

;--------------------------------------------------------------------
P_SETVAR	MACRO	[size,var,value]
	P_GSET	{size},{var},{value}
	ENDM
;--------------------------------------------------------------------
P_WOBBLE	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	wobble

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFAREAOUT	MACRO	[addr]

	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	ifareaout
	PADDR	{addr}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_IFPLRTURN	MACRO	[switch,addr]

	pathmac_start
MYNARG	=	NARG
	PNARG	2

	pathcode	ifplrturn{switch}
	PADDR	{addr}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_PLRCONTROL	MACRO	[switch]

	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	plrcontrol{switch}

	pathmac_end
	ENDM
;--------------------------------------------------------------------
P_GSET	MACRO	[size,var,val]
	pathmac_start
MYNARG	=	NARG
	PNARG	3

_pg_b	=	1
_pg_w	=	2

	IFEQ	_pg_{size}-1
	pathcode	gsetb
	dw	({var})&WM
	db	{val}
	ELSEIF
	pathcode	gsetw
	dw	({var})&WM
	dw	{val}
	ENDC


	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_IFLASTTRIG		MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	iflasttrig
	PADDR	{addr}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_PASSSOUND		MACRO	[switch]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	passsound{switch}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ENEMYDMGSE		MACRO	[name]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	enemydmgSE

	db	ese_{name}

	pathmac_end
		ENDM
;--------------------------------------------------------------------
P_ENEMYRBDSE		MACRO	[name]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	enemyrbdSE

	db	rse_{name}

	pathmac_end
		ENDM

;--------------------------------------------------------------------
P_FIREOBJ	MACRO	[switch]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	fireobj{switch}

	pathmac_end

	ENDM

;--------------------------------------------------------------------
P_ADDRANDOM	MACRO	[alvar,rndmask]

	pathmac_start
MYNARG	=	NARG
	PNARG	2
	PALVAR	{alvar}

	IFEQ	size_al_{alvar}-1
	pathcode	addrandomB
	PALVAROFFSET	{alvar}
	db	{rndmask}
	ELSEIF
	pathcode	addrandomW
	PALVAROFFSET	{alvar}
	dw	{rndmask}
	ENDC

	pathmac_end
	ENDM

;--------------------------------------------------------------------
P_TAMEHOMON	MACRO
	pathmac_start
MYNARG	=	NARG
	PNARG	0

	pathcode	tamehomon

	pathmac_end

	ENDM
;--------------------------------------------------------------------
P_IFTAMEHOMON	MACRO	[addr]
	pathmac_start
MYNARG	=	NARG
	PNARG	1

	pathcode	iftamehomon

	PADDR	{addr}

	pathmac_end

	ENDM
;--------------------------------------------------------------------


