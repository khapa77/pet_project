BEGIN {
        FS=":"
        WINS=0
        LOSS=0
        LAST=0
        LASTFF=""
        LASTCHAMP=""
        LASTWIN=0
        LASTVIC=0
        TALCHAMP=0
        TALFF=0
        for(i=1;i<ARGC;i++) {
                if (ARGV[i]=="-T") TRNY=ARGV[i+1]
                if (ARGV[i]=="-t") TEAM=ARGV[i+1]
                }
        if (TRNY==""||TEAM=="")
                {
                print "Usage: "ARGV[0]": -T tournament -t team"
                exit
                }
        for(i=1;i<ARGC;i++) ARGV[i]=""
        ARGV[1]="/home/james/.data/scores"
        }
(($3==TRNY)&&($6==TEAM)) {
        WINS++
        LAST=$1
        if ($4=="1"&&($5=="R"||$5=="L")) 
                {
                TALCHAMP++
                if (LASTCHAMP=="" ) LASTCHAMP=$1
                else
                        {
                        if (TALCHAMP==11)
                              {
                              LASTCHAMP=LASTCHAMP",\n "$1
                              TALCHAMP=0
                              }
                        else
                              LASTCHAMP=LASTCHAMP", "$1
                        }
                }
        LASTVIC=$8
        if ($4=="3"&&($5=="R"||$5=="L")&&($3=="NCAA"||$3=="NIT"))
                {
                TALFF++
                if (LASTFF=="" ) LASTFF=$1
                else 
                        {
                        if (TALFF==11)
                              {
                              LASTFF=LASTFF",\n                 "$1
                              TALFF=0
                              }
                        else
                              LASTFF=LASTFF", "$1
                        }
                }
        LASTWIN=$1
        }
(($3==TRNY)&&($8==TEAM)) {
        LOSS++
        LAST=$1
        }
END {
        printf "\n"
        if (LAST!=0) {
                printf "Record for %s is %d-%d, ", TEAM, WINS, LOSS
                printf "last appearance in %s.\n", LAST
                if (LASTWIN!=0)
                        printf "Last win in %s over %s.\n", \
                              LASTWIN, LASTVIC
                if (TRNY!="ALL")
                        {
                        if (LASTFF!="")
                              printf "Final Four(s) in %s.\n", LASTFF

                        if (LASTCHAMP!="")
                              printf "Championships in %s.\n", LASTCHAMP
                        }
                }
        else
                {
                printf "%s never appeared in the %s tournament.\n", \
                        TEAM, TRNY
                }
        }