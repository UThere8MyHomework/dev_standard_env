#!/usr/bin/env bash
#
# Copyright 2012 UThere8MyHomework
#
# FILE:  ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/ut8mh_generate_unique_build_number.bash
#
# See also test script file ${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/bin/ut8mh_BNG_test.bash
#


# -------------------
# -- preliminaries --
# -------------------


# -- make sure dev env is set up

if [ "X${GITHUB_UT8MH_DEV_STANDARD_ENV_HAS_BEEN_PREPARED}" != "X1" ]; then

    echo "== ERROR:  the http://github.com/UThere8MyHomework dev env hasn't been prepared ==";
    exit 1;

fi


# -- is this program execution for creating link file, or for actually generating a build number?

is_for_create_link_file=0;
if [ "X${1}" = "X--create-link-file" ]; then
    is_for_create_link_file=1;
fi


# -- make sure environment variables are or aren't set

if [ ${is_for_create_link_file} = "0" ]; then

    if [ "X${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER}" != "X" ]; then
        echo "== ERROR:  environment variable \${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER} is set ==";
        exit 1;
    fi
    if [ "X${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID}" != "X" ]; then
        echo "== ERROR:  environment variable \${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID} is set ==";
        exit 1;
    fi

else

    if [ "X${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER}" = "X" ] || [ "X${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID}" = "X" ]; then
        echo "== ERROR:  one or both environment variables \${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER} or \${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID} are empty/undefined ==";
        exit 1;
    fi

fi


# -- ...

echo


# -- get the master git repository (central repository that holds build numbers and build-related meta-info)

if [ "X${master_git_repo}" = "X" ]; then
    master_git_repo="git@github.com-ut8mh:UThere8MyHomework/_build_number_gen.git";
fi
echo "== central git repo used for generating build numbers is at \"${master_git_repo}\" ==";


# -- get the name of the local directory that will clone and modify the central repository,
#    make sure its parent is 'valid'

if [ "X${git_repo_dir}" = "X" ]; then
    # outside testing program might set 'git_repo_dir' to alternate directory ... we don't want to corrupt the real repo
    git_repo_dir="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code/_build_number_gen";
    git_repo_dir_parent="${GITHUB_UT8MH_DEV_STANDARD_ENV_HOME}/maven_based_code";
else
    # make sure ${git_repo_dir} parent path exists
    while [ "X${git_repo_dir:${#git_repo_dir}-1}" = "X/" ]; do
        git_repo_dir="${git_repo_dir:0:${#git_repo_dir}-1}";
    done
    git_repo_dir_parent="${git_repo_dir%/*}"
    while [ "X${git_repo_dir_parent:${#git_repo_dir_parent}-1}" = "X/" ]; do
        git_repo_dir_parent="${git_repo_dir_parent%/}";
    done
    if [ "X${git_repo_dir_parent}" = "X" ]; then
        echo "== ERROR:  alternate specified \${git_repo_dir}'s parent directory resolved down to an empty string ==";
        exit 1;
    fi
    git_repo_dir=`echo "${git_repo_dir}" | sed -e 's/\/\/*/\//g'`;
    git_repo_dir_parent=`echo "${git_repo_dir_parent}" | sed -e 's/\/\/*/\//g'`;
fi
echo "== directory used for local copy of the git repo is at \"${git_repo_dir}\" ==";
echo "==                              ... with parent at ... \"${git_repo_dir_parent}\" ==";

if [ "X${test_switch__quit_after_verifying_git_repo_dir}" = "X1" ]; then
    echo "== WARNING:  quitting prematurely due to \${test_switch__quit_after_verifying_git_repo_dir} flag ==";
    exit 0;
fi


# -- make sure we can switch to the repository directory

cd "${git_repo_dir}${test_switch__force_fail_switch_to_git_repo_dir}" 2>/dev/null;
status=$?;
if [ "X${status}" != "X0" ]; then
    echo "== ERROR:  couldn't switch to directory \"${git_repo_dir}\" ==";
    exit 1;
fi


# -----------------------------------------------------------------------------
# -- we might be trying to write link content ... deal with that possibility --
# -----------------------------------------------------------------------------

