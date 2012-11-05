#!/usr/bin/env bash
#
# Copyright 2012 UThere8MyHomework
#
# FILE:  ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/_ut8mh_bash_utils.bash
#
#

function _func_ut8mh_gen_header()
{
    msg="${1}";

    if [[ ${msg} = *${HOME}* ]]; then
        msg="${msg%%${HOME}*}__HOME_DIR__${msg##*${HOME}}";
    fi

    sep=`echo "${msg}" | sed -e 's/./#/g'`;
    sep="#######${sep}#######";
    sep2=`echo "${msg}" | sed -e 's/./ /g'`;
    sep2="#####  ${sep2}  #####";
    echo;
    echo;
    echo "${sep}";
    echo "${sep}";
    echo "${sep2}";
    echo "#####  ${msg}  #####";
    echo "${sep2}";
    echo "${sep}";
    echo "${sep}";
    echo;
    echo;
}

function _func_ut8mh_ENSURE_COMMAND_STATUS()
{
    op_desc="${1}";
    op_status="${2}";
    op_exit_status_if_failed="${3}";
    if [ "X${op_exit_status_if_failed}" = "X" ]; then
        op_exit_status_if_failed=1;
    fi

    if [ "X${op_status}" != "X0" ]; then

        echo "ERROR:  operation failed with status \"${op_status}\", ${op_desc}";
        echo;
        exit ${op_exit_status_if_failed};
    fi
}

alias ut8mh_cd_home="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/.\"";
alias ut8mh_cd_maven_code="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/.\"";
alias ut8mh_cd_0java="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/0java/.\"";
alias ut8mh_cd_0maven="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/0maven/standard_grandparent_project/.\"";
alias ut8mh_cd_docs_local_copy="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/github_docs_at_UThere8MyHomeworkDgithubDcomScode/.\"";
alias ut8mh_cd_public_maven_repo_snapshots="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_maven_UThere8MyHomework_public_repo/raw/snapshots/com/UThere8MyHomework/.\"";
alias ut8mh_cd_public_maven_repo_releases="cd \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_maven_UThere8MyHomework_public_repo/raw/releases/com/UThere8MyHomework/.\"";
alias ut8mh_kill_build_number_and_uuid_vars_script="rm -f \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_build_number_gen/_tmp-cur_build_info.bash_src\"";
alias ut8mh_env_set_build_number_and_uuid_vars="source \"${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_build_number_gen/_tmp_cur_build_info.bash_src\"";
alias ut8mh_env_unset_build_number_and_uuid_vars="unset GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER && unset GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID";
alias ut8mh_env_echo_build_number_var="echo \${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER}";
alias ut8mh_env_echo_build_uuid_var="echo \${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID}";
unalias ut8mh_env 2>/dev/null;


# --- END OF FILE.
