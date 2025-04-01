BEGIN {
        FS=":"
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
        printf "\nAll Time Tournament Record for %s:\n\n", TEAM
}
(($3==TRNY)&&($6==TEAM)) {
        opp=$8
        if (wins[opp]==0&&lose[opp]==0)
                {
                sort[++number]=opp
                scrs[opp]=""
                }
        else if (((wins[opp]+lose[opp])%3)==0)
                scrs[opp]=scrs[opp]"\n            "
        else
                scrs[opp]=scrs[opp]";"
        ++wins[opp]
        perc[opp]=(wins[opp]/(wins[opp]+lose[opp]))
        scrs[opp]=scrs[opp]" "$7"-"$9
        if ($10!=0)
                if ($10!=1)
                        scrs[opp]=scrs[opp]" "$10" OTS"
                else
                        scrs[opp]=scrs[opp]" OT"
        }
(($3==TRNY)&&($8==TEAM)) {
        opp=$6
        if (wins[opp]==0&&lose[opp]==0)
                {
                sort[++number]=opp
                scrs[opp]=""
                }
        else if (((wins[opp]+lose[opp])%3)==0)
                scrs[opp]=scrs[opp]"\n          "
        else
                scrs[opp]=scrs[opp]";"
        ++lose[opp]
        perc[opp]=(wins[opp]/(wins[opp]+lose[opp]))
        scrs[opp]=scrs[opp]" "$9"-"$7
        if ($10!=0)
                if ($10!=1)
                        scrs[opp]=scrs[opp]" "$10" OTS"
                else
                        scrs[opp]=scrs[opp]" OT"
        }
END {
        for(i=number;i>=1;--i)
                {
                max=0
                mp=0 - 1
                mw=0
                ml=1575
                tn="ZZZ"
                for(j=1;j<=number;j++)
                        if
(perc[sort[j]]>mp||(perc[sort[j]]==mp&&wins[sort[j]]>mw)|| \
(perc[sort[j]]==mp&&wins[sort[j]]==mw&&lose[sort[j]]<ml)|| \
(perc[sort[j]]==mp&&wins[sort[j]]==mw&&lose[sort[j]]==ml&& \
 sort[j]<tn)) {
                                max=j
                                mp=perc[sort[j]]
                                mw=wins[sort[j]]
                                ml=lose[sort[j]]
                                tn=sort[j]
                                }
                printf "against %-30s %2d-%-2d %5.3f %s\n", \
                        tn, mw, ml, mp, scrs[sort[max]]
                perc[tn]= 0 - 1
                }
        }