if [ ${is_for_create_link_file} = "1" ]; then

    # NOTE:  the content in this if-clause is not as thoroughly tested as the other, trickier stuff (other stuff
    # has concurrency issues)

    echo "== creating link file ==";

    link_to_relative_to_ut8mh_home="${2}";
    label="${3}";

    dir_for_link="./built_product_info/20${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER:0:2}/20${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER:0:2}_${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER:2:2}";
    fname="20${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER:0:2}_${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER:2:2}_${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER:4:2}__${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER}";
    if [ "X${label}" != "X" ]; then
        fname="${fname}__${label}";
    fi
    fname="${fname}.htm";
    echo "  link file directory   :  ${dir_for_link}";
    echo "  link file             :  ${fname}";
    mkdir --parents "${dir_for_link}";
    fname="${dir_for_link}/${fname}";
    echo "<ul>" > "${fname}";
    echo "  <li>GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER=\"${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER}\"</li>" >> "${fname}";
    echo "  <li>GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID=\"${GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID}\"</li>" >> "${fname}";
    if [ "X${label}" != "X" ]; then
        echo "  <li>label=\"${label}\"</li>" >> "${fname}";
    fi
    label2="${label}";
    link="";
    if [ "X${link_to_relative_to_ut8mh_home}" != "X" ]; then
        link="${link_to_relative_to_ut8mh_home}";
        if [ "X${label2}" = "X" ]; then
            label2="_";
        fi
        echo "  <li><a href=\"../../../../../${link}\">${label2}</a></li>" >> "${fname}";
    fi
    echo "</ul>" >> "${fname}";

    if [ ! -e ./_tmp_cur_build_info.bash_src ]; then
        echo "== ERROR:  did not find expected file ./_tmp_cur_build_info.bash_src ==";
        exit 9;
    fi
    (cat ./_tmp_cur_build_info.bash_src | grep --invert-match GITHUB_UT8MH_DEV__TMP__CUR_BUILD_TAG | grep --invert-match GITHUB_UT8MH_DEV__TMP__CUR_BUILD_LINK) > ./_TMP_tmp_cur_build_info.bash_src;
    rm --force ./_tmp_cur_build_info.bash_rc;
    echo "export GITHUB_UT8MH_DEV__TMP__CUR_BUILD_LABEL=\"${label}\"" >> ./_TMP_tmp_cur_build_info.bash_src;
    echo "export GITHUB_UT8MH_DEV__TMP__CUR_BUILD_LINK=\"${link}\"" >> ./_TMP_tmp_cur_build_info.bash_src;
    mv ./_TMP_tmp_cur_build_info.bash_src ./_tmp_cur_build_info.bash_src;
    if [ ! -e ./_tmp_cur_build_info.bash_src ] || [ -e ./_TMP_tmp_cur_build_info.bash_src ]; then
        echo "== ERROR:  did not successfully rename ./_TMP_tmp_cur_build_info.bash_src to ./_tmp_cur_build_info.bash_src ==";
        exit 9;
    fi

    echo "== succeeded ==";
    echo;

    exit 0;

fi


# --------------------------------------------------------------------------------
# -- run through attempts to generate build number several times until it works --
# --------------------------------------------------------------------------------


GEN_UNIQUE_BUILD_NUMBER_TIMES=`echo "${GEN_UNIQUE_BUILD_NUMBER_TIMES}" | sed -e 's/[^0-9]//g'`;
if [ "X${GEN_UNIQUE_BUILD_NUMBER_TIMES}" = "X" ]; then
    GEN_UNIQUE_BUILD_NUMBER_TIMES=5;
fi

