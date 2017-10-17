# this function will show_menu and return array lenght
# $1 which array you whant to show
function _show_menu_cst()
{
    local i=0
    local rag

    local array_name
    local array_lenght
    local array_numble

    eval array_name=\${$1[@]}
    eval array_lenght=\${\#$1[@]}
    array_numble=$(expr ${array_lenght} - 1)

    for rag in $array_name
    do
        echo " $i ${rag}"
        let i++
    done
    return $array_lenght
}

# this function will return one or more choose and quit
# $1 the choose range
# $2 the choose will save this arguments
# $3 if set one just return one choose if set more will return some choose
function _get_choose_cst()
{
    local loopnum=0
    local num
    local num_array
    local arg
    local array_lenght=$1
    local array_numble
    local replace_num
    array_numble=$(expr ${array_lenght} - 1)
#    echo array_numble is $array_numble
    if [ "$3" == 'one' ]
    then
        read -p "please enter the num(or q to quit):" num
        if [ "$num" == q ]
        then
            eval $2=$num
            return 0
        fi
        while [ $loopnum -eq 0 ]
        do
            if echo $num | grep -q '^[0-9]\+$'
            then
                if [ $num -lt 0 -o $num -ge $array_lenght ]
                then
                    read -p "Please input numble 0~$array_numble(or q to quit):" num
                    if [ "$num" == "q" ]
                    then
                        eval $2=$num
                        return 0
                    fi
                else
                    eval $2=$num
                    return 0
                fi
            else
                read -p "Please input numble 0~$array_numble(or q to quit):" num
                if [ "$num" == q ]
                then
                    eval $2=$num
                    return 0
                fi
            fi
        done
    else
        read -p "Please input at least one choose(or q to quit):" num_array
        if [ "$num_array" == q ]
        then
            eval $2=$num_array
            return 0
        fi
        while [ $loopnum -eq 0 ]
        do
            loopnum=1
            for arg in $num_array
            do
                if echo $arg | grep -q '^[0-9]\+$'
                then
                    if [ $arg -lt 0 -o $arg -ge $array_lenght ]
                    then
                        echo "You have a num $arg not in arng!"
                        echo -n "Please input numble 0~$array_numble>>"
                        read replace_num
                        eval num_array="\${num_array/$arg/$replace_num}"
                        echo you have input $replace_num to replace $arg!
                        echo input numble is $num_array
                        loopnum=0
                    fi
                else
                    echo "You input have a not num $arg!"
                    echo -n "Please input numble 0~$array_numble>>"
                    read replace_num
                    eval num_array="\${num_array/$arg/$replace_num}"
                    echo you have input $replace_num to replace $arg!
                    echo input numble is $num_array
                    loopnum=0
                fi
            done
        done
        eval $2=\"$num_array\"
        return 0
    fi
}

function _popd_dir_cst()
{
    local dirarray
    declare -a dirarray
    local arg
    local count
    local dirrarry_count_cst=0
    local dirrarry_lengh=0
    dirrarry=()
    for arg in $(dirs)
    do
        dirarray[dirrarry_count_cst]=$arg
        let dirrarry_count_cst++
    done
    dirrarry_lengh=${#dirarray[@]}
    for ((count=1;count<$dirrarry_lengh;count++))
    do
        if [ ${dirarray[0]} == ${dirarray[count]} ]
        then
            popd +$count > /dev/null
        fi
    done
    dirrarry_count_cst=0
    for arg in $(dirs)
    do
        dirrarry[dirrarry_count_cst]=$arg
        let dirrarry_count_cst++
    done
    dirrarry_lengh=${#dirrarry[@]}
    if [ ${dirrarry_lengh} -eq 11 ]
    then
        popd +10 > /dev/null
    fi
}

function _cd_cst()
{
    pushd $1 > /dev/null
    _popd_dir_cst
}


function _dir_jump()
{
    local arg
    local dirsarray
    local dirsarray_num=0
    declare -a dirsarray
    local reback_choose

    for arg in $(dirs -l)
    do
        eval dirsarray[$dirsarray_num]=$arg
        let dirsarray_num++
    done

    _show_menu_cst dirsarray
    _get_choose_cst $dirsarray_num reback_choose one
    if [ $reback_choose == "q" ]
    then
        echo You choose quit , exit now!
    else
        pushd +$reback_choose > /dev/null
    fi
}

function _clean_dir()
{
    dirs -c
    echo All the dir record have clean!
}


function ccd()
{
    local jump_path='NULL'
    local CCD_TABLE_PATH="/home/Bin/ccd/"
    local CCD_PROGRAM_NAME="ccdsource.sh"
    local CCD_TMP_PATH_NAME="seedcst.tmp"
    local CCD_TABLE_NAME=".ccdglobaltable"
case $1 in
     -h)
     eval ${CCD_TABLE_PATH}${CCD_PROGRAM_NAME} -h
     ;;
     -j)
     _dir_jump
     ;;
     -c)
     _clean_dir
     ;;
     -w)
     eval vim ${CCD_TABLE_PATH}${CCD_TABLE_NAME}
     ;;
     -g)
     ${CCD_TABLE_PATH}${CCD_PROGRAM_NAME} -g
     if [ -e ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME} ]
     then
         jump_path=$(cat ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME})
         rm ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME}
         _cd_cst $jump_path
     fi
     ;;
     -l)
     ${CCD_TABLE_PATH}${CCD_PROGRAM_NAME} -l
     if [ -e ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME} ]
     then
         jump_path=$(cat ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME})
         rm ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME}
         _cd_cst $jump_path
     fi
     ;;
     -a)
     ${CCD_TABLE_PATH}${CCD_PROGRAM_NAME} -a
     ;;
     *)
     _cd_cst $1
esac
}
