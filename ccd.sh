function num_charn_char()
{
    case $1 in
       "0")
        return 0
        ;;
       "1")
        return 0
        ;;
        "2")
        return 0
        ;;
        "3")
        return 0
        ;;
        "4")
        return 0
        ;;
        "5")
        return 0
        ;;
        "6")
        return 0
        ;;
        "7")
        return 0
        ;;
        "8")
        return 0
        ;;
        "9")
        return 0
        ;;
        "q")
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}

function _popd_dir_cst()
{
#    echo here is _popd_dir_cst
    declare -a dirarry
    dirrarry_count_cst=0
    dirrarry_lengh=0
    dirrarry=()
    for arg in `dirs`
    do
        dirarry[dirrarry_count_cst]=$arg
        let dirrarry_count_cst++
    done
    dirrarry_lengh=${#dirarry[@]}
    for ((i=1;i<$dirrarry_lengh;i++))
    do 
        if [ ${dirarry[0]} == ${dirarry[i]} ]
        then
            popd +$i > /dev/null
        fi
    done
    dirrarry_count_cst=0
    for arg in `dirs`
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
    now_pwd_cst=$PWD
    pushd $1 > /dev/null
    _popd_dir_cst
}

function _dir_jump()
{
    input=
    echo Which dir you want to jump!
    echo Or Input q to quit!
    dirs -l -p -v
    until (num_charn_char $input;)
    do
        read -p "Please input you choose:" input
    done
    if [ $input == "q" ]
    then
        echo you choose quit!
    else 
        echo you choose $input!
        pushd +$input > /dev/null
    fi
}

function _clean_dir()
{
    dirs -c
    echo all the dir record have clean!
}

function _global_path()
{
    if [ -e ~/.ccdglobatable ]
    then
        echo Here has ccdglobatable!
    else
        echo Here has no ccdglobatable!
        touch ~/.ccdglobatable
        echo Have creat ccdglobatable!
    fi
}

function ccd()
{
case $1 in
     -j)
     _dir_jump
     ;;
     -c)
     _clean_dir
     ;;
     -g)
     _global_path
     ;;
     *)
     _cd_cst $1
esac
}
