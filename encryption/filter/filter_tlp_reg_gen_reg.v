module  filter_tlp_reg_gen  (

clk                   ,
rst_n                 ,

params_filter_rst     ,

market_explain        , //市场说明 3
info_classify         , //信息分类 1
dialog_num            , //会话编号 4
contract_flag         , //合约标志 1
contract_num          , //合约编号 4
contract_code         , //合约代码 22
update_time           , //更新时间 9
update_ms             , //更新毫秒 4
new_price             , //最新价 8
turnover              , //成交量 4
volume                , //成交额 8   
position              , //持仓量 8
purchase_price        , //申买价 8
buy_quantity          , //申买量 4
sell_price            , //申买价 8
sell_quantity         , //申卖量 4
market_rdy            ,


sq00_market_explain     , //市场说明 3
sq01_market_explain     , //市场说明 3
sq02_market_explain     , //市场说明 3
sq03_market_explain     , //市场说明 3
sq04_market_explain     , //市场说明 3
sq05_market_explain     , //市场说明 3
sq06_market_explain     , //市场说明 3
sq07_market_explain     , //市场说明 3
sq08_market_explain     , //市场说明 3
sq09_market_explain     , //市场说明 3
sq10_market_explain     , //市场说明 3
sq11_market_explain     , //市场说明 3
sq12_market_explain     , //市场说明 3
sq13_market_explain     , //市场说明 3
sq14_market_explain     , //市场说明 3
sq15_market_explain     , //市场说明 3
sq16_market_explain     , //市场说明 3
sq17_market_explain     , //市场说明 3
sq18_market_explain     , //市场说明 3
sq19_market_explain     , //市场说明 3
sq20_market_explain     , //市场说明 3
sq21_market_explain     , //市场说明 3
sq22_market_explain     , //市场说明 3
sq23_market_explain     , //市场说明 3
sq24_market_explain     , //市场说明 3
sq25_market_explain     , //市场说明 3
sq26_market_explain     , //市场说明 3
sq27_market_explain     , //市场说明 3
sq28_market_explain     , //市场说明 3
sq29_market_explain     , //市场说明 3
sq30_market_explain     , //市场说明 3
sq31_market_explain     , //市场说明 3


sq00_info_classify      , //信息分类 1
sq01_info_classify      , //信息分类 1
sq02_info_classify      , //信息分类 1
sq03_info_classify      , //信息分类 1
sq04_info_classify      , //信息分类 1
sq05_info_classify      , //信息分类 1
sq06_info_classify      , //信息分类 1
sq07_info_classify      , //信息分类 1
sq08_info_classify      , //信息分类 1
sq09_info_classify      , //信息分类 1
sq10_info_classify      , //信息分类 1
sq11_info_classify      , //信息分类 1
sq12_info_classify      , //信息分类 1
sq13_info_classify      , //信息分类 1
sq14_info_classify      , //信息分类 1
sq15_info_classify      , //信息分类 1
sq16_info_classify      , //信息分类 1
sq17_info_classify      , //信息分类 1
sq18_info_classify      , //信息分类 1
sq19_info_classify      , //信息分类 1
sq20_info_classify      , //信息分类 1
sq21_info_classify      , //信息分类 1
sq22_info_classify      , //信息分类 1
sq23_info_classify      , //信息分类 1
sq24_info_classify      , //信息分类 1
sq25_info_classify      , //信息分类 1
sq26_info_classify      , //信息分类 1
sq27_info_classify      , //信息分类 1
sq28_info_classify      , //信息分类 1
sq29_info_classify      , //信息分类 1
sq30_info_classify      , //信息分类 1
sq31_info_classify      , //信息分类 1

sq00_dialog_num         , //会话编号 4
sq01_dialog_num         , //会话编号 4
sq02_dialog_num         , //会话编号 4
sq03_dialog_num         , //会话编号 4
sq04_dialog_num         , //会话编号 4
sq05_dialog_num         , //会话编号 4
sq06_dialog_num         , //会话编号 4
sq07_dialog_num         , //会话编号 4
sq08_dialog_num         , //会话编号 4
sq09_dialog_num         , //会话编号 4
sq10_dialog_num         , //会话编号 4
sq11_dialog_num         , //会话编号 4
sq12_dialog_num         , //会话编号 4
sq13_dialog_num         , //会话编号 4
sq14_dialog_num         , //会话编号 4
sq15_dialog_num         , //会话编号 4
sq16_dialog_num         , //会话编号 4
sq17_dialog_num         , //会话编号 4
sq18_dialog_num         , //会话编号 4
sq19_dialog_num         , //会话编号 4
sq20_dialog_num         , //会话编号 4
sq21_dialog_num         , //会话编号 4
sq22_dialog_num         , //会话编号 4
sq23_dialog_num         , //会话编号 4
sq24_dialog_num         , //会话编号 4
sq25_dialog_num         , //会话编号 4
sq26_dialog_num         , //会话编号 4
sq27_dialog_num         , //会话编号 4
sq28_dialog_num         , //会话编号 4
sq29_dialog_num         , //会话编号 4
sq30_dialog_num         , //会话编号 4
sq31_dialog_num         , //会话编号 4

sq00_contract_flag      , //合约标志 1
sq01_contract_flag      , //合约标志 1
sq02_contract_flag      , //合约标志 1
sq03_contract_flag      , //合约标志 1
sq04_contract_flag      , //合约标志 1
sq05_contract_flag      , //合约标志 1
sq06_contract_flag      , //合约标志 1
sq07_contract_flag      , //合约标志 1
sq08_contract_flag      , //合约标志 1
sq09_contract_flag      , //合约标志 1
sq10_contract_flag      , //合约标志 1
sq11_contract_flag      , //合约标志 1
sq12_contract_flag      , //合约标志 1
sq13_contract_flag      , //合约标志 1
sq14_contract_flag      , //合约标志 1
sq15_contract_flag      , //合约标志 1
sq16_contract_flag      , //合约标志 1
sq17_contract_flag      , //合约标志 1
sq18_contract_flag      , //合约标志 1
sq19_contract_flag      , //合约标志 1
sq20_contract_flag      , //合约标志 1
sq21_contract_flag      , //合约标志 1
sq22_contract_flag      , //合约标志 1
sq23_contract_flag      , //合约标志 1
sq24_contract_flag      , //合约标志 1
sq25_contract_flag      , //合约标志 1
sq26_contract_flag      , //合约标志 1
sq27_contract_flag      , //合约标志 1
sq28_contract_flag      , //合约标志 1
sq29_contract_flag      , //合约标志 1
sq30_contract_flag      , //合约标志 1
sq31_contract_flag      , //合约标志 1

sq00_contract_num       , //合约编号 4
sq01_contract_num       , //合约编号 4
sq02_contract_num       , //合约编号 4
sq03_contract_num       , //合约编号 4
sq04_contract_num       , //合约编号 4
sq05_contract_num       , //合约编号 4
sq06_contract_num       , //合约编号 4
sq07_contract_num       , //合约编号 4
sq08_contract_num       , //合约编号 4
sq09_contract_num       , //合约编号 4
sq10_contract_num       , //合约编号 4
sq11_contract_num       , //合约编号 4
sq12_contract_num       , //合约编号 4
sq13_contract_num       , //合约编号 4
sq14_contract_num       , //合约编号 4
sq15_contract_num       , //合约编号 4
sq16_contract_num       , //合约编号 4
sq17_contract_num       , //合约编号 4
sq18_contract_num       , //合约编号 4
sq19_contract_num       , //合约编号 4
sq20_contract_num       , //合约编号 4
sq21_contract_num       , //合约编号 4
sq22_contract_num       , //合约编号 4
sq23_contract_num       , //合约编号 4
sq24_contract_num       , //合约编号 4
sq25_contract_num       , //合约编号 4
sq26_contract_num       , //合约编号 4
sq27_contract_num       , //合约编号 4
sq28_contract_num       , //合约编号 4
sq29_contract_num       , //合约编号 4
sq30_contract_num       , //合约编号 4
sq31_contract_num       , //合约编号 4

sq00_contract_code      , //合约代码 22
sq01_contract_code      , //合约代码 22
sq02_contract_code      , //合约代码 22
sq03_contract_code      , //合约代码 22
sq04_contract_code      , //合约代码 22
sq05_contract_code      , //合约代码 22
sq06_contract_code      , //合约代码 22
sq07_contract_code      , //合约代码 22
sq08_contract_code      , //合约代码 22
sq09_contract_code      , //合约代码 22
sq10_contract_code      , //合约代码 22
sq11_contract_code      , //合约代码 22
sq12_contract_code      , //合约代码 22
sq13_contract_code      , //合约代码 22
sq14_contract_code      , //合约代码 22
sq15_contract_code      , //合约代码 22
sq16_contract_code      , //合约代码 22
sq17_contract_code      , //合约代码 22
sq18_contract_code      , //合约代码 22
sq19_contract_code      , //合约代码 22
sq20_contract_code      , //合约代码 22
sq21_contract_code      , //合约代码 22
sq22_contract_code      , //合约代码 22
sq23_contract_code      , //合约代码 22
sq24_contract_code      , //合约代码 22
sq25_contract_code      , //合约代码 22
sq26_contract_code      , //合约代码 22
sq27_contract_code      , //合约代码 22
sq28_contract_code      , //合约代码 22
sq29_contract_code      , //合约代码 22
sq30_contract_code      , //合约代码 22
sq31_contract_code      , //合约代码 22

sq00_update_time        , //更新时间 9
sq01_update_time        , //更新时间 9
sq02_update_time        , //更新时间 9
sq03_update_time        , //更新时间 9
sq04_update_time        , //更新时间 9
sq05_update_time        , //更新时间 9
sq06_update_time        , //更新时间 9
sq07_update_time        , //更新时间 9
sq08_update_time        , //更新时间 9
sq09_update_time        , //更新时间 9
sq10_update_time        , //更新时间 9
sq11_update_time        , //更新时间 9
sq12_update_time        , //更新时间 9
sq13_update_time        , //更新时间 9
sq14_update_time        , //更新时间 9
sq15_update_time        , //更新时间 9
sq16_update_time        , //更新时间 9
sq17_update_time        , //更新时间 9
sq18_update_time        , //更新时间 9
sq19_update_time        , //更新时间 9
sq20_update_time        , //更新时间 9
sq21_update_time        , //更新时间 9
sq22_update_time        , //更新时间 9
sq23_update_time        , //更新时间 9
sq24_update_time        , //更新时间 9
sq25_update_time        , //更新时间 9
sq26_update_time        , //更新时间 9
sq27_update_time        , //更新时间 9
sq28_update_time        , //更新时间 9
sq29_update_time        , //更新时间 9
sq30_update_time        , //更新时间 9
sq31_update_time        , //更新时间 9

sq00_update_ms          , //更新毫秒 4
sq01_update_ms          , //更新毫秒 4
sq02_update_ms          , //更新毫秒 4
sq03_update_ms          , //更新毫秒 4
sq04_update_ms          , //更新毫秒 4
sq05_update_ms          , //更新毫秒 4
sq06_update_ms          , //更新毫秒 4
sq07_update_ms          , //更新毫秒 4
sq08_update_ms          , //更新毫秒 4
sq09_update_ms          , //更新毫秒 4
sq10_update_ms          , //更新毫秒 4
sq11_update_ms          , //更新毫秒 4
sq12_update_ms          , //更新毫秒 4
sq13_update_ms          , //更新毫秒 4
sq14_update_ms          , //更新毫秒 4
sq15_update_ms          , //更新毫秒 4
sq16_update_ms          , //更新毫秒 4
sq17_update_ms          , //更新毫秒 4
sq18_update_ms          , //更新毫秒 4
sq19_update_ms          , //更新毫秒 4
sq20_update_ms          , //更新毫秒 4
sq21_update_ms          , //更新毫秒 4
sq22_update_ms          , //更新毫秒 4
sq23_update_ms          , //更新毫秒 4
sq24_update_ms          , //更新毫秒 4
sq25_update_ms          , //更新毫秒 4
sq26_update_ms          , //更新毫秒 4
sq27_update_ms          , //更新毫秒 4
sq28_update_ms          , //更新毫秒 4
sq29_update_ms          , //更新毫秒 4
sq30_update_ms          , //更新毫秒 4
sq31_update_ms          , //更新毫秒 4

sq00_new_price          , //最新价 8
sq01_new_price          , //最新价 8
sq02_new_price          , //最新价 8
sq03_new_price          , //最新价 8
sq04_new_price          , //最新价 8
sq05_new_price          , //最新价 8
sq06_new_price          , //最新价 8
sq07_new_price          , //最新价 8
sq08_new_price          , //最新价 8
sq09_new_price          , //最新价 8
sq10_new_price          , //最新价 8
sq11_new_price          , //最新价 8
sq12_new_price          , //最新价 8
sq13_new_price          , //最新价 8
sq14_new_price          , //最新价 8
sq15_new_price          , //最新价 8
sq16_new_price          , //最新价 8
sq17_new_price          , //最新价 8
sq18_new_price          , //最新价 8
sq19_new_price          , //最新价 8
sq20_new_price          , //最新价 8
sq21_new_price          , //最新价 8
sq22_new_price          , //最新价 8
sq23_new_price          , //最新价 8
sq24_new_price          , //最新价 8
sq25_new_price          , //最新价 8
sq26_new_price          , //最新价 8
sq27_new_price          , //最新价 8
sq28_new_price          , //最新价 8
sq29_new_price          , //最新价 8
sq30_new_price          , //最新价 8
sq31_new_price          , //最新价 8

sq00_turnover           , //成交量 4
sq01_turnover           , //成交量 4
sq02_turnover           , //成交量 4
sq03_turnover           , //成交量 4
sq04_turnover           , //成交量 4
sq05_turnover           , //成交量 4
sq06_turnover           , //成交量 4
sq07_turnover           , //成交量 4
sq08_turnover           , //成交量 4
sq09_turnover           , //成交量 4
sq10_turnover           , //成交量 4
sq11_turnover           , //成交量 4
sq12_turnover           , //成交量 4
sq13_turnover           , //成交量 4
sq14_turnover           , //成交量 4
sq15_turnover           , //成交量 4
sq16_turnover           , //成交量 4
sq17_turnover           , //成交量 4
sq18_turnover           , //成交量 4
sq19_turnover           , //成交量 4
sq20_turnover           , //成交量 4
sq21_turnover           , //成交量 4
sq22_turnover           , //成交量 4
sq23_turnover           , //成交量 4
sq24_turnover           , //成交量 4
sq25_turnover           , //成交量 4
sq26_turnover           , //成交量 4
sq27_turnover           , //成交量 4
sq28_turnover           , //成交量 4
sq29_turnover           , //成交量 4
sq30_turnover           , //成交量 4
sq31_turnover           , //成交量 4

sq00_volume             , //成交额 8   
sq01_volume             , //成交额 8   
sq02_volume             , //成交额 8   
sq03_volume             , //成交额 8   
sq04_volume             , //成交额 8   
sq05_volume             , //成交额 8   
sq06_volume             , //成交额 8   
sq07_volume             , //成交额 8
sq08_volume             , //成交额 8   
sq09_volume             , //成交额 8   
sq10_volume             , //成交额 8   
sq11_volume             , //成交额 8   
sq12_volume             , //成交额 8   
sq13_volume             , //成交额 8   
sq14_volume             , //成交额 8   
sq15_volume             , //成交额 8
sq16_volume             , //成交额 8   
sq17_volume             , //成交额 8   
sq18_volume             , //成交额 8   
sq19_volume             , //成交额 8   
sq20_volume             , //成交额 8   
sq21_volume             , //成交额 8   
sq22_volume             , //成交额 8   
sq23_volume             , //成交额 8
sq24_volume             , //成交额 8   
sq25_volume             , //成交额 8   
sq26_volume             , //成交额 8   
sq27_volume             , //成交额 8   
sq28_volume             , //成交额 8   
sq29_volume             , //成交额 8   
sq30_volume             , //成交额 8   
sq31_volume             , //成交额 8

sq00_position           , //持仓量 8
sq01_position           , //持仓量 8
sq02_position           , //持仓量 8
sq03_position           , //持仓量 8
sq04_position           , //持仓量 8
sq05_position           , //持仓量 8
sq06_position           , //持仓量 8
sq07_position           , //持仓量 8
sq08_position           , //持仓量 8
sq09_position           , //持仓量 8
sq10_position           , //持仓量 8
sq11_position           , //持仓量 8
sq12_position           , //持仓量 8
sq13_position           , //持仓量 8
sq14_position           , //持仓量 8
sq15_position           , //持仓量 8
sq16_position           , //持仓量 8
sq17_position           , //持仓量 8
sq18_position           , //持仓量 8
sq19_position           , //持仓量 8
sq20_position           , //持仓量 8
sq21_position           , //持仓量 8
sq22_position           , //持仓量 8
sq23_position           , //持仓量 8
sq24_position           , //持仓量 8
sq25_position           , //持仓量 8
sq26_position           , //持仓量 8
sq27_position           , //持仓量 8
sq28_position           , //持仓量 8
sq29_position           , //持仓量 8
sq30_position           , //持仓量 8
sq31_position           , //持仓量 8

sq00_purchase_price     , //申买价 8
sq01_purchase_price     , //申买价 8
sq02_purchase_price     , //申买价 8
sq03_purchase_price     , //申买价 8
sq04_purchase_price     , //申买价 8
sq05_purchase_price     , //申买价 8
sq06_purchase_price     , //申买价 8
sq07_purchase_price     , //申买价 8
sq08_purchase_price     , //申买价 8
sq09_purchase_price     , //申买价 8
sq10_purchase_price     , //申买价 8
sq11_purchase_price     , //申买价 8
sq12_purchase_price     , //申买价 8
sq13_purchase_price     , //申买价 8
sq14_purchase_price     , //申买价 8
sq15_purchase_price     , //申买价 8
sq16_purchase_price     , //申买价 8
sq17_purchase_price     , //申买价 8
sq18_purchase_price     , //申买价 8
sq19_purchase_price     , //申买价 8
sq20_purchase_price     , //申买价 8
sq21_purchase_price     , //申买价 8
sq22_purchase_price     , //申买价 8
sq23_purchase_price     , //申买价 8
sq24_purchase_price     , //申买价 8
sq25_purchase_price     , //申买价 8
sq26_purchase_price     , //申买价 8
sq27_purchase_price     , //申买价 8
sq28_purchase_price     , //申买价 8
sq29_purchase_price     , //申买价 8
sq30_purchase_price     , //申买价 8
sq31_purchase_price     , //申买价 8

sq00_buy_quantity       , //申买量 4
sq01_buy_quantity       , //申买量 4
sq02_buy_quantity       , //申买量 4
sq03_buy_quantity       , //申买量 4
sq04_buy_quantity       , //申买量 4
sq05_buy_quantity       , //申买量 4
sq06_buy_quantity       , //申买量 4
sq07_buy_quantity       , //申买量 4
sq08_buy_quantity       , //申买量 4
sq09_buy_quantity       , //申买量 4
sq10_buy_quantity       , //申买量 4
sq11_buy_quantity       , //申买量 4
sq12_buy_quantity       , //申买量 4
sq13_buy_quantity       , //申买量 4
sq14_buy_quantity       , //申买量 4
sq15_buy_quantity       , //申买量 4
sq16_buy_quantity       , //申买量 4
sq17_buy_quantity       , //申买量 4
sq18_buy_quantity       , //申买量 4
sq19_buy_quantity       , //申买量 4
sq20_buy_quantity       , //申买量 4
sq21_buy_quantity       , //申买量 4
sq22_buy_quantity       , //申买量 4
sq23_buy_quantity       , //申买量 4
sq24_buy_quantity       , //申买量 4
sq25_buy_quantity       , //申买量 4
sq26_buy_quantity       , //申买量 4
sq27_buy_quantity       , //申买量 4
sq28_buy_quantity       , //申买量 4
sq29_buy_quantity       , //申买量 4
sq30_buy_quantity       , //申买量 4
sq31_buy_quantity       , //申买量 4

sq00_sell_price         , //申买价 8
sq01_sell_price         , //申买价 8
sq02_sell_price         , //申买价 8
sq03_sell_price         , //申买价 8
sq04_sell_price         , //申买价 8
sq05_sell_price         , //申买价 8
sq06_sell_price         , //申买价 8
sq07_sell_price         , //申买价 8
sq08_sell_price         , //申买价 8
sq09_sell_price         , //申买价 8
sq10_sell_price         , //申买价 8
sq11_sell_price         , //申买价 8
sq12_sell_price         , //申买价 8
sq13_sell_price         , //申买价 8
sq14_sell_price         , //申买价 8
sq15_sell_price         , //申买价 8
sq16_sell_price         , //申买价 8
sq17_sell_price         , //申买价 8
sq18_sell_price         , //申买价 8
sq19_sell_price         , //申买价 8
sq20_sell_price         , //申买价 8
sq21_sell_price         , //申买价 8
sq22_sell_price         , //申买价 8
sq23_sell_price         , //申买价 8
sq24_sell_price         , //申买价 8
sq25_sell_price         , //申买价 8
sq26_sell_price         , //申买价 8
sq27_sell_price         , //申买价 8
sq28_sell_price         , //申买价 8
sq29_sell_price         , //申买价 8
sq30_sell_price         , //申买价 8
sq31_sell_price         , //申买价 8

sq00_sell_quantity      , //申卖量 4
sq01_sell_quantity      , //申卖量 4
sq02_sell_quantity      , //申卖量 4
sq03_sell_quantity      , //申卖量 4
sq04_sell_quantity      , //申卖量 4
sq05_sell_quantity      , //申卖量 4
sq06_sell_quantity      , //申卖量 4
sq07_sell_quantity      , //申卖量 4
sq08_sell_quantity      , //申卖量 4
sq09_sell_quantity      , //申卖量 4
sq10_sell_quantity      , //申卖量 4
sq11_sell_quantity      , //申卖量 4
sq12_sell_quantity      , //申卖量 4
sq13_sell_quantity      , //申卖量 4
sq14_sell_quantity      , //申卖量 4
sq15_sell_quantity      , //申卖量 4
sq16_sell_quantity      , //申卖量 4
sq17_sell_quantity      , //申卖量 4
sq18_sell_quantity      , //申卖量 4
sq19_sell_quantity      , //申卖量 4
sq20_sell_quantity      , //申卖量 4
sq21_sell_quantity      , //申卖量 4
sq22_sell_quantity      , //申卖量 4
sq23_sell_quantity      , //申卖量 4
sq24_sell_quantity      , //申卖量 4
sq25_sell_quantity      , //申卖量 4
sq26_sell_quantity      , //申卖量 4
sq27_sell_quantity      , //申卖量 4
sq28_sell_quantity      , //申卖量 4
sq29_sell_quantity      , //申卖量 4
sq30_sell_quantity      , //申卖量 4
sq31_sell_quantity      , //申卖量 4

sq00_market_rdy         ,
sq01_market_rdy         ,
sq02_market_rdy         ,
sq03_market_rdy         ,
sq04_market_rdy         ,
sq05_market_rdy         ,
sq06_market_rdy         ,
sq07_market_rdy         ,
sq08_market_rdy         ,
sq09_market_rdy         ,
sq10_market_rdy         ,
sq11_market_rdy         ,
sq12_market_rdy         ,
sq13_market_rdy         ,
sq14_market_rdy         ,
sq15_market_rdy         ,
sq16_market_rdy         ,
sq17_market_rdy         ,
sq18_market_rdy         ,
sq19_market_rdy         ,
sq20_market_rdy         ,
sq21_market_rdy         ,
sq22_market_rdy         ,
sq23_market_rdy         ,
sq24_market_rdy         ,
sq25_market_rdy         ,
sq26_market_rdy         ,
sq27_market_rdy         ,
sq28_market_rdy         ,
sq29_market_rdy         ,
sq30_market_rdy         ,
sq31_market_rdy         ,

rmem_data0_0            ,
rmem_data0_1            ,
rmem_data0_0_vld        ,
rmem_data0_1_vld        ,

rmem_data0_2            ,
rmem_data0_3            ,
rmem_data0_2_vld        ,
rmem_data0_3_vld        ,

rmem_data0            ,
rmem_data1            ,
rmem_data2            ,
rmem_data3            ,
rmem_vld              

);

