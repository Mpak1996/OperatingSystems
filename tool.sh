#!/usr/bin/env bash
#6326 ΙΩΑΝΝΗΣ ΜΠΑΚΟΜΙΧΑΛΗΣ
#6204 ΑΘΑΝΑΣΙΟΣ ΣΜΠΟΥΚΗΣ
FILE_FLAG=0
FILE=
ID_FLAG=0
ID=
FIRSTNAMES_FLAG=0
LASTNAMES_FLAG=0

SOCIALMEDIA_FLAG=0

BORN_SINCE_FLAG=0
BORN_SINCE=

BORN_UNTIL_FLAG=0
BORN_UNTIL=

EDIT_FLAG=0
EDIT_ID=
EDIT_COLUMN=
EDIT_VALUE=

ID_COLUMN=0
LASTNAME_COLUMN=1
FIRSTNAME_COLUMN=2
GENDER_COLUMN=3
BIRTHDAY_COLUMN=4
JOINDATE_COLUMN=5
IP_COLUMN=6
BROWSERUSED_COL=7
SOCIALMEDIA_COL=8




#Erotima 1 tis askisis
print_file() {
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue
        fi
        echo "$line"
    done < "$1"
}

#Erotima 2 tis askisis
get_user_by_id() {
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi  

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        case ${line_array[$ID_COLUMN]} in
            $ID)
                echo "${line_array[$FIRSTNAME_COLUMN]} ${line_array[$LASTNAME_COLUMN]} ${line_array[$BIRTHDAY_COLUMN]}"
                ;;
        esac

    done < $FILE
}

#Erotima 3 tis askisis
get_unique_firstnames_sorted() {
    firstname_array=()
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        firstname_array+=(${line_array[$FIRSTNAME_COLUMN]})
    done < $FILE

    for element in "${firstname_array[@]}"
    do
        echo "$element"
    done | sort -n | uniq

}

get_unique_lastnames_sorted() {
    lastname_array=()
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        lastname_array+=(${line_array[$LASTNAME_COLUMN]})
    done < $FILE

    for element in "${lastname_array[@]}"
    do
        echo "$element"
    done | sort -n | uniq
}

#Erotima 4 tis askisis
get_born_until_only() {

    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        if [[ "${line_array[$BIRTHDAY_COLUMN]}" < "$BORN_UNTIL" ]] || [ "${line_array[$BIRTHDAY_COLUMN]}" == "$BORN_UNTIL" ]
        then
                echo "$line"

        fi

    done < $FILE
}

get_born_since_only() {
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        if [[ "${line_array[$BIRTHDAY_COLUMN]}" > "$BORN_SINCE" ]] || [ "${line_array[$BIRTHDAY_COLUMN]}" == "$BORN_SINCE" ]
        then
                echo "$line"

        fi

    done < $FILE
}

get_born_until_since() {
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        if ([[ "${line_array[$BIRTHDAY_COLUMN]}" > "$BORN_SINCE" ]] || [ "${line_array[$BIRTHDAY_COLUMN]}" == "$BORN_SINCE" ]) && ([[ "${line_array[$BIRTHDAY_COLUMN]}" < "$BORN_UNTIL" ]] || [ "${line_array[$BIRTHDAY_COLUMN]}" == "$BORN_UNTIL" ])
        then
                echo "$line"

        fi

    done < $FILE
}

 #Erotima 5 tis askisis
get_socialmedia_with_count() {

    socialmedia_array=()
    while read -r line
    do
        if [[ $line =~ ^#+ ]]; then
            continue # min printareis grammes me comment
        fi

        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        socialmedia_array+=(${line_array[$SOCIALMEDIA_COL]})
    done < $FILE

    
IFS=$'\n'
    unique_socialmedia=($(for socialmedia in "${socialmedia_array[@]}"
                    do
                        echo "$socialmedia"
                    done | sort -n | uniq))
    unset IFS
 

for socialmedia in "${unique_socialmedia[@]}"
    do

        counter=0

        for temp_socialmedia in "${socialmedia_array[@]}"
        do
            if [ "$temp_socialmedia" == "$socialmedia" ]
            then
                counter=$((counter+1))
        fi
        done 

  echo " $counter $socialmedia "  
    done

}



function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }


edit_file(){
    EDIT_COLUMN=$((EDIT_COLUMN-1))
    
    IFS=$'\n'
    new_lines=($(while read -r line
    do
        line_array=()
        IFS='|'
        for column in $line
        do
            line_array+=($column)
        done

        case ${line_array[$ID_COLUMN]} in
            $EDIT_ID)
                if [ "$EDIT_COLUMN" -ge "$LASTNAME_COLUMN" ] && [ "$EDIT_COLUMN" -le "$SOCIALMEDIA_COL" ]
                then
                    line_array[$EDIT_COLUMN]=$EDIT_VALUE
                fi
                ;;
        esac
        line=$( IFS='|', echo  "${line_array[*]}")

        echo "$line"

    done < $FILE))

    new_file=$( IFS=$'\n', echo  "${new_lines[*]}")

    echo "$new_file" > $FILE


}


while test $# -gt 0
do
    case $1 in 
        -f)
            FILE_FLAG=1
            FILE="$2"
            shift 2 
            ;; 
        -id)
            ID_FLAG=1
            ID="$2"			
            shift 2
            ;;
        --firstnames)
            FIRSTNAMES_FLAG=1
            shift
            ;;
            
        --lastnames)
            LASTNAMES_FLAG=1
            shift
            ;;          
            
        --socialmedia)
            SOCIALMEDIA_FLAG=1
            shift
            ;;  
        --born-since)
            BORN_SINCE_FLAG=1
            BORN_SINCE="$2"
            shift 2
            ;;  
        --born-until)
            BORN_UNTIL_FLAG=1
            BORN_UNTIL="$2"
            shift 2
            ;;
        --edit)
            EDIT_FLAG=1
            EDIT_ID="$2"
            EDIT_COLUMN="$3"
            EDIT_VALUE="$4"
            shift 4
            ;;
        --)
            break
            ;;
        *)
            echo "$1: Unknown argument"
            exit 1
            break
            ;;
    esac
done

if [ $FILE_FLAG -eq 1 ] # user has passed -f option
then
    if [ $ID_FLAG -eq 1 ]
    then

        get_user_by_id

    elif [ $FIRSTNAMES_FLAG -eq 1 ]
    then
    
        get_unique_firstnames_sorted
   
    elif [ $LASTNAMES_FLAG -eq 1 ]
    then
        
        get_unique_lastnames_sorted
        
    elif [ $SOCIALMEDIA_FLAG -eq 1 ]
    then
    
       get_socialmedia_with_count
    
    elif [ $BORN_SINCE_FLAG -eq 1 ] && [ $BORN_UNTIL_FLAG -eq 1 ]
    then
        #echo "both"
        get_born_until_since
    
    elif [ $BORN_SINCE_FLAG -eq 1 ]
    then
        get_born_since_only
   
    elif [ $BORN_UNTIL_FLAG -eq 1 ]
    then
    
        get_born_until_only
   
    elif [ $EDIT_FLAG -eq 1 ]
    then
    
        edit_file
   
    else
    
        print_file $FILE

    fi
else
    echo "6326-6204"
fi