ok=1;
permanent_failure=0;
i=1;
while [ ${i} -le ${GEN_UNIQUE_BUILD_NUMBER_TIMES} ]; do

    echo;
    echo "==============================================================";
    echo "===== starting attempt ${i} of ${GEN_UNIQUE_BUILD_NUMBER_TIMES} to generate a build number =====";
    echo "==============================================================";
    echo;

    ok=1;

    if [ "X${ok}" = "X1" ]; then

        rm --force ./{,_TMP}_tmp_cur_build_info.bash_src${test_switch__force_fail_delete_tmp_cur_build_info_bash_src} 2>/dev/null;
        if [ -e "./_tmp_cur_build_info.bash_src" ] || [ -e "./_TMP_tmp_cur_build_info.bash_src" ]; then
            echo "== ERROR:  failed to remove current version file ./_tmp_cur_build_info.bash_src (or temporary copy) ==";
            ok=0;
            permanent_failure=1;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        rm --force ./cur_build_uuid.txt${test_switch__force_fail_delete_cur_build_uuid_txt} 2>/dev/null;
        if [ -e "./cur_build_uuid.txt" ]; then
            echo "== ERROR:  failed to remove current version file ./cur_build_uuid.txt ==";
            ok=0;
            permanent_failure=1;
        fi
    fi

    if  [ "X${ok}" = "X1" ] && [ ${i} -gt 1 ]; then
        echo "== erasing partial results from prior failed attempt in git repo copy \"${git_repo_dir}\" ==";
        rm${test_switch__force_fail_delete_prior_partial_results} --recursive --force ./.gitignore ./* >/dev/null 2>&1;
        status=$?;
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  failed to erase partial results from prior failed attempt ==";
            ok=0;
            permanent_failure=1;
        fi
    fi
    if  [ "X${ok}" = "X1" ] && [ ${i} -gt 1 ]; then
        echo "== restoring git repo copy \"${git_repo_dir}\" to match central repo ==";
        git${test_switch__force_fail_restore_git_repo_to_central_state_1} reset --hard HEAD >/dev/null 2>&1;
        status=$?;
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  failed to restore local copy to central repo state [1] ==";
            ok=0;
            permanent_failure=1;
        fi
    fi
    if  [ "X${ok}" = "X1" ] && [ ${i} -gt 1 ]; then
        # DO_NOT:  echo "== ... ==";
        git${test_switch__force_fail_restore_git_repo_to_central_state_2} fetch >/dev/null 2>&1;
        status=$?;
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  failed to restore local copy to central repo state [2] ==";
            ok=0;
            permanent_failure=1;
        fi
    fi
    if  [ "X${ok}" = "X1" ] && [ ${i} -gt 1 ]; then
        # DO_NOT:  echo "== ... ==";
        git${test_switch__force_fail_restore_git_repo_to_central_state_3} merge --strategy-option theirs origin >/dev/null 2>&1;
        status=$?;
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  failed to restore local copy to central repo state [3] ==";
            ok=0;
            permanent_failure=1;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== ensuring directory \"${git_repo_dir}\" is a proper git repo copy ==";
        git status . >/dev/null 2>&1;
        status=$?;
        if [ "X${test_switch__rename_dot_git_dir_1}" != "X" ]; then
            if [ ! -d ./.git ]; then
                echo "== ERROR:  weird unexpected condition, \"${git_repo_dir}/.git\" does not exist ==";
                exit 9;
            fi
            mv ./.git ./.git2
        fi
        if [ "X${status}" != "X0" ] || [ ! -d ./.git ]; then

            # NOTE:  used the ./.git test because if, for some reason .git is missing, git might treat this directory as a potential
            # thing to be added to an ancestor directory that itself is a local copy of a git repo

            echo "== ERROR:  directory \"${git_repo_dir}\" is not a proper git repo copy ==";
            ok=0;
            permanent_failure=0;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== ensuring the directory has no uncommitted changes ==";
        num_modified=`git status --short 2>&1 | wc${test_switch__fail_wc_1} --lines 2>/dev/null`;
        status=$?;
        if [ "X${status}" != "X0" ] || [ "X${num_modified}" != "X0" ]; then
            git status 2>&1 | sed -e 's/^/  /';
            echo "== ERROR:  the directory has uncommitted changes (or there were problems figuring this out) ... build-number generation will not proceed without manual intervention ==";
            ok=0;
            permanent_failure=1;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== pulling latest build number info from github ==";
        git${test_switch__fail_git_1} pull 2>&1 | sed -e 's/^/  /';
        status=${PIPESTATUS[0]};
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  failed to pull latest build number info from github ==";
            ok=0;
            permanent_failure=0;
        elif [ "X${test_switch__quit_after_pulling_central_changes}" = "X1" ]; then
            echo "== WARNING:  quitting prematurely due to \${test_switch__quit_after_pulling_central_changes} flag ==";
            exit 0;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== getting last official build number ==";

        LAST_BUILD_NUMBER=`cat ./proposed_cur_build_number.txt`;

        if [ ${#LAST_BUILD_NUMBER} -ne 9 ]; then
            echo "== ERROR:  the last build number from ./proposed_cur_build_number.txt is \"${LAST_BUILD_NUMBER}\" and has unexpected form/length ==";
            ok=0;
            permanent_failure=1;
        else
            echo "== the last build number from ./proposed_cur_build_number.txt is \"${LAST_BUILD_NUMBER}\" ==";
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        BUILD_NUMBER_BASE=`date${test_switch__fail_date_1} -u +%y%m%d 2>/dev/null`;

        if [ ${#BUILD_NUMBER_BASE} -ne 6 ]; then
            echo "== ERROR:  getting a build-number-base failed, weirdness with 'date -u +%y%m%d' output \"${BUILD_NUMBER_BASE}\" ==";
            ok=0;
            permanent_failure=1;
        fi

        if [ "X${test_switch__substitute_date}" != "X" ]; then
            BUILD_NUMBER_BASE="${test_switch__substitute_date}";
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        NEXT_BUILD_NUMBER_FOR_DAY="001"

        if [ ${BUILD_NUMBER_BASE} = ${LAST_BUILD_NUMBER:0:6} ]; then
            WITHIN_DAY=`echo "${LAST_BUILD_NUMBER:6:3}" | sed -e 's/^0*//g'`;
            let NEXT_BUILD_NUMBER_FOR_DAY=$WITHIN_DAY+1
            if [ ${NEXT_BUILD_NUMBER_FOR_DAY} -gt 999 ]; then
                echo "== ERROR:  unexpectedly reached '999' limit on next build number for the day ==";
                ok=0
                permanent_failure=1;
            else
                if [ ${NEXT_BUILD_NUMBER_FOR_DAY} -lt 10 ]; then
                    NEXT_BUILD_NUMBER_FOR_DAY="00${NEXT_BUILD_NUMBER_FOR_DAY}"
                elif [ ${NEXT_BUILD_NUMBER_FOR_DAY} -lt 100 ]; then
                    NEXT_BUILD_NUMBER_FOR_DAY="0${NEXT_BUILD_NUMBER_FOR_DAY}"
                fi
                NEXT_BUILD_NUMBER="${BUILD_NUMBER_BASE}${NEXT_BUILD_NUMBER_FOR_DAY}";
                echo "== incrementing same-day (UTC) build number to \"${NEXT_BUILD_NUMBER}\" ==";
            fi
        elif [ ${BUILD_NUMBER_BASE} -lt ${LAST_BUILD_NUMBER:0:6} ]; then
            echo "== ERROR:  unexpectedly found there's an existing version number from a future day, \"${LAST_BUILD_NUMBER:0:6}\", today \"${BUILD_NUMBER_BASE}\" ==";
            ok=0;
            permanent_failure=1;
        else
            NEXT_BUILD_NUMBER="${BUILD_NUMBER_BASE}${NEXT_BUILD_NUMBER_FOR_DAY}";
            echo "== starting new-day (UTC) build number to be \"${NEXT_BUILD_NUMBER}\" ==";
        fi

        if [ "X${ok}" = "X1" ] && [ "X${test_switch__quit_after_computing_next_build_number}" = "X1" ]; then
            echo "== WARNING:  quitting prematurely due to \${test_switch__quit_after_computing_next_build_number} flag ==";
            exit 0;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== writing new build number as proposal to ./proposed_cur_build_number.txt ==";
        if [ "X${test_switch__force_fail_write_proposed_cur_build_number_txt}" != "X" ]; then
            chmod 000 ./proposed_cur_build_number.txt;
        fi
        echo "${NEXT_BUILD_NUMBER}" >./proposed_cur_build_number.txt 2>/dev/null;
        status=$?;
        if [ "X${test_switch__force_fail_write_proposed_cur_build_number_txt}" != "X" ]; then
            chmod 777 ./proposed_cur_build_number.txt;
        fi
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  couldn't write new build number to ./proposed_cur_build_number.txt ==";
            ok=0;
            permanent_failure=1;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== generating a new uuid for this build ==";
        build_uuid=`(echo $$ ${HOSTNAME} ${USER} ; date -u ) | sha1sum | sed -e 's/[ -]//g'`;
        if [ "X${test_switch__force_fail_generate_uuid}" != "X" ];then
            build_uuid="";
        fi
        if [ "X${build_uuid}" = "X" ]; then
            echo "== ERROR:  couldn't generate a new uuid for this build ==";
            ok=0;
            permanent_failure=1;
        else
            echo "== writing new uuid for this build as proposal to ./proposed_cur_build_uuid.txt ==";
            if [ "X${test_switch__force_fail_write_proposed_cur_build_uuid}" != "X" ]; then
                chmod 000 ./proposed_cur_build_uuid.txt;
            fi
            echo "${build_uuid}" >./proposed_cur_build_uuid.txt 2>/dev/null;
            status=$?;
            if [ "X${test_switch__force_fail_write_proposed_cur_build_uuid_txt}" != "X" ]; then
                chmod 777 ./proposed_cur_build_uuid.txt;
            fi
            if [ "X${status}" != "X0" ]; then
                echo "== ERROR:  couldn't write new uuid for this build to ./proposed_cur_build_uuid.txt ==";
                ok=0;
                permanent_failure=1;
            fi
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "== committing locally the new build number and uuid ==";
        git${test_switch__fail_git_2} add ./proposed_cur_build_number.txt ./proposed_cur_build_uuid.txt >/dev/null 2>&1;
        status=$?;
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  couldn't commit locally the new build number and uuid [1] ==";
            ok=0;
            permanent_failure=0;
        else
            git${test_switch__fail_git_3} commit -m "new build_number=${NEXT_BUILD_NUMBER} and uuid=${build_uuid}" >/dev/null 2>&1;
            status=$?;
            if [ "X${status}" != "X0" ]; then
                echo "== ERROR:  couldn't commit locally the new build number and uuid [2] ==";
                ok=0;
                permanent_failure=0;
            fi
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        echo "export GITHUB_UT8MH_DEV__TMP__CUR_BUILD_NUMBER=\"${NEXT_BUILD_NUMBER}\"" > ./_TMP_tmp_cur_build_info.bash_src
        echo "export GITHUB_UT8MH_DEV__TMP__CUR_BUILD_UUID=\"${build_uuid}\"" >> ./_TMP_tmp_cur_build_info.bash_src
        mv ./_TMP_tmp_cur_build_info.bash_src ./_tmp_cur_build_info.bash_src
        if [ ! -e "./_tmp_cur_build_info.bash_src${test_switch__force_fail_write_tmp_cur_build_info_bash_src}" ] || [ -e "./_TMP_tmp_cur_build_info.bash_src" ]; then
            echo "== ERROR:  failed to write generated build number info to bash-soruce-able file ./_tmp_cur_build_info.bash_src ==";
            ok=0;
            permanent_failure=1;
        fi
    fi

    if [ "X${ok}" = "X1" ]; then

        if [ "X${sleep_before_push}" != "X" ]; then
            # during testing for conflict-during-push the instance that succeeds will sleep for a while here
            echo "  sleeping before push for ${sleep_before_push} seconds";
            sleep ${sleep_before_push};
        fi

        showed_delay_msg=0;
        while [ -f ./delay_push_while_this_file_exists.txt ]; do
            # during testing for conflict-during-push the instance that fails will pause here until the other one succeeds
            if [ ${showed_delay_msg} = "0" ]; then
                echo "  delaying push until ./delay_push_while_this_file_exists.txt file is removed";
                showed_delay_msg=1
            fi
            sleep 1;
        done

        echo "== pushing local changes to github ==";
        git push 2>&1 | sed -e 's/^/  /';
        status=${PIPESTATUS[0]};
        if [ "X${status}" != "X0" ]; then
            echo "== ERROR:  failed to push local build number info to github ==";
            ok=0;
            permanent_failure=0;        # yes, we do want to try again
        fi
    fi

    let i=i+1;

    echo;

    if [ "X${ok}" = "X1" ]; then

        echo "==========================================================";
        echo "===== succeeded in attempt to generate a build number ====";
        echo "==========================================================";

        let i=${GEN_UNIQUE_BUILD_NUMBER_TIMES}+1;

    else

        echo "==========================================================";
        echo "===== FAILED in attempt to generate a build number =======";
        if [ ${permanent_failure} = "1" ]; then
            echo "=====    (this is a 'permanent' failure)           =======";
            let i=${GEN_UNIQUE_BUILD_NUMBER_TIMES}+1;
        fi
        if [ ${i} -le ${GEN_UNIQUE_BUILD_NUMBER_TIMES} ]; then
            echo "=====    (WILL TRY AGAIN)                          =======";
            if [ "X${test_switch__quit_even_if_not_permanent_failure}" != "X" ]; then
                echo "=====    actually, will not try again, for testing =======";
                let i=${GEN_UNIQUE_BUILD_NUMBER_TIMES}+1;
            fi
        else
            echo "=====    (WILL NOT TRY AGAIN)                      =======";
        fi
        echo "==========================================================";
    fi

done

echo;

if [ "X${ok}" = "X1" ]; then
    exit 0;
else
    exit 1;
fi


# --- END OF FILE.