input                       clk                ;
input                       rst_n              ;

input                       params_filter_rst  ;

input      [ 23: 0]         market_explain     ; //市场说明 3
input      [  7: 0]         info_classify      ; //信息分类 1
input      [ 31: 0]         dialog_num         ; //会话编号 4
input      [  7: 0]         contract_flag      ; //合约标志 1
input      [ 31: 0]         contract_num       ; //合约编号 4
input      [175: 0]         contract_code      ; //合约代码 22
input      [ 71: 0]         update_time        ; //更新时间 9
input      [ 31: 0]         update_ms          ; //更新毫秒 4
input      [ 63: 0]         new_price          ; //最新价 8
input      [ 31: 0]         turnover           ; //成交量 4
input      [ 63: 0]         volume             ; //成交额 8   
input      [ 63: 0]         position           ; //持仓量 8
input      [ 63: 0]         purchase_price     ; //申买价 8
input      [ 31: 0]         buy_quantity       ; //申买量 4
input      [ 63: 0]         sell_price         ; //申买价 8
input      [ 31: 0]         sell_quantity      ; //申卖量 4
input                       market_rdy         ;



input      [ 23: 0]         sq00_market_explain     ; //市场说明 3
input      [ 23: 0]         sq01_market_explain     ; //市场说明 3
input      [ 23: 0]         sq02_market_explain     ; //市场说明 3
input      [ 23: 0]         sq03_market_explain     ; //市场说明 3
input      [ 23: 0]         sq04_market_explain     ; //市场说明 3
input      [ 23: 0]         sq05_market_explain     ; //市场说明 3
input      [ 23: 0]         sq06_market_explain     ; //市场说明 3
input      [ 23: 0]         sq07_market_explain     ; //市场说明 3
input      [ 23: 0]         sq08_market_explain     ; //市场说明 3
input      [ 23: 0]         sq09_market_explain     ; //市场说明 3
input      [ 23: 0]         sq10_market_explain     ; //市场说明 3
input      [ 23: 0]         sq11_market_explain     ; //市场说明 3
input      [ 23: 0]         sq12_market_explain     ; //市场说明 3
input      [ 23: 0]         sq13_market_explain     ; //市场说明 3
input      [ 23: 0]         sq14_market_explain     ; //市场说明 3
input      [ 23: 0]         sq15_market_explain     ; //市场说明 3
input      [ 23: 0]         sq16_market_explain     ; //市场说明 3
input      [ 23: 0]         sq17_market_explain     ; //市场说明 3
input      [ 23: 0]         sq18_market_explain     ; //市场说明 3
input      [ 23: 0]         sq19_market_explain     ; //市场说明 3
input      [ 23: 0]         sq20_market_explain     ; //市场说明 3
input      [ 23: 0]         sq21_market_explain     ; //市场说明 3
input      [ 23: 0]         sq22_market_explain     ; //市场说明 3
input      [ 23: 0]         sq23_market_explain     ; //市场说明 3
input      [ 23: 0]         sq24_market_explain     ; //市场说明 3
input      [ 23: 0]         sq25_market_explain     ; //市场说明 3
input      [ 23: 0]         sq26_market_explain     ; //市场说明 3
input      [ 23: 0]         sq27_market_explain     ; //市场说明 3
input      [ 23: 0]         sq28_market_explain     ; //市场说明 3
input      [ 23: 0]         sq29_market_explain     ; //市场说明 3
input      [ 23: 0]         sq30_market_explain     ; //市场说明 3
input      [ 23: 0]         sq31_market_explain     ; //市场说明 3


