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
#        vi "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/additional_gnu_exec_keep_in_env_var_list"    # insert list of executables you want to keep in variables of form ${[A-Z][A-Z]8[A-Z][A-Z]_GNU_BIN_execname}
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
#   # _build_number_gen                              ... need more info
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

    "${[A-Z][A-Z]8[A-Z][A-Z]_GNU_BIN_true}";

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
    gnu_exec_list="true false echo env cat head tail grep sort which find ls mkdir ln mv rm rmdir touch cp chmod date sleep";
    gnu_exec_list_custom=`cat "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/etc/additional_gnu_exec_list" 2>/dev/null`;
    gnu_exec_list="${gnu_exec_list} ${gnu_exec_list_custom}";
    unset gnu_exec_list_custom;
    gnu_exec_keep_in_env_var_list="true false echo";
    gnu_exec_keep_in_env_var_list_custom=`cat "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/etc/additional_gnu_exec_keep_in_env_var_list" 2>/dev/null`;
    gnu_exec_keep_in_env_var_list="${gnu_exec_keep_in_env_var_list} ${gnu_exec_keep_in_env_var_list_custom}";
    unset gnu_exec_keep_in_env_var_list_custom;

        # avoid aliases during gnu-exec check
    shopt -u expand_aliases;

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                    # inside here we generally can't assume GNU coreutils, etc., are in use

        for execname in ${gnu_exec_list}; do

            if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                echo "  checking whether executable \"${execname}\" is GNU version";

                fexecname=`which ${execname} 2>/dev/null`;

                if [ "X${fexecname}" = "X" ]; then
                    echo "  ERROR:  executable \"${execname}\" is not found";
                    GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
                else
                    echo "    executable is at \"${fexecname}\"";
                fi
            fi

            if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                if [ "X${execname}" = "Xwhich" ]; then
                    numlines=`( "${fexecname}" --help | grep -i 'Report bugs to .*gnu\\.org' | wc -l | sed -e 's/ //g') 2>/dev/null`;
                elif [ "X${execname}" = "Xfind" ]; then
                    numlines=`( "${fexecname}" --help | grep -i 'savannah\\.gnu\\.org' | wc -l | sed -e 's/ //g') 2>/dev/null`;
                else
                    numlines=`( "${fexecname}" --help | grep -i 'General help using GNU software' | wc -l | sed -e 's/ //g') 2>/dev/null`;
                fi

                if [ "X${numlines}" != "X1" ]; then
                    echo "  ERROR:  executable \"${execname}\" is not the standard GNU version";
                    GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
                fi

                if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

                    keep=0;
                    for execname2 in ${gnu_exec_keep_in_env_var_list}; do
                        if [ ${execname} = ${execname2} ]; then
                            keep=1;
                        fi
                    done

                    if [ "${keep}" = "1" ]; then
                        vname="[A-Z][A-Z]8[A-Z][A-Z]_GNU_BIN_${execname}";
                        export ${vname}="${fexecname}";
                    fi
                fi
            fi
        done

        unset execname;
        unset fexecname;
        unset numlines;
        unset keep;
        unset execname2;
        unset vname;

    fi

        # enable aliases
    shopt -s expand_aliases;

                    # NOTE:  after this point at any time we know ${GITHUB_UT8MH_DEV_STANDARD_PREP_OK} is "1"
                    # we can use full GNU command-line options, much more readable.  We'll avoid messing
                    # with bash 'builtin', 'enable', etc., and use the ${[A-Z][A-Z]8[A-Z][A-Z]_GNU_BIN_cmdname} form to
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
        mvn_version=`(mvn --version 2>/dev/null) | grep --ignore-case 'apache maven'`;
        if [ "X${mvn_version}" = "X" ]; then
            echo "  ERROR:  Apache Maven (mvn) version not found"
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        else
            echo "  Apache Maven (mvn) version : \"${mvn_version}\"";
            echo "  Apache Maven (mvn) path    : \"${M2_HOME}/bin/mvn\"";
        fi
        unset mvn_version;
    fi


        # -- get Apache ant's version

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then
        ant_path=`which ant 2>/dev/null`;
        if [ "X${ant_path}" = "X" ]; then
            echo "  ERROR:  Apache Ant 'ant' executable not found"
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        else
            ant_version=`(ant -diagnostics 2>/dev/null) | grep --ignore-case 'apache ant.*version' | grep --ignore-case --invert-match '^ant\\.version'`;
            if [ "X${ant_version}" = "X" ]; then
                echo "  ERROR:  Apache Ant (ant) version not found"
                GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
            else
                echo "  Apache Ant   (ant) version : \"${ant_version}\"";
                echo "  Apache Ant   (ant) path is : \"${ant_path}\"";
            fi
            unset ant_version;
        fi
        unset ant_path;
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

    switch_on_old_pull="(presumably) ";
    is_real_ut8mh_env=0;
    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ! -d "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/github_docs_at_UThere8MyHomeworkDgithubDcomScode" ]; then

        switch_on_old_pull="newly pulled ";

        # source . . . script not sourced in -cloned- environment

    fi
    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ] && [ ${is_real_ut8mh_env} = "1" ]; then
        # message if local docs copy succeeded or was already present
        echo "  Local copy of docs repo ${switch_on_old_pull}at : \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/github_docs_at_UThere8MyHomeworkDgithubDcomScode\"";
    fi
    unset switch_on_old_pull;
    unset is_real_ut8mh_env;


        # -- make sure various directories are pulled from github

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        extra_path=""

        echo "  Ensuring Maven-based code is checked out"

        rm --recursive --force "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_c856f53b96a8_"*;

        repo_list=`((echo _maven_UThere8MyHomework_public_repo _maven_UThere8MyHomework_private_repo_and_docs _build_number_gen 0maven 0java | sed --expression 's/\s\+/\n/g' | cat "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc/additional_checkout_repo_list" - ) 2>/dev/null) | sort --unique | sed --expression ':a;N;$!ba;s/\n/ /g'`
        repo_ok=1
        for repo in ${repo_list[@]}; do

            if [ ${repo_ok} = "1" ]; then

                repo_dir="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/${repo}";

                fetch_repo=1;
                if [ ${repo} = "_maven_UThere8MyHomework_private_repo_and_docs" ] && [ ! -f "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/etc/flag_fetch_private_git_repos" ]; then
                    fetch_repo=0;
                fi

                if [ ${fetch_repo} = "1" ]; then

                    repo_dir_tmp="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_c856f53b96a8_${repo}";

                    if [ -d  "${repo_dir}/.git" ]; then
                        echo "    remote repository \"${repo}\" is (presumably) already mapped to local repository \"${repo_dir}\"";
                    else

                        echo "    dealing with remote repository \"${repo}\"";

                        echo "      cloning remote repository \"${repo}\" into \"${repo_dir_tmp}\"";

                        mkdir "${repo_dir_tmp}" 2>/dev/null;
                        if [ "X$?" != "X0" ]; then
                            echo "      ERROR:  could not create directory \"${repo_dir_tmp}\"";
                            repo_ok=0;
                        fi
                        
                        if [ "X${repo_ok}" = "X1" ]; then

                            (cd "${repo_dir_tmp}" && (git clone "git@github.com-ut8mh:UThere8MyHomework/${repo}" . >/dev/null 2>/dev/null))
                            if [ "X$?" != "X0" ]; then
                                echo "      ERROR:  problems cloning remote repository \"${repo}\" to local repository \"${repo_dir_tmp}\"";
                                repo_ok=0;
                            fi
                        fi
                        
                        if [ "X${repo_ok}" = "X1" ]; then

                            echo "      moving cloned repository from \"${repo_dir_tmp}\" to \"${repo_dir}\"";

                            mv "${repo_dir_tmp}" "${repo_dir}" 2>/dev/null;
                            if [ "X$?" != "X0" ]; then
                                echo "      ERROR:  problems moving cloned repository \"${repo_dir_tmp}\" to \"${repo_dir}\"";
                                repo_ok=0;
                            fi
                        fi

                    fi
                fi

                if [ "X${repo_ok}" = "X1" ] && [ -d "${repo_dir}/AUX/bin" ]; then

                    if [ "X${extra_path}" = "X" ]; then
                        extra_path="${repo_dir}/AUX/bin";
                    else
                        extra_path="${extra_path}:${repo_dir}/AUX/bin";
                    fi
                fi

                unset fetch_repo;
                unset repo_dir;
                unset repo_dir_tmp;
            fi

        done
        unset repo_list;
        unset repo;

        if [ ${repo_ok} = "1" ]; then
            echo "  Done ensuring Maven-based code is checked out";
        else
            echo "  ERROR:  there were problems ensuring Maven-based code is checked out";
            GITHUB_UT8MH_DEV_STANDARD_PREP_OK=0;
        fi;

        unset repo_ok;
    fi


        # -- winding up

    echo "==== END preparing the http://github.com/UThere8MyHomework standard Java (et. al.) dev env ====";
    echo;

    if [ "X${GITHUB_UT8MH_DEV_STANDARD_PREP_OK}" = "X1" ]; then

        # modify prompt
        export PS1="_\[\e[1;31m\]c\[\e[1;32m\]8\[\e[1;33m\]i\[\e[1;34m\]o\[\e[1;35m\]n\[\e[0;0m\]_[\u@\h \W]\$ "

        # modify $PATH
        export PATH="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin:${PATH}";
        if [ "X${extra_path}" != "X" ]; then
            export PATH="${PATH}:${extra_path}";
        fi
        if [ -d "${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/bin" ]; then
            export PATH="${PATH}:${GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR}/bin";
        fi
        unset extra_path;

        # no need to keep this
        unset gnu_exec_list;
        unset gnu_exec_keep_in_env_var_list;

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
        "${[A-Z][A-Z]8[A-Z][A-Z]_GNU_BIN_true}";

    else

        unset extra_path;

        unset gnu_exec_list;
        unset gnu_exec_keep_in_env_var_list;

        unset GITHUB_UT8MH_DEV_STANDARD_PREP_OK;
        unset GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED;
        unset GITHUB_UT8MH_DEV_STANDARD_ENV_SETTINGS_DIR;

        for badvar in `( env | sed -e 's/=.*//' | grep [A-Z][A-Z]8[A-Z][A-Z]_GNU_BIN_ ) 2>/dev/null`; do
            unset "${badvar}";
        done
        unset badvar;

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
