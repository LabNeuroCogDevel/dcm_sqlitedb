#!/usr/bin/env bash
cd $(dirname $0)

[ ! -d data ] && mkdir data

echo "starting $(date )"
rawis="/disk/mace2/scan_data/homeless/ABCD^20160926"
for rd in rawsshfsmnt/*/*; do 
     # skip ABCD-DAILY-QA, phantom, etc
     [[ ! "$rd" =~ NDAR[-_]INV[A-Z0-9]{7,9} ]] && continue #echo "no id in $dir!" >&2 && continue  
     id=$BASH_REMATCH
     echo -n $id >&2
     for d in $rd/*; do
        [[ "$d" =~ /PhoenixZIPReport ]] && continue # skip report
        [[ "$d" =~ PMU_0x0. ]]          && continue # skip physio file hack/fake dicoms
        dir=$(cd $d; pwd | sed "s:.*rawsshfsmnt/:$rawis:")
        # file system is expensive, capture in bash
        alldcm=($(find $d -maxdepth 1 -type f -not -iname 'need_*' ) )
        ndcm=${#alldcm[@]}
        seqno=$(basename $d | perl -F\\. -slane 'print "$F[$#F]"')

        # record info
        echo -ne "$id $dir $seqno $ndcm "
        ./hinfo ${alldcm[0]} 
        echo

        # put dot for progress on cli
        echo -n "." >&2
     done

     # clear cli progress line
     echo >&2
done > data/dicominfo_raw.txt

sed 's/\t/ /g' data/dicominfo_raw.txt |cut -d' ' -f1-22,25,28 |sed '/^$/d; s/ $//' > data/dicominfo.txt
echo "finished $(date )"


