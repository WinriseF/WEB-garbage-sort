// type: 'recyclable' (可回收物), 'kitchen' (厨余垃圾), 'hazardous' (有害垃圾), 'other' (其他垃圾)
const fullGarbageList = [
    // 可回收物 (recyclable)
    { name: '废纸盒', type: 'recyclable', difficult: false },
    { name: '塑料瓶', type: 'recyclable', difficult: false },
    { name: '玻璃瓶', type: 'recyclable', difficult: false },
    { name: '易拉罐', type: 'recyclable', difficult: false },
    { name: '旧报纸', type: 'recyclable', difficult: false },
    { name: '旧衣服', type: 'recyclable', difficult: false },
    { name: '牛奶盒', type: 'recyclable', difficult: false },
    { name: '泡沫塑料', type: 'recyclable', difficult: false },
    { name: '金属罐头', type: 'recyclable', difficult: false },
    { name: '旧书本', type: 'recyclable', difficult: false },
    { name: '废纸盒 (干净)', type: 'recyclable', difficult: false },
    { name: '快递纸箱 (去胶带)', type: 'recyclable', difficult: false },
    { name: '旧报纸', type: 'recyclable', difficult: false },
    { name: '杂志', type: 'recyclable', difficult: false },
    { name: '书本', type: 'recyclable', difficult: false },
    { name: '打印纸', type: 'recyclable', difficult: false },
    { name: '信封 (无塑料窗)', type: 'recyclable', difficult: false },
    { name: '宣传单', type: 'recyclable', difficult: false },
    { name: '购物纸袋', type: 'recyclable', difficult: false },
    { name: '硬纸板', type: 'recyclable', difficult: false },
    { name: '纸质鸡蛋托', type: 'recyclable', difficult: false },
    { name: '纸质笔记本内页', type: 'recyclable', difficult: false },
    { name: '利乐包装 (洗净压扁)', type: 'recyclable', difficult: true }, // 牛奶盒、饮料盒
    { name: '塑料饮料瓶 (PET)', type: 'recyclable', difficult: false },
    { name: '洗发水瓶 (HDPE)', type: 'recyclable', difficult: false },
    { name: '洗衣液瓶', type: 'recyclable', difficult: false },
    { name: '塑料油桶 (干净)', type: 'recyclable', difficult: false },
    { name: '塑料盆/桶', type: 'recyclable', difficult: false },
    { name: '塑料玩具 (不含电池)', type: 'recyclable', difficult: false },
    { name: '泡沫塑料 (干净)', type: 'recyclable', difficult: true }, // 很多地方要求单独或归为其他
    { name: '塑料保鲜盒 (干净)', type: 'recyclable', difficult: false },
    { name: '酸奶盒 (洗净)', type: 'recyclable', difficult: false },
    { name: '塑料衣架', type: 'recyclable', difficult: false },
    { name: '塑料瓶盖', type: 'recyclable', difficult: true }, // 有时要求分开或不算
    { name: '塑料包装膜 (干净)', type: 'recyclable', difficult: true }, // 如保鲜膜、气泡膜
    { name: '玻璃酒瓶', type: 'recyclable', difficult: false },
    { name: '玻璃罐头瓶 (干净)', type: 'recyclable', difficult: false },
    { name: '玻璃调料瓶', type: 'recyclable', difficult: false },
    { name: '平板玻璃 (非钢化)', type: 'recyclable', difficult: true }, // 需小心处理，或联系专门回收
    { name: '玻璃杯 (非钢化/耐热)', type: 'recyclable', difficult: false },
    { name: '金属易拉罐 (铝)', type: 'recyclable', difficult: false },
    { name: '金属罐头盒 (钢)', type: 'recyclable', difficult: false },
    { name: '金属锅/盆', type: 'recyclable', difficult: false },
    { name: '金属勺子/叉子', type: 'recyclable', difficult: false },
    { name: '金属衣架', type: 'recyclable', difficult: false },
    { name: '钥匙', type: 'recyclable', difficult: false },
    { name: '螺丝刀 (金属部分)', type: 'recyclable', difficult: false },
    { name: '铝箔纸 (干净)', type: 'recyclable', difficult: false },
    { name: '金属瓶盖', type: 'recyclable', difficult: false },
    { name: '空的气雾罐 (非危险品)', type: 'recyclable', difficult: true }, // 如空气清新剂空罐
    { name: '旧衣服 (干净)', type: 'recyclable', difficult: false },
    { name: '旧床单/被套 (干净)', type: 'recyclable', difficult: false },
    { name: '旧毛巾 (干净)', type: 'recyclable', difficult: false }, // 脏污算其他
    { name: '布鞋 (干净)', type: 'recyclable', difficult: false },
    { name: '帆布包', type: 'recyclable', difficult: false },
    { name: '窗帘 (干净)', type: 'recyclable', difficult: false },
    { name: '毛绒玩具 (干净)', type: 'recyclable', difficult: false },
    { name: '电线', type: 'recyclable', difficult: true }, // 含有金属和塑料
    { name: '电路板 (无电池)', type: 'recyclable', difficult: true }, // 有专门回收渠道更佳
    { name: '路由器 (无电源)', type: 'recyclable', difficult: false },
    { name: '鼠标 (无电池)', type: 'recyclable', difficult: false },
    { name: '键盘', type: 'recyclable', difficult: false },
    { name: '旧手机 (去电池)', type: 'recyclable', difficult: true }, // 属于电子垃圾，专门回收更好
    { name: '充电宝 (去电池)', type: 'recyclable', difficult: true }, // 外壳可回收，电池有害
    { name: '雨伞骨架 (金属)', type: 'recyclable', difficult: false },

    // 厨余垃圾 (kitchen)
    { name: '剩菜剩饭', type: 'kitchen', difficult: false },
    { name: '骨头（小）', type: 'kitchen', difficult: false }, // 小骨头是厨余
    { name: '菜根菜叶', type: 'kitchen', difficult: false },
    { name: '果皮', type: 'kitchen', difficult: false },
    { name: '茶叶渣', type: 'kitchen', difficult: false },
    { name: '过期食品', type: 'kitchen', difficult: false },
    { name: '蛋壳', type: 'kitchen', difficult: false },
    { name: '鱼骨', type: 'kitchen', difficult: false },
    { name: '咖啡渣', type: 'kitchen', difficult: false },
    { name: '玉米核', type: 'kitchen', difficult: false },
    { name: '剩菜剩饭', type: 'kitchen', difficult: false },
    { name: '过期米面', type: 'kitchen', difficult: false },
    { name: '面包糕点 (过期)', type: 'kitchen', difficult: false },
    { name: '瓜子壳', type: 'kitchen', difficult: false },
    { name: '花生壳', type: 'kitchen', difficult: false },
    { name: '水果皮 (如苹果皮、香蕉皮)', type: 'kitchen', difficult: false },
    { name: '水果核 (小)', type: 'kitchen', difficult: false },
    { name: '西瓜皮', type: 'kitchen', difficult: false },
    { name: '蔬菜叶/根', type: 'kitchen', difficult: false },
    { name: '葱姜蒜', type: 'kitchen', difficult: false },
    { name: '茶叶渣', type: 'kitchen', difficult: false },
    { name: '咖啡渣', type: 'kitchen', difficult: false },
    { name: '中药药渣', type: 'kitchen', difficult: true }, // 有些地方可能归为其他
    { name: '鸡蛋壳', type: 'kitchen', difficult: false },
    { name: '鱼骨/鱼刺', type: 'kitchen', difficult: false },
    { name: '鸡骨/鸭骨 (小)', type: 'kitchen', difficult: false },
    { name: '小龙虾壳', type: 'kitchen', difficult: false },
    { name: '螃蟹壳', type: 'kitchen', difficult: false },
    { name: '贝壳肉', type: 'kitchen', difficult: false }, // 肉是厨余，壳是其他
    { name: '玉米棒', type: 'kitchen', difficult: false },
    { name: '甘蔗渣', type: 'kitchen', difficult: false },
    { name: '枯萎的鲜花', type: 'kitchen', difficult: false },
    { name: '室内绿植 (修剪部分)', type: 'kitchen', difficult: false },
    { name: '宠物饲料 (过期)', type: 'kitchen', difficult: false },
    { name: '酸掉的牛奶', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '厨房用纸 (未污染)', type: 'kitchen', difficult: true }, // 轻微油污可以，重度不行
    { name: '调味料 (过期)', type: 'kitchen', difficult: false },
    { name: '软糖/巧克力 (过期)', type: 'kitchen', difficult: false },
    { name: '坚果肉', type: 'kitchen', difficult: false },
    { name: '海带/紫菜', type: 'kitchen', difficult: false },
    { name: '蘑菇/菌类', type: 'kitchen', difficult: false },
    { name: '豆渣', type: 'kitchen', difficult: false },
    { name: '南瓜籽', type: 'kitchen', difficult: false },
    { name: '菱角壳 (软)', type: 'kitchen', difficult: false },
    { name: '红薯/土豆皮', type: 'kitchen', difficult: false },
    { name: '动物内脏 (生/熟)', type: 'kitchen', difficult: false },
    { name: '粉丝/面条 (生/熟)', type: 'kitchen', difficult: false },
    { name: '椰子肉', type: 'kitchen', difficult: false }, // 壳是其他
    { name: '宠物饼干 (过期)', type: 'kitchen', difficult: false },
    { name: '豆腐/豆制品 (过期)', type: 'kitchen', difficult: false },
    { name: '披萨边', type: 'kitchen', difficult: false },
    { name: '饺子皮', type: 'kitchen', difficult: false },
    { name: '火锅底料 (固体部分)', type: 'kitchen', difficult: false }, // 油脂需处理
    { name: '艾草 (烹饪用)', type: 'kitchen', difficult: false },
    { name: '甘草片 (食用)', type: 'kitchen', difficult: false },
    { name: '酵母粉 (过期)', type: 'kitchen', difficult: false },
    { name: '冰糖/白糖 (过期)', type: 'kitchen', difficult: false },
    { name: '果酱 (过期)', type: 'kitchen', difficult: false },
    { name: '辣椒/花椒', type: 'kitchen', difficult: false },
    { name: '香料 (如八角桂皮)', type: 'kitchen', difficult: false },
    { name: '香葱/香菜', type: 'kitchen', difficult: false },
    { name: '干贝/虾米 (过期)', type: 'kitchen', difficult: false },
    { name: '腊肉/腊肠 (过期)', type: 'kitchen', difficult: false },
    { name: '干果 (过期)', type: 'kitchen', difficult: false },
    { name: '坚果壳 (如核桃壳)', type: 'kitchen', difficult: false },
    { name: '水果籽 (如苹果核)', type: 'kitchen', difficult: false },
    { name: '花生米 (过期)', type: 'kitchen', difficult: false },
    { name: '豆芽', type: 'kitchen', difficult: false },
    { name: '豆皮 (过期)', type: 'kitchen', difficult: false },
    { name: '香菇 (过期)', type: 'kitchen', difficult: false },
    { name: '海鲜 (过期)', type: 'kitchen', difficult: false },
    { name: '腌菜 (过期)', type: 'kitchen', difficult: false },
    { name: '榴莲果肉', type: 'kitchen', difficult: false }, // 榴莲壳是其他
    { name: '椰子水', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '豆浆渣', type: 'kitchen', difficult: false },
    { name: '豆腐渣', type: 'kitchen', difficult: false },
    { name: '牛奶 (过期)', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '酸奶 (过期)', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '果汁 (过期)', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '饮料 (过期)', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '酒精 (食用)', type: 'kitchen', difficult: false }, // 液体需沥干，易燃
    { name: '醋 (食用)', type: 'kitchen', difficult: false }, // 液体需沥干
    { name: '酱油 (食用)', type: 'kitchen', difficult: false }, // 液体需沥干

    // 有害垃圾 (hazardous)
    { name: '废电池', type: 'hazardous', difficult: false },
    { name: '废灯管', type: 'hazardous', difficult: false },
    { name: '过期药品', type: 'hazardous', difficult: false },
    { name: '油漆桶', type: 'hazardous', difficult: false },
    { name: '杀虫剂罐', type: 'hazardous', difficult: false },
    { name: '温度计(含汞)', type: 'hazardous', difficult: false },
    { name: '废弃化妆品', type: 'hazardous', difficult: false },
    { name: '消毒剂瓶', type: 'hazardous', difficult: false },
    { name: 'X光片', type: 'hazardous', difficult: false },
    { name: '指甲油瓶', type: 'hazardous', difficult: false },
    
    { name: '废电池 (充电电池)', type: 'hazardous', difficult: true }, // 通常有专门回收点
    { name: '纽扣电池', type: 'hazardous', difficult: false },
    { name: '锂电池', type: 'hazardous', difficult: false },
    { name: '手机电池', type: 'hazardous', difficult: false },
    { name: '蓄电池 (汽车/电动车)', type: 'hazardous', difficult: true }, // 通常有专门回收点
    { name: '碱性电池 (AA/AAA)', type: 'hazardous', difficult: true }, // 现在多为低汞或无汞，部分地区算其他，但投放有害最保险
    { name: '废弃灯管 (荧光灯/节能灯)', type: 'hazardous', difficult: false },
    { name: 'LED灯泡', type: 'hazardous', difficult: true }, // 含微量有害物质
    { name: '紫外线灯管', type: 'hazardous', difficult: false },
    { name: '过期药品', type: 'hazardous', difficult: false },
    { name: '药品包装 (有残留)', type: 'hazardous', difficult: true }, // 空的干净包装可回收
    { name: '温度计 (含汞)', type: 'hazardous', difficult: false },
    { name: '血压计 (含汞)', type: 'hazardous', difficult: false },
    { name: '废油漆桶', type: 'hazardous', difficult: false },
    { name: '染发剂壳', type: 'hazardous', difficult: false },
    { name: '杀虫剂罐', type: 'hazardous', difficult: false },
    { name: '消毒剂瓶', type: 'hazardous', difficult: false },
    { name: '指甲油/洗甲水', type: 'hazardous', difficult: false },
    { name: '废弃化妆品 (如口红)', type: 'hazardous', difficult: true }, // 少量可视为其他，大量或液体有害
    { name: '胶水/强力胶管', type: 'hazardous', difficult: false },
    { name: '修正液/修正带', type: 'hazardous', difficult: false },
    { name: '硒鼓/墨盒', type: 'hazardous', difficult: false },
    { name: 'X光片/相片底片', type: 'hazardous', difficult: false },
    { name: '废弃农药瓶', type: 'hazardous', difficult: false },
    { name: '打火机 (含液体)', type: 'hazardous', difficult: true }, // 用尽算其他
    { name: '酒精 (瓶装)', type: 'hazardous', difficult: false }, // 易燃
    { name: '医用棉签/纱布 (带血)', type: 'hazardous', difficult: true }, // 需按医疗废物处理
    { name: '注射器/针头', type: 'hazardous', difficult: false }, // 需安全处理
    { name: '含油漆的刷子', type: 'hazardous', difficult: false },
    { name: 'WD-40 喷雾罐', type: 'hazardous', difficult: false },
    { name: '除草剂', type: 'hazardous', difficult: false },
    { name: '汽车防冻液', type: 'hazardous', difficult: false },
    { name: '机油桶 (有残留)', type: 'hazardous', difficult: false },
    { name: '实验室化学试剂', type: 'hazardous', difficult: false },
    { name: '老鼠药', type: 'hazardous', difficult: false },
    { name: '樟脑丸', type: 'hazardous', difficult: false },
    { name: '显影液/定影液', type: 'hazardous', difficult: false },
    { name: '蚊香片/电蚊香液瓶', type: 'hazardous', difficult: false },
    { name: '漂白剂瓶 (有残留)', type: 'hazardous', difficult: false },
    { name: '胶卷', type: 'hazardous', difficult: false },
    { name: '荧光棒', type: 'hazardous', difficult: false },
    { name: '水彩/油画颜料管', type: 'hazardous', difficult: false },
    { name: '沥青', type: 'hazardous', difficult: false },
    { name: '煤油', type: 'hazardous', difficult: false },
    { name: '生石灰', type: 'hazardous', difficult: false }, // 遇水放热，有腐蚀性
    { name: '电池充电器', type: 'hazardous', difficult: true }, // 算电子垃圾，投放有害桶较稳妥
    { name: '含汞开关/继电器', type: 'hazardous', difficult: false },
    { name: '香水瓶 (有残留)', type: 'hazardous', difficult: true }, // 主要成分酒精
    { name: '染料', type: 'hazardous', difficult: false },
    { name: '发胶喷雾罐', type: 'hazardous', difficult: false }, // 压力容器，可能有易燃物

    // 其他垃圾 (other)
    { name: '烟头', type: 'other', difficult: false },
    { name: '陶瓷碎片', type: 'other', difficult: false },
    { name: '污染纸张', type: 'other', difficult: false },
    { name: '一次性餐具', type: 'other', difficult: false },
    { name: '尘土', type: 'other', difficult: false },
    { name: '大棒骨', type: 'other', difficult: false }, // 大骨头难腐蚀，算其他
    { name: '贝壳', type: 'other', difficult: false }, // 贝壳难腐蚀
    { name: '旧毛巾(污染)', type: 'other', difficult: false },
    { name: '破损花盆', type: 'other', difficult: false },
    { name: '尿不湿', type: 'other', difficult: false },
    { name: '烟头', type: 'other', difficult: false },
    { name: '尘土/灰尘', type: 'other', difficult: false },
    { name: '用过的纸尿裤', type: 'other', difficult: false },
    { name: '卫生巾', type: 'other', difficult: false },
    { name: '湿纸巾', type: 'other', difficult: false },
    { name: '餐巾纸 (用过)', type: 'other', difficult: false },
    { name: '厨房用纸 (重度污染)', type: 'other', difficult: false },
    { name: '一次性筷子', type: 'other', difficult: false },
    { name: '一次性塑料餐具 (污染)', type: 'other', difficult: true }, // 干净可回收
    { name: '外卖餐盒 (重油污)', type: 'other', difficult: true }, // 干净可回收
    { name: '陶瓷碎片', type: 'other', difficult: false },
    { name: '瓦片', type: 'other', difficult: false },
    { name: '镜子碎片', type: 'other', difficult: false },
    { name: '玻璃钢制品', type: 'other', difficult: false },
    { name: '砖块', type: 'other', difficult: false },
    { name: '渣土', type: 'other', difficult: false },
    { name: '干枯的植物盆栽土', type: 'other', difficult: false },
    { name: '宠物粪便', type: 'other', difficult: false },
    { name: '猫砂/狗砂', type: 'other', difficult: false },
    { name: '大棒骨 (猪腿骨等)', type: 'other', difficult: true }, // 难腐蚀
    { name: '贝壳 (硬)', type: 'other', difficult: true }, // 如蛤蜊壳、扇贝壳
    { name: '榴莲壳', type: 'other', difficult: true },
    { name: '椰子壳', type: 'other', difficult: true },
    { name: '核桃壳', type: 'other', difficult: true }, // 坚硬难分解
    { name: '旧毛巾 (脏污破损)', type: 'other', difficult: false },
    { name: '破旧鞋子 (无法修复)', type: 'other', difficult: false },
    { name: '海绵/丝瓜络', type: 'other', difficult: false },
    { name: '百洁布', type: 'other', difficult: false },
    { name: '牙刷', type: 'other', difficult: false },
    { name: '梳子 (塑料/木)', type: 'other', difficult: false },
    { name: '笔 (圆珠笔/水笔)', type: 'other', difficult: false },
    { name: '橡皮擦', type: 'other', difficult: false },
    { name: '胶带', type: 'other', difficult: false },
    { name: '便利贴', type: 'other', difficult: true }, // 带粘性，少量可随纸张回收，大量算其他
    { name: '照片', type: 'other', difficult: false }, // 覆膜、含药剂
    { name: '复写纸/蜡纸', type: 'other', difficult: false },
    { name: '干燥剂包', type: 'other', difficult: false },
    { name: '暖宝宝贴', type: 'other', difficult: false },
    { name: '香烟盒 (含内衬纸)', type: 'other', difficult: true }, // 干净纸盒可回收
    { name: '牙线/牙签', type: 'other', difficult: false },
    { name: '隐形眼镜', type: 'other', difficult: false },
    { name: '创可贴', type: 'other', difficult: false }, // 可能沾染体液
    { name: '棉签 (普通用)', type: 'other', difficult: false },
    { name: '一次性口罩', type: 'other', difficult: false },
    { name: '蜡烛', type: 'other', difficult: false },
    { name: '旧皮具 (钱包/皮带)', type: 'other', difficult: false },
    { name: '橡胶手套', type: 'other', difficult: false },
    { name: '羽毛', type: 'other', difficult: false },
    { name: '碎玻璃 (少量包裹好)', type: 'other', difficult: true }, // 大量需专门处理
    { name: '白炽灯泡', type: 'other', difficult: true }, // 不含有害物质
    { name: '保鲜膜/袋 (污染)', type: 'other', difficult: false },
    { name: '竹制品 (砧板/篮子)', type: 'other', difficult: false },
    { name: '冰棍棒', type: 'other', difficult: false },
    { name: '笔芯', type: 'other', difficult: false },
    { name: '镜片 (树脂/玻璃)', type: 'other', difficult: false },
    { name: '旧手机壳 (塑料)', type: 'other', difficult: false },
    { name: '旧耳机 (塑料)', type: 'other', difficult: false },
    { name: '旧充电线 (塑料)', type: 'other', difficult: false },
    { name: '旧电器外壳 (塑料)', type: 'other', difficult: false },
    { name: '旧电脑配件 (塑料)', type: 'other', difficult: false },
    { name: '旧家电外壳 (塑料)', type: 'other', difficult: false },
    { name: '破损的雨伞', type: 'other', difficult: false },
    { name: '破损的手套', type: 'other', difficult: false },
    { name: '破损的围巾', type: 'other', difficult: false },
    { name: '破损的帽子', type: 'other', difficult: false },
    { name: '破损的包包', type: 'other', difficult: false },
    { name: '旧手表 (非金属)', type: 'other', difficult: false },
    { name: '旧眼镜 (非金属)', type: 'other', difficult: false },
    { name: '旧耳环 (非金属)', type: 'other', difficult: false },
    { name: '旧项链 (非金属)', type: 'other', difficult: false },
    { name: '旧戒指 (非金属)', type: 'other', difficult: false },
    { name: '旧手链 (非金属)', type: 'other', difficult: false },
    { name: '旧发夹 (非金属)', type: 'other', difficult: false },
    { name: '旧发圈 (非金属)', type: 'other', difficult: false },
    { name: '旧皮肤贴 (非金属)', type: 'other', difficult: false },
    //困难部分
    { name: '带有塑料涂层的纸质咖啡杯', type: 'recyclable', difficult: true }, // 需分离涂层否则算其他
    { name: '复合材质食品袋（铝塑包装）', type: 'recyclable', difficult: true }, // 需专门回收渠道
    { name: '含金属丝的茶包', type: 'recyclable', difficult: true }, // 需拆解分离
    { name: '带硅胶垫的玻璃饭盒', type: 'recyclable', difficult: true }, // 需完全分离材质
    { name: '带残留化妆品的玻璃瓶', type: 'recyclable', difficult: true }, // 必须彻底清洁
    { name: '复合木塑板材', type: 'recyclable', difficult: true }, // 特殊回收渠道
    { name: '快递气泡袋（含纸质面单）', type: 'recyclable', difficult: true }, // 需撕去面单
    { name: '带金属环的玻璃瓶', type: 'recyclable', difficult: true }, // 需拆解金属部件
    { name: '含陶瓷内胆的保温杯', type: 'recyclable', difficult: true }, // 需分离材质
    { name: '带电池的电子贺卡', type: 'recyclable', difficult: true }, // 必须拆除电池
    { name: '复合材质的牙膏管', type: 'recyclable', difficult: true }, // 铝塑复合需专门回收
    { name: '带硅胶头的奶瓶', type: 'recyclable', difficult: true }, // 需完全分离部件
    { name: '含金属涂层的塑料包装', type: 'recyclable', difficult: true }, // 特殊处理要求
    { name: '带玻璃镜的塑料首饰盒', type: 'recyclable', difficult: true }, // 需拆解分类
    { name: '复合材质的汽车脚垫', type: 'recyclable', difficult: true }, // 橡胶+织物需分离
    { name: '带液晶屏的计算器', type: 'recyclable', difficult: true }, // 需专业电子回收
    { name: '含金属丝的清洁球', type: 'recyclable', difficult: true }, // 钢+塑料需分离
    { name: '带橡胶圈的玻璃密封罐', type: 'recyclable', difficult: true }, // 需拆除橡胶部件
    { name: '复合材质的运动鞋', type: 'recyclable', difficult: true }, // 需专业拆解回收
    { name: '带锂电池的蓝牙耳机', type: 'recyclable', difficult: true }, // 需拆除电池
    { name: '含金属箔的零食包装', type: 'recyclable', difficult: true }, // 需特殊处理
    { name: '带陶瓷把手的锅具', type: 'recyclable', difficult: true }, // 需分离金属和陶瓷
    { name: '复合材质的遮阳伞', type: 'recyclable', difficult: true }, // 需拆解金属骨架
    { name: '带电子元件的玩具', type: 'recyclable', difficult: true }, // 需拆除电路板
    { name: '含硅胶部件的手机壳', type: 'recyclable', difficult: true }, // 需分离材质
    { name: '带荧光涂层的纸张', type: 'recyclable', difficult: true }, // 涂层影响回收
    { name: '复合包装的茶包（纸+线+标签）', type: 'recyclable', difficult: true }, // 需完全分离
    { name: '带金属扣的皮质钱包', type: 'recyclable', difficult: true }, // 需拆解各部件
    { name: '含玻璃纤维的塑料制品', type: 'recyclable', difficult: true }, // 特殊回收要求
    { name: '带电子显示屏的冰箱贴', type: 'recyclable', difficult: true }, // 需拆除电子部件
    { name: '复合材质的隐形眼镜包装', type: 'recyclable', difficult: true }, // 铝塑复合需专门处理
    { name: '带橡胶吸盘的塑料挂钩', type: 'recyclable', difficult: true }, // 需完全分离材质
    { name: '含金属钉的木质家具', type: 'recyclable', difficult: true }, // 需拆除金属连接件
    { name: '带硅胶密封圈的塑料盒', type: 'recyclable', difficult: true }, // 需完全分离部件
    { name: '复合材质的美妆蛋包装', type: 'recyclable', difficult: true }, // 塑料+纸质需分离
    { name: '带电子标签的服装', type: 'recyclable', difficult: true }, // 需拆除RFID标签
    { name: '含金属涂层的贺卡', type: 'recyclable', difficult: true }, // 涂层影响纸张回收
    { name: '带玻璃部件的台灯', type: 'recyclable', difficult: true }, // 需拆解分类回收
    { name: '复合材质的瑜伽垫', type: 'recyclable', difficult: true }, // PVC+织物需特殊处理
    { name: '带锂电池的智能手表', type: 'recyclable', difficult: true }, // 需专业电子回收
    { name: '含金属部件的眼镜框', type: 'recyclable', difficult: true }, // 需拆解材质分类
    { name: '带陶瓷装饰的金属餐具', type: 'recyclable', difficult: true }, // 需完全分离材质
    { name: '复合包装的湿纸巾袋', type: 'recyclable', difficult: true }, // 铝塑复合需专门处理
    { name: '带电子元件的圣诞装饰', type: 'recyclable', difficult: true }, // 需拆除电路部件
    { name: '含金属涂层的塑料瓶', type: 'recyclable', difficult: true }, // 涂层影响回收
    { name: '带硅胶部件的吸管', type: 'recyclable', difficult: true }, // 需分离不同材质
    { name: '复合材质的汽车保险杠', type: 'recyclable', difficult: true }, // 需专业拆解
    { name: '带玻璃面板的微波炉', type: 'recyclable', difficult: true }, // 需专业电子回收
    { name: '含金属丝的茶漏', type: 'recyclable', difficult: true }, // 需拆解分离材质

    { name: '咖啡滤纸（无咖啡渣）', type: 'kitchen', difficult: true }, // 纯纸质可回收，有残留算厨余
    { name: '可降解塑料袋装的厨余', type: 'kitchen', difficult: true }, // 需破袋投放
    { name: '中药药渣（含纱布包装）', type: 'kitchen', difficult: true }, // 需分离纱布
    { name: '海鲜头足类内脏', type: 'kitchen', difficult: true }, // 易与外壳混淆
    { name: '坚果壳（夏威夷果）', type: 'kitchen', difficult: true }, // 坚硬外壳易误判
    { name: '食用菌培养基', type: 'kitchen', difficult: true }, // 含木质成分需判断
    { name: '茶叶包（含线标）', type: 'kitchen', difficult: true }, // 需分离非厨余部件
    { name: '含牙签的水果残渣', type: 'kitchen', difficult: true }, // 需挑出牙签
    { name: '宠物食品（含干燥剂）', type: 'kitchen', difficult: true }, // 需分离包装
    { name: '调味料包装（有残留）', type: 'kitchen', difficult: true }, // 需清洁包装
    { name: '带贴纸的水果皮', type: 'kitchen', difficult: true }, // 需去除贴纸
    { name: '含蜡质的果蔬表皮', type: 'kitchen', difficult: true }, // 打蜡处理影响判断
    { name: '食用花卉的包装材料', type: 'kitchen', difficult: true }, // 需分离非有机部分
    { name: '含骨头的肉汤残渣', type: 'kitchen', difficult: true }, // 需分离大骨头
    { name: '烘焙失败的有机材料', type: 'kitchen', difficult: true }, // 可能含不可食用部件
    { name: '带绳结的粽子叶', type: 'kitchen', difficult: true }, // 需去除绑绳
    { name: '含包装的速冻食品', type: 'kitchen', difficult: true }, // 需完全解冻分离
    { name: '带贝壳的海鲜残渣', type: 'kitchen', difficult: true }, // 需分离贝壳
    { name: '含干燥剂的中药材', type: 'kitchen', difficult: true }, // 需分离非有机部分
    { name: '带标签的蔬菜捆扎带', type: 'kitchen', difficult: true }, // 需完全去除标签
    { name: '含牙签的餐厨垃圾', type: 'kitchen', difficult: true }, // 需仔细分拣
    { name: '带包装纸的口香糖', type: 'kitchen', difficult: true }, // 需分离包装
    { name: '含竹签的烧烤残渣', type: 'kitchen', difficult: true }, // 需去除竹签
    { name: '带吸管的饮料残渣', type: 'kitchen', difficult: true }, // 需分离吸管
    { name: '含调味包的方便面', type: 'kitchen', difficult: true }, // 需分离包装
    { name: '带金属扣的茶包', type: 'kitchen', difficult: true }, // 需拆除金属件
    { name: '含包装的火锅底料', type: 'kitchen', difficult: true }, // 需完全分离包装
    { name: '带塑料膜的冷冻蔬菜', type: 'kitchen', difficult: true }, // 需解冻分离
    { name: '含干燥剂的即食食品', type: 'kitchen', difficult: true }, // 需仔细分拣
    { name: '带标签的进口水果', type: 'kitchen', difficult: true }, // 需去除所有标签
    { name: '含牙线的餐后垃圾', type: 'kitchen', difficult: true }, // 需分离非有机部分
    { name: '带包装的调味料', type: 'kitchen', difficult: true }, // 需清洁包装
    { name: '含竹制餐具的外卖', type: 'kitchen', difficult: true }, // 需分离餐具
    { name: '带金属环的瓶装食品', type: 'kitchen', difficult: true }, // 需完全分离
    { name: '含保鲜膜的剩菜', type: 'kitchen', difficult: true }, // 需去除保鲜膜
    { name: '带橡皮筋的蔬菜', type: 'kitchen', difficult: true }, // 需去除所有捆扎物
    { name: '含干燥花的食品', type: 'kitchen', difficult: true }, // 需确认是否可降解
    { name: '带塑料头的棉签', type: 'kitchen', difficult: true }, // 需分离塑料部件
    { name: '含金属箔的巧克力', type: 'kitchen', difficult: true }, // 需完全分离包装
    { name: '带标签的有机食品', type: 'kitchen', difficult: true }, // 需去除所有标签
    { name: '含塑料膜的冷冻肉', type: 'kitchen', difficult: true }, // 需解冻分离
    { name: '带金属罐的宠物食品', type: 'kitchen', difficult: true }, // 需完全分离包装
    { name: '含竹签的甜品', type: 'kitchen', difficult: true }, // 需去除所有装饰物
    { name: '带塑料盖的调料瓶', type: 'kitchen', difficult: true }, // 需完全清洁分离
    { name: '含金属弹簧的厨房工具', type: 'kitchen', difficult: true }, // 需拆解分拣
    { name: '带电子标签的智能包装', type: 'kitchen', difficult: true }, // 需拆除电子元件
    { name: '含塑料网的果蔬包装', type: 'kitchen', difficult: true }, // 需完全分离
    { name: '带金属夹的食品袋', type: 'kitchen', difficult: true }, // 需拆除金属部件
    { name: '含干燥剂的保健食品', type: 'kitchen', difficult: true }, // 需仔细分拣

    { name: '含汞的恒温器', type: 'hazardous', difficult: true }, // 需专业回收
    { name: '废弃的电子烟弹', type: 'hazardous', difficult: true }, // 含尼古丁残留
    { name: '实验室PH试纸', type: 'hazardous', difficult: true }, // 含化学药剂
    { name: '含镉的旧电池', type: 'hazardous', difficult: true }, // 需特殊处理
    { name: '废弃的石棉制品', type: 'hazardous', difficult: true }, // 需专业防护处理
    { name: '含铅的钓鱼坠', type: 'hazardous', difficult: true }, // 重金属污染
    { name: '废弃的化学试剂瓶', type: 'hazardous', difficult: true }, // 需专业清洗
    { name: '含汞的牙齿填充物', type: 'hazardous', difficult: true }, // 医疗特殊废物
    { name: '废弃的夜光涂料', type: 'hazardous', difficult: true }, // 含放射性物质
    { name: '含砷的木材防腐剂', type: 'hazardous', difficult: true }, // 剧毒需专业处理
    { name: '废弃的氰化物溶液', type: 'hazardous', difficult: true }, // 剧毒化学品
    { name: '含多氯联苯的电容器', type: 'hazardous', difficult: true }, // 持久性污染物
    { name: '废弃的实验室手套', type: 'hazardous', difficult: true }, // 可能接触危险品
    { name: '含汞的继电器', type: 'hazardous', difficult: true }, // 需专业拆解
    { name: '废弃的X射线胶片', type: 'hazardous', difficult: true }, // 含银和化学物质
    { name: '含镉的太阳能板', type: 'hazardous', difficult: true }, // 需专业回收
    { name: '废弃的含铅水晶玻璃', type: 'hazardous', difficult: true }, // 重金属污染
    { name: '含铬的鞣制剂', type: 'hazardous', difficult: true }, // 六价铬污染
    { name: '废弃的含汞开关', type: 'hazardous', difficult: true }, // 需专业处理
    { name: '含多溴联苯的塑料', type: 'hazardous', difficult: true }, // 阻燃剂污染
    { name: '废弃的实验室滤纸', type: 'hazardous', difficult: true }, // 可能接触危险品
    { name: '含镍镉的充电电池', type: 'hazardous', difficult: true }, // 重金属污染
    { name: '废弃的含铍合金', type: 'hazardous', difficult: true }, // 剧毒需专业处理
    { name: '含钚的烟雾探测器', type: 'hazardous', difficult: true }, // 放射性物质
    { name: '废弃的含汞血压计', type: 'hazardous', difficult: true }, // 需专业回收
    { name: '含氰化物的电镀液', type: 'hazardous', difficult: true }, // 剧毒需中和处理
    { name: '废弃的实验室培养皿', type: 'hazardous', difficult: true }, // 生物污染风险
    { name: '含铅的彩绘玻璃', type: 'hazardous', difficult: true }, // 重金属污染
    { name: '废弃的含汞牙科材料', type: 'hazardous', difficult: true }, // 需医疗废物处理
    { name: '含多氯联苯的变压器油', type: 'hazardous', difficult: true }, // 持久性污染物
    { name: '废弃的含砷农药', type: 'hazardous', difficult: true }, // 剧毒需专业处理
    { name: '含镉的红色颜料', type: 'hazardous', difficult: true }, // 重金属污染
    { name: '废弃的含汞实验室试剂', type: 'hazardous', difficult: true }, // 需专业中和
    { name: '含铬的皮革鞣制剂', type: 'hazardous', difficult: true }, // 六价铬污染
    { name: '废弃的含铅焊料', type: 'hazardous', difficult: true }, // 重金属污染
    { name: '含汞的荧光粉', type: 'hazardous', difficult: true }, // 需专业回收
    { name: '废弃的含铊灭鼠剂', type: 'hazardous', difficult: true }, // 剧毒需专业处理
    { name: '含多环芳烃的焦油', type: 'hazardous', difficult: true }, // 致癌物质
    { name: '废弃的含汞温度控制器', type: 'hazardous', difficult: true },
];
