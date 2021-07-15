#!/usr/bin/env bash

#Build 20210712-003

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh

## 预设的仓库及默认调用仓库设置
## 将"repo=$repo1"改成repo=$repo2"或其他，以默认调用其他仓库脚本日志
## 也可自行搜索本脚本内的"name_js=("和"name_js_only",将"repo"改成"repo2"或其他，用以自由组合调用仓库的脚本日志
repo1='panghu999_jd_scripts'                       #预设的 panghu999 仓库
repo2='JDHelloWorld_jd_scripts'                    #预设的 JDHelloWorld 仓库
repo3='he1pu_JDHelp'                               #预设的 he1pu 仓库
repo4='shufflewzc_faker2'                          #预设的 shufflewzc 仓库
repo5='Wenmoux_scripts_wen_chinnkarahoi'           #预设的 Wenmoux 仓库，用于读取口袋书店互助码。需提前拉取温某人的仓库或口袋书店脚本并完整运行。
repo=$repo1                                        #默认调用 panghu999 仓库脚本日志

## 调试模式开关，默认是0，表示关闭；设置为1，表示开启
DEBUG="1"

## 备份配置文件开关，默认是1，表示开启；设置为0，表示关闭。备份路径 /ql/config/bak/
BACKUP="1"
## 是否删除指定天数以前的备份文件开关，默认是1，表示开启；设置为0，表示关闭。删除路径 /ql/config/bak/
CLEANBAK="1"
## 定义删除指定天数以前的备份文件
CLEANBAK_DAYS="2"

## 定义 jcode 脚本导出的互助码模板样式（选填）
## 不填 使用“按编号顺序互助模板”，Cookie编号在前的优先助力
## 填 0 使用“全部一致互助模板”，所有账户要助力的码全部一致
## 填 1 使用“均等机会互助模板”，所有账户获得助力次数一致
## 填 2 使用“随机顺序互助模板”，本套脚本内账号间随机顺序助力，每次生成的顺序都不一致。
HelpType="1"

## 定义指定活动采用指定的互助模板。
## 设定值为 DiyHelpType="1" 表示启用功能；不填或填其他内容表示不开启功能。
## 如果只是想要控制某个活动以执行某种互助规则，可以参考下面 case 这个命令的例子来控制
## 活动名称参见 name_config 定义内容；具体可在本脚本中搜索 name_config=( 获悉
DiyHelpType="0"
diy_help_rules(){
    case $1 in
        Fruit)
            tmp_helptype="0"            # 东东农场使用“全部一致互助模板”，所有账户要助力的码全部一致
            ;;
        DreamFactory | JdFactory)
            tmp_helptype="1"            # 京喜工厂和东东工厂使用“均等机会互助模板”，所有账户获得助力次数一致
            ;;
        Jdzz | Joy)
            tmp_helptype="2"            # 京东赚赚和疯狂的Joy使用“随机顺序互助模板”，本套脚本内账号间随机顺序助力，每次生成的顺序都不一致。
            ;;
        *)
            tmp_helptype=$HelpType      # 其他活动仍按默认互助模板生产互助规则。
            ;;
    esac
}

## 定义屏蔽模式。被屏蔽的账号将不被助力，被屏蔽的账号仍然可以助力其他账号。
## 设定值为 BreakHelpType="1" 表示启用屏蔽模式；不填或填其他内容表示不开启功能。
## 自定义屏蔽账号序号或序号区间。当 BreakHelpType="1"时生效。
## 设定值为一个或多个不相同正整数，每个正整数不大于账号总数；也可以设置正整数区间，最大正整数不大于账号总数；
## 如：a) 设定为 BreakHelpNum="3" 表示第 3 个账号不被助力；
##     b) 设定为 BreakHelpNum="5 7 8 10" 表示第 5 7 8 10 个账号均不被助力；
##     c) 设定为 BreakHelpNum="6-12" 表示从第 6 至 12 个账号均不被助力；
##     d) 设定为 BreakHelpNum="4 9-14 15~18 19_21" 表示第4个账号、第9至14账号、第15至18账号、第19至21账号均不被助力。注意序号区间连接符仅支持 - ~ _；
## 不按示例填写可能引发报错。
BreakHelpType="0"                  ## 屏蔽模式
BreakHelpNum="4 9-14 15~18 19_21"  ## 屏蔽账号序号或序号区间

