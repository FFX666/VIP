# 青龙拉取常用京东脚本库
## 说明
- 更新一个整库脚本
```
ql repo <repourl> <path> <blacklist> <dependence> <branch>
```
- 更新单个脚本文件
```
ql raw <fileurl>
```
下面是示例

## 整库
- `Unknown 备份托管等`
  
  1. `JDHelloWorld`
  ```
  ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen|update" "^jd[^_]|USER|^TS|utils|package"
  ```
  2. `he1pu`（自动提交助力码-京喜工厂、种豆得豆、东东工厂、东东农场、健康社区、京喜财富岛、东东萌宠、闪购盲盒，随机从数据库中选取助力码互助）
  ```
  ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|update" "^jd[^_]|USER|utils|^MovementFaker|^JDJRValidator|^sign|^ZooFaker"
  ```
  3. `shufflewzc`
  ```
  ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|jddj_|getJDCookie" "activity|backUp|Coupon|update" "^jd[^_]|USER|utils|^ZooFaker|^JDJRValidator|^sign"
  ```
  4. `Aaron-lv`
  ```
  ql repo https://github.com/Aaron-lv/sync.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER|utils" "jd_scripts"
  ```
  5. `panghu999`（无维护）
  ```
  ql repo https://github.com/panghu999/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|jd_try|format_" "^jd[^_]|USER"
  ```
  6. `chinnkarahoi`（无维护）
  ```
  ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER"
  ```

- `passerby-b`
```
ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event|jddj_fruit_code.js|jddj_getck.js|jd_|jddj_cookie"
```
- `curtinlv`
```
ql repo https://github.com/curtinlv/JD-Script.git "jd_"
```
- `smiek2221`
```
ql repo https://github.com/smiek2221/scripts.git "jd_|gua_" "" "^ZooFaker|^JDJRValidator|^sign"
```
- `cdle`
```
ql repo https://github.com/cdle/jd_study.git "jd_"
```
- `ZCY01`
```
ql repo https://github.com/ZCY01/daily_scripts.git "jd_"
```
- `whyour/hundun`
```
ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
```
- `moposmall`
```
ql repo https://github.com/moposmall/Script.git "Me"
```
- `Ariszy (Zhiyi-N)`
```
ql repo https://github.com/Ariszy/Private-Script.git "JD"
```
- `photonmang`（宠汪汪及兑换、点点券修复）
```
ql repo https://github.com/photonmang/quantumultX.git "JDscripts"
```
- `jiulan`
```
ql repo https://github.com/jiulan/platypus.git
```
- `panghu999/panghu`
```
ql repo https://github.com/panghu999/panghu.git "jd_"
```
- `star261`
```
ql repo https://github.com/star261/jd.git "jd_|star" "" "MovementFaker"
```
- `Wenmoux`
```
ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"
```

## 单脚本
### 名称之后标注`﹢`的单脚本，若上面已拉取仓库的可以不拉，否则会重复拉取。这里适用于只拉取部分脚本使用
> `curtinlv`﹢

>> 入会
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
```
>> 关注
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py
```

> `chiupam`

>> 京喜工厂瓜分电力开团 ID 
```
ql raw https://raw.githubusercontent.com/chiupam/JD_Diy/master/pys/activeId.py
```

> `Aaron-lv`+

>> 财富岛
```
ql raw https://raw.githubusercontent.com/Aaron-lv/sync/jd_scripts/jd_cfd.js
```
or
```
ql repo https://github.com/Aaron-lv/sync.git "jd_cfd" "" "" "jd_scripts"
```

> `Wenmoux`+

>> 口袋书店
```
ql raw https://raw.githubusercontent.com/Wenmoux/scripts/wen/jd/chinnkarahoi_jd_bookshop.js
```
or
```
ql repo https://github.com/Wenmoux/scripts.git "chinnkarahoi_jd_bookshop" "" "" "wen"
```

## 已删库存档
- `monk-coder`
```
ql repo https://github.com/monk-dust/dust.git "i-chenzhe|normal|member|car" "backup"
```
- `hyzaw`
```
ql repo https://github.com/hyzaw/scripts.git "ddo_"
```
- `zooPanda`
```
ql repo https://github.com/zooPanda/zoo.git "zoo"
```
- `longzhuzhu`
```
ql repo https://github.com/longzhuzhu/nianyu.git "qx"
```
