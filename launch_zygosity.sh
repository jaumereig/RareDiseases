#!/bin/bash

# paths dels arxius (en el meu cas el input file de l'index el vull filtrat i els altres vull els originals sense filtrar) i script
filtered="/homes/users/nmoreno/vdh/WGS_FIS_VH/FILTERED"
original="/homes/users/nmoreno/vdh/WGS_FIS_VH/SNP_INDEL"
script="/home/vant/Escritorio/pid/scripts/parents_zygosity.py"


#// En el meu cas faig això perquè tinc diferents tipus de families, per exemple les families fim són les que faig amb aquest loop. 
#// for i in {01..02} 04 {06..10} {12..14} {16..23}; do
#//  in_f=$original"/VH"$i"f_SNP_INDEL.tsv"
#//  in_i=$filtered"/STRONG_CANDIDATES/VH"$i"i_STRONG.tsv"
#//  in_m=$original"/VH"$i"m_SNP_INDEL.tsv"
 # recorda la consistencia entre el que posis aquí i el que tinguis a l'hora de llegir el input al script de python
 python3 $script "fim" "VH"$i $in_f $in_i $in_m; 
 # li dic el nom del tmp file que creo amb python i el del output final que vull
 tmp=$filtered"/INDEX_ANNOTATED/VH"$i".tmp"   
 out=$filtered"/INDEX_ANNOTATED/VH"$i"i.tsv"
 # printeges el arxiu temporal amb els IDs i les zigositats i s'ho passes a la comanda de AWK com a input
 # Aquesta és la línia rebuscada de AWK que és més senzilla del que sembla un cop la fas servir moltes vegades i la vas canviant i jo he trobat que és suuuuuper util per quasi tot
 #? BEGIN{FS=OFS="\t";} defineixo que quan posi OFS significa un tabulador
 #* NR==FNR{a[$1]=1;fzyg[$1]=$2;mzyg[$1]=$3;szyg[$1]=$4;next} llegeixo el primer arxiu TMP (el que ve de l'esquerra) i genero la llista que em serveix per associar amb la mateixa variant del segon arxiu o arxiu de la dreta (llista A)
 #? amb fzyg[$1] li dic que la father zygosity de la variant amb aquell ID concret eés $2 (la segona columna de l'arxiu de l'esquerra), etc
 #* /^#/{$15= $15 OFS "f_ZYG" OFS "m_ZYG" OFS "s_ZYG";} quan llegeix el segon arxiu, si la linia comença amb # (que es el header) m'afegeixes els noms de les tres columnes
 #? $3 in a{$15 = $15 OFS fzyg[$3] OFS mzyg[$3] OFS szyg[$3]} Si $3 que és la posició del ID en el arxiu de la dreta, està dins de la llista A, llavors afegeix les tres columnes amb els valors corresponents a aquest ID de cadascuna de les llistes
 #* 1 ; super important perquè imprimeixi tot l'arxiu
 #?  - <(cat $in_i) # super important el guió abans de donar-li <( i aquí li printeges amb cat el arxiu de variants de l'index )
 cat /home/vant/Escritorio/pid/arg.tmp | awk 'BEGIN{FS=OFS="\t";}NR==FNR{a[$1]=1;fzyg[$1]=$2;mzyg[$1]=$3;szyg[$1]=$4;next}/^#/{$15= $15 OFS "f_ZYG" OFS "m_ZYG" OFS "s_ZYG";}$3 in a{$15 = $15 OFS fzyg[$3] OFS mzyg[$3] OFS szyg[$3]}1' - <(cat $in_i) > $out
done