input      [  7: 0]         sq00_info_classify      ; //信息分类 1
input      [  7: 0]         sq01_info_classify      ; //信息分类 1
input      [  7: 0]         sq02_info_classify      ; //信息分类 1
input      [  7: 0]         sq03_info_classify      ; //信息分类 1
input      [  7: 0]         sq04_info_classify      ; //信息分类 1
input      [  7: 0]         sq05_info_classify      ; //信息分类 1
input      [  7: 0]         sq06_info_classify      ; //信息分类 1
input      [  7: 0]         sq07_info_classify      ; //信息分类 1
input      [  7: 0]         sq08_info_classify      ; //信息分类 1
input      [  7: 0]         sq09_info_classify      ; //信息分类 1
input      [  7: 0]         sq10_info_classify      ; //信息分类 1
input      [  7: 0]         sq11_info_classify      ; //信息分类 1
input      [  7: 0]         sq12_info_classify      ; //信息分类 1
input      [  7: 0]         sq13_info_classify      ; //信息分类 1
input      [  7: 0]         sq14_info_classify      ; //信息分类 1
input      [  7: 0]         sq15_info_classify      ; //信息分类 1
input      [  7: 0]         sq16_info_classify      ; //信息分类 1
input      [  7: 0]         sq17_info_classify      ; //信息分类 1
input      [  7: 0]         sq18_info_classify      ; //信息分类 1
input      [  7: 0]         sq19_info_classify      ; //信息分类 1
input      [  7: 0]         sq20_info_classify      ; //信息分类 1
input      [  7: 0]         sq21_info_classify      ; //信息分类 1
input      [  7: 0]         sq22_info_classify      ; //信息分类 1
input      [  7: 0]         sq23_info_classify      ; //信息分类 1
input      [  7: 0]         sq24_info_classify      ; //信息分类 1
input      [  7: 0]         sq25_info_classify      ; //信息分类 1
input      [  7: 0]         sq26_info_classify      ; //信息分类 1
input      [  7: 0]         sq27_info_classify      ; //信息分类 1
input      [  7: 0]         sq28_info_classify      ; //信息分类 1
input      [  7: 0]         sq29_info_classify      ; //信息分类 1
input      [  7: 0]         sq30_info_classify      ; //信息分类 1
input      [  7: 0]         sq31_info_classify      ; //信息分类 1

input      [ 31: 0]         sq00_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq01_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq02_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq03_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq04_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq05_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq06_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq07_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq08_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq09_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq10_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq11_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq12_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq13_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq14_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq15_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq16_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq17_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq18_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq19_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq20_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq21_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq22_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq23_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq24_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq25_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq26_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq27_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq28_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq29_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq30_dialog_num         ; //会话编号 4
input      [ 31: 0]         sq31_dialog_num         ; //会话编号 4

input      [  7: 0]         sq00_contract_flag      ; //合约标志 1
input      [  7: 0]         sq01_contract_flag      ; //合约标志 1
input      [  7: 0]         sq02_contract_flag      ; //合约标志 1
input      [  7: 0]         sq03_contract_flag      ; //合约标志 1
input      [  7: 0]         sq04_contract_flag      ; //合约标志 1
input      [  7: 0]         sq05_contract_flag      ; //合约标志 1
input      [  7: 0]         sq06_contract_flag      ; //合约标志 1
input      [  7: 0]         sq07_contract_flag      ; //合约标志 1
input      [  7: 0]         sq08_contract_flag      ; //合约标志 1
input      [  7: 0]         sq09_contract_flag      ; //合约标志 1
input      [  7: 0]         sq10_contract_flag      ; //合约标志 1
input      [  7: 0]         sq11_contract_flag      ; //合约标志 1
input      [  7: 0]         sq12_contract_flag      ; //合约标志 1
input      [  7: 0]         sq13_contract_flag      ; //合约标志 1
input      [  7: 0]         sq14_contract_flag      ; //合约标志 1
input      [  7: 0]         sq15_contract_flag      ; //合约标志 1
input      [  7: 0]         sq16_contract_flag      ; //合约标志 1
input      [  7: 0]         sq17_contract_flag      ; //合约标志 1
input      [  7: 0]         sq18_contract_flag      ; //合约标志 1
input      [  7: 0]         sq19_contract_flag      ; //合约标志 1
input      [  7: 0]         sq20_contract_flag      ; //合约标志 1
input      [  7: 0]         sq21_contract_flag      ; //合约标志 1
input      [  7: 0]         sq22_contract_flag      ; //合约标志 1
input      [  7: 0]         sq23_contract_flag      ; //合约标志 1
input      [  7: 0]         sq24_contract_flag      ; //合约标志 1
input      [  7: 0]         sq25_contract_flag      ; //合约标志 1
input      [  7: 0]         sq26_contract_flag      ; //合约标志 1
input      [  7: 0]         sq27_contract_flag      ; //合约标志 1
input      [  7: 0]         sq28_contract_flag      ; //合约标志 1
input      [  7: 0]         sq29_contract_flag      ; //合约标志 1
input      [  7: 0]         sq30_contract_flag      ; //合约标志 1
input      [  7: 0]         sq31_contract_flag      ; //合约标志 1

input      [ 31: 0]         sq00_contract_num       ; //合约编号 4
input      [ 31: 0]         sq01_contract_num       ; //合约编号 4
input      [ 31: 0]         sq02_contract_num       ; //合约编号 4
input      [ 31: 0]         sq03_contract_num       ; //合约编号 4
input      [ 31: 0]         sq04_contract_num       ; //合约编号 4
input      [ 31: 0]         sq05_contract_num       ; //合约编号 4
input      [ 31: 0]         sq06_contract_num       ; //合约编号 4
input      [ 31: 0]         sq07_contract_num       ; //合约编号 4
input      [ 31: 0]         sq08_contract_num       ; //合约编号 4
input      [ 31: 0]         sq09_contract_num       ; //合约编号 4
input      [ 31: 0]         sq10_contract_num       ; //合约编号 4
input      [ 31: 0]         sq11_contract_num       ; //合约编号 4
input      [ 31: 0]         sq12_contract_num       ; //合约编号 4
input      [ 31: 0]         sq13_contract_num       ; //合约编号 4
input      [ 31: 0]         sq14_contract_num       ; //合约编号 4
input      [ 31: 0]         sq15_contract_num       ; //合约编号 4
input      [ 31: 0]         sq16_contract_num       ; //合约编号 4
input      [ 31: 0]         sq17_contract_num       ; //合约编号 4
input      [ 31: 0]         sq18_contract_num       ; //合约编号 4
input      [ 31: 0]         sq19_contract_num       ; //合约编号 4
input      [ 31: 0]         sq20_contract_num       ; //合约编号 4
input      [ 31: 0]         sq21_contract_num       ; //合约编号 4
input      [ 31: 0]         sq22_contract_num       ; //合约编号 4
input      [ 31: 0]         sq23_contract_num       ; //合约编号 4
input      [ 31: 0]         sq24_contract_num       ; //合约编号 4
input      [ 31: 0]         sq25_contract_num       ; //合约编号 4
input      [ 31: 0]         sq26_contract_num       ; //合约编号 4
input      [ 31: 0]         sq27_contract_num       ; //合约编号 4
input      [ 31: 0]         sq28_contract_num       ; //合约编号 4
input      [ 31: 0]         sq29_contract_num       ; //合约编号 4
input      [ 31: 0]         sq30_contract_num       ; //合约编号 4
input      [ 31: 0]         sq31_contract_num       ; //合约编号 4

input      [175: 0]         sq00_contract_code      ; //合约代码 22
input      [175: 0]         sq01_contract_code      ; //合约代码 22
input      [175: 0]         sq02_contract_code      ; //合约代码 22
input      [175: 0]         sq03_contract_code      ; //合约代码 22
input      [175: 0]         sq04_contract_code      ; //合约代码 22
input      [175: 0]         sq05_contract_code      ; //合约代码 22
input      [175: 0]         sq06_contract_code      ; //合约代码 22
input      [175: 0]         sq07_contract_code      ; //合约代码 22
input      [175: 0]         sq08_contract_code      ; //合约代码 22
input      [175: 0]         sq09_contract_code      ; //合约代码 22
input      [175: 0]         sq10_contract_code      ; //合约代码 22
input      [175: 0]         sq11_contract_code      ; //合约代码 22
input      [175: 0]         sq12_contract_code      ; //合约代码 22
input      [175: 0]         sq13_contract_code      ; //合约代码 22
input      [175: 0]         sq14_contract_code      ; //合约代码 22
input      [175: 0]         sq15_contract_code      ; //合约代码 22
input      [175: 0]         sq16_contract_code      ; //合约代码 22
input      [175: 0]         sq17_contract_code      ; //合约代码 22
input      [175: 0]         sq18_contract_code      ; //合约代码 22
input      [175: 0]         sq19_contract_code      ; //合约代码 22
input      [175: 0]         sq20_contract_code      ; //合约代码 22
input      [175: 0]         sq21_contract_code      ; //合约代码 22
input      [175: 0]         sq22_contract_code      ; //合约代码 22
input      [175: 0]         sq23_contract_code      ; //合约代码 22
input      [175: 0]         sq24_contract_code      ; //合约代码 22
input      [175: 0]         sq25_contract_code      ; //合约代码 22
input      [175: 0]         sq26_contract_code      ; //合约代码 22
input      [175: 0]         sq27_contract_code      ; //合约代码 22
input      [175: 0]         sq28_contract_code      ; //合约代码 22
input      [175: 0]         sq29_contract_code      ; //合约代码 22
input      [175: 0]         sq30_contract_code      ; //合约代码 22
input      [175: 0]         sq31_contract_code      ; //合约代码 22

input      [ 71: 0]         sq00_update_time        ; //更新时间 9
input      [ 71: 0]         sq01_update_time        ; //更新时间 9
input      [ 71: 0]         sq02_update_time        ; //更新时间 9
input      [ 71: 0]         sq03_update_time        ; //更新时间 9
input      [ 71: 0]         sq04_update_time        ; //更新时间 9
input      [ 71: 0]         sq05_update_time        ; //更新时间 9
input      [ 71: 0]         sq06_update_time        ; //更新时间 9
input      [ 71: 0]         sq07_update_time        ; //更新时间 9
input      [ 71: 0]         sq08_update_time        ; //更新时间 9
input      [ 71: 0]         sq09_update_time        ; //更新时间 9
input      [ 71: 0]         sq10_update_time        ; //更新时间 9
input      [ 71: 0]         sq11_update_time        ; //更新时间 9
input      [ 71: 0]         sq12_update_time        ; //更新时间 9
input      [ 71: 0]         sq13_update_time        ; //更新时间 9
input      [ 71: 0]         sq14_update_time        ; //更新时间 9
input      [ 71: 0]         sq15_update_time        ; //更新时间 9
input      [ 71: 0]         sq16_update_time        ; //更新时间 9
input      [ 71: 0]         sq17_update_time        ; //更新时间 9
input      [ 71: 0]         sq18_update_time        ; //更新时间 9
input      [ 71: 0]         sq19_update_time        ; //更新时间 9
input      [ 71: 0]         sq20_update_time        ; //更新时间 9
input      [ 71: 0]         sq21_update_time        ; //更新时间 9
input      [ 71: 0]         sq22_update_time        ; //更新时间 9
input      [ 71: 0]         sq23_update_time        ; //更新时间 9
input      [ 71: 0]         sq24_update_time        ; //更新时间 9
input      [ 71: 0]         sq25_update_time        ; //更新时间 9
input      [ 71: 0]         sq26_update_time        ; //更新时间 9
input      [ 71: 0]         sq27_update_time        ; //更新时间 9
input      [ 71: 0]         sq28_update_time        ; //更新时间 9
input      [ 71: 0]         sq29_update_time        ; //更新时间 9
input      [ 71: 0]         sq30_update_time        ; //更新时间 9
input      [ 71: 0]         sq31_update_time        ; //更新时间 9

input      [ 31: 0]         sq00_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq01_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq02_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq03_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq04_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq05_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq06_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq07_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq08_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq09_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq10_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq11_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq12_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq13_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq14_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq15_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq16_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq17_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq18_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq19_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq20_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq21_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq22_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq23_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq24_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq25_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq26_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq27_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq28_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq29_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq30_update_ms          ; //更新毫秒 4
input      [ 31: 0]         sq31_update_ms          ; //更新毫秒 4

input      [ 63: 0]         sq00_new_price          ; //最新价 8
input      [ 63: 0]         sq01_new_price          ; //最新价 8
input      [ 63: 0]         sq02_new_price          ; //最新价 8
input      [ 63: 0]         sq03_new_price          ; //最新价 8
input      [ 63: 0]         sq04_new_price          ; //最新价 8
input      [ 63: 0]         sq05_new_price          ; //最新价 8
input      [ 63: 0]         sq06_new_price          ; //最新价 8
input      [ 63: 0]         sq07_new_price          ; //最新价 8
input      [ 63: 0]         sq08_new_price          ; //最新价 8
input      [ 63: 0]         sq09_new_price          ; //最新价 8
input      [ 63: 0]         sq10_new_price          ; //最新价 8
input      [ 63: 0]         sq11_new_price          ; //最新价 8
input      [ 63: 0]         sq12_new_price          ; //最新价 8
input      [ 63: 0]         sq13_new_price          ; //最新价 8
input      [ 63: 0]         sq14_new_price          ; //最新价 8
input      [ 63: 0]         sq15_new_price          ; //最新价 8
input      [ 63: 0]         sq16_new_price          ; //最新价 8
input      [ 63: 0]         sq17_new_price          ; //最新价 8
input      [ 63: 0]         sq18_new_price          ; //最新价 8
input      [ 63: 0]         sq19_new_price          ; //最新价 8
input      [ 63: 0]         sq20_new_price          ; //最新价 8
input      [ 63: 0]         sq21_new_price          ; //最新价 8
input      [ 63: 0]         sq22_new_price          ; //最新价 8
input      [ 63: 0]         sq23_new_price          ; //最新价 8
input      [ 63: 0]         sq24_new_price          ; //最新价 8
input      [ 63: 0]         sq25_new_price          ; //最新价 8
input      [ 63: 0]         sq26_new_price          ; //最新价 8
input      [ 63: 0]         sq27_new_price          ; //最新价 8
input      [ 63: 0]         sq28_new_price          ; //最新价 8
input      [ 63: 0]         sq29_new_price          ; //最新价 8
input      [ 63: 0]         sq30_new_price          ; //最新价 8
input      [ 63: 0]         sq31_new_price          ; //最新价 8

input      [ 31: 0]         sq00_turnover           ; //成交量 4
input      [ 31: 0]         sq01_turnover           ; //成交量 4
input      [ 31: 0]         sq02_turnover           ; //成交量 4
input      [ 31: 0]         sq03_turnover           ; //成交量 4
input      [ 31: 0]         sq04_turnover           ; //成交量 4
input      [ 31: 0]         sq05_turnover           ; //成交量 4
input      [ 31: 0]         sq06_turnover           ; //成交量 4
input      [ 31: 0]         sq07_turnover           ; //成交量 4
input      [ 31: 0]         sq08_turnover           ; //成交量 4
input      [ 31: 0]         sq09_turnover           ; //成交量 4
input      [ 31: 0]         sq10_turnover           ; //成交量 4
input      [ 31: 0]         sq11_turnover           ; //成交量 4
input      [ 31: 0]         sq12_turnover           ; //成交量 4
input      [ 31: 0]         sq13_turnover           ; //成交量 4
input      [ 31: 0]         sq14_turnover           ; //成交量 4
input      [ 31: 0]         sq15_turnover           ; //成交量 4
input      [ 31: 0]         sq16_turnover           ; //成交量 4
input      [ 31: 0]         sq17_turnover           ; //成交量 4
input      [ 31: 0]         sq18_turnover           ; //成交量 4
input      [ 31: 0]         sq19_turnover           ; //成交量 4
input      [ 31: 0]         sq20_turnover           ; //成交量 4
input      [ 31: 0]         sq21_turnover           ; //成交量 4
input      [ 31: 0]         sq22_turnover           ; //成交量 4
input      [ 31: 0]         sq23_turnover           ; //成交量 4
input      [ 31: 0]         sq24_turnover           ; //成交量 4
input      [ 31: 0]         sq25_turnover           ; //成交量 4
input      [ 31: 0]         sq26_turnover           ; //成交量 4
input      [ 31: 0]         sq27_turnover           ; //成交量 4
input      [ 31: 0]         sq28_turnover           ; //成交量 4
input      [ 31: 0]         sq29_turnover           ; //成交量 4
input      [ 31: 0]         sq30_turnover           ; //成交量 4
input      [ 31: 0]         sq31_turnover           ; //成交量 4

input      [ 63: 0]         sq00_volume             ; //成交额 8   
input      [ 63: 0]         sq01_volume             ; //成交额 8   
input      [ 63: 0]         sq02_volume             ; //成交额 8   
input      [ 63: 0]         sq03_volume             ; //成交额 8   
input      [ 63: 0]         sq04_volume             ; //成交额 8   
input      [ 63: 0]         sq05_volume             ; //成交额 8   
input      [ 63: 0]         sq06_volume             ; //成交额 8   
input      [ 63: 0]         sq07_volume             ; //成交额 8
input      [ 63: 0]         sq08_volume             ; //成交额 8   
input      [ 63: 0]         sq09_volume             ; //成交额 8   
input      [ 63: 0]         sq10_volume             ; //成交额 8   
input      [ 63: 0]         sq11_volume             ; //成交额 8   
input      [ 63: 0]         sq12_volume             ; //成交额 8   
input      [ 63: 0]         sq13_volume             ; //成交额 8   
input      [ 63: 0]         sq14_volume             ; //成交额 8   
input      [ 63: 0]         sq15_volume             ; //成交额 8
input      [ 63: 0]         sq16_volume             ; //成交额 8   
input      [ 63: 0]         sq17_volume             ; //成交额 8   
input      [ 63: 0]         sq18_volume             ; //成交额 8   
input      [ 63: 0]         sq19_volume             ; //成交额 8   
input      [ 63: 0]         sq20_volume             ; //成交额 8   
input      [ 63: 0]         sq21_volume             ; //成交额 8   
input      [ 63: 0]         sq22_volume             ; //成交额 8   
input      [ 63: 0]         sq23_volume             ; //成交额 8
input      [ 63: 0]         sq24_volume             ; //成交额 8   
input      [ 63: 0]         sq25_volume             ; //成交额 8   
input      [ 63: 0]         sq26_volume             ; //成交额 8   
input      [ 63: 0]         sq27_volume             ; //成交额 8   
input      [ 63: 0]         sq28_volume             ; //成交额 8   
input      [ 63: 0]         sq29_volume             ; //成交额 8   
input      [ 63: 0]         sq30_volume             ; //成交额 8   
input      [ 63: 0]         sq31_volume             ; //成交额 8

input      [ 63: 0]         sq00_position           ; //持仓量 8
input      [ 63: 0]         sq01_position           ; //持仓量 8
input      [ 63: 0]         sq02_position           ; //持仓量 8
input      [ 63: 0]         sq03_position           ; //持仓量 8
input      [ 63: 0]         sq04_position           ; //持仓量 8
input      [ 63: 0]         sq05_position           ; //持仓量 8
input      [ 63: 0]         sq06_position           ; //持仓量 8
input      [ 63: 0]         sq07_position           ; //持仓量 8
input      [ 63: 0]         sq08_position           ; //持仓量 8
input      [ 63: 0]         sq09_position           ; //持仓量 8
input      [ 63: 0]         sq10_position           ; //持仓量 8
input      [ 63: 0]         sq11_position           ; //持仓量 8
input      [ 63: 0]         sq12_position           ; //持仓量 8
input      [ 63: 0]         sq13_position           ; //持仓量 8
input      [ 63: 0]         sq14_position           ; //持仓量 8
input      [ 63: 0]         sq15_position           ; //持仓量 8
input      [ 63: 0]         sq16_position           ; //持仓量 8
input      [ 63: 0]         sq17_position           ; //持仓量 8
input      [ 63: 0]         sq18_position           ; //持仓量 8
input      [ 63: 0]         sq19_position           ; //持仓量 8
input      [ 63: 0]         sq20_position           ; //持仓量 8
input      [ 63: 0]         sq21_position           ; //持仓量 8
input      [ 63: 0]         sq22_position           ; //持仓量 8
input      [ 63: 0]         sq23_position           ; //持仓量 8
input      [ 63: 0]         sq24_position           ; //持仓量 8
input      [ 63: 0]         sq25_position           ; //持仓量 8
input      [ 63: 0]         sq26_position           ; //持仓量 8
input      [ 63: 0]         sq27_position           ; //持仓量 8
input      [ 63: 0]         sq28_position           ; //持仓量 8
input      [ 63: 0]         sq29_position           ; //持仓量 8
input      [ 63: 0]         sq30_position           ; //持仓量 8
input      [ 63: 0]         sq31_position           ; //持仓量 8

input      [ 63: 0]         sq00_purchase_price     ; //申买价 8
input      [ 63: 0]         sq01_purchase_price     ; //申买价 8
input      [ 63: 0]         sq02_purchase_price     ; //申买价 8
input      [ 63: 0]         sq03_purchase_price     ; //申买价 8
input      [ 63: 0]         sq04_purchase_price     ; //申买价 8
input      [ 63: 0]         sq05_purchase_price     ; //申买价 8
input      [ 63: 0]         sq06_purchase_price     ; //申买价 8
input      [ 63: 0]         sq07_purchase_price     ; //申买价 8
input      [ 63: 0]         sq08_purchase_price     ; //申买价 8
input      [ 63: 0]         sq09_purchase_price     ; //申买价 8
input      [ 63: 0]         sq10_purchase_price     ; //申买价 8
input      [ 63: 0]         sq11_purchase_price     ; //申买价 8
input      [ 63: 0]         sq12_purchase_price     ; //申买价 8
input      [ 63: 0]         sq13_purchase_price     ; //申买价 8
input      [ 63: 0]         sq14_purchase_price     ; //申买价 8
input      [ 63: 0]         sq15_purchase_price     ; //申买价 8
input      [ 63: 0]         sq16_purchase_price     ; //申买价 8
input      [ 63: 0]         sq17_purchase_price     ; //申买价 8
input      [ 63: 0]         sq18_purchase_price     ; //申买价 8
input      [ 63: 0]         sq19_purchase_price     ; //申买价 8
input      [ 63: 0]         sq20_purchase_price     ; //申买价 8
input      [ 63: 0]         sq21_purchase_price     ; //申买价 8
input      [ 63: 0]         sq22_purchase_price     ; //申买价 8
input      [ 63: 0]         sq23_purchase_price     ; //申买价 8
input      [ 63: 0]         sq24_purchase_price     ; //申买价 8
input      [ 63: 0]         sq25_purchase_price     ; //申买价 8
input      [ 63: 0]         sq26_purchase_price     ; //申买价 8
input      [ 63: 0]         sq27_purchase_price     ; //申买价 8
input      [ 63: 0]         sq28_purchase_price     ; //申买价 8
input      [ 63: 0]         sq29_purchase_price     ; //申买价 8
input      [ 63: 0]         sq30_purchase_price     ; //申买价 8
input      [ 63: 0]         sq31_purchase_price     ; //申买价 8

input      [ 31: 0]         sq00_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq01_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq02_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq03_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq04_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq05_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq06_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq07_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq08_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq09_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq10_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq11_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq12_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq13_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq14_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq15_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq16_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq17_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq18_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq19_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq20_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq21_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq22_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq23_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq24_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq25_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq26_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq27_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq28_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq29_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq30_buy_quantity       ; //申买量 4
input      [ 31: 0]         sq31_buy_quantity       ; //申买量 4

input      [ 63: 0]         sq00_sell_price         ; //申买价 8
input      [ 63: 0]         sq01_sell_price         ; //申买价 8
input      [ 63: 0]         sq02_sell_price         ; //申买价 8
input      [ 63: 0]         sq03_sell_price         ; //申买价 8
input      [ 63: 0]         sq04_sell_price         ; //申买价 8
input      [ 63: 0]         sq05_sell_price         ; //申买价 8
input      [ 63: 0]         sq06_sell_price         ; //申买价 8
input      [ 63: 0]         sq07_sell_price         ; //申买价 8
input      [ 63: 0]         sq08_sell_price         ; //申买价 8
input      [ 63: 0]         sq09_sell_price         ; //申买价 8
input      [ 63: 0]         sq10_sell_price         ; //申买价 8
input      [ 63: 0]         sq11_sell_price         ; //申买价 8
input      [ 63: 0]         sq12_sell_price         ; //申买价 8
input      [ 63: 0]         sq13_sell_price         ; //申买价 8
input      [ 63: 0]         sq14_sell_price         ; //申买价 8
input      [ 63: 0]         sq15_sell_price         ; //申买价 8
input      [ 63: 0]         sq16_sell_price         ; //申买价 8
input      [ 63: 0]         sq17_sell_price         ; //申买价 8
input      [ 63: 0]         sq18_sell_price         ; //申买价 8
input      [ 63: 0]         sq19_sell_price         ; //申买价 8
input      [ 63: 0]         sq20_sell_price         ; //申买价 8
input      [ 63: 0]         sq21_sell_price         ; //申买价 8
input      [ 63: 0]         sq22_sell_price         ; //申买价 8
input      [ 63: 0]         sq23_sell_price         ; //申买价 8
input      [ 63: 0]         sq24_sell_price         ; //申买价 8
input      [ 63: 0]         sq25_sell_price         ; //申买价 8
input      [ 63: 0]         sq26_sell_price         ; //申买价 8
input      [ 63: 0]         sq27_sell_price         ; //申买价 8
input      [ 63: 0]         sq28_sell_price         ; //申买价 8
input      [ 63: 0]         sq29_sell_price         ; //申买价 8
input      [ 63: 0]         sq30_sell_price         ; //申买价 8
input      [ 63: 0]         sq31_sell_price         ; //申买价 8

input      [ 31: 0]         sq00_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq01_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq02_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq03_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq04_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq05_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq06_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq07_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq08_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq09_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq10_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq11_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq12_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq13_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq14_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq15_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq16_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq17_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq18_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq19_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq20_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq21_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq22_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq23_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq24_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq25_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq26_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq27_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq28_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq29_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq30_sell_quantity      ; //申卖量 4
input      [ 31: 0]         sq31_sell_quantity      ; //申卖量 4

input                       sq00_market_rdy         ;
input                       sq01_market_rdy         ;
input                       sq02_market_rdy         ;
input                       sq03_market_rdy         ;
input                       sq04_market_rdy         ;
input                       sq05_market_rdy         ;
input                       sq06_market_rdy         ;
input                       sq07_market_rdy         ;
input                       sq08_market_rdy         ;
input                       sq09_market_rdy         ;
input                       sq10_market_rdy         ;
input                       sq11_market_rdy         ;
input                       sq12_market_rdy         ;
input                       sq13_market_rdy         ;
input                       sq14_market_rdy         ;
input                       sq15_market_rdy         ;
input                       sq16_market_rdy         ;
input                       sq17_market_rdy         ;
input                       sq18_market_rdy         ;
input                       sq19_market_rdy         ;
input                       sq20_market_rdy         ;
input                       sq21_market_rdy         ;
input                       sq22_market_rdy         ;
input                       sq23_market_rdy         ;
input                       sq24_market_rdy         ;
input                       sq25_market_rdy         ;
input                       sq26_market_rdy         ;
input                       sq27_market_rdy         ;
input                       sq28_market_rdy         ;
input                       sq29_market_rdy         ;
input                       sq30_market_rdy         ;
input                       sq31_market_rdy         ;


output     [255:0]          rmem_data0            ;
output     [255:0]          rmem_data1            ;
output     [255:0]          rmem_data2            ;
output     [ 31:0]          rmem_data3            ;
output                      rmem_vld              ;


output        [255:0]          rmem_data0_0 ;
output        [255:0]          rmem_data0_1 ;
output                         rmem_data0_0_vld ;
output                         rmem_data0_1_vld ;


output        [255:0]          rmem_data0_2 ;
output        [255:0]          rmem_data0_3 ;
output                         rmem_data0_2_vld ;
output                         rmem_data0_3_vld ;
/////////////////////////////////////////////////////////////////////////////////////
reg        [  1:0]          rmem_cnt              ;

//////////////////////////////////////////////////////////////////////////////////////////////
reg        [255:0]          rmem_data0 ;
reg        [255:0]          rmem_data1 ;
reg        [255:0]          rmem_data2 ;
reg        [ 31:0]          rmem_data3 ;
reg                         rmem_vld   ;

reg        [255:0]          rmem_data0_0 ;
reg        [255:0]          rmem_data1_0 ;
reg        [255:0]          rmem_data2_0 ;

reg        [255:0]          rmem_data0_1 ;
reg        [255:0]          rmem_data1_1 ;
reg        [255:0]          rmem_data2_1 ;

reg        [255:0]          rmem_data0_2 ;
reg        [255:0]          rmem_data1_2 ;
reg        [255:0]          rmem_data2_2 ;

reg        [255:0]          rmem_data0_3 ;
reg        [255:0]          rmem_data1_3 ;
reg        [255:0]          rmem_data2_3 ;

reg                         rmem_data0_0_vld ;
reg                         rmem_data1_0_vld ;
reg                         rmem_data2_0_vld ;

reg                         rmem_data0_1_vld ;
reg                         rmem_data1_1_vld ;
reg                         rmem_data2_1_vld ;

reg                         rmem_data0_2_vld ;
reg                         rmem_data1_2_vld ;
reg                         rmem_data2_2_vld ;

reg                         rmem_data0_3_vld ;
reg                         rmem_data1_3_vld ;
reg                         rmem_data2_3_vld ;

reg        [ 31: 0]         contract_num_cnt   ; //合约编号 4

wire        [ 31: 0]        contract_num_wire    ; 

wire        [ 31: 0]        sq_market_rdy       ;

assign    sq_market_rdy =  {
sq31_market_rdy,
sq30_market_rdy,
sq29_market_rdy,
sq28_market_rdy,
sq27_market_rdy,
sq26_market_rdy,
sq25_market_rdy,
sq24_market_rdy,
sq23_market_rdy,
sq22_market_rdy,
sq21_market_rdy,
sq20_market_rdy,
sq19_market_rdy,
sq18_market_rdy,
sq17_market_rdy,
sq16_market_rdy,
sq15_market_rdy,
sq14_market_rdy,
sq13_market_rdy,
sq12_market_rdy,
sq11_market_rdy,
sq10_market_rdy,
sq09_market_rdy,
sq08_market_rdy,
sq07_market_rdy,
sq06_market_rdy,
sq05_market_rdy,
sq04_market_rdy,
sq03_market_rdy,
sq02_market_rdy,
sq01_market_rdy,
sq00_market_rdy
};

reg               market_rdy_dly   ;
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     market_rdy_dly  <=  1'd0 ;
  end
  else  if (  market_rdy|| (|sq_market_rdy)  )   begin
     market_rdy_dly  <=  1'd1 ;    
  end
  else begin
     market_rdy_dly  <=  1'd0 ;    
  end
