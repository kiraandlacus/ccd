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
        "10")
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}

function _push_dir_cst()
{
    dirs -p 
    pushd $PWD > /dev/null
    echo here is push_dir_cst
}

function _cd_cst()
{
    cd $1;
    if [ $? == 0 ]
    then
        _push_dir_cst
        echo ok!
    else
        echo no!
    fi
}

function _dir_jump()
{
    input=100
    echo Input the numble of dir which you want to jump!
    echo Or Input q to out!
    dirs -l -p -v
    echo 10   qiut
    while [ $input -lt 0 ] || [ $input -gt 11 ]
    do
        read -p "Please input you choose:" input
        num_charn_char $input
        echo $?
    done
}

function ccd()
{
case $1 in
     -j)
     _dir_jump
     ;;
     *)
     _cd_cst $1
esac
}
