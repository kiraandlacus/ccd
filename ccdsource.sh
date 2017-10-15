# this function will add element to array
# if $1 is 1 modle,function will check if array has the element,if has do noting ,if has not will add the element to the array
# if $1 is 0 modle,function will not to check the array and add the element to array
# $2 array
# $3~$n element
function add_array_element()
{
    local arg
    local element_num=3
    local add_element_count=$#
    local same_flag=1

    if [ $# -lt 3 ]
    then
        echo you must add at lest one element
        return 1
    fi

    if [ $( eval echo \${\#$2[@]} ) == 0 ]
    then
##        echo array lenght is $( eval echo \${\#$2[@]} )
        eval $2[0]=$3
##        eval echo \${$2[0]}
    fi

    if [ $1 == '1' ]
    then
        while [ $element_num -le $add_element_count ]
        do
            for arg in $( eval echo \${$2[@]} )
            do
                if [ $( eval echo \$${element_num} ) == $arg ]
                then
##                    eval echo \$${element_num} same as $arg
##                    eval echo \$${element_num} has in $2
                    same_flag=1
                    break
                else
                    same_flag=0
                fi
            done

            if [ $same_flag -eq 0 ]
            then
##                eval echo \$${element_num} not in $2
                eval $2[\${\#$2[@]}]=\$${element_num}
##                eval echo \$${element_num} add to $2
            fi

            let element_num++
        done
    else
        if [ $1 == '0' ]
        then
            echo modle 0
            while [ $element_num -le $add_element_count ]
            do
                eval $2[\${\#$2[@]}]=\$${element_num}
##                eval echo \$${element_num} add to $2
                let element_num++
            done
        else
            echo Please input modle 0 or 1
            return 1
        fi
    fi
    return 0
}


# this function will return one or more choose and quit
# $1 the choose range
# $2 the choose will save this arguments
# $3 if set one just return one choose if set more will return some choose
function _get_choose()
{
#    echo 1 is $1 2 is $2 3 is $3
    local loopnum=0
    local num
    local num_array
    local arg
    local array_lenght=$1
    local array_numble
    local replace_num
    array_numble=$(expr ${array_lenght} - 1)
#    echo array_numble is $array_numble
    if [ $3 == 'one' ]
    then
        read -p "please enter the num(or q to quit):" num
        if [ $num == q ]
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
                    if [ $num == q ]
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
                if [ $num == q ]
                then
                    eval $2=$num
                    return 0
                fi
            fi
        done
    else
        read -p "Please input at least one choose(or q to quit):" num_array
        if [ $num_array == q ]
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

# this function will show_menu and return array lenght
# $1 which array you whant to show
function _show_menu()
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

# This function will read the table and reback value
# $1 the table path
# $2 variable
# $3 if set entire it will return all line
# $3 if not set it just return the value behind =
function get_table_value()
{
    local value
    if [ $# -eq 3 ]
    then
        if [ $3 == entire ]
        then
# awk rm the #line sed rm the emptyline grep to find the world
             value=$(awk '$0!~"#"{print $0}' $1 | sed -e '/^$/d' | grep $2 |\
             (while read rag;\
             do echo $rag;\
             done))
        fi
    else
             value=$(awk '$0!~"#"{print $0}' $1 | sed -e '/^$/d' | grep $2 |\
             (while read rag;\
             do \
             if [ ${rag%%=*} == $2 ];\
             then value=${rag#*=};\
             echo $value;\
             fi;\
             done))
    fi
    echo $value
}

function add_array_element()
{
    local arg
    local element_num=3
    local add_element_count=$#
    local same_flag=1

    if [ $# -lt 3 ]
    then
        echo you must add at lest one element
        return 1
    fi

    if [ $( eval echo \${\#$2[@]} ) == 0 ]
    then
##        echo array lenght is $( eval echo \${\#$2[@]} )
        eval $2[0]=$3
##        eval echo \${$2[0]}
    fi

    if [ $1 == '1' ]
    then
        while [ $element_num -le $add_element_count ]
        do
            for arg in $( eval echo \${$2[@]} )
            do
                if [ $( eval echo \$${element_num} ) == $arg ]
                then
##                    eval echo \$${element_num} same as $arg
##                    eval echo \$${element_num} has in $2
                    same_flag=1
                    break
                else
                    same_flag=0
                fi
            done

            if [ $same_flag -eq 0 ]
            then
##                eval echo \$${element_num} not in $2
                eval $2[\${\#$2[@]}]=\$${element_num}
##                eval echo \$${element_num} add to $2
            fi

            let element_num++
        done
    else
        if [ $1 == '0' ]
        then
            echo modle 0
            while [ $element_num -le $add_element_count ]
            do
                eval $2[\${\#$2[@]}]=\$${element_num}
##                eval echo \$${element_num} add to $2
                let element_num++
            done
        else
            echo Please input modle 0 or 1
            return 1
        fi
    fi
    return 0
}

function _clean_dir_CST()
{
    dirs -c
    echo all the dir record have clean!
}

# this function need 2 arguments,one is array,one is num
# the function will change the num to the value by array
# $1 array
# $2 one or some numble
function _change_num_to_value()
{
#    echo here is _change_num_to_value
    local num_count=0
    local arg
    local tmp_num_array
    declare -a tmp_num_array
    declare -a tmp_value_array

    for arg in $(eval echo \$$2)
    do
        eval tmp_num_array[$num_count]=$arg
        let num_count++
    done
#    echo tmp_num_array is ${tmp_num_array[@]}

    local sameflag="SAMENULL"
    local i=0
    local j=0
    local count=0

    if [ $num_count -ne 1 ]
    then
        for (( i=0;i<$num_count;i++ ))
        do
            for (( j=i+1;j<$num_count;j++ ))
            do
                if [ $(eval echo \${tmp_num_array[$i]}) == $(eval echo \${tmp_num_array[$j]}) ]
                then
#                    eval echo tmp_num_array[$i]:\${tmp_num_array[$i]} is same as tmp_num_array[$j]:\${tmp_num_array[$j]}
                    eval tmp_num_array[$j]=$sameflag
                fi
            done
        done
    fi

    for arg in ${tmp_num_array[@]}
    do
        if [ $arg == $sameflag ]
        then
#            echo arg is $arg sameflag is $sameflag count is $count
            tmp_num_array[$count]=' '
        fi
        let count++
    done
#    echo -----------------------------
#    echo ${tmp_num_array[@]}
    count=0
    for arg in ${tmp_num_array[@]}
    do
        eval tmp_value_array[$count]=\${$1[$arg]}
        let count++
    done

    eval $2=\$\(echo ${tmp_value_array[@]}\)
}

# This function will show the menu and return the choose
# $1 which array you whant to show
# $2 which statements will show before the menu
# $3 the choose will save in this arguments
# $4 this arguments must set one or more,
# when set one will just return one choose
# when set more it can return some choose
function show_menu_and_get_choose()
{
    if [ $# -ne 4 ]
    then
        echo Please input 4 arguments!
        return 1
    fi

    if [ $4 != 'one' ]
    then
        if [ $4 != 'more' ]
        then
            echo Please input one or more modle
            return 1
        fi
    fi

    local return_num
    local array_lenght

    echo $2
    _show_menu $1
    array_lenght=$?
    _get_choose $array_lenght $3 $4
#    echo $3
#    eval echo \$$3
    if [ $(eval echo \$$3) == q ]
    then
        echo You choose quit,exit now!
        exit 1
    fi
    _change_num_to_value $1 $3
}

function _globa_path
{
    local globalpath
    local arg
    local loop=1
    local reback=0

    globalpath_choose="NULL"
    declare -a globalpatharray

    globalpath=$(get_table_value ${CCD_TABLE_PATH}${CCD_TABLE_NAME} GLOBAL_PATH)
    for arg in $globalpath
    do
        add_array_element 1 globalpatharray $arg
    done

    while [ $loop == 1 ]
    do
        show_menu_and_get_choose globalpatharray "Which path you want to go:" globalpath_choose one
        if [ $globalpath_choose == LABEL_PATH ]
        then
            _label_path
            reback=$?
            if [ $reback != 1 ]
            then
                loop=0
            fi
        else
            _tmp_path $globalpath_choose
            loop=0
        fi
    done

    unset globalpath_choose
    unset globalpatharray
    return 0
}

function _label_path()
{
    local arg
    local labelenght
    local loop=1

    labelname="NULL"
    declare -a labelnamearray
    labelname=$(get_table_value ${CCD_TABLE_PATH}${CCD_TABLE_NAME} LABEL_PATH_NAME)

    for arg in $labelname
    do
        add_array_element 1 labelnamearray $arg
    done

#    echo ${labelnamearray[@]}

    while [ $loop == 1 ]
    do
        _show_menu labelnamearray
        labelenght=$?
        _get_choose $labelenght labelname one
        if [ $(echo $labelname) == q ]
        then
            unset labelname
            unset labelnamearray
            return 1
        else
            label="NULL"
            declare -a labelarray
            _change_num_to_value labelnamearray labelname
            echo labelname is $labelname
            label=$(get_table_value ${CCD_TABLE_PATH}${CCD_TABLE_NAME} $labelname)
#        echo label is $label
            for arg in $label
            do
                add_array_element 1 labelarray $arg
            done
            _show_menu labelarray
            labelenght=$?
            if [ $labelenght == 0 ]
            then
                echo Here has not label
                unset label
                unset labelarray
                loop=1
            else
                _get_choose $labelenght label one
                if [ $(echo $label) == q ]
                then
                    loop=1
                    unset label
                    unset labelarray
                else
                    _change_num_to_value labelarray label
#                    globalpath_choose=$label
                    _tmp_path $label
                    unset labelname
                    unset labelnamearray
                    return 0
                fi
            fi
        fi
    done
}

function _tmp_path()
{
    if [ -e ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME} ]
    then
        rm ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME}
    fi
    echo $1 >> ${CCD_TABLE_PATH}${CCD_TMP_PATH_NAME}
}

function _write_table_path
{
    eval vim ${CCD_TABLE_PATH}${CCD_TABLE_NAME}
}

function _show_help
{
    echo 'ccd -h:show the help'
    echo 'ccd -j:show the path you have gone'
    echo 'ccd -c:clean all the path you have gone'
    echo 'ccd -g:show the path in ~/.ccdglobaltable'
    echo 'ccd -w:open the ~/.ccdglobaltable'
    return 0
}

CCD_TABLE_PATH='/home/Bin/ccd/'
CCD_TABLE_NAME='.ccdglobaltable'
CCD_TMP_PATH_NAME='seedcst.tmp'

globalpath_choose="NULL"

case $1 in
     -h)
     _show_help
     ;;
     -w)
     _write_table_path
     ;;
     -g)
     _globa_path
     ;;
     -l)
     _label_path
     ;;
     *)
     _show_help
     ;;
esac

