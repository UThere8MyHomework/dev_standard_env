# --
#
# Copyright 2012 UThere8MyHomework
#
# FILE:  ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_source_to_prep_env.bash
#
# --
#
# -- A note about exit status:  this script does not use 'exit STATUS;' as it's
#    usually called within a bash-shell with "source .../_ut8mh_source_to_prep_env.bash" --
#    an 'exit STATUS;' would kill the current bash-shell.
#
# -- typical use (some of this would go permanently in '.bashrc' or '.profile', some is
#    one-time setup, some is done each time one wants to use the standard development
#    environment) --
#
#   # -- note that this script is known to work (as of early 2012) on a recent OSX
#   #    version and CentOS 6 (RHEL clone) (with proper maven/ant setup)
#
#   # -- set up standard GNU UNIX/Linux utilities (avoid Mac OSX native versions, for example)
#
#        # on OSX you probably would do following:
#        sudo port install coreutils                                                        # once
#        export PATH="/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin:${PATH}"     # each time
#
#        # on all/most Linux distributions one would have the standard GNU executables on the path
#        # ... probably no need to do anything ...
#
#        # optionally create additional files . . . (see comments on ${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR} below)
#        vi "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/additional_gnu_exec_list"                    # insert list of executables you want to make sure are gnu versions
#        vi "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/additional_gnu_exec_keep_in_env_var_list"    # insert list of executables you want to keep in variables of form ${UT8MH_GNU_BIN_execname}
#
#   # -- set up for git
#
#   export GIT_EDITOR=/usr/bin/vim
#   #...
#
#   # -- set up for 'ant'
#
#   # ... make sure 'ant' is on the ${PATH}
#
#   # -- set up for Maven's 'mvn'
#
#   export M2_HOME="/usr/local/maven-3.0.3"
#   export M2="${M2_HOME}/bin"
#   export PATH="${M2}:${PATH}"
#   #...
#
#   # -- create directory to hold standard development environment 'home',
#   #    pull standard dev git repository into the directory
#
#   mkdir "/home/egdev/dev standard env"
#   cd "/home/egdev/dev standard env"
#   git clone git@github.com-ut8mh:UThere8MyHomework/dev_standard_env .
#
#       # *** indicate this is the 'home' directory for the standard development environment ***
#   export GITHUB_UT8MH_DEV_STANDARD_ENV_HOME="/home/egdev/dev standard env"
#       # Note that this init-dev-env-script will set, in this case, environment variable
#       # GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR="/home/egdev/_dev standard env-ut8mh-settings"
#
#   # -- create parallel directory with custom settings (kept under separate source control),
#   #    named similarly to standard development environment 'home'
#
#       # create the settings directories (see comments on ${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR} above)
#   mkdir "/home/egdev/_dev standard env-ut8mh-settings"
#   cd "/home/egdev/_dev standard env-ut8mh-settings"
#   mkdir ./etc
#   cd ./etc
#
#       # indicate which additional repositories beyond the default ones will be cloned
#       # into "/home/egdev/dev standard env/maven_based_code"
#   cat <<EOF >./additional_checkout_repo_list
#   0java_user empty empty2
#   EOF
#
#       # make sure these repositories exist and are 'cloneable', and otherwise initialized as expected (need more info)
#   # _maven_UThere8MyHomework_public_repo                ... need more info
#   # _maven_UThere8MyHomework_private_repo_and_docs      ... need more info
#   # _build_number_gen
#   #   should have same contents as repository https://github.com/clarafaction/_build_number_gen (including '.gitignore')
#   # 0maven                                         ... need more info
#   # 0java                                          ... need more info
#
#       # if one has access to 'private repositories' then add this flag (this will add to the default cloned repos)
#   #touch ./flag_fetch_private_git_repos
#
#   # -- create alias to prepare to use the environment (for convenience only ... when running the script
#   #    that puts environment into effect the particular alias 'ut8mh_env' is deleted).
#   alias ut8mh_env='bash --noprofile --init-file "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_source_to_prep_env.bash"'
#
#   # -- put dev environment into effect
#
#   cd /to/wherever/you/please
#
#       # use alias to set up environment
#   ut8mh_env
#       # if this works then:
#       #  * execution status from 'source' command (in alias) will be $? == 0    # (if fails, will be non-0)
#       #  * ${GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED} == 1
#       #  * the following repositories will be checked out in respective subdirectories of
#       #    ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code
#       #      ./_maven_UThere8MyHomework_public_repo                    -- local clone of public github-hosted Maven deployment directory,
#       #                                                              ready for more deployments, commits, and push-to-github
#       #      ./_maven_UThere8MyHomework_private_repo_and_docs          -- similar to above, but is a private repo (only if 'flag_fetch_private_git_repos' used),
#       #                                                              and also contains docs
#       #      ./0maven                                             -- contains standard 'parent pom.xml' ./0maven/standard_parent_project/pom.xml
#       #      ./0java                                              -- ...
#       #      ./_build_number_gen                                  -- a repository dedicated to generating unique build numbers
#       # TODO:  may want to revise these effects
#
# --

