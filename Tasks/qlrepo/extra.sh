#!/usr/bin/env bash

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 使用方法：定时任务→添加定时→命令【ql extra】→定时规则【15 0-23/4 * * *】-运行
## 推荐配置：如下。自行在需要的命令前注释和取消注释 ##，该文件最前的 # 勿动


## 预设仓库和参数（u=url，p=path，b=blacklist，d=dependence），如果懂得定义可以自行修改
## （1）预设的 panghu999 仓库
u1="https://github.com/panghu999/jd_scripts.git"
p1="jd_|jx_|getJDCookie" 
b1="activity|backUp|Coupon|jd_try|format_" 
d1="^jd[^_]|USER" 
## （2）预设的 JDHelloWorld 仓库
u2="https://github.com/JDHelloWorld/jd_scripts.git"
p2="jd_|jx_|getJDCookie"
b2="activity|backUp|Coupon|enen|update"
d2="^jd[^_]|USER"
## （3）预设的 he1pu 仓库
u3="https://github.com/he1pu/JDHelp.git"
p3="jd_|jx_|getJDCookie" 
b3="activity|backUp|Coupon|update" 
d3="^jd[^_]|USER|MovementFaker|JDJRValidator_Pure|sign_graphics_validate|ZooFaker_Necklace"
## （4）预设的 shufflewzc 仓库
u4="https://github.com/shufflewzc/faker2.git"
p4="jd_|jx_|getJDCookie"
b4="activity|backUp|Coupon"
d4="^jd[^_]|USER|ZooFaker_Necklace|JDJRValidator_Pure"
## 默认拉取仓库参数集合
default1="$u1 $p1 $b1 $d1"
default2="$u2 $p2 $b2 $d2"
default3="$u3 $p3 $b3 $d3"
default4="$u4 $p4 $b4 $d4"
## 默认拉取仓库编号设置
default=$default4 ##此处修改，只改数字，默认 shufflewzc 仓库


# 整库
# 1. Unknown 备份托管等（如上）
ql repo $default ##此处勿动

# 2. passerby-b
## ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event" "jddj_cookie"

# 3. curtinlv
## ql repo https://github.com/curtinlv/JD-Script.git

# 4. smiek2221
## ql repo https://github.com/smiek2221/scripts.git "jd_|gua_" "" "ZooFaker_Necklace.js|JDJRValidator_Pure.js|sign_graphics_validate.js"

# 5. cdle
## ql repo https://github.com/cdle/jd_study.git "jd_"

# 6. ZCY01
## ql repo https://github.com/ZCY01/daily_scripts.git "jd_"

# 7. whyour/hundun
## ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"

# 8. moposmall
## ql repo https://github.com/moposmall/Script.git "Me"

# 9. Ariszy (Zhiyi-N)
## ql repo https://github.com/Ariszy/Private-Script.git "JD"

# 10. photonmang（宠汪汪及兑换、点点券修复）
## ql repo https://github.com/photonmang/quantumultX.git "JDscripts"

# 11. jiulan
## ql repo https://github.com/jiulan/platypus.git

# 12. panghu999/panghu
## ql repo https://github.com/panghu999/panghu.git "jd_"

# 13. star261
## ql repo https://github.com/star261/jd.git "jd_|star" "" "^MovementFaker"

# 14. Wenmoux
## ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"

# 15. Aaron-lv
## ql repo https://github.com/Aaron-lv/sync.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER" "jd_scripts"


# 单脚本
## 名称之后标注﹢的单脚本，若上面已拉取仓库的可以不拉，否则会重复拉取。这里适用于只拉取部分脚本使用
# 1. curtinlv﹢
## 抢京豆 0 0 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/jd_qjd.py
## 入会 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
## 关注 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py

# 2. chiupam
## 京喜工厂瓜分电力开团 ID
## ql raw https://raw.githubusercontent.com/chiupam/JD_Diy/master/pys/activeId.py

# 3. Aaron-lv
## 财富岛
## ql raw https://raw.githubusercontent.com/Aaron-lv/sync/jd_scripts/jd_cfd.js
ql repo https://github.com/Aaron-lv/sync.git "jd_cfd" "" "" "jd_scripts"

# 4. Wenmoux
## 口袋书店
## ql raw https://raw.githubusercontent.com/Wenmoux/scripts/wen/jd/chinnkarahoi_jd_bookshop.js
ql repo https://github.com/Wenmoux/scripts.git "chinnkarahoi_jd_bookshop" "" "" "wen"


# 依赖
## Python 3 安装 requests
pip3 install requests
## 安装 canvas，适用于柠檬胖虎代维护 lxk0301 仓库，宠汪汪二代目和宠汪汪兑换，只支持国内机
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
## 安装 png-js，适用于 JDHelloWorld 和 he1pu 的宠汪汪二代目和宠汪汪兑奖品二代目
npm install png-js -S
## 安装 date-fns
npm install date-fns -S
## 安装 axios
npm install axios -S
## 安装 crypto-js
npm install crypto-js -S
## 安装 ts-md5
npm install ts-md5 -S
## 安装 tslib
npm install tslib -S
## 安装 @types/node
npm install @types/node -S