end

 
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     contract_num_cnt  <=  32'd1 ;
  end
  else if (params_filter_rst) begin
     contract_num_cnt  <=  32'd1 ;
  end
  else  if (  market_rdy_dly   )   begin
     contract_num_cnt  <=  (contract_num_cnt==32'hffff_ffff)  ?   32'd1  :   contract_num_cnt +  32'd1 ;    
  end
end

assign   contract_num_wire = { contract_num_cnt[7:0],contract_num_cnt[15:8],contract_num_cnt[23:16],contract_num_cnt[31:24] };


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data0_0  <=  256'd0 ;
     rmem_data0_0_vld  <=  1'd0  ;
  end
  else begin
     rmem_data0_0_vld  <=  |sq_market_rdy[ 7:0]  ;      
     case (sq_market_rdy[7:0])
	 8'h01:     rmem_data0_0  <=  {sq00_market_explain[23:0]   ,sq00_info_classify[7:0]      ,sq00_dialog_num[31:0]        ,sq00_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq00_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h02:     rmem_data0_0  <=  {sq01_market_explain[23:0]   ,sq01_info_classify[7:0]      ,sq01_dialog_num[31:0]        ,sq01_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq01_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h04:     rmem_data0_0  <=  {sq02_market_explain[23:0]   ,sq02_info_classify[7:0]      ,sq02_dialog_num[31:0]        ,sq02_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq02_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h08:     rmem_data0_0  <=  {sq03_market_explain[23:0]   ,sq03_info_classify[7:0]      ,sq03_dialog_num[31:0]        ,sq03_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq03_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h10:     rmem_data0_0  <=  {sq04_market_explain[23:0]   ,sq04_info_classify[7:0]      ,sq04_dialog_num[31:0]        ,sq04_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq04_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h20:     rmem_data0_0  <=  {sq05_market_explain[23:0]   ,sq05_info_classify[7:0]      ,sq05_dialog_num[31:0]        ,sq05_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq05_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h40:     rmem_data0_0  <=  {sq06_market_explain[23:0]   ,sq06_info_classify[7:0]      ,sq06_dialog_num[31:0]        ,sq06_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq06_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h80:     rmem_data0_0  <=  {sq07_market_explain[23:0]   ,sq07_info_classify[7:0]      ,sq07_dialog_num[31:0]        ,sq07_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq07_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 default:      rmem_data0_0  <=   rmem_data0_0 ; 
	 endcase
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data0_2  <=  256'd0 ;
     rmem_data0_2_vld  <=  1'd0  ;
  end
  else begin
     rmem_data0_2_vld  <=  |sq_market_rdy[15:8]  ;      
     case (sq_market_rdy[15:8])
	 8'h01:     rmem_data0_2  <=  {sq08_market_explain[23:0]   ,sq08_info_classify[7:0]      ,sq08_dialog_num[31:0]        ,sq08_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq08_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h02:     rmem_data0_2  <=  {sq09_market_explain[23:0]   ,sq09_info_classify[7:0]      ,sq09_dialog_num[31:0]        ,sq09_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq09_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h04:     rmem_data0_2  <=  {sq10_market_explain[23:0]   ,sq10_info_classify[7:0]      ,sq10_dialog_num[31:0]        ,sq10_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq10_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h08:     rmem_data0_2  <=  {sq11_market_explain[23:0]   ,sq11_info_classify[7:0]      ,sq11_dialog_num[31:0]        ,sq11_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq11_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h10:     rmem_data0_2  <=  {sq12_market_explain[23:0]   ,sq12_info_classify[7:0]      ,sq12_dialog_num[31:0]        ,sq12_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq12_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h20:     rmem_data0_2  <=  {sq13_market_explain[23:0]   ,sq13_info_classify[7:0]      ,sq13_dialog_num[31:0]        ,sq13_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq13_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h40:     rmem_data0_2  <=  {sq14_market_explain[23:0]   ,sq14_info_classify[7:0]      ,sq14_dialog_num[31:0]        ,sq14_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq14_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h80:     rmem_data0_2  <=  {sq15_market_explain[23:0]   ,sq15_info_classify[7:0]      ,sq15_dialog_num[31:0]        ,sq15_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq15_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 default:   rmem_data0_2  <=   rmem_data0_2 ; 
	 endcase
  end
end



always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data0_1  <=  256'd0 ;
     rmem_data0_1_vld <= 1'd0 ;
  end
//  else if ( |{market_rdy,sq_market_rdy[31:16]} )  begin
  else  begin  
     rmem_data0_1_vld <=  |{market_rdy,sq_market_rdy[31:24]}  ;      
     case ({market_rdy,sq_market_rdy[31:24]})
	 9'h0_01:     rmem_data0_1  <=  {sq24_market_explain[23:0]   ,sq24_info_classify[7:0]      ,sq24_dialog_num[31:0]        ,sq24_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq24_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_02:     rmem_data0_1  <=  {sq25_market_explain[23:0]   ,sq25_info_classify[7:0]      ,sq25_dialog_num[31:0]        ,sq25_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq25_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_04:     rmem_data0_1  <=  {sq26_market_explain[23:0]   ,sq26_info_classify[7:0]      ,sq26_dialog_num[31:0]        ,sq26_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq26_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_08:     rmem_data0_1  <=  {sq27_market_explain[23:0]   ,sq27_info_classify[7:0]      ,sq27_dialog_num[31:0]        ,sq27_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq27_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_10:     rmem_data0_1  <=  {sq28_market_explain[23:0]   ,sq28_info_classify[7:0]      ,sq28_dialog_num[31:0]        ,sq28_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq28_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_20:     rmem_data0_1  <=  {sq29_market_explain[23:0]   ,sq29_info_classify[7:0]      ,sq29_dialog_num[31:0]        ,sq29_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq29_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_40:     rmem_data0_1  <=  {sq30_market_explain[23:0]   ,sq30_info_classify[7:0]      ,sq30_dialog_num[31:0]        ,sq30_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq30_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 9'h0_80:     rmem_data0_1  <=  {sq31_market_explain[23:0]   ,sq31_info_classify[7:0]      ,sq31_dialog_num[31:0]        ,sq31_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq31_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
         9'h1_00  :     rmem_data0_1  <=  {market_explain[23:0]   ,info_classify[7:0]      ,dialog_num[31:0]        ,contract_flag[7:0]  ,contract_num_wire[31:0]   ,contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
         default      :     rmem_data0_1  <=  rmem_data0_1  ;  //3+1+4+1+4 + 19
	 endcase
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data0_3  <=  256'd0 ;
     rmem_data0_3_vld <= 1'd0 ;
  end
//  else if ( |{market_rdy,sq_market_rdy[31:16]} )  begin
  else  begin  
     rmem_data0_3_vld <=  |sq_market_rdy[23:16]  ;      
     case (sq_market_rdy[23:16])
	 8'h01:     rmem_data0_3  <=  {sq16_market_explain[23:0]   ,sq16_info_classify[7:0]      ,sq16_dialog_num[31:0]        ,sq16_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq16_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h02:     rmem_data0_3  <=  {sq17_market_explain[23:0]   ,sq17_info_classify[7:0]      ,sq17_dialog_num[31:0]        ,sq17_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq17_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h04:     rmem_data0_3  <=  {sq18_market_explain[23:0]   ,sq18_info_classify[7:0]      ,sq18_dialog_num[31:0]        ,sq18_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq18_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h08:     rmem_data0_3  <=  {sq19_market_explain[23:0]   ,sq19_info_classify[7:0]      ,sq19_dialog_num[31:0]        ,sq19_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq19_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h10:     rmem_data0_3  <=  {sq20_market_explain[23:0]   ,sq20_info_classify[7:0]      ,sq20_dialog_num[31:0]        ,sq20_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq20_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h20:     rmem_data0_3  <=  {sq21_market_explain[23:0]   ,sq21_info_classify[7:0]      ,sq21_dialog_num[31:0]        ,sq21_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq21_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h40:     rmem_data0_3  <=  {sq22_market_explain[23:0]   ,sq22_info_classify[7:0]      ,sq22_dialog_num[31:0]        ,sq22_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq22_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
	 8'h80:     rmem_data0_3  <=  {sq23_market_explain[23:0]   ,sq23_info_classify[7:0]      ,sq23_dialog_num[31:0]        ,sq23_contract_flag[7:0]  ,contract_num_wire[31:0]   ,sq23_contract_code[22*8-1:3*8]} ;  //3+1+4+1+4 + 19
         default:   rmem_data0_3  <=  rmem_data0_3  ;  //3+1+4+1+4 + 19
	 endcase
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
	 rmem_data0  <=  256'd0 ;
  end
  else if ( rmem_data0_0_vld )  begin 
	 rmem_data0  <=  rmem_data0_0 ;         
  end
  else if ( rmem_data0_1_vld )  begin 
	 rmem_data0  <=  rmem_data0_1 ;         
  end
  else if ( rmem_data0_2_vld )  begin 
	 rmem_data0  <=  rmem_data0_2 ;         
  end
  else if ( rmem_data0_3_vld )  begin 
	 rmem_data0  <=  rmem_data0_3 ;         
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data1_0  <=  256'd0 ;
     rmem_data1_0_vld  <=  1'd0  ;           
  end
//  else if ( |sq_market_rdy[7:0] )  begin
  else  begin
     rmem_data1_0_vld  <=  |sq_market_rdy[7:0]  ;      
     case (sq_market_rdy[7:0])
	 8'h01:     rmem_data1_0  <=  {sq00_contract_code[3*8-1:0] ,sq00_update_time[71:0]       ,sq00_update_ms[31:0]         ,sq00_new_price[63:0]     ,sq00_turnover[31:0]         ,sq00_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h02:     rmem_data1_0  <=  {sq01_contract_code[3*8-1:0] ,sq01_update_time[71:0]       ,sq01_update_ms[31:0]         ,sq01_new_price[63:0]     ,sq01_turnover[31:0]         ,sq01_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h04:     rmem_data1_0  <=  {sq02_contract_code[3*8-1:0] ,sq02_update_time[71:0]       ,sq02_update_ms[31:0]         ,sq02_new_price[63:0]     ,sq02_turnover[31:0]         ,sq02_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h08:     rmem_data1_0  <=  {sq03_contract_code[3*8-1:0] ,sq03_update_time[71:0]       ,sq03_update_ms[31:0]         ,sq03_new_price[63:0]     ,sq03_turnover[31:0]         ,sq03_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h10:     rmem_data1_0  <=  {sq04_contract_code[3*8-1:0] ,sq04_update_time[71:0]       ,sq04_update_ms[31:0]         ,sq04_new_price[63:0]     ,sq04_turnover[31:0]         ,sq04_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h20:     rmem_data1_0  <=  {sq05_contract_code[3*8-1:0] ,sq05_update_time[71:0]       ,sq05_update_ms[31:0]         ,sq05_new_price[63:0]     ,sq05_turnover[31:0]         ,sq05_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h40:     rmem_data1_0  <=  {sq06_contract_code[3*8-1:0] ,sq06_update_time[71:0]       ,sq06_update_ms[31:0]         ,sq06_new_price[63:0]     ,sq06_turnover[31:0]         ,sq06_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h80 :  rmem_data1_0  <=  {sq07_contract_code[3*8-1:0] ,sq07_update_time[71:0]       ,sq07_update_ms[31:0]         ,sq07_new_price[63:0]     ,sq07_turnover[31:0]         ,sq07_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
         default :  rmem_data1_0 <= rmem_data1_0 ;
	 endcase
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data1_2  <=  256'd0 ;
     rmem_data1_2_vld  <=  1'd0  ;           
  end
//  else if ( |sq_market_rdy[15:0] )  begin
  else  begin
     rmem_data1_2_vld  <=   |sq_market_rdy[15:8]  ;      
     case (sq_market_rdy[15:8])
	 8'h01:     rmem_data1_2  <=  {sq08_contract_code[3*8-1:0] ,sq08_update_time[71:0]       ,sq08_update_ms[31:0]         ,sq08_new_price[63:0]     ,sq08_turnover[31:0]         ,sq08_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h02:     rmem_data1_2  <=  {sq09_contract_code[3*8-1:0] ,sq09_update_time[71:0]       ,sq09_update_ms[31:0]         ,sq09_new_price[63:0]     ,sq09_turnover[31:0]         ,sq09_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h04:     rmem_data1_2  <=  {sq10_contract_code[3*8-1:0] ,sq10_update_time[71:0]       ,sq10_update_ms[31:0]         ,sq10_new_price[63:0]     ,sq10_turnover[31:0]         ,sq10_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h08:     rmem_data1_2  <=  {sq11_contract_code[3*8-1:0] ,sq11_update_time[71:0]       ,sq11_update_ms[31:0]         ,sq11_new_price[63:0]     ,sq11_turnover[31:0]         ,sq11_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h10:     rmem_data1_2  <=  {sq12_contract_code[3*8-1:0] ,sq12_update_time[71:0]       ,sq12_update_ms[31:0]         ,sq12_new_price[63:0]     ,sq12_turnover[31:0]         ,sq12_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h20:     rmem_data1_2  <=  {sq13_contract_code[3*8-1:0] ,sq13_update_time[71:0]       ,sq13_update_ms[31:0]         ,sq13_new_price[63:0]     ,sq13_turnover[31:0]         ,sq13_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h40:     rmem_data1_2  <=  {sq14_contract_code[3*8-1:0] ,sq14_update_time[71:0]       ,sq14_update_ms[31:0]         ,sq14_new_price[63:0]     ,sq14_turnover[31:0]         ,sq14_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h80  :    rmem_data1_2  <=  {sq15_contract_code[3*8-1:0] ,sq15_update_time[71:0]       ,sq15_update_ms[31:0]         ,sq15_new_price[63:0]     ,sq15_turnover[31:0]         ,sq15_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 default  :    rmem_data1_2  <=    rmem_data1_2  ;  //3+9+4+8+4 +4         
	 endcase
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data1_1  <=  256'd0 ;
     rmem_data1_1_vld  <=  1'd0  ;
  end
//  else if ( |sq_market_rdy[23:16] )  begin
  else  begin  
         rmem_data1_1_vld  <=  |sq_market_rdy[23:16]  ;            
     case (sq_market_rdy[23:16])
	 8'h01:     rmem_data1_1  <=  {sq16_contract_code[3*8-1:0] ,sq16_update_time[71:0]       ,sq16_update_ms[31:0]         ,sq16_new_price[63:0]     ,sq16_turnover[31:0]         ,sq16_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h02:     rmem_data1_1  <=  {sq17_contract_code[3*8-1:0] ,sq17_update_time[71:0]       ,sq17_update_ms[31:0]         ,sq17_new_price[63:0]     ,sq17_turnover[31:0]         ,sq17_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h04:     rmem_data1_1  <=  {sq18_contract_code[3*8-1:0] ,sq18_update_time[71:0]       ,sq18_update_ms[31:0]         ,sq18_new_price[63:0]     ,sq18_turnover[31:0]         ,sq18_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h08:     rmem_data1_1  <=  {sq19_contract_code[3*8-1:0] ,sq19_update_time[71:0]       ,sq19_update_ms[31:0]         ,sq19_new_price[63:0]     ,sq19_turnover[31:0]         ,sq19_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h10:     rmem_data1_1  <=  {sq20_contract_code[3*8-1:0] ,sq20_update_time[71:0]       ,sq20_update_ms[31:0]         ,sq20_new_price[63:0]     ,sq20_turnover[31:0]         ,sq20_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h20:     rmem_data1_1  <=  {sq21_contract_code[3*8-1:0] ,sq21_update_time[71:0]       ,sq21_update_ms[31:0]         ,sq21_new_price[63:0]     ,sq21_turnover[31:0]         ,sq21_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h40:     rmem_data1_1  <=  {sq22_contract_code[3*8-1:0] ,sq22_update_time[71:0]       ,sq22_update_ms[31:0]         ,sq22_new_price[63:0]     ,sq22_turnover[31:0]         ,sq22_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 8'h80:    rmem_data1_1  <=  {sq23_contract_code[3*8-1:0] ,sq23_update_time[71:0]       ,sq23_update_ms[31:0]         ,sq23_new_price[63:0]     ,sq23_turnover[31:0]         ,sq23_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
        default :   rmem_data1_1 <= rmem_data1_1 ;
	 endcase
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data1_3  <=  256'd0 ;
     rmem_data1_3_vld  <=  1'd0  ;
  end
//  else if ( |{market_rdy,sq_market_rdy[31:24]} )  begin
  else   begin
         rmem_data1_3_vld  <=  |{market_rdy,sq_market_rdy[31:24]}  ;            
     case ({market_rdy,sq_market_rdy[31:24]})
	 9'h0_01:     rmem_data1_3  <=  {sq24_contract_code[3*8-1:0] ,sq24_update_time[71:0]       ,sq24_update_ms[31:0]         ,sq24_new_price[63:0]     ,sq24_turnover[31:0]         ,sq24_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_02:     rmem_data1_3  <=  {sq25_contract_code[3*8-1:0] ,sq25_update_time[71:0]       ,sq25_update_ms[31:0]         ,sq25_new_price[63:0]     ,sq25_turnover[31:0]         ,sq25_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_04:     rmem_data1_3  <=  {sq26_contract_code[3*8-1:0] ,sq26_update_time[71:0]       ,sq26_update_ms[31:0]         ,sq26_new_price[63:0]     ,sq26_turnover[31:0]         ,sq26_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_08:     rmem_data1_3  <=  {sq27_contract_code[3*8-1:0] ,sq27_update_time[71:0]       ,sq27_update_ms[31:0]         ,sq27_new_price[63:0]     ,sq27_turnover[31:0]         ,sq27_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_10:     rmem_data1_3  <=  {sq28_contract_code[3*8-1:0] ,sq28_update_time[71:0]       ,sq28_update_ms[31:0]         ,sq28_new_price[63:0]     ,sq28_turnover[31:0]         ,sq28_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_20:     rmem_data1_3  <=  {sq29_contract_code[3*8-1:0] ,sq29_update_time[71:0]       ,sq29_update_ms[31:0]         ,sq29_new_price[63:0]     ,sq29_turnover[31:0]         ,sq29_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_40:     rmem_data1_3  <=  {sq30_contract_code[3*8-1:0] ,sq30_update_time[71:0]       ,sq30_update_ms[31:0]         ,sq30_new_price[63:0]     ,sq30_turnover[31:0]         ,sq30_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h0_80:     rmem_data1_3  <=  {sq31_contract_code[3*8-1:0] ,sq31_update_time[71:0]       ,sq31_update_ms[31:0]         ,sq31_new_price[63:0]     ,sq31_turnover[31:0]         ,sq31_volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
	 9'h1_00:     rmem_data1_3  <=  {contract_code[3*8-1:0] ,update_time[71:0]       ,update_ms[31:0]         ,new_price[63:0]     ,turnover[31:0]       ,volume[8*8-1:4*8]        } ;  //3+9+4+8+4 +4
         default :    rmem_data1_3 <= rmem_data1_3 ;         
	 endcase
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
	 rmem_data1  <=  256'd0 ;
  end
  else if ( rmem_data1_0_vld )  begin 
	 rmem_data1  <=  rmem_data1_0 ;         
  end
  else if ( rmem_data1_1_vld )  begin 
	 rmem_data1  <=  rmem_data1_1 ;         
  end
  else if ( rmem_data1_2_vld )  begin 
	 rmem_data1  <=  rmem_data1_2 ;         
  end
  else if ( rmem_data1_3_vld )  begin 
	 rmem_data1  <=  rmem_data1_3 ;         
  end
end

always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data2_1  <=  256'd0 ;
     rmem_data2_1_vld <=  1'd0   ;
  end
  //else if ( sq_market_rdy[23:16] )  begin
  else  begin    
     rmem_data2_1_vld <=  |sq_market_rdy[23:16]    ;     
     case ( sq_market_rdy[23:16] )
	 8'h01:          rmem_data2_1  <=  {sq16_volume[4*8-1:0]        ,sq16_position[8*8-1:0]       ,sq16_purchase_price[8*8-1:0] ,sq16_buy_quantity[31:0]  ,sq16_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h02:          rmem_data2_1  <=  {sq17_volume[4*8-1:0]        ,sq17_position[8*8-1:0]       ,sq17_purchase_price[8*8-1:0] ,sq17_buy_quantity[31:0]  ,sq17_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h04:          rmem_data2_1  <=  {sq18_volume[4*8-1:0]        ,sq18_position[8*8-1:0]       ,sq18_purchase_price[8*8-1:0] ,sq18_buy_quantity[31:0]  ,sq18_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h08:          rmem_data2_1  <=  {sq19_volume[4*8-1:0]        ,sq19_position[8*8-1:0]       ,sq19_purchase_price[8*8-1:0] ,sq19_buy_quantity[31:0]  ,sq19_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h10:          rmem_data2_1  <=  {sq20_volume[4*8-1:0]        ,sq20_position[8*8-1:0]       ,sq20_purchase_price[8*8-1:0] ,sq20_buy_quantity[31:0]  ,sq20_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h20:          rmem_data2_1  <=  {sq21_volume[4*8-1:0]        ,sq21_position[8*8-1:0]       ,sq21_purchase_price[8*8-1:0] ,sq21_buy_quantity[31:0]  ,sq21_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h40:          rmem_data2_1  <=  {sq22_volume[4*8-1:0]        ,sq22_position[8*8-1:0]       ,sq22_purchase_price[8*8-1:0] ,sq22_buy_quantity[31:0]  ,sq22_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h80     :     rmem_data2_1  <=  {sq23_volume[4*8-1:0]        ,sq23_position[8*8-1:0]       ,sq23_purchase_price[8*8-1:0] ,sq23_buy_quantity[31:0]  ,sq23_sell_price[63:0]                                    } ;  //4+8+8+4+8
         default :       rmem_data2_1 <= rmem_data2_1 ;
	 endcase
  end
end



always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data2_3  <=  256'd0 ;
     rmem_data2_3_vld <=  1'd0   ;
  end
//  else if ( |{market_rdy,sq_market_rdy[31:24]} )  begin
  else   begin  
     rmem_data2_3_vld <=     |{market_rdy,sq_market_rdy[31:24]} ;     
     case ({market_rdy,sq_market_rdy[31:24]})
	 9'h0_01:     rmem_data2_3  <=  {sq24_volume[4*8-1:0]        ,sq24_position[8*8-1:0]       ,sq24_purchase_price[8*8-1:0] ,sq24_buy_quantity[31:0]  ,sq24_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_02:     rmem_data2_3  <=  {sq25_volume[4*8-1:0]        ,sq25_position[8*8-1:0]       ,sq25_purchase_price[8*8-1:0] ,sq25_buy_quantity[31:0]  ,sq25_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_04:     rmem_data2_3  <=  {sq26_volume[4*8-1:0]        ,sq26_position[8*8-1:0]       ,sq26_purchase_price[8*8-1:0] ,sq26_buy_quantity[31:0]  ,sq26_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_08:     rmem_data2_3  <=  {sq27_volume[4*8-1:0]        ,sq27_position[8*8-1:0]       ,sq27_purchase_price[8*8-1:0] ,sq27_buy_quantity[31:0]  ,sq27_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_10:     rmem_data2_3  <=  {sq28_volume[4*8-1:0]        ,sq28_position[8*8-1:0]       ,sq28_purchase_price[8*8-1:0] ,sq28_buy_quantity[31:0]  ,sq28_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_20:     rmem_data2_3  <=  {sq29_volume[4*8-1:0]        ,sq29_position[8*8-1:0]       ,sq29_purchase_price[8*8-1:0] ,sq29_buy_quantity[31:0]  ,sq29_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_40:     rmem_data2_3  <=  {sq30_volume[4*8-1:0]        ,sq30_position[8*8-1:0]       ,sq30_purchase_price[8*8-1:0] ,sq30_buy_quantity[31:0]  ,sq30_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h0_80:     rmem_data2_3  <=  {sq31_volume[4*8-1:0]        ,sq31_position[8*8-1:0]       ,sq31_purchase_price[8*8-1:0] ,sq31_buy_quantity[31:0]  ,sq31_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 9'h1_00    :    rmem_data2_3  <=  {volume[4*8-1:0]        ,position[8*8-1:0]       ,purchase_price[8*8-1:0] ,buy_quantity[31:0]  ,sell_price[63:0]                               } ;  //4+8+8+4+8 
         default :    rmem_data2_3  <=  rmem_data2_3 ;         
	 endcase
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data2_0  <=  256'd0 ;
     rmem_data2_0_vld  <=  1'd0  ;
  end
//  else if ( |sq_market_rdy[7:0] )  begin
  else  begin  
     rmem_data2_0_vld  <=   |sq_market_rdy[7:0]  ;     
     case ( sq_market_rdy[7:0])
	 8'h01:     rmem_data2_0  <=  {sq00_volume[4*8-1:0]        ,sq00_position[8*8-1:0]       ,sq00_purchase_price[8*8-1:0] ,sq00_buy_quantity[31:0]  ,sq00_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h02:     rmem_data2_0  <=  {sq01_volume[4*8-1:0]        ,sq01_position[8*8-1:0]       ,sq01_purchase_price[8*8-1:0] ,sq01_buy_quantity[31:0]  ,sq01_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h04:     rmem_data2_0  <=  {sq02_volume[4*8-1:0]        ,sq02_position[8*8-1:0]       ,sq02_purchase_price[8*8-1:0] ,sq02_buy_quantity[31:0]  ,sq02_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h08:     rmem_data2_0  <=  {sq03_volume[4*8-1:0]        ,sq03_position[8*8-1:0]       ,sq03_purchase_price[8*8-1:0] ,sq03_buy_quantity[31:0]  ,sq03_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h10:     rmem_data2_0  <=  {sq04_volume[4*8-1:0]        ,sq04_position[8*8-1:0]       ,sq04_purchase_price[8*8-1:0] ,sq04_buy_quantity[31:0]  ,sq04_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h20:     rmem_data2_0  <=  {sq05_volume[4*8-1:0]        ,sq05_position[8*8-1:0]       ,sq05_purchase_price[8*8-1:0] ,sq05_buy_quantity[31:0]  ,sq05_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h40:     rmem_data2_0  <=  {sq06_volume[4*8-1:0]        ,sq06_position[8*8-1:0]       ,sq06_purchase_price[8*8-1:0] ,sq06_buy_quantity[31:0]  ,sq06_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h80  :   rmem_data2_0  <=  {sq07_volume[4*8-1:0]        ,sq07_position[8*8-1:0]       ,sq07_purchase_price[8*8-1:0] ,sq07_buy_quantity[31:0]  ,sq07_sell_price[63:0]                                    } ;  //4+8+8+4+8
         default :  rmem_data2_0 <= rmem_data2_0 ;
	 endcase
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_data2_2  <=  256'd0 ;
     rmem_data2_2_vld  <=  1'd0  ;
  end
//  else if ( |sq_market_rdy[15:8] )  begin
  else   begin  
     rmem_data2_2_vld  <=  |sq_market_rdy[15:8] ;     
     case ( sq_market_rdy[15:8])
	 8'h01:     rmem_data2_2  <=  {sq08_volume[4*8-1:0]        ,sq08_position[8*8-1:0]       ,sq08_purchase_price[8*8-1:0] ,sq08_buy_quantity[31:0]  ,sq08_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h02:     rmem_data2_2  <=  {sq09_volume[4*8-1:0]        ,sq09_position[8*8-1:0]       ,sq09_purchase_price[8*8-1:0] ,sq09_buy_quantity[31:0]  ,sq09_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h04:     rmem_data2_2  <=  {sq10_volume[4*8-1:0]        ,sq10_position[8*8-1:0]       ,sq10_purchase_price[8*8-1:0] ,sq10_buy_quantity[31:0]  ,sq10_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h08:     rmem_data2_2  <=  {sq11_volume[4*8-1:0]        ,sq11_position[8*8-1:0]       ,sq11_purchase_price[8*8-1:0] ,sq11_buy_quantity[31:0]  ,sq11_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h10:     rmem_data2_2  <=  {sq12_volume[4*8-1:0]        ,sq12_position[8*8-1:0]       ,sq12_purchase_price[8*8-1:0] ,sq12_buy_quantity[31:0]  ,sq12_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h20:     rmem_data2_2  <=  {sq13_volume[4*8-1:0]        ,sq13_position[8*8-1:0]       ,sq13_purchase_price[8*8-1:0] ,sq13_buy_quantity[31:0]  ,sq13_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h40:     rmem_data2_2  <=  {sq14_volume[4*8-1:0]        ,sq14_position[8*8-1:0]       ,sq14_purchase_price[8*8-1:0] ,sq14_buy_quantity[31:0]  ,sq14_sell_price[63:0]                                    } ;  //4+8+8+4+8
	 8'h80 :   rmem_data2_2  <=  {sq15_volume[4*8-1:0]        ,sq15_position[8*8-1:0]       ,sq15_purchase_price[8*8-1:0] ,sq15_buy_quantity[31:0]  ,sq15_sell_price[63:0]                                    } ;  //4+8+8+4+8
         default :   rmem_data2_2 <= rmem_data2_2 ;
	 endcase
  end
end


always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
	 rmem_data2  <=  256'd0 ;
  end
  else if ( rmem_data2_0_vld )  begin 
	 rmem_data2  <=  rmem_data2_0 ;         
  end
  else if ( rmem_data2_1_vld )  begin 
	 rmem_data2  <=  rmem_data2_1 ;         
  end
  else if ( rmem_data2_2_vld )  begin 
	 rmem_data2  <=  rmem_data2_2 ;         
  end
  else if ( rmem_data2_3_vld )  begin 
	 rmem_data2  <=  rmem_data2_3 ;         
  end

end



always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
	 rmem_data3  <=  32'd0 ;
  end
  //else if ( market_rdy )  begin 
//	 rmem_data3  <=  {sell_quantity[31:0],{28{8'd0}}} ;  //4
  //end
  //else if ( |sq_market_rdy )  begin 
  //   case (sq_market_rdy)
//  else if ( |{market_rdy,sq_market_rdy} )  begin
  else begin 
     case ({market_rdy,sq_market_rdy})
	 33'h0_0000_0001:     rmem_data3  <=  {sq00_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0002:     rmem_data3  <=  {sq01_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0004:     rmem_data3  <=  {sq02_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0008:     rmem_data3  <=  {sq03_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0010:     rmem_data3  <=  {sq04_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0020:     rmem_data3  <=  {sq05_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0040:     rmem_data3  <=  {sq06_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0080:     rmem_data3  <=  {sq07_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0100:     rmem_data3  <=  {sq08_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0200:     rmem_data3  <=  {sq09_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0400:     rmem_data3  <=  {sq10_sell_quantity[31:0]} ;  //4
	 33'h0_0000_0800:     rmem_data3  <=  {sq11_sell_quantity[31:0]} ;  //4
	 33'h0_0000_1000:     rmem_data3  <=  {sq12_sell_quantity[31:0]} ;  //4
	 33'h0_0000_2000:     rmem_data3  <=  {sq13_sell_quantity[31:0]} ;  //4
	 33'h0_0000_4000:     rmem_data3  <=  {sq14_sell_quantity[31:0]} ;  //4
	 33'h0_0000_8000:     rmem_data3  <=  {sq15_sell_quantity[31:0]} ;  //4
	 33'h0_0001_0000:     rmem_data3  <=  {sq16_sell_quantity[31:0]} ;  //4
	 33'h0_0002_0000:     rmem_data3  <=  {sq17_sell_quantity[31:0]} ;  //4
	 33'h0_0004_0000:     rmem_data3  <=  {sq18_sell_quantity[31:0]} ;  //4
	 33'h0_0008_0000:     rmem_data3  <=  {sq19_sell_quantity[31:0]} ;  //4
	 33'h0_0010_0000:     rmem_data3  <=  {sq20_sell_quantity[31:0]} ;  //4
	 33'h0_0020_0000:     rmem_data3  <=  {sq21_sell_quantity[31:0]} ;  //4
	 33'h0_0040_0000:     rmem_data3  <=  {sq22_sell_quantity[31:0]} ;  //4
	 33'h0_0080_0000:     rmem_data3  <=  {sq23_sell_quantity[31:0]} ;  //4
	 33'h0_0100_0000:     rmem_data3  <=  {sq24_sell_quantity[31:0]} ;  //4
	 33'h0_0200_0000:     rmem_data3  <=  {sq25_sell_quantity[31:0]} ;  //4
	 33'h0_0400_0000:     rmem_data3  <=  {sq26_sell_quantity[31:0]} ;  //4
	 33'h0_0800_0000:     rmem_data3  <=  {sq27_sell_quantity[31:0]} ;  //4
	 33'h0_1000_0000:     rmem_data3  <=  {sq28_sell_quantity[31:0]} ;  //4
	 33'h0_2000_0000:     rmem_data3  <=  {sq29_sell_quantity[31:0]} ;  //4
	 33'h0_4000_0000:     rmem_data3  <=  {sq30_sell_quantity[31:0]} ;  //4
	 33'h0_8000_0000:     rmem_data3  <=  {sq31_sell_quantity[31:0]} ;  //4
	 33'h1_0000_0000:     rmem_data3  <=  {sell_quantity[31:0]     } ;  //4
         default      :       rmem_data3  <=  rmem_data3 ;
	 endcase
  end
end


//input      [ 23: 0]         market_explain     ; //市场说明 3
//input      [  7: 0]         info_classify      ; //信息分类 1
//input      [ 31: 0]         dialog_num         ; //会话编号 4
//input      [  7: 0]         contract_flag      ; //合约标志 1
//input      [ 31: 0]         contract_num       ; //合约编号 4
//input      [175: 0]         contract_code      ; //合约代码 22
//input      [ 71: 0]         update_time        ; //更新时间 9
//input      [ 31: 0]         update_ms          ; //更新毫秒 4
//input      [ 63: 0]         new_price          ; //最新价 8
//input      [ 31: 0]         turnover           ; //成交量 4
//input      [ 63: 0]         volume             ; //成交额 8   
//input      [ 63: 0]         position           ; //持仓量 8
//input      [ 63: 0]         purchase_price     ; //申买价 8
//input      [ 31: 0]         buy_quantity       ; //申买量 4
//input      [ 63: 0]         sell_price         ; //申买价 8
//input      [ 31: 0]         sell_quantity      ; //申卖量 4
//input                       market_rdy         ;

//rmem_vld
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_vld  <=  1'd0 ;
  end
  else if (market_rdy|| (|sq_market_rdy) )  begin 
     rmem_vld  <=  1'd1  ;
  end
  else if (  rmem_vld &&(rmem_cnt==2'd3))   begin
     rmem_vld  <=  1'd0 ;
  end
end
always@ ( negedge rst_n  or posedge clk)
begin
  if (~rst_n) begin
     rmem_cnt  <=  2'd0 ;
  end
  else if ( rmem_vld )   begin
     rmem_cnt  <=  rmem_cnt + 1'd1 ;
  end
  else begin
     rmem_cnt  <=  2'd0 ;     
  end
end
////////////////////////////////////////////////////////////////////////////////////////////////////






endmodule


