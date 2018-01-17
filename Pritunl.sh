function add_vapor_apt() {
    eval "$(cat /etc/lsb-release)"

    if [[ "$DISTRIB_CODENAME" != "xenial" && "$DISTRIB_CODENAME" != "yakkety" && "$DISTRIB_CODENAME" != "trusty" ]];
    then
        echo "Only Ubuntu 14.04, 16.04, and 16.10 are supported."
        echo "You are running $DISTRIB_RELEASE ($DISTRIB_CODENAME) [`uname`]"
        return 1;
    fi
        echo "....."
        exit
}

add_vapor_apt
