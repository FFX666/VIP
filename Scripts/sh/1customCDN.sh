
#!/usr/bin/env bash

## 本脚本搬运并模仿 liuqitoday
dir_shell=/ql/config
dir_script=/ql/scripts
dir_repo=/ql/repo
config_shell_path=$dir_shell/config.sh
extra_shell_path=$dir_shell/extra.sh
code_shell_path=$dir_shell/code.sh
task_before_shell_path=$dir_shell/task_before.sh


# 控制是否执行变量
read -p "是否全部替换或下载，输入 1 即可全部替换，输入 0 则跳出，默认和其他不全部替换，建议初次配置输入 1：" Rall
if [ "${Rall}" = 1 ]; then
    echo "将执行全部替换操作"
elif [ "${Rall}" = 0 ]; then
    exit 0
else
    echo "以下操作默认为是，不需要的请输入 n"
    read -p "是否替换或下载 config.sh y/n：" Rconfig
    Rconfig=${Rconfig:-'y'}
    read -p "是否替换或下载 extra.sh y/n：" Rextra
    Rextra=${Rextra:-'y'}
    read -p "是否替换或下载 code.sh y/n：" Rcode
    Rcode=${Rcode:-'y'}
    read -p "是否替换或下载 task_before.sh y/n：" Rbefore
    Rbefore=${Rbefore:-'y'}
    read -p "是否添加 task:ql bot（会拉取机器人并自动更新） y/n：" Rbot
    Rbot=${Rbot:-'y'}
fi


# 下载 config.sh
if [ ! -a "$config_shell_path" ]; then
    touch $config_shell_path
fi
if [ "${Rconfig}" = 'y' -o "${Rall}" = 1 ]; then
    curl -s --connect-timeout 3 https://raw.githubusercontents.com/Oreomeow/VIP/main/Conf/Qinglong/config.sample.sh > $config_shell_path
    cp $config_shell_path $dir_shell/config.sh
    # 判断是否下载成功
    config_size=$(ls -l $config_shell_path | awk '{print $5}')
    if (( $(echo "${config_size} < 100" | bc -l) )); then
        echo "config.sh 下载失败"
        exit 0
    fi
else
    echo "已为您跳过替换 config.sh"
fi


# 下载 extra.sh
if [ ! -a "$extra_shell_path" ]; then
    touch $extra_shell_path
fi
if [ "${Rextra}" = 'y' -o "${Rall}" = 1 ]; then
    curl -s --connect-timeout 3 https://raw.githubusercontents.com/Oreomeow/VIP/main/Tasks/qlrepo/extra.sh > $extra_shell_path
    cp $extra_shell_path $dir_shell/extra.sh
    # 判断是否下载成功
    extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
    if (( $(echo "${extra_size} < 100" | bc -l) )); then
        echo "extra.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $extra_shell_path
    # extra.sh 预设仓库及默认拉取仓库设置
    echo -e "（1）panghu999\n（2）JDHelloWorld\n（3）he1pu\n（4）shufflewzc\n（6）Aaron-lv"
    read -p "输入您想拉取的仓库编号(默认为 4):" defaultNum
    defaultNum=${defaultNum:-'4'}
    sed -i "s/\$default4/\$default${defaultNum}/g" $extra_shell_path
    # 将 extra.sh 添加到定时任务
    if [ "$(grep -c extra /ql/config/crontab.list)" = 0 ]; then
        echo "开始添加 task ql extra"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"初始化任务","command":"ql extra","schedule":"15 0-23/4 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
    fi
else
    echo "已为您跳过替换 extra.sh"
fi


# 下载 code.sh
if [ ! -a "$code_shell_path" ]; then
    touch $code_shell_path
fi
if [ "${Rcode}" = 'y' -o "${Rall}" = 1 ]; then
    curl -s --connect-timeout 3 https://raw.githubusercontents.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/code.sh > $code_shell_path
    cp $code_shell_path $dir_shell/code.sh
    # 判断是否下载成功
    code_size=$(ls -l $code_shell_path | awk '{print $5}')
    if (( $(echo "${code_size} < 100" | bc -l) )); then
        echo "code.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $code_shell_path
    # code.sh 预设仓库及默认调用仓库设置
    echo -e "## 将\"repo=\$repo1\"改成\"repo=\$repo2\"或其他，以默认调用其他仓库脚本日志\nrepo1='panghu999_jd_scripts' #预设的 panghu999 仓库\nrepo2='JDHelloWorld_jd_scripts' #预设的 JDHelloWorld 仓库\nrepo3='he1pu_JDHelp' #预设的 he1pu 仓库\nrepo4='shufflewzc_faker2' #预设的 shufflewzc 仓库\nrepo6='Aaron-lv_sync_jd_scripts' #预设的 Aaron-lv 仓库\nrepo=\$repo1 #默认调用 panghu999 仓库脚本日志"
    read -p "输入您想调用的仓库编号(默认为 4):" repoNum
    repoNum=${repoNum:-'4'}
    sed -i "s/\$repo4/\$repo${repoNum}/g" $code_shell_path
    # 将 code.sh 添加到定时任务
    if [ "$(grep -c code.sh /ql/config/crontab.list)" = 0 ]; then
        echo "开始添加 task code.sh"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"格式化更新助力码","command":"bash /ql/config/code.sh &","schedule":"*/10 * * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247939659'
    fi
else
    echo "已为您跳过替换 code.sh"
fi


# 下载 task_before.sh
if [ ! -a "$task_before_shell_path" ] ; then
    touch $task_before_shell_path
fi
if [ "${Rbefore}" = 'y' -o "${Rall}" = 1 ]; then
    curl -s --connect-timeout 3 https://raw.githubusercontents.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/task_before.sh > $task_before_shell_path
    # 判断是否下载成功
    task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
    if (( $(echo "${task_before_size} < 100" | bc -l) )); then
        echo "task_before.sh 下载失败"
        exit 0
    fi
else
    echo "已为您跳过替换 task_before.sh"
fi


# 添加定时任务 ql bot
if [ "$(grep -c bot /ql/config/crontab.list)" != 0 ] && [ "${Rbot}" = 'y' -o "${Rall}" = 1 ]; then
    echo "您的任务列表中已存在 task ql bot"
elif [ "$(grep -c bot /ql/config/crontab.list)" = 0 ] && [ "${Rbot}" = 'y' -o "${Rall}" = 1 ]; then
    echo "开始添加 task ql bot"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
else
    echo "已为您跳过添加定时任务 ql bot"
fi


# 提示配置结束
echo "配置到此结束，您是否成功了呢？"