## 定义是否自动更新配置文件中的互助码和互助规则，默认为1，表示更新；留空或其他数值表示不更新。
UpdateType="1"

## 需组合的环境变量列表，env_name需要和var_name一一对应，如何有新活动按照格式添加(不懂勿动)
env_name=(
  FRUITSHARECODES
  PETSHARECODES
  PLANT_BEAN_SHARECODES
  DREAM_FACTORY_SHARE_CODES
  DDFACTORY_SHARECODES
  JDJOY_SHARECODES
  JDZZ_SHARECODES
  JXNC_SHARECODES
  BOOKSHOP_SHARECODES
  JD_CASH_SHARECODES
  JDSGMH_SHARECODES
  JDCFD_SHARECODES
  JDHEALTH_SHARECODES
  JD818_SHARECODES
  CITY_SHARECODES
  JXNCTOKENS
)
var_name=(
  ForOtherFruit
  ForOtherPet
  ForOtherBean
  ForOtherDreamFactory
  ForOtherJdFactory
  ForOtherJoy
  ForOtherJdzz
  ForOtherJxnc
  ForOtherBookShop
  ForOtherCash
  ForOtherSgmh
  ForOtherCfd
  ForOtherHealth
  ForOtherCarni
  ForOtherCity
)

## name_js为脚本文件名，如果使用ql repo命令拉取，文件名含有作者名
## 所有有互助码的活动，把脚本名称列在 name_js 中，对应 config.sh 中互助码后缀列在 name_config 中，中文名称列在 name_chinese 中。
## name_js、name_config 和 name_chinese 中的三个名称必须一一对应。
name_js=(
  "$repo"_jd_fruit
  "$repo"_jd_pet
  "$repo"_jd_plantBean
  "$repo"_jd_dreamFactory
  "$repo"_jd_jdfactory
  "$repo"_jd_crazy_joy
  "$repo"_jd_jdzz
  "$repo"_jd_jxnc
  "$repo5"_jd_bookshop
  "$repo"_jd_cash
  "$repo"_jd_sgmh
  "$repo"_jd_cfd
  "$repo"_jd_health
  "$repo"_jd_carnivalcity
  "$repo"_jd_city
)

name_config=(
  Fruit
  Pet
  Bean
  DreamFactory
  JdFactory
  Joy
  Jdzz
  Jxnc
  BookShop
  Cash
  Sgmh
  Cfd
  Health
  Carni
  City
)

name_chinese=(
  东东农场
  东东萌宠
  京东种豆得豆
  京喜工厂
  东东工厂
  crazyJoy任务
  京东赚赚
  京喜农场
  口袋书店
  签到领现金
  闪购盲盒
  京喜财富岛
  东东健康社区
  京东手机狂欢城
  城城领现金
)

#仅输出互助码的环境变量
name_js_only=(
  "$repo"_jd_cfd
)

name_config_only=(
  TokenJxnc
)

name_chinese_only=(
  京喜token
)

## 生成pt_pin清单
gen_pt_pin_array() {
  local envs=$(eval echo "\$JD_COOKIE")
  local array=($(echo $envs | sed 's/&/ /g'))
  local tmp1 tmp2 i pt_pin_temp
  for i in "${!array[@]}"; do
    pt_pin_temp=$(echo ${array[i]} | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|; s|%|\\\x|g}")
    [[ $pt_pin_temp == *\\x* ]] && pt_pin[i]=$(printf $pt_pin_temp) || pt_pin[i]=$pt_pin_temp
  done
}

