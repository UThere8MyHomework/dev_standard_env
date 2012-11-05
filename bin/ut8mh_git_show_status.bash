#!/usr/bin/env bash
#
# Copyright 2012 UThere8MyHomework
#
# FILE:  ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/ut8mh_git_show_status.bash
#
#


if [ "X${GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED}" != "X1" ]; then

    echo "ERROR:  the http://github.com/UThere8MyHomework dev env hasn't been prepared";
    exit 1;

else

    source "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_bash_utils.bash";
    cd "${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}";
    _func_ut8mh_ENSURE_COMMAND_STATUS "change dir to \"\${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}\"" ${?} 1;

    git_repo_list=`find . -name .git -print -prune`;

    for git_repo in ${git_repo_list}; do

        full_dir="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/${git_repo:2:${#git_repo}-6}";
        num_target_dir=`echo ${full_dir} | grep '/target/' | wc --lines`;
        if [ "X${num_target_dir}" = "X0" ]; then

            _func_ut8mh_gen_header "git status \"\${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/${git_repo:2:${#git_repo}-6}\"";

            cd "${full_dir}";
            _func_ut8mh_ENSURE_COMMAND_STATUS "change dir to \"\${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/${git_repo:2:${#git_repo}-6}\"" ${?} 1;

            git status;

        fi

    done

    echo;

fi

exit 0;

# --- END OF FILE.