echo;

if [ "X${GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED}" = "X1" ]; then

    echo "(the http://github.com/UThere8MyHomework standard Java (et. al.) dev env is already prepared)";
    echo;

    "${UT8MH_GNU_BIN_true}";

elif [ "X${GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED}" = "X" ]; then


        # -- init

    echo "==== BEGIN preparing the http://github.com/UThere8MyHomework standard Java (et. al.) dev env ====";

    GITHUB_UT8MH_DEV_STANDARD_PREP_OK=1;


        # -- make sure home defined and 'long enough' (long enough to have at least one char if trailing '/' is removed)

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${#GITHUB_UT8MH_DEV_STANDARD_ENV_HOME} -lt 2 ]; then
        echo "ERROR:  \${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME} is not defined or 'not long enough'";
        GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
    fi


        # -- strip trailing "/" from home if needed

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME#${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME%?}} = "/" ]; then
        export GITHUB_UT8MH_DEV_STANDARD_ENV_HOME=${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME%?};
    fi


        # -- make sure home is absolute

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME:0:1} != "/" ]; then
        echo "ERROR:  \${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME} is not an absolute path";
        GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
    fi


        # -- make sure this very file here is found (we're discounting possibility of mis-pointing across different copies of the dev shell)

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ! -f "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_source_to_prep_env.bash" ]; then
        echo "ERROR:  file \${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_source_to_prep_env.bash not found, var points to invalid location";
        GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
    fi


        # -- get the settings directory for custom per-env settings (probably backed up in a Subversion copy of dev home directory)

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME%/*}/_${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME##*/}-ut8mh-settings"

        if [ ! -d "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}" ]; then
            echo "  ERROR:  settings directory \"${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}\" not found";
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        else
            echo "  Settings for dev env are at: \"${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}\"";
        fi
    fi


        # -- make sure various programs found are the "real" standard GNU builds (rather than the OSX versions, for example) -- we need consistency

        # NOTE:  note "proper" absence of 'cd', 'wait' -- and no way to check for properly for 'bash'
    QTVEQkRGRTkz__gnu_exec_list="true false echo env cat head tail grep sort which find ls mkdir ln mv rm rmdir touch cp chmod date sleep";
    QTVEQkRGRTkz__gnu_exec_list_custom=`cat "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/etc/additional_gnu_exec_list" 2>/dev/null`;
    QTVEQkRGRTkz__gnu_exec_list="${QTVEQkRGRTkz__gnu_exec_list} ${QTVEQkRGRTkz__gnu_exec_list_custom}";
    unset QTVEQkRGRTkz__gnu_exec_list_custom;
    QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list="true false echo";
    QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list_custom=`cat "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/etc/additional_gnu_exec_keep_in_env_var_list" 2>/dev/null`;
    QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list="${QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list} ${QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list_custom}";
    unset QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list_custom;

        # avoid aliases during gnu-exec check
    shopt -u expand_aliases;

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                    # inside here we generally can't assume GNU coreutils, etc., are in use

        for QTVEQkRGRTkz__execname in ${QTVEQkRGRTkz__gnu_exec_list}; do

            if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                echo "  checking whether executable \"${QTVEQkRGRTkz__execname}\" is GNU version";

                QTVEQkRGRTkz__fexecname=`which ${QTVEQkRGRTkz__execname} 2>/dev/null`;

                if [ "X${QTVEQkRGRTkz__fexecname}" = "X" ]; then
                    echo "  ERROR:  executable \"${QTVEQkRGRTkz__execname}\" is not found";
                    GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
                else
                    echo "    executable is at \"${QTVEQkRGRTkz__fexecname}\"";
                fi
            fi

            if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                if [ "X${QTVEQkRGRTkz__execname}" = "Xwhich" ]; then
                    QTVEQkRGRTkz__numlines=`( "${QTVEQkRGRTkz__fexecname}" --help | grep -i 'Report bugs to .*gnu\\.org' | wc -l | sed -e 's/ //g') 2>/dev/null`;
                elif [ "X${QTVEQkRGRTkz__execname}" = "Xfind" ]; then
                    QTVEQkRGRTkz__numlines=`( "${QTVEQkRGRTkz__fexecname}" --help | grep -i 'savannah\\.gnu\\.org' | wc -l | sed -e 's/ //g') 2>/dev/null`;
                else
                    QTVEQkRGRTkz__numlines=`( "${QTVEQkRGRTkz__fexecname}" --help | grep -i 'General help using GNU software' | wc -l | sed -e 's/ //g') 2>/dev/null`;
                fi

                if [ "X${QTVEQkRGRTkz__numlines}" != "X1" ]; then
                    echo "  ERROR:  executable \"${QTVEQkRGRTkz__execname}\" is not the standard GNU version";
                    GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
                fi

                if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                    QTVEQkRGRTkz__keep=0;
                    for QTVEQkRGRTkz__execname2 in ${QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list}; do
                        if [ ${QTVEQkRGRTkz__execname} = ${QTVEQkRGRTkz__execname2} ]; then
                            QTVEQkRGRTkz__keep=1;
                        fi
                    done

                    if [ "${QTVEQkRGRTkz__keep}" = "1" ]; then
                        QTVEQkRGRTkz__vname="UT8MH_GNU_BIN_${QTVEQkRGRTkz__execname}";
                        export ${QTVEQkRGRTkz__vname}="${QTVEQkRGRTkz__fexecname}";
                    fi
                fi
            fi
        done

        unset QTVEQkRGRTkz__execname;
        unset QTVEQkRGRTkz__fexecname;
        unset QTVEQkRGRTkz__numlines;
        unset QTVEQkRGRTkz__keep;
        unset QTVEQkRGRTkz__execname2;
        unset QTVEQkRGRTkz__vname;

    fi

        # enable aliases
    shopt -s expand_aliases;

                    # NOTE:  after this point at any time we know ${GITHUB_UT8MH_DEV_STANDARD_PREP_OK} is "1"
                    # we can use full GNU command-line options, much more readable.  We'll avoid messing
                    # with bash 'builtin', 'enable', etc., and use the ${UT8MH_GNU_BIN_cmdname} form to
                    # invoke actual programs whenever we want to make sure we're not using the builtin for,
                    # e.g., 'echo' or some other command.


        # -- adjust M2_HOME if needed, make sure Apache Maven is found, and display Maven's version

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${#M2_HOME} -lt 2 ]; then
        echo "ERROR:  Apache Maven's home directory \${M2_HOME} is not defined or 'not long enough'";
        GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
    fi

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${M2_HOME#${M2_HOME%?}} = "/" ]; then
        export M2_HOME="${M2_HOME%?}";
    fi

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ "`which mvn 2>/dev/null`" != "${M2_HOME}/bin/mvn" ]; then
        echo "ERROR:  the Apache Maven executable 'mvn' found isn't from \${M2_HOME}";
        GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
    fi

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then
        QTVEQkRGRTkz__mvn_version=`(mvn --version 2>/dev/null) | grep --ignore-case 'apache maven'`;
        if [ "X${QTVEQkRGRTkz__mvn_version}" = "X" ]; then
            echo "  ERROR:  Apache Maven (mvn) version not found"
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        else
            echo "  Apache Maven (mvn) version : \"${QTVEQkRGRTkz__mvn_version}\"";
            echo "  Apache Maven (mvn) path    : \"${M2_HOME}/bin/mvn\"";
        fi
        unset QTVEQkRGRTkz__mvn_version;
    fi


        # -- get Apache ant's version

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then
        QTVEQkRGRTkz__ant_path=`which ant 2>/dev/null`;
        if [ "X${QTVEQkRGRTkz__ant_path}" = "X" ]; then
            echo "  ERROR:  Apache Ant 'ant' executable not found"
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        else
            QTVEQkRGRTkz__ant_version=`(ant -diagnostics 2>/dev/null) | grep --ignore-case 'apache ant.*version' | grep --ignore-case --invert-match '^ant\\.version'`;
            if [ "X${QTVEQkRGRTkz__ant_version}" = "X" ]; then
                echo "  ERROR:  Apache Ant (ant) version not found"
                GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
            else
                echo "  Apache Ant   (ant) version : \"${QTVEQkRGRTkz__ant_version}\"";
                echo "  Apache Ant   (ant) path is : \"${QTVEQkRGRTkz__ant_path}\"";
            fi
            unset QTVEQkRGRTkz__ant_version;
        fi
        unset QTVEQkRGRTkz__ant_path;
    fi


        # -- make sure the settings directory has an 'etc' subdirectory

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ! -d "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/etc" ]; then

        echo "  ERROR:  settings directory does not have an 'etc' subdirectory";
        GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
    fi


        # -- remove any 'etc' that already exists in the base

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        rm --force "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc" 2>/dev/null;
        if [ -e "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc" ]; then

            echo "  ERROR:  could not remove pre-existing 'etc' from \${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}";
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        fi
    fi


        # -- link the settings-directory's 'etc' into home's 'etc'

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        ln --symbolic "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/etc" "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc" 2>/dev/null;
        if [ ! -L "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc" ]; then

            echo "  ERROR:  could not link settings 'etc' to from \${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc";
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        fi
    fi


        # -- create directory for dealing with source code and build products

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        mkdir --parents "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code" 2>/dev/null;
        if [ "X$?" != "X0" ]; then
            echo "  ERROR:  could not ensure existence of code directory \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code\"";
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        else
            echo "  Maven-based code to be at  : \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code\"";
        fi
    fi


        # -- create directory for dealing with code documentation that will be synced to github "GitHub Pages" at http://UThere8MyHomework.github.com/code/...

    QTVEQkRGRTkz__switch_on_old_pull="(presumably) ";
    QTVEQkRGRTkz__is_real_ut8mh_env=0;
    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ! -d "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/github_docs_at_UThere8MyHomeworkDgithubDcomScode" ]; then

        QTVEQkRGRTkz__switch_on_old_pull="newly pulled ";

        echo "**BEFORE**";
        # source . . . script not sourced in -cloned- environment
        echo "**AFTER**";

    else
        QTVEQkRGRTkz__is_real_ut8mh_env=0;
    fi
    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${QTVEQkRGRTkz__is_real_ut8mh_env} = "1" ]; then
        # message if local docs copy succeeded or was already present
        echo "  Local copy of docs repo ${QTVEQkRGRTkz__switch_on_old_pull}at : \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/github_docs_at_UThere8MyHomeworkDgithubDcomScode\"";
    fi
    unset QTVEQkRGRTkz__switch_on_old_pull;
    unset QTVEQkRGRTkz__is_real_ut8mh_env;


        # -- make sure various directories are pulled from github

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        QTVEQkRGRTkz__extra_path=""

        echo "  Ensuring Maven-based code is checked out"

        rm --recursive --force "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_c856f53b96a8_"*;

        QTVEQkRGRTkz__repo_list=`((echo _maven_UThere8MyHomework_public_repo _maven_UThere8MyHomework_private_repo_and_docs _build_number_gen 0maven 0java | sed --expression 's/\s\+/\n/g' | cat "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc/additional_checkout_repo_list" - ) 2>/dev/null) | sort --unique | sed --expression ':a;N;$!ba;s/\n/ /g'`
        QTVEQkRGRTkz__repo_ok=1
        for QTVEQkRGRTkz__repo in ${QTVEQkRGRTkz__repo_list[@]}; do

            if [ ${QTVEQkRGRTkz__repo_ok} = "1" ]; then

                QTVEQkRGRTkz__repo_dir="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/${QTVEQkRGRTkz__repo}";

                QTVEQkRGRTkz__fetch_repo=1;
                if [ ${QTVEQkRGRTkz__repo} = "_maven_UThere8MyHomework_private_repo_and_docs" ] && [ ! -f "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc/flag_fetch_private_git_repos" ]; then
                    QTVEQkRGRTkz__fetch_repo=0;
                fi

                if [ ${QTVEQkRGRTkz__fetch_repo} = "1" ]; then

                    QTVEQkRGRTkz__repo_dir_tmp="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_c856f53b96a8_${QTVEQkRGRTkz__repo}";

                    if [ -d  "${QTVEQkRGRTkz__repo_dir}/.git" ]; then
                        echo "    remote repository \"${QTVEQkRGRTkz__repo}\" is (presumably) already mapped to local repository \"${QTVEQkRGRTkz__repo_dir}\"";
                    else

                        echo "    dealing with remote repository \"${QTVEQkRGRTkz__repo}\"";

                        echo "      cloning remote repository \"${QTVEQkRGRTkz__repo}\" into \"${QTVEQkRGRTkz__repo_dir_tmp}\"";

                        mkdir "${QTVEQkRGRTkz__repo_dir_tmp}" 2>/dev/null;
                        if [ "X$?" != "X0" ]; then
                            echo "      ERROR:  could not create directory \"${QTVEQkRGRTkz__repo_dir_tmp}\"";
                            QTVEQkRGRTkz__repo_ok=0;
                        fi
                        
                        if [ "X${QTVEQkRGRTkz__repo_ok}" = "X1" ]; then

                            (cd "${QTVEQkRGRTkz__repo_dir_tmp}" && (git clone "git@github.com-ut8mh:UThere8MyHomework/${QTVEQkRGRTkz__repo}" . >/dev/null 2>/dev/null))
                            if [ "X$?" != "X0" ]; then
                                echo "      ERROR:  problems cloning remote repository \"${QTVEQkRGRTkz__repo}\" to local repository \"${QTVEQkRGRTkz__repo_dir_tmp}\"";
                                QTVEQkRGRTkz__repo_ok=0;
                            fi
                        fi
                        
                        if [ "X${QTVEQkRGRTkz__repo_ok}" = "X1" ]; then

                            echo "      moving cloned repository from \"${QTVEQkRGRTkz__repo_dir_tmp}\" to \"${QTVEQkRGRTkz__repo_dir}\"";

                            mv "${QTVEQkRGRTkz__repo_dir_tmp}" "${QTVEQkRGRTkz__repo_dir}" 2>/dev/null;
                            if [ "X$?" != "X0" ]; then
                                echo "      ERROR:  problems moving cloned repository \"${QTVEQkRGRTkz__repo_dir_tmp}\" to \"${QTVEQkRGRTkz__repo_dir}\"";
                                QTVEQkRGRTkz__repo_ok=0;
                            fi
                        fi

                    fi
                fi

                if [ "X${QTVEQkRGRTkz__repo_ok}" = "X1" ] && [ -d "${QTVEQkRGRTkz__repo_dir}/AUX/bin" ]; then

                    if [ "X${QTVEQkRGRTkz__extra_path}" = "X" ]; then
                        QTVEQkRGRTkz__extra_path="${QTVEQkRGRTkz__repo_dir}/AUX/bin";
                    else
                        QTVEQkRGRTkz__extra_path="${QTVEQkRGRTkz__extra_path}:${QTVEQkRGRTkz__repo_dir}/AUX/bin";
                    fi
                fi

                unset QTVEQkRGRTkz__fetch_repo;
                unset QTVEQkRGRTkz__repo_dir;
                unset QTVEQkRGRTkz__repo_dir_tmp;
            fi

        done
        unset QTVEQkRGRTkz__repo_list;
        unset QTVEQkRGRTkz__repo;

        if [ ${QTVEQkRGRTkz__repo_ok} = "1" ]; then
            echo "  Done ensuring Maven-based code is checked out";
        else
            echo "  ERROR:  there were problems ensuring Maven-based code is checked out";
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        fi;

        unset QTVEQkRGRTkz__repo_ok;
    fi


        # -- winding up

    echo "==== END preparing the http://github.com/UThere8MyHomework standard Java (et. al.) dev env ====";
    echo;

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        # modify prompt
        export PS1="_\[\e[1;31m\]c\[\e[1;32m\]8\[\e[1;33m\]i\[\e[1;34m\]o\[\e[1;35m\]n\[\e[0;0m\]_[\u@\h \W]\$ "

        # modify $PATH
        export PATH="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin:${PATH}";
        if [ "X${QTVEQkRGRTkz__extra_path}" != "X" ]; then
            export PATH="${PATH}:${QTVEQkRGRTkz__extra_path}";
        fi
        if [ -d "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/bin" ]; then
            export PATH="${PATH}:${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/bin";
        fi
        unset QTVEQkRGRTkz__extra_path;

        # no need to keep this
        unset QTVEQkRGRTkz__gnu_exec_list;
        unset QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list;

        # mark in this shell instance that the dev env is prepared
        export GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED=1;

        # remember the settings directory
        export GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR;

        # make sure to set 'M2'
        export M2="${M2_HOME}/bin";

        # define some aliases (undefine the one that invoked this script as well, presumably 'ut8mh_env') ...
        # and also define some convenient bash utilities
        source "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_bash_utils.bash";

        # set SHELL
        SHELL=`which bash`;

        # done
        unset GITHUB_UT8MH_DEV_STANDARD_PREP_OK;
        "${UT8MH_GNU_BIN_true}";

    else

        unset QTVEQkRGRTkz__extra_path;

        unset QTVEQkRGRTkz__gnu_exec_list;
        unset QTVEQkRGRTkz__gnu_exec_keep_in_env_var_list;

        unset GITHUB_UT8MH_DEV_STANDARD_PREP_OK;
        unset GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED;
        unset GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR;

        for QTVEQkRGRTkz__badvar in `( env | sed -e 's/=.*//' | grep UT8MH_GNU_BIN_ ) 2>/dev/null`; do
            unset "${QTVEQkRGRTkz__badvar}";
        done
        unset QTVEQkRGRTkz__badvar;

        # done
        `which false`;
    fi

else

    echo "==== ERROR in _ut8mh_source_to_prep_env.bash:  env var \${GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED} unexpected value ====";
    echo;

    `which false`;

fi

# exit status already set


# --- END OF FILE.