## 导出互助码的通用程序，$1：去掉后缀的脚本名称，$2：config.sh中的后缀，$3：活动中文名称
export_codes_sub() {
    local task_name=$1
    local config_name=$2
    local chinese_name=$3
    local config_name_my=My$config_name
    local config_name_for_other=ForOther$config_name
    local tmp_helptype=$HelpType
    local BreakHelpInterval=$(echo $BreakHelpNum | perl -pe "{s|~|-|; s|_|-|}" | sed 's/\(\d\+\)-\(\d\+\)/{\1..\2}/g')
    local BreakHelpNumArray=($(eval echo $BreakHelpInterval))
    local BreakHelpNumVerify=$(echo $BreakHelpNum | sed 's/ //g' | perl -pe "{s|-||; s|~||; s|_||}" | sed 's/^\d\+$//g')
    local i j k m n t pt_pin_in_log code tmp_grep tmp_my_code tmp_for_other user_num random_num_list
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    local user_sum=${#array[*]}
    if cd $dir_log/$task_name &>/dev/null && [[ $(ls) ]]; then
        ## 寻找所有互助码以及对应的pt_pin
        i=0
        pt_pin_in_log=()
        code=()
        pt_pin_and_code=$(ls -r *.log | xargs awk -v var="的$chinese_name好友互助码" 'BEGIN{FS="[（ ）】]+"; OFS="&"} $3~var {print $2,$4}')
        for line in $pt_pin_and_code; do
            pt_pin_in_log[i]=$(echo $line | awk -F "&" '{print $1}')
            code[i]=$(echo $line | awk -F "&" '{print $2}')
            let i++
        done

        ## 输出My系列变量
        if [[ ${#code[*]} -gt 0 ]]; then
            for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                tmp_my_code=""
                j=$((m + 1))
                for ((n = 0; n < ${#code[*]}; n++)); do
                    if [[ ${pt_pin[m]} == ${pt_pin_in_log[n]} ]]; then
                        tmp_my_code=${code[n]}
                        break
                    fi
                done
                echo "$config_name_my$j='$tmp_my_code'"
            done
        else
            echo "## 从日志中未找到任何互助码"
        fi

        ## 输出ForOther系列变量
        if [[ ${#code[*]} -gt 0 ]]; then
            [[ $DiyHelpType = "1" ]] && diy_help_rules $2
            case $tmp_helptype in
            0) ## 全部一致
                HelpTemp="全部一致"
                echo -e "\n## 采用\"$HelpTemp\"互助模板："
                tmp_for_other=""
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    j=$((m + 1))
                    if [ $BreakHelpType = 1 ]; then
                        if [ "$BreakHelpNumVerify" = "" ]; then
                            for ((t = 0; t < ${#BreakHelpNumArray[*]}; t++)); do
                                [[ "${BreakHelpNumArray[t]}" = "$j" ]] && continue 2
                            done
                            tmp_for_other="$tmp_for_other@\${$config_name_my$j}"
                        else
                            echo -e "\n#$cur_time 变量值填写不规范，请检查后重试！"
                            tmp_for_other="$tmp_for_other@\${$config_name_my$j}"
                        fi
                    else
                        tmp_for_other="$tmp_for_other@\${$config_name_my$j}"
                    fi
                done
                echo "${config_name_for_other}1=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                for ((m = 1; m < ${#pt_pin[*]}; m++)); do
                    j=$((m + 1))
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            1) ## 均等助力
                HelpTemp="均等助力"
                echo -e "\n## 采用\"$HelpTemp\"互助模板："
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    j=$((m + 1))
                    for ((n = $m; n < $(($user_sum + $m)); n++)); do
                        [[ $m -eq $n ]] && continue
                        if [[ $((n + 1)) -le $user_sum ]]; then
                            k=$((n + 1))
                        else
                            k=$((n + 1 - $user_sum))
                        fi
                        if [ $BreakHelpType = 1 ]; then
                            if [ "$BreakHelpNumVerify" = "" ]; then
                                for ((t = 0; t < ${#BreakHelpNumArray[*]}; t++)); do
                                    [[ "${BreakHelpNumArray[t]}" = "$k" ]] && continue 2
                                done
                                tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                            else
                                echo -e "\n#$cur_time 变量值填写不规范，请检查后重试！"
                                tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                            fi
                        else
                            tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                        fi
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            2) ## 本套脚本内账号间随机顺序助力
                HelpTemp="随机顺序"
                echo -e "\n## 采用\"$HelpTemp\"互助模板："
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    random_num_list=$(seq $user_sum | sort -R)
                    j=$((m + 1))
                    for n in $random_num_list; do
                        [[ $j -eq $n ]] && continue
                        if [ $BreakHelpType = 1 ]; then
                            if [ "$BreakHelpNumVerify" = "" ]; then
                                for ((t = 0; t < ${#BreakHelpNumArray[*]}; t++)); do
                                    [[ "${BreakHelpNumArray[t]}" = "$n" ]] && continue 2
                                done
                                tmp_for_other="$tmp_for_other@\${$config_name_my$n}"
                            else
                                echo -e "\n#$cur_time 变量值填写不规范，请检查后重试！"
                                tmp_for_other="$tmp_for_other@\${$config_name_my$n}"
                            fi
                        else
                            tmp_for_other="$tmp_for_other@\${$config_name_my$n}"
                        fi
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            *) ## 按编号优先
                HelpTemp="按编号优先"
                echo -e "\n## 采用\"$HelpTemp\"互助模板"
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    j=$((m + 1))
                    for ((n = 0; n < ${#pt_pin[*]}; n++)); do
                        [[ $m -eq $n ]] && continue
                        k=$((n + 1))
                        if [ $BreakHelpType = 1 ]; then
                            if [ "$BreakHelpNumVerify" = "" ]; then
                                for ((t = 0; t < ${#BreakHelpNumArray[*]}; t++)); do
                                    [[ "${BreakHelpNumArray[t]}" = "$k" ]] && continue 2
                                done
                                tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                            else
                                echo -e "\n#$cur_time 变量值填写不规范，请检查后重试！"
                                tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                            fi
                        else
                            tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                        fi
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;
            esac
        fi
    else
        echo "#$cur_time 未运行过 $task_name.js 脚本，未产生日志"
    fi
}

## 汇总输出
export_all_codes() {
    gen_pt_pin_array
    [[ $DEBUG = "1" ]] && echo -e "\n#$cur_time 当前 code.sh 的线程数量：$ps_num"
    [[ $DEBUG = "1" ]] && echo -e "\n#$cur_time 预设的 JD_COOKIE 数量：`echo $JD_COOKIE | grep -o 'pt_key' | wc -l`"
    [[ $DEBUG = "1" ]] && echo -e "\n#$cur_time 预设的 JD_COOKIE 环境变量数量：`echo $JD_COOKIE | sed 's/&/\n/g' | wc -l`"
    [[ $DEBUG = "1" && "$(echo $JD_COOKIE | sed 's/&/\n/g' | wc -l)" = "1" && "$(echo $JD_COOKIE | grep -o 'pt_key' | wc -l)" -gt 1 ]] && echo -e "\n#$cur_time 检测到您将多个 COOKIES 填写到单个环境变量值，请注意将各 COOKIES 采用 & 分隔，否则将无法完整输出互助码及互助规则！"
    echo -e "\n#$cur_time 从日志提取互助码，编号和配置文件中Cookie编号完全对应，如果为空就是所有日志中都没有。\n\n#$cur_time 即使某个MyXxx变量未赋值，也可以将其变量名填在ForOtherXxx中，jtask脚本会自动过滤空值。\n"
    if [ $DiyHelpType = "1" ]; then
        echo -e "#$cur_time 您已启用指定活动采用指定互助模板功能！"
    else
        echo -n "#$cur_time 您选择的互助码模板为："
        case $HelpType in
        0)
            echo "所有账号助力码全部一致。"
            ;;
        1)
            echo "所有账号机会均等助力。"
            ;;
        2)
            echo "本套脚本内账号间随机顺序助力。"
            ;;
    	*)
            echo "按账号编号优先。"
            ;;
        esac
    fi
    [[ $BreakHelpType = 1 ]] && echo -e "\n#$cur_time 您已启用屏蔽模式，账号 $BreakHelpNum 将不被助力！"
    if [ "$ps_num" -gt 7 ]; then
        echo -e "\n#$cur_time 检测到 code.sh 的线程过多 ，请稍后再试！"
        exit
    elif [ -z $repo ]; then
        echo -e "\n#$cur_time 未检测到兼容的活动脚本日志，无法读取互助码，退出！"
        exit
    else
        echo -e "\n#$cur_time 默认调用 $repo 的脚本日志，格式化导出互助码，生成互助规则！"
        dump_user_info
        for ((i = 0; i < ${#name_js[*]}; i++)); do
        echo -e "\n## ${name_chinese[i]}："
        export_codes_sub "${name_js[i]}" "${name_config[i]}" "${name_chinese[i]}"
        done
        for ((i = 0; i < ${#name_js_only[*]}; i++)); do
            echo -e "\n## ${name_chinese_only[i]}："
            export_codes_sub_only "${name_js_only[i]}" "${name_config_only[i]}" "${name_chinese_only[i]}"
        done
    fi
}

#更新配置文件中互助码的函数
help_codes_rules(){
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
local config_name=$1
local config_name_my=My$config_name
local config_name_for_other=ForOther$config_name
local i j k

#更新配置文件中的互助码
if [ -z "$(cat $file_task_before | grep "^$config_name_my\d")" ]; then
   echo -e "\n${config_name_my}1=''\n" >> $file_task_before
fi
for ((i=1; i<=100; i++)); do
    if [[ $i -le $user_sum ]] && [[ ! -z "$(cat $log_path | grep "^$config_name_my$i=.*'$")" ]]; then
        new_code="$(cat $log_path | grep "^$config_name_my$i=.*'$" | sed "s/.*'\(.*\)'.*/\1/")"
        old_code="$(cat $file_task_before | grep "^$config_name_my$i=.*'$" | sed "s/.*'\(.*\)'.*/\1/")"
        if [ -z "$(grep "^$config_name_my$i" $file_task_before)" ]; then
            sed -i "/^$config_name_my$[$i-1]='.*'/ s/$/\n$config_name_my$i=\'\'/" $file_task_before
        fi
        if [ "$new_code" != "$old_code" ]; then
#            if [ $1 = "BookShop" ]; then
#                if [[ "$new_code" != "undefined" ]] && [[ "$new_code" != "{}" ]] && [[ "$new_code" != "" ]]; then
#                    sed -i "s/^$config_name_my$i='$old_code'$/$config_name_my$i='$new_code'/" $file_task_before
#                fi
#            else
                if [[ "$new_code" != "undefined" ]] && [[ "$new_code" != "{}" ]] || [[ "$new_code" = "" ]]; then
                    sed -i "s/^$config_name_my$i='$old_code'$/$config_name_my$i='$new_code'/" $file_task_before
                fi
#            fi
        fi
    elif [[ $i -gt $user_sum ]] && [[ ! -z "$(cat $file_task_before | grep "^$config_name_my$i")" ]]; then
        sed -i "/^$config_name_my$i/d" $file_task_before
    fi
done

#更新配置文件中的互助规则
if [ -z "$(cat $file_task_before | grep "^$config_name_for_other\d")" ]; then
   echo -e "${config_name_for_other}1=\"\"\n" >> $file_task_before
fi
for ((j=1; j<=100; j++)); do
    if [[ $j -le $user_sum ]] && [[ ! -z "$(cat $log_path | grep "^$config_name_for_other$j=.*\"$")" ]]; then
        new_rule="$(cat $log_path | grep "^$config_name_for_other$j=.*\"$" | sed "s/.*\"\(.*\)\".*/\1/")"
        old_rule="$(cat $file_task_before | grep "^$config_name_for_other$j=.*\"$" | sed "s/.*\"\(.*\)\".*/\1/")"
        if [ -z "$(grep "^$config_name_for_other$j" $file_task_before)" ]; then
            sed -i "/^$config_name_for_other$[$j-1]=".*"/ s/$/\n$config_name_for_other$j=\"\"/" $file_task_before
        fi
        if [ "$new_rule" != "$old_rule" ]; then
            sed -i "s/^$config_name_for_other$j=\"$old_rule\"$/$config_name_for_other$j=\"$new_rule\"/" $file_task_before
        fi
    elif [[ $j -gt $user_sum ]] && [[ ! -z "$(cat $file_task_before | grep "^$config_name_for_other$j")" ]]; then
        sed -i "/^$config_name_for_other$j/d" $file_task_before
    fi
done
}

help_codes_only(){
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
local config_name=$1
local config_name_my=My$config_name
local config_name_for_other=ForOther$config_name
local i j k

#更新配置文件中的互助码
if [ -z "$(cat $file_task_before | grep "^$config_name\d")" ]; then
   echo -e "\n${config_name}1=''\n" >> $file_task_before
fi
for ((k=1; k<=100; k++)); do
    if [[ $k -le $user_sum ]] && [[ ! -z "$(cat $log_path | grep "^$config_name$k=.*'$")" ]]; then
        new_code="$(cat $log_path | grep "^$config_name$k=.*'$" | sed "s/.*'\(.*\)'.*/\1/")"
        old_code="$(cat $file_task_before | grep "^$config_name$k=.*'$" | sed "s/.*'\(.*\)'.*/\1/")"
        if [ -z "$(grep "^$config_name$k" $file_task_before)" ]; then
            sed -i "/^$config_name$[$k-1]='.*'/ s/$/\n$config_name$k=\'\'/" $file_task_before
        fi
        if [ "$new_code" != "$old_code" ]; then
            if [[ "$new_code" != "undefined" ]] && [[ "$new_code" != "{}" ]] || [[ "$new_code" = "" ]]; then
                sed -i "s/^$config_name$k='$old_code'$/$config_name$k='$new_code'/" $file_task_before
            fi
        fi
    elif [[ $k -gt $user_sum ]] && [[ ! -z "$(cat $file_task_before | grep "^$config_name$k")" ]]; then
        sed -i "/^$config_name$k/d" $file_task_before
    fi
done
}

export_codes_sub_only(){
if [ "$(cat $dir_scripts/"$repo"_jd_cfd.js | grep "// console.log(\`token")" != "" ]; then
    echo -e "\n# 正在修改 "$repo"_jd_cfd.js ，待完全运行 "$repo"_jd_cfd.js 后即可输出 token ！"
fi
sed -i 's/.*\(c.*log\).*\(${JSON.*token)}\).*/      \1(\`\\n【京东账号${$.index}（${$.UserName}）的京喜token好友互助码】\2\\n\`)/g' /ql/scripts/*_jd_cfd.js
    local task_name=$1
    local config_name=$2
    local chinese_name=$3
    local i j k m n pt_pin_in_log code tmp_grep tmp_my_code tmp_for_other user_num random_num_list
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    local user_sum=${#array[*]}
    if cd $dir_log/$task_name &>/dev/null && [[ $(ls) ]]; then
        ## 寻找所有互助码以及对应的pt_pin
        i=0
        pt_pin_in_log=()
        code=()
        pt_pin_and_code=$(ls -r *.log | xargs awk -v var="的$chinese_name好友互助码" 'BEGIN{FS="[（ ）】]+"; OFS="&"} $3~var {print $2,$4}')
        for line in $pt_pin_and_code; do
            pt_pin_in_log[i]=$(echo $line | awk -F "&" '{print $1}')
            code[i]=$(echo $line | awk -F "&" '{print $2}')
            let i++
        done

        ## 输出互助码
        if [[ ${#code[*]} -gt 0 ]]; then
            for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                tmp_my_code=""
                j=$((m + 1))
                for ((n = 0; n < ${#code[*]}; n++)); do
                    if [[ ${pt_pin[m]} == ${pt_pin_in_log[n]} ]]; then
                        tmp_my_code=${code[n]}
                        break
                    fi
                done
                echo "$config_name$j='$tmp_my_code'"
            done
        else
            echo "#$cur_time 从日志中未找到任何互助码"
        fi
fi
}

#更新互助码和互助规则
update_help(){
#latest_log=$(ls -r $dir_code | head -1)
latest_log=$log_path
case $UpdateType in
    1)
        if [ "$ps_num" -le 7 ] && [ -f $log_path ] && [ -f $file_task_before ]; then
            backup_del
            echo -e "\n#$cur_time 开始更新配置文件的互助码和互助规则" | tee -a $latest_log
            for i in ${name_config[@]}; do
                help_codes_rules $i
            done
            for i in ${name_config_only[@]}; do
                help_codes_only $i
            done
            sed -i "4c ## 上次导入时间：$(date +%Y年%m月%d日\ %X)" /ql/config/task_before.sh
            echo -e "\n#$cur_time 配置文件的互助码和互助规则已完成更新" | tee -a $latest_log
        elif [ ! -f $log_path ]; then
            echo -e "\n#$cur_time 日志文件不存在，请检查后重试！" | tee -a $latest_log
        elif [ ! -f $file_task_before ]; then
            echo -e "\n#$cur_time 配置文件不存在，请检查后重试！" | tee -a $latest_log
        fi
        ;;
    *)
        echo -e "\n#$cur_time 您已设置不更新配置文件的互助码和互助规则，跳过更新！" | tee -a $latest_log
        ;;
esac
}

dump_user_info(){
echo -e "\n## 账号用户名及 COOKIES 整理如下："
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
    for ((m = 0; m < ${#pt_pin[*]}; m++)); do
        j=$((m + 1))
        echo -e "## 用户名 $j：${pt_pin[m]}\n## Cookie$j=\"${array[m]}\""
    done
}

backup_del(){
[[ $BACKUP = "1" ]] && mkdir -p $dir_config/bak/ && cp $file_task_before $dir_config/bak/task_before_$log_time.sh
[[ $CLEANBAK = "1" ]] && find $dir_config/bak/ -type f -mtime +$CLEANBAK_DAYS | xargs rm -rvf
}


## 执行并写入日志
today="$(date +%Y年%m月%d日)"
cur_time="【$(date +%X)】"
log_time=$(date "+%Y-%m-%d-%H-%M-%S")
log_path="$dir_code/$log_time.log"
make_dir "$dir_code"
ps_num="$(ps | grep code.sh | grep -v grep | wc -l)"
[[ ! -z "$(ps -ef|grep -w 'code.sh'|grep -v grep)" ]] && ps -ef|grep -w 'code.sh'|grep -v grep|awk '{print $3}'|xargs kill -9
export_all_codes | perl -pe "{s|京东种豆|种豆|; s|crazyJoy任务|疯狂的JOY|}" | tee $log_path
sleep 5
update_help

## 修改curtinlv京东超市兑换脚本的参数
sed -i "21c cookies='$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*\(pt_key=\S\+;\)\S*\(pt_pin=\S\+;\)\S*/\1\2/g;" | perl -pe "s| |&|g")'" /ql/scripts/curtinlv_JD-Script_jd_blueCoin.py

## 修改curtinlv入会领豆配置文件的参数
sed -i "4c JD_COOKIE = '$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*\(pt_key=\S\+;\)\S*\(pt_pin=\S\+;\)\S*/\1\2/g;" | perl -pe "s| |&|g")'" /ql/repo/curtinlv_JD-Script/OpenCard/OpenCardConfig.ini
