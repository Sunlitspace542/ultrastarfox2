``Note: since the PATH language was expanded so much from Star Fox 1's, any documentation for UltraStarFox2 will refer to the version of PATH SF2 uses as PATH2.``  
# PATH2 Language Documentation (modified from PATHMACS.INC) (some descriptions need translation)

```
                            #################
             #################              ################
             #               # PATH2 MACROS #              #
             #################              ################
                            #################

     ########################
###### MISCELLANEOUS MACROS ################################################
#    ########################                                              #
#                                                                          #
# START_PATH      name                define the beginning of a path       #
# P_END                               end of path                          #
# P_DEBRIS        shape               debris explosions to use <shape>     #
# P_EXPLODE                           explodes the object                  #
# P_REMOVE                            remove object                        #
# P_DEBUG                             causes a 'blink'                     #
# P_PRINT         alvar,mode,user     displays the value in alvar          #
#                                     mode = d,b, or h (bin, dec, hex)     #
# P_SETANIM       value               initialise animation to value        #
# P_ADDANIM       rate,max            adds [rate] to anim, max=last frame  #
# P_SETCOLANIM    value               initialise colouranimation to value  #
# P_ADDCOLANIM    rate,max            adds [rate] to colour anim           #
# P_SPRITE        colour[,size]       makes shape a software sprite        #
# P_TEXT          addr,color[,size]   change path type to message          #
# P_TRAIL         OFF|num             (use with P_TEXT) num = trail col    #
# P_TRIGGER       (ALL)addr,type|OFF[,cnt]                                 # 
#                 trigger routine if (see 'TRIGGERS')                      #
#                                     Optionally the trigger can be        #
#                                     automatically removed after 'cnt'    #
#                                     game frames                          #
# P_RTRIGGER                          same as trigger but address must     #
#                                     be within +256 bytes                 #
# P_IFLASTTRIG    addr                if this is last trigger to occur     #
#                                     before being removed goto 'addr'     #
#                                     (this will only work for ALWAYS)     #
#                                     check the 'TIMER' trigger type       #
# P_FORCE         addr                sets address to begin execution      #
#                                     AFTER current trigger routine has    #
#                                     finished (all DO-NEXT and GOSUB-     #
#                                     RETURN loops are cleared             #
#                                     (must only use from triggered code)  #
# P_FORCEGOSUB    addr                Same as FORCE however, P_RETURN will #
#                                     return to the point it was FORCE'd   #
#                                     (must only use from triggered code)  #
# P_START65816                        begin 65816 code                     #
# P_END65816                          end 65816 code                       #
# P_JSL65816      routine             call 65816 code                      #
# P_SWITCHOUT     addr|A              switch out of 65816 to <routine>     #
# P_PARTICLES     type,amount,life    create particles shower              #
#                                     type can be gravity or normal        #
#                                     amount is amount added every frame   #
#                                     life is how long you want to last    #
# P_SOUND               num           trigger continuous sound effect      #
# P_SOUNDEFFECT         num           trigger one-shot sound effect        #
# P_SOUNDEFTDIST        num           trigger sound effect from dist(n,m,l)#
# P_SOUNDEFTPOS         num           trigger sound effect from L/C/R      #
# P_SOUNDEFTDISTPOS     num           trigger sound effect from dist(n,m,l)#
#                                                    & left/center/right   #
# P_SOUNDEFTNEAR        num           trigger sound effect from near dist  #
# P_SOUNDEFTNEARPOS     num           trigger sound effect from L/C/R(near)#
# P_SOUNDEFTVIS         num           trigger sound effect visible         #
# P_SOUNDEFTDIRECT      num,flag      trigger sound effect direct          #
#              flag = (nearL,nearC,nearR,midL,midC,midR,far)               #
# P_SOUNDPLACE     place              set sound place                      #
# P_BECOME                            becomes the last shape created       #
# P_BECOMESHAPE                       become shape                         #
# P_BECOMEMOTHER                      become mother                        #
# P_BECOMECHILD   num|[alvar,addr]    become the child specified           #
#                                     this allows access to a child's      #
#                                     variables                            #
#                                     If an alvar is specified it will     #
#                                     jump to addr if the child isn't      #
#                                     found                                #
# P_UNBECOME                          back to normal                       #
# P_RADAROBJ      num                 set the object for the radar display #
# P_CLEARSTACK                        clears the stack (housekeeping)      #
# P_BEGINDEMO                         begin path controlled demo sequence  #
# P_ENDDEMO                           end path controlled demo sequence    #
# P_ACTIVE        ON|OFF              active during demo sequence?         #
# P_SETCAMERA     [IMMEDIATE]         set camera to current position       #
# P_RANGECHECK    ON|OFF[,MAP]        turns off view range checking        #
# P_SETSWITCH     alvar,[alvar]       sets switch to alvar (must be 1-16)  #
#                                     If the second alvar is specified     #
# P_COPYVIEWPOS   view's worldx,y,z --> current obj's worldx,y,z           #
# P_COPYVIEWROTS  view's rotx,y,z   --> current obj's rotx,y,z             #
# P_COPYVIEWPOS_demo (demo) view's worldx,y,z --> current obj's worldx,y,z #
# P_COPYVIEWROTS_demo(demo) view's rotx,y,z   --> current obj's rotx,y,z   #
#                                     the flags will be set in that and    #
#                                     not the global map switch            #
# P_CLRSWITCH     alvar,[alvar]       clears switch                        #
# P_IFSWITCH      alvar[,alvar],addr  if switch number 'alvar' is set then #
#                                     jump to addr                         #
# P_SETTYPE       colltype            set collision type:                  #
# P_CLRTYPE       colltype            clr collision type:                  #
#                                     enemy1 or enemy2                     #
# P_AREA          alvar|val,ON|OFF    turn an area on or off (blockmap)    #
# P_SETCLIP       <y>                 y position to y-clip at              #
# P_SCENERY                           turns into scenery.. no strategy!    #
# P_WOBBLE                            wobble the alien from side to side   #
#                                     should be used once per frame        #
#                                                                          #
############################################################################
     ###############
###### MODE MACROS #########################################################
#    ###############                                                       #
#                                                                          #
# P_RELTOPLAYER   ON|OFF              make z relative to player            #
# P_ALWAYSGENVECS ON|OFF              always generate vectors              #
# P_SPACESHIP     ON|OFF              y rotation is relative to z rotation #
# P_INVINCIBLE    ON|OFF              turn invincibility off or on         #
# P_ZREMOVE       ON|OFF              automatic removal of shape when z<0  #
# P_INVISIBLE     ON|OFF              shape invisible and no collisions    #
# P_HITFLASH      ON|OFF              hit flash on or off (on is default)  #
# P_COLLISIONS    ON|OFF               collision detection on or off       #
# P_SHADOW        ON|OFF              shadow on or off (default=on)        #
# P_BOOST         ON|OFF              software sprite boost on/off         #
# P_POLLEN        ON|OFF              pollen on or off                     #
# P_LOCKPLAYER    ON|OFF              lock the position relative to player #
# P_SLOPE         ON|OFF              Switch slope object on or off        #
# P_CLIPPING      ON|OFF|plane        Switch on plane clipping             #
# P_MOVEPLAYER    ON|OFF              move the player with the current obj #
# P_GROUNDOBJ     ON|OFF              force Z sort for ground object       #
# P_FIREOBJ       ON|OFF              player ni hi wo tsukeru object       #
# P_QUADVECS      ON|OFF              multiply vectors by 4?               #
# P_PASSSOUND     ON|OFF    player to surechigatta toki no SOUND no ON|OFF #
# P_ENEMYDMGSE    name      hit sitatokino damage sound                    #
#                            bs_cry_1(dragon)                              #
#                            en_cry_2(seibutsu small)                      #
#                            en_cry_3(seibutsu large)                      #
# P_ENEMYRBDSE    name      hit sitatokino damage sound                    #
#                            reboundlaser2(STARWOLF)                       #
#                                                                          #
############################################################################

     #################
###### FRIEND MACROS ########################################################
#    #################                                                      #
#                                                                           #
# P_FRIEND                            define path as a friend's path        #
# P_IFFRIEND      friend,address      if friend then goes to address        #
# P_NOTFRIEND     friend,address      if not friend then goes to address    #
# P_MSG           num|alvar[,METER]   Displays msg <num> (METER shows hp)   #
# P_DAMAGE                            takes one unit of damage from friend  #
# P_ALMOSTDEAD    address             if friend almost dead then goto addr  #
#                                                                           #
#############################################################################

     ###################
###### CREATION MACROS ######################################################
#    ###################                                                    #
#                                                                           #
# P_SPAWN         x,y,z,              creates a new path object             #
#                 xrot,yrot,zrot,     xyz rotation (relative to original)   #
#                 shape,path,         shape and path name                   #
#                 hp,ap               hit points and attack points          #
#                 [,LINK]             links newly created shape             #
#                 [,n]                n = child number (use child macros)   #
# P_QSPAWN        shape,path,hp,ap    short version of above (x,y,etc = 0)  #
#                                                                           #
#############################################################################

     ###############################
###### GENERAL PROGRAM FLOW MACROS ##########################################
#    ###############################                                        #
#                                                                           #
# P_WAIT          frames|alvar        wait for some time                    #
# P_GOTO          addr                goto specified addr (waits 1 frame)   #
# P_IGOTO         addr                immediately goto specified address    #
# P_GOSUB         addr|alvar          nested gosub (alvar must be word)     #
# P_RETURN                            return to gosub call                  #
# P_RANDOMGOTO    addr                will go to address (50% of the time)  #
# P_LOOP          num,address         loop to addr <num>+1 times, (0-255)   #
# P_DO            num|alvar           do until NEXT <num> times, (0-65535)  #
# P_NEXT                              repeat DO loop (nested) (1 frame)     #
# P_INEXT                             repeat DO loop (0 frame)              #
# P_BREAK         [addr]              break DO-NEXT loop, goto addr         #
# P_IFLEVEL       number,addr         if level=number then go to addr       #
# P_IFNOTLEVEL    number,addr         if level!=number then go to addr      #
# P_HITGROUND     ground,addr         when hits [ground] goes to addr       #
# P_NOTHITGROUND  ground,addr         if not hitting [ground] goes to addr  #
# P_HITWALL       address             goes to addr when hits tunnel walls   #
# P_SETSTRAT      address             sets strategy (active immediately)    #
# P_IFHITFLAG     addr[,1[,2]]...     check for hitflags (and clear them)   #
#                                     if none specified, checks for any     #
# P_ANDFRAMEGOTO     and,addr           gameframe&and=0 then goto addr      #
# P_CHAINPOS         zofs                                                   #
# P_HITSLOPE      addr   if hit slope then goto addr(osoi kamo)             #
# P_IFAREAOUT     addr   AREA out sitara ADDR ni jump.                      #
#                                                                           #
#############################################################################

     #################
###### PLAYER MACROS #######################################################
#    #################                                                     #
#                                                                          #
# P_PLAYER        <number>            set which player to check            #
# P_PLAYERDEAD    addr                if player is dead then go to addr    #
# P_LEFTOFPLAYER  addr                if left of player go to addr         #
# P_RIGHTOFPLAYER addr                if right of player go to addr        #
# P_ABOVEPLAYER   addr                if above player go to addr           #
# P_BELOWPLAYER   addr                if below player go to addr           #
# P_BEHINDPLAYER  addr                if behind player go to addr          #
# P_BEHINDKPLAYER  addr               if behind player go to addr (kawa)   #
# P_WAITFACEPLAYER                    turns to the player (until finished) #
# P_FACEPLAYER    [IMMEDIATE]         face player (1 iteration)            #
# P_FACEPLAYER    Y                   face player (only Y rotation)        #
# P_FACEVIEW      [IMMEDIATE]         face view (only Y rotation)          #
# P_GOTOPOS       x,y,z,maxspeed      goes to position relative to player  #
# P_DISTLESS      value,addr          if distance from player < value      #
# P_DISTMORE      value,addr          if distance from player > value      #
# P_ZDISTLESS     value,addr          if distance from player < value      #
# P_ZDISTMORE     value,addr          if distance from player > value      #
# P_WITHINRADIUS  radius,addr         if player is within <radius>         #
# P_IFPLAYER      n,addr              if player n then goto (see P_PLAYER) #
# P_SWAPPLAYER                        swaps the player      (see P_PLAYER) #
# P_PLAYERINCONE  range,addr          is player within -range・->range・     #
# P_INPLAYERSCONE -range,+range,addr  is object in player's view cone?     #
# P_SCORE         num                 add to player's score                #
# P_MOVEINPLAYER  num|alvar           move towards or away from the player #
# P_CIRCLEPLAYER  angle|alvar         rotates object around player (y-rot) #
# P_COPYPLAYERPOS                     copy the player's position           #
# P_REBOUNDLASER           player no laser wo hanekaesu.                   #
# P_FACEPLAYEROFS xofs,yofs,zofs   face playerpos+xofs<<4+yofs<<4+zofs<<4  #
#                                                                          #
#                                                                          #
#                                                                          #
############################################################################
     #########################
###### PLAYER'S WEPON MACROS ###############################################
#    #########################                                             #
# *al_ptr = player's pointer                                               #
#                                                                          #
# P_PWEAPINCLMT      player no weapon no limitter(sonzai dekiru kazu)      #
#                    wo INCRIMENT suru.                                    #
# P_PWEAPDECLMT      player no weapon no limitter(sonzai dekiru kazu)      #
#                    wo DECRIMENT suru.                                    #
# P_PWEAPHIT   addr0,addr1,addr2  If hit slope or obj                      #
#                     gimen ni atatta toki addr0                           #
#                     damage wo ataetara   addr1                           #
#                     rebound saretara     addr2                           #
#                                                                          #
############################################################################
     #####################
###### DEMO CAMERA MACRO ####################################################
#    #####################                                                  #
#                                                                           #
# P_CAMPANSHAPE     num,reduce,[immediate] pan with shape                   #
# P_CAMPANPLAYER    num,reduce,[immediate] pan with player                  #
# P_CAMPANDEMOSHAPE num,reduce,[immediate] pan with "demoobjptr"            #
# P_COPYPOS2VIEW    num,[immediate]   copy pos to view (1 or 2)             #
# P_COPYROT2VIEW    num,[immediate]   copy rot to view (1 or 2)             #
# P_SETBG          name      change bg                                      #
#                                                                           #
# P_NEXTMAP          set mapptr & mapbank 2 next map                        #
#                                                                           #
#                                                                           #
#    #####################                                                  #
###### DEMO PLAYER MACRO ####################################################
#    #####################                                                  #
# P_COPYPOS2PLAYER   copy worldx,y,z  to player                             #
# P_COPYROT2PLAYER   copy rot  x,y,z  to player                             #
#    ####################                                                   #
###### DEMO SHAPE MACRO #####################################################
#    ####################                                                   #
#                                                                           #
# P_SETDEMO    num            set demo mode number                          #
# P_DEMOSETMAP                map no objct wo set suru.                     #
# P_DEMOEND                   end demo & set map                            #
# P_IFDEMOEND     addr           demo ga owattara REMOVE suru...            #
# P_IFNOTDEMO  num,addr       if demomode != num then goto addr             #
# P_IFSAMEDEMO num,addr       if demomode  = num then goto addr             #
# P_DEMOSHAPE            current obj pointer wo demoobjptr ni set           #
# P_CLRDEMOSHAPE      Clear demo no toki ni camara ga miru you ni naru.     #
# P_PLAYERSHAPE      player no shape(only arwing) wo copy suru.             #
#                                                                           #
#                                                                           #
#############################################################################
     #################
######  BOSS MACROS  ########################################################
#    #################                                                      #
#                                                                           #
# P_BOSSMODELIST  bossname            Initialises the boss mode definitions #
#                                     You must follow this with a list of   #
#                                     P_BOSSMODE's                          #
# P_BOSSMODE      addr[,name]         Define a boss mode                    #
# P_JUMPBOSSMODE                      Jump to the current boss mode         #
# P_SETBOSSMODE   name                Set boss into a particular mode       #
# P_NEXTBOSSMODE                      Set the next boss mode                #
# P_BOSSFLAGLIST                      Initialise flag list for this boss    #
#                                     This must be specified somewhere      #
#                                     AFTER the P_BOSSMODELIST definition   #
# P_BOSSFLAG      name                define a boss flag                    #
# P_IFBOSSFLAG    name,ON|OFF,addr    if boss flag on or off then jump      #
# P_SETBOSSFLAG   name,ON|OFF         set a boss flag                       #
# P_CLRBOSSFLAGS                      clear all boss flags                  #
# P_STOREBOSSMODE                     store current boss mode (one level)   #
# P_RESTOREBOSSMODE                   restore previously stored mode        #
# P_SETBOSSNAME   <name>              set the boss's name for the hp meter  #
#                                                                           #
#############################################################################

     #################
###### WEAPON MACROS ########################################################
#    #################                                                      #
#                                                                           #
# P_WEAPON        weaponname          sets default weapon for path object   #
# P_FIRE          [CANHIT]            fires default weapon                  #
# P_FIRE          ATPLAYER,[CANHIT]   fires default weapon at player        #
# P_FIRE          ATSHAPE,[CANHIT]    fires default weapon at found shape   #
#                                                                           #
#############################################################################

     ###################
###### VARIABLE MACROS ######################################################
#    ###################                                                    #
#                                                                           #
# P_CHASE         var,value           smoothly set var to value             #
# P_CHASE         var1,var2           smoothly set var to another var       #
# P_WAITCHASE     var,value           smoothly set var (until finished)     #
# P_SET           var,value           immediately set var                   #
# P_SET           var1,var2           set var1 = var2                       #
# P_ZERO          var                 zero var                              #
# P_SETRANDOM     var[,rndmask]       set var to random value               #
#                                     (rndmask = 1,3,7,15,31...65535)       #
# P_ADDRANDOM     var,rndmask         add var to random value               #
#                                     (rndmask = 1,3,7,15,31...32767)       #
# P_ADD           var,value           add value to var (sign extended)      #
# P_ADD           var,var             add var to var (sign extended)        #
# P_GADD          dest,source         add global to alvar storing result    #
#                                     in dest                               #
# P_GSET          B|W,global var,#    set global to immediate value         #
# P_GINC          B|W,global var      increment global by 1                 #
# P_GDEC          B|W,global var      decrement global by 1                 #
# P_INC           var                 increment var by 1                    #
# P_DEC           var                 decrement var by 1                    #
# P_NEG           var                 negate var                            #
# P_DIV2          var                 signed divide by 2                    #
# P_SHIFTR        var                 unsigned divide by 2                  #
# P_SETVEL        velocity            change speed (will remake vectors)    #
# P_ACCEL         velocity,rate       change speed by rate (smooth setvel)  #
# P_IFSAME        var,value,addr      if var=value then go to addr          #
# P_IFSAME        var,var,addr        if var=var then go to addr            #
# P_IFNOTSAME     var,value,addr      if var!=value then go to addr         #
# P_IFNOTSAME     var,var,addr        if var!=var then go to addr           #
# P_IFZERO        var,addr            if var=0 then go to addr              #
# P_IFNOTZERO     var,addr            if var!=0 then go to addr             #
# P_IFBETWEEN     min,var,max,addr    if min>var>max then go to addr        #
# P_IFNOTBETWEEN  min,var,max,addr    if min<var | var>max then go to addr  #
# P_IFLARGER      var1,var2,addr      if var1>var2 goto <addr> (signed)     #
# P_IFSMALLER     var1,var2,addr      if var1<var2 goto <addr> (signed)     #
# P_IMPORT        var,global var      var = global var                      #
# P_EXPORT        global var,var      global var = var                      #
#                                     global var must be same size as var   #
#                                     ie. a byte=byte or word=word          #
#                                     see 'GLOBAL VARIABLES'                #
# P_INDEX         dest,table,index    indexes into a table (see 'TABLES')   #
# P_AUTOINDEX     B|W,d,t,i,max       same as P_INDEX but increments 'i'    #
#                                     up until 'max'-1 then loops back to 0 #
#                                     also value is ADDED to 'd'            #
#                                     Table size is specified with B or W   #
# P_PUSH          var                 pushes var onto the stack             #
# P_PULL          var                 pulls var from the stack (see stack)  #
#                                                                           #
#                                                                           #
#############################################################################

     ##################
###### LINKING MACROS #######################################################
#    ##################                                                     #
#                                                                           #
# P_LINK          shape               link path to next path created        #
# P_FINDSHAPE     shape               finds the shape specified             #
# P_FINDNEXTSHAPE shape               finds the next closest shape          #
# P_FACESHAPE     [IMMEDIATE]         faces the found or linked shape       #
# P_GOTOSHAPEPOS  x,y,z,maxspeed      goes to a relative position           #
# P_IMMUNE                            immune to collisions                  #
# P_SHAPEDISTLESS value,address       if distance from shape < value        #
# P_SHAPEDEAD     address             if shape is dead, goes to address     #
# P_SPAWN         ...,LINK            see <CREATION MACROS>                 #
# P_FLAGSHAPE                         set flag for linked shape             #
#                                     (only if linked shape is path obj)    #
# P_IFFLAG        addr                if flag set goto addr (clears flag)   #
# P_SHAPEINRADIUS radius,address      if linked shape is within radius      #
# P_MOVEINSHAPE   val|var             move closer to found shape            #
# P_CIRCLESHAPE   val|var             move around found shape               #
# P_LINKTOBECOME                      sets shape obj to last created obj    #
#                                                                           #
#############################################################################

     ################
###### CHILD MACROS #########################################################
#    ################                                                       #
#                                                                           #
# P_SPAWN         ...,n               see spawn command above               #
# P_CHILDDEAD     n,address           if CHILD n is dead, goto address      #
# P_FLAGCHILD     n                   flag child (from child or mother)     #
# P_FLAGMOTHER                        flag mother (from child)              #
# P_IFFLAG        addr                if flag set goto addr (clears flag)   #
# P_UNLINKCHILD   n                   make child into normal object         #
# P_REMOVE        n                   remove child n                        #
# P_CIRCLE        angle|alvar         rotates child around mother (y-rot)   #
# P_MOVEIN        n|alvar             move closer to mother by val|alvar    #
# P_SETID         n|alvar             set child id number                   #
# P_BECOMEINERT                       changes into an inert object          #
# P_STAMPSTART                        set the restart routine for inerts    #
# P_ADJUSTROT                         adjusts world rotation to child rot   #
#                                     eg. P_FACEPLAYER would normally       #
#                                     not work, however if followed by      #
#                                     P_ADJUSTROT it will                   #
# P_POSCHILDREN   ON|OFF              turn automatic positioning of childs  #
# P_IFCHILD       n|alvar,addr        if current object is child 'n'        #
# P_IFNOTCHILD    n|alvar,addr        if current object is NOT child 'n'    #
# P_RELATIVE      ON|OFF              relative to mother object?            #
#                                                                           #
#############################################################################

#############################################################################  
#                                                                           #
# Note #1: NEVER use FINDSHAPE, LINK, or FINDNEXTSHAPE with CHILD macros    #
# Note #2: P_GOTO P_NEXT, and P_LOOP AUTOMATICALLY do a P_WAIT 1            #
# Note #3**P_TRIGGER should NOT be used from within a trigger subroutine    #
# Note #4: Note #3 is now OBSOLETE                                          #
#                                                                           #
#############################################################################

     ################
###### VALID 'VAR's #########################################################
#    ################                                                       #
#                                                                           #
#                worldx               object's x                            #
#                worldy               object's y                            #
#                rotx                 object's x rotation                   #
#                roty                 object's y rotation                   #
#                rotz                 object's z rotation                   #
#                hp                   object's hp                           #
#                ap                   object's ap                           #
#                shape                object's shape                        #
#                coltab               object's colour table                 #
#                tx                   tx map x coordinate (or sprite size)  #
#                ty                   tx map y coordinate                   #
#                area                 set to -1 for permanent existance     #
#                                                                           #
#############################################################################

     ###################################                                     
###### VARS AVAILABLE FOR CHILD MACROS ######################################
#    ###################################                                    #
#                                                                           #
#                childx               relative x                            #
#                childy               relative y                            #
#                childz               relative z (relative to mother)       #
#                childrotx            x rotation                            #
#                childroty            y rotation                            #
#                childrotz            z rotation                            #
#                                                                           #
#############################################################################

     #################################################                       
###### TEMPORARY VARIABLES AVAILABLE FOR GENERAL USE ########################
#    #################################################                      #
#                                                                           #
#                pbyte1               temporary byte #1                     #
#                pbyte2               temporary byte #2                     #
#                pword1               temporary word #1                     #
#                                                                           #
#############################################################################

     ###################################################
###### CURRENT VALID WEAPONS ARE (USE WITH 'P_WEAPON') ######################
#    ###################################################                    #
#                                                                           #
#  SlowElaser          Elaser (use for ground based objects)                #
#  RelSlowElaserHome   Relative slow laser (homes towards player)           #
#  RelSlowElaser       Relative slow laser                                  #
#  hmissile1           Normal homing missile                                #
#  chickhmissile1      Chicken missile                                      #
#  missile1            Straight firing missile                              #
#  plasma              Plasma ball                                          #
#  shortplasma         Plasma ball (disappears quicker)                     #
#  Hplasma             Homing plasma ball                                   #
#  ovalbeam            Oval (ellipse) beam                                  #
#  ringlaser           Ring laser                                           #
#                                                                           #
#############################################################################

     ############
###### TRIGGERS #############################################################
#    ############                                                           #
#                                                                           #
#  Always             - calls the routine on every game frame               #
#  2,4,8,...,128      - ... once every n frames                             #
#  WhenHit            - ... if hit                                          #
#  WhenHitByPlayer    - ... if shot by player                               #
#  WhenFlagged        - ... if flag is set (clears the flag automatically)  #
#  WhenDead           - ... if hp=0 (explodes anyway, but you can spawn)    #
#  WhenShapeDead      - ... if the LINK'd or FOUND shape dies               #
#  WhenThrough        - ... if a player goes through the object             #
#                       (sets P_PLAYER n automatically)                     #
#  WhenSteppedOn      - ... if stepped on by the player (must be a slope)   #
#                       (AL_SLOPENUM specifies which polygon)               #
#                       (automatically does P_PLAYER to set which player)   #
#  AboveSea           - player has burst through from under                 #
#  BelowSea           - player has dived down under                         #
#  Timer              - the trigger routine is called after 'cnt' frames    #
#                                                                           #
#############################################################################
#                                                                           #
#  Note: TRIGGER should not use P_WAIT, P_GOTO, P_LOOP, P_WAITxxxx          #
#  (anything which causes the next game frame to be displayed -             #
#  doing so will cause a blue BLINK |^) )                                   #
#                                                                           #
#  Extra: TRIGGER can now be used from within a TRIGGER subroutine          #
#  Also, the new extra parameter is a 'life' count, after n frames the      #
#  trigger will be removed (0-255)                                          #
#                                                                           #
#############################################################################

     ####################
###### GLOBAL VARIABLES #####################################################
#    ####################                                                   #
#                                                                           #
# Global variables are available for use by all strategies they are         #
# completely independent of the strategy that uses them.. ie. if one        #
# strategy changes a global variable, another strategy can read or change   #
# it.  Use IMPORT to copy a global variable into an alien variable.         #
# Use EXPORT to copy an alien variable into a global variable.              #
#                                                                           #
#############################################################################
#                                                                           #
#  gbyte1        = global byte 1                                            #
#  gbyte2        = global byte 2                                            #
#  gbyte3        = global byte 3                                            #
#  gword1        = global word 1                                            #
#  gword2        = global word 2                                            #
#  gword3        = global word 3                                            #
#                                                                           #
#############################################################################
#                                                                           #
# Note: you can ONLY copy a byte into a byte or a word into a word,         #
# ie.  you cannot copy a byte into a word or vice versa.                    #
#                                                                           #
#############################################################################

     ##########
###### TABLES ###############################################################
#    ##########                                                             #
#                                                                           #
# The INDEX feature allows you to retrieve data from tables.  The index     #
# should be a byte alien variable, if it is a word then only the bottom     #
# 8 bits are utilised.                                                      #
# If the destination is a word then the index is automatically multiplied   #
# by 2 thus assuming you are indexing into a table of words.                #
#                                                                           #
#############################################################################
#                                                                           #
# There are some default tables you can use:                                #
#                                                                           #
#   sintab - sin table (index should be 0-255, destination must be a byte)  #
#   costab - cos table (index should be 0-255, destination must be a byte)  #
#                                                                           #
#############################################################################
#                                                                           #
# Example:                                                                  #
#                                                                           #
#   P_SET   pbyte1,5                                                        #
#   P_INDEX pword1,mytab,pbyte1                                             #
#   ...                                                                     #
#                                                                           #
# mytab                                                                     #
#   dw      0,500,400,300,200,400,500                                       #
#                                                                           #
# This will set pword1 = mytab+5*2 (400)                                    #
#                                                                           #
#############################################################################

     #############
###### THE STACK ############################################################
#    #############                                                          #
#                                                                           #
# The stack is used for DO-NEXT loops and GOSUB-RETURN subroutines.         #
# It is also used for the PUSH/PULL commands therefore there is of          #
# course some possibility of a clash.  You cannot PULL a variable           #
# from a level different to that from which it was PUSHed.                  #
#                                                                           #
# ie.  P_DO    5                                                            #
#      P_PUSH  pbyte1                                                       #
#      ...                                                                  #
#      P_PULL  pbyte1                                                       #
#      P_NEXT                                                               #
#                                                                           #
# is valid, but:                                                            #
#                                                                           #
#      P_DO    5                                                            #
#      P_PUSH  pbyte1                                                       #
#      ...                                                                  #
#      P_NEXT                                                               #
#      P_PULL  pbyte1                                                       #
#                                                                           #
# is invalid and will probably crash                                        #
#                                                                           #
#############################################################################
     #################################
######  MACROS TO CONTROL THE PLAYER ###########################################
#    #################################                                         #
#                                                                              #
# P_FORCEJUMP          value      player(ROBOT) wo jump saseru. (normal 5)     #
# P_FORCETRANSFORM     type      player wo transform saseru.(ARWING,ROBOT,UFO) #
# P_PLRTRANSLOCK     P_FORCETRANSFORM no ato ni tsukau.                        #
# P_PLRTRANSLOCKOFF                                                            #
# P_INCSPWEAP     num      special weapon no kazu wo huyasu.(max15)            #
# P_SETSPWEAP     type      special weapon no type wo set suru.                #
#               (pbyte2 wo tsukau!)                                            #
#                            missile1                                          #
#                            dummy                                             #
#                            flamethrower                                      #
#                            smartplasma                                       #
# P_INCSPWEAP     num,addr special weapon no kazu wo huyasu.(max15)            #
#                (P_SETSPWEAP 1 kai set sitaato ni tsukau!                     #
#                           kazu ga sudeni max ni natte itara,addr ni jump.    #
#                                                                              #
# P_PLRSHIELD     frame(max255)    player no shield wo set suru.               #
# P_PLRTURN          on/off      starfox1 mode on/off. on:turn dekinai         #
# P_PLRFORCETURN     roty,width                                                #
#                                                                              #
#     roty      : 1 houkou mode no muki                                        #
#     width     : idou no haba(hankei)                                         #
#                                                                              #
# P_PLRFORCEWAY     roty,width,length                                          #
#                                                                              #
#     roty      : 1 houkou mode no muki                                        #
#     width     : idou no haba(hankei)                                         #
#     length     : check suru nagasa                                           #
# P_PLRBURN pos     pos = L(wing),C(body),R(wing),ALL                          #
#                    player ga moeru.                                          #
# P_IFPLRTURN     on/off,addr  player ga turn dekiruka check                   #
# P_PLRCONTROL     on/off          player no control wo on/off suru.           #
# P_TAMEHOMON      player no tamedama no HOMING wo ON ni suru.                 #
# P_IFTAMEHOMON     addr  player no homing ga ON nara addr ni JUMP suru.       #
#                                                                              #
#                                                                              #
################################################################################

     ##############################
######    PLAYER WEAPON MACROS    #########################################################
#    ##############################                                                       #
# P_FINDENEMYSHAPE    maxradius,range,addr find enemy shape                               #
# P_OBJINCONE          range,addr          is "objct(al_ptr)" within -range->range        #
# P_PLRWEAPLEVELUP     player no laser no levelup(normal -> twin -> twinbeam)             #
# P_IFPLRWEAPLEVEL     level,addr if player's laser level = "level(0,1,2)" then goto addr #
#                                                                                         #
###########################################################################################
     ##########################
######  GAME SEQUENCE MACROS  ################################################
#    ##########################                                              #
# P_CLEARSEQUENCE      set clear sequence.                                   #
#                                                                            #
##############################################################################
     ################
###### EFFECT MACRO #########################################################
#    ################                                                       #
#                                                                           #
# P_HITFLASHTRIG           set hitflash flag                                #
# P_CIRCLEWINDOW     stepoffset[,mode]      circle window on                #
#                   mode=big(big window),warp(blue window)                  #
# P_CIRCLEWINDOWPOS      circle window no position wo kaerutoki tsukau..    #
# P_SCREENFLASH      screen wo flash suru.(Don't use with P_CIRCLEWINDOW)   #
#                                                                           #
#############################################################################
     #################
###### CAMERA MACROS ##########################################################
#    #################                                                        #
#                                                                             #
# P_SHOCKCAM     1or2,value      camera wo sindou saseru.value=128 kurai.     #
# P_SHOCKCAM     1or2,value      camera wo sindou saseru.value=128 kurai.     #
#                                                                             #
###############################################################################
     ######################
###### ENEMY MARKER MACRO #########################################################################
#    ######################                                                                       #
#                                                                                                 #
#  P_SETMARKER     1or2,offdist      Set enemy markers.                                           #
#  P_ROBOTCAMYOFS   offset(16bit)    robot no view no offset. (-) de ue wo muki                   #
#                                                                                                 #
###################################################################################################
     ############################################
###### MACROS TO CHECK THE STATUS OF THE PLAYER #################################
#    ############################################                               #
#                                                                               #
# P_IFARWING        addr       if player is arwing  then goto addr              #
# P_IFROBOT         addr       if player is robot   then goto addr              #
# P_IFUFO           addr       if player is ufo     then goto addr              #
# P_IFPLAYERFULLHP  addr       if player's HP = max then goto addr              #
# P_IFPILOT         name(FOX,FALCO....),addr     if pilot = pilot then jmp addr #
# P_NOTPILOT        name,addr  if pilot != pilot then jmp addr                  #
# P_IFPLAYERBOOST   addr       if player using "boost" then goto addr           #
# P_IFPLAYERBRAKE   addr       if player using "brake" then goto addr           #
#                                                                               #
#################################################################################
```