module  filter_tlp_gen  (
clk                   ,
rst_n                 ,

// pcie_clk              ,
// pcie_clk_rstn         ,

params_filter_rst     ,
//params_des_acnt       ,

market_explain        , //市场说明 3
info_classify         , //信息分类 1
dialog_num            , //会话编号 4
contract_flag         , //合约标志 1
contract_num          , //合约编号 4
contract_code         , //合约代码 22
update_time           , //更新时间 9
update_ms             , //更新毫秒 4
new_price             , //�?新价 8
turnover              , //成交�? 4
volume                , //成交�? 8   
position              , //持仓�? 8
purchase_price        , //申买�? 8
buy_quantity          , //申买�? 4
sell_price            , //申买�? 8
sell_quantity         , //申卖�? 4
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

sq00_new_price          , //�?新价 8
sq01_new_price          , //�?新价 8
sq02_new_price          , //�?新价 8
sq03_new_price          , //�?新价 8
sq04_new_price          , //�?新价 8
sq05_new_price          , //�?新价 8
sq06_new_price          , //�?新价 8
sq07_new_price          , //�?新价 8
sq08_new_price          , //�?新价 8
sq09_new_price          , //�?新价 8
sq10_new_price          , //�?新价 8
sq11_new_price          , //�?新价 8
sq12_new_price          , //�?新价 8
sq13_new_price          , //�?新价 8
sq14_new_price          , //�?新价 8
sq15_new_price          , //�?新价 8
sq16_new_price          , //�?新价 8
sq17_new_price          , //�?新价 8
sq18_new_price          , //�?新价 8
sq19_new_price          , //�?新价 8
sq20_new_price          , //�?新价 8
sq21_new_price          , //�?新价 8
sq22_new_price          , //�?新价 8
sq23_new_price          , //�?新价 8
sq24_new_price          , //�?新价 8
sq25_new_price          , //�?新价 8
sq26_new_price          , //�?新价 8
sq27_new_price          , //�?新价 8
sq28_new_price          , //�?新价 8
sq29_new_price          , //�?新价 8
sq30_new_price          , //�?新价 8
sq31_new_price          , //�?新价 8

sq00_turnover           , //成交�? 4
sq01_turnover           , //成交�? 4
sq02_turnover           , //成交�? 4
sq03_turnover           , //成交�? 4
sq04_turnover           , //成交�? 4
sq05_turnover           , //成交�? 4
sq06_turnover           , //成交�? 4
sq07_turnover           , //成交�? 4
sq08_turnover           , //成交�? 4
sq09_turnover           , //成交�? 4
sq10_turnover           , //成交�? 4
sq11_turnover           , //成交�? 4
sq12_turnover           , //成交�? 4
sq13_turnover           , //成交�? 4
sq14_turnover           , //成交�? 4
sq15_turnover           , //成交�? 4
sq16_turnover           , //成交�? 4
sq17_turnover           , //成交�? 4
sq18_turnover           , //成交�? 4
sq19_turnover           , //成交�? 4
sq20_turnover           , //成交�? 4
sq21_turnover           , //成交�? 4
sq22_turnover           , //成交�? 4
sq23_turnover           , //成交�? 4
sq24_turnover           , //成交�? 4
sq25_turnover           , //成交�? 4
sq26_turnover           , //成交�? 4
sq27_turnover           , //成交�? 4
sq28_turnover           , //成交�? 4
sq29_turnover           , //成交�? 4
sq30_turnover           , //成交�? 4
sq31_turnover           , //成交�? 4

sq00_volume             , //成交�? 8   
sq01_volume             , //成交�? 8   
sq02_volume             , //成交�? 8   
sq03_volume             , //成交�? 8   
sq04_volume             , //成交�? 8   
sq05_volume             , //成交�? 8   
sq06_volume             , //成交�? 8   
sq07_volume             , //成交�? 8
sq08_volume             , //成交�? 8   
sq09_volume             , //成交�? 8   
sq10_volume             , //成交�? 8   
sq11_volume             , //成交�? 8   
sq12_volume             , //成交�? 8   
sq13_volume             , //成交�? 8   
sq14_volume             , //成交�? 8   
sq15_volume             , //成交�? 8
sq16_volume             , //成交�? 8   
sq17_volume             , //成交�? 8   
sq18_volume             , //成交�? 8   
sq19_volume             , //成交�? 8   
sq20_volume             , //成交�? 8   
sq21_volume             , //成交�? 8   
sq22_volume             , //成交�? 8   
sq23_volume             , //成交�? 8
sq24_volume             , //成交�? 8   
sq25_volume             , //成交�? 8   
sq26_volume             , //成交�? 8   
sq27_volume             , //成交�? 8   
sq28_volume             , //成交�? 8   
sq29_volume             , //成交�? 8   
sq30_volume             , //成交�? 8   
sq31_volume             , //成交�? 8

sq00_position           , //持仓�? 8
sq01_position           , //持仓�? 8
sq02_position           , //持仓�? 8
sq03_position           , //持仓�? 8
sq04_position           , //持仓�? 8
sq05_position           , //持仓�? 8
sq06_position           , //持仓�? 8
sq07_position           , //持仓�? 8
sq08_position           , //持仓�? 8
sq09_position           , //持仓�? 8
sq10_position           , //持仓�? 8
sq11_position           , //持仓�? 8
sq12_position           , //持仓�? 8
sq13_position           , //持仓�? 8
sq14_position           , //持仓�? 8
sq15_position           , //持仓�? 8
sq16_position           , //持仓�? 8
sq17_position           , //持仓�? 8
sq18_position           , //持仓�? 8
sq19_position           , //持仓�? 8
sq20_position           , //持仓�? 8
sq21_position           , //持仓�? 8
sq22_position           , //持仓�? 8
sq23_position           , //持仓�? 8
sq24_position           , //持仓�? 8
sq25_position           , //持仓�? 8
sq26_position           , //持仓�? 8
sq27_position           , //持仓�? 8
sq28_position           , //持仓�? 8
sq29_position           , //持仓�? 8
sq30_position           , //持仓�? 8
sq31_position           , //持仓�? 8

sq00_purchase_price     , //申买�? 8
sq01_purchase_price     , //申买�? 8
sq02_purchase_price     , //申买�? 8
sq03_purchase_price     , //申买�? 8
sq04_purchase_price     , //申买�? 8
sq05_purchase_price     , //申买�? 8
sq06_purchase_price     , //申买�? 8
sq07_purchase_price     , //申买�? 8
sq08_purchase_price     , //申买�? 8
sq09_purchase_price     , //申买�? 8
sq10_purchase_price     , //申买�? 8
sq11_purchase_price     , //申买�? 8
sq12_purchase_price     , //申买�? 8
sq13_purchase_price     , //申买�? 8
sq14_purchase_price     , //申买�? 8
sq15_purchase_price     , //申买�? 8
sq16_purchase_price     , //申买�? 8
sq17_purchase_price     , //申买�? 8
sq18_purchase_price     , //申买�? 8
sq19_purchase_price     , //申买�? 8
sq20_purchase_price     , //申买�? 8
sq21_purchase_price     , //申买�? 8
sq22_purchase_price     , //申买�? 8
sq23_purchase_price     , //申买�? 8
sq24_purchase_price     , //申买�? 8
sq25_purchase_price     , //申买�? 8
sq26_purchase_price     , //申买�? 8
sq27_purchase_price     , //申买�? 8
sq28_purchase_price     , //申买�? 8
sq29_purchase_price     , //申买�? 8
sq30_purchase_price     , //申买�? 8
sq31_purchase_price     , //申买�? 8

sq00_buy_quantity       , //申买�? 4
sq01_buy_quantity       , //申买�? 4
sq02_buy_quantity       , //申买�? 4
sq03_buy_quantity       , //申买�? 4
sq04_buy_quantity       , //申买�? 4
sq05_buy_quantity       , //申买�? 4
sq06_buy_quantity       , //申买�? 4
sq07_buy_quantity       , //申买�? 4
sq08_buy_quantity       , //申买�? 4
sq09_buy_quantity       , //申买�? 4
sq10_buy_quantity       , //申买�? 4
sq11_buy_quantity       , //申买�? 4
sq12_buy_quantity       , //申买�? 4
sq13_buy_quantity       , //申买�? 4
sq14_buy_quantity       , //申买�? 4
sq15_buy_quantity       , //申买�? 4
sq16_buy_quantity       , //申买�? 4
sq17_buy_quantity       , //申买�? 4
sq18_buy_quantity       , //申买�? 4
sq19_buy_quantity       , //申买�? 4
sq20_buy_quantity       , //申买�? 4
sq21_buy_quantity       , //申买�? 4
sq22_buy_quantity       , //申买�? 4
sq23_buy_quantity       , //申买�? 4
sq24_buy_quantity       , //申买�? 4
sq25_buy_quantity       , //申买�? 4
sq26_buy_quantity       , //申买�? 4
sq27_buy_quantity       , //申买�? 4
sq28_buy_quantity       , //申买�? 4
sq29_buy_quantity       , //申买�? 4
sq30_buy_quantity       , //申买�? 4
sq31_buy_quantity       , //申买�? 4

sq00_sell_price         , //申买�? 8
sq01_sell_price         , //申买�? 8
sq02_sell_price         , //申买�? 8
sq03_sell_price         , //申买�? 8
sq04_sell_price         , //申买�? 8
sq05_sell_price         , //申买�? 8
sq06_sell_price         , //申买�? 8
sq07_sell_price         , //申买�? 8
sq08_sell_price         , //申买�? 8
sq09_sell_price         , //申买�? 8
sq10_sell_price         , //申买�? 8
sq11_sell_price         , //申买�? 8
sq12_sell_price         , //申买�? 8
sq13_sell_price         , //申买�? 8
sq14_sell_price         , //申买�? 8
sq15_sell_price         , //申买�? 8
sq16_sell_price         , //申买�? 8
sq17_sell_price         , //申买�? 8
sq18_sell_price         , //申买�? 8
sq19_sell_price         , //申买�? 8
sq20_sell_price         , //申买�? 8
sq21_sell_price         , //申买�? 8
sq22_sell_price         , //申买�? 8
sq23_sell_price         , //申买�? 8
sq24_sell_price         , //申买�? 8
sq25_sell_price         , //申买�? 8
sq26_sell_price         , //申买�? 8
sq27_sell_price         , //申买�? 8
sq28_sell_price         , //申买�? 8
sq29_sell_price         , //申买�? 8
sq30_sell_price         , //申买�? 8
sq31_sell_price         , //申买�? 8

sq00_sell_quantity      , //申卖�? 4
sq01_sell_quantity      , //申卖�? 4
sq02_sell_quantity      , //申卖�? 4
sq03_sell_quantity      , //申卖�? 4
sq04_sell_quantity      , //申卖�? 4
sq05_sell_quantity      , //申卖�? 4
sq06_sell_quantity      , //申卖�? 4
sq07_sell_quantity      , //申卖�? 4
sq08_sell_quantity      , //申卖�? 4
sq09_sell_quantity      , //申卖�? 4
sq10_sell_quantity      , //申卖�? 4
sq11_sell_quantity      , //申卖�? 4
sq12_sell_quantity      , //申卖�? 4
sq13_sell_quantity      , //申卖�? 4
sq14_sell_quantity      , //申卖�? 4
sq15_sell_quantity      , //申卖�? 4
sq16_sell_quantity      , //申卖�? 4
sq17_sell_quantity      , //申卖�? 4
sq18_sell_quantity      , //申卖�? 4
sq19_sell_quantity      , //申卖�? 4
sq20_sell_quantity      , //申卖�? 4
sq21_sell_quantity      , //申卖�? 4
sq22_sell_quantity      , //申卖�? 4
sq23_sell_quantity      , //申卖�? 4
sq24_sell_quantity      , //申卖�? 4
sq25_sell_quantity      , //申卖�? 4
sq26_sell_quantity      , //申卖�? 4
sq27_sell_quantity      , //申卖�? 4
sq28_sell_quantity      , //申卖�? 4
sq29_sell_quantity      , //申卖�? 4
sq30_sell_quantity      , //申卖�? 4
sq31_sell_quantity      , //申卖�? 4

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

tlp_fifo_empty,
tlp_fifo_rdata ,
tlp_fifo_data_vld,
fifo_ready     
// requestor_id          ,
// tlp_StReady_i         ,
// tlp_StData_o          ,
// tlp_StSop_o           ,
// tlp_StEop_o           ,
// tlp_StEmpty_o         ,
// tlp_StValid_o         ,         
// st_fifo_hfull         ,
// st_fifo_full          ,
// st_fifo_empty         ,    
// rmem_descriptor_reg    
);

parameter  TLPG_IDLE  =  4'd0 ;
parameter   TLPG_DA0  =  4'd1 ;

input                       clk                ;
input                       rst_n              ;
input      [ 23: 0]         market_explain     ; //市场说明 3
input      [  7: 0]         info_classify      ; //信息分类 1
input      [ 31: 0]         dialog_num         ; //会话编号 4
input      [  7: 0]         contract_flag      ; //合约标志 1
input      [ 31: 0]         contract_num       ; //合约编号 4
input      [175: 0]         contract_code      ; //合约代码 22
input      [ 71: 0]         update_time        ; //更新时间 9
input      [ 31: 0]         update_ms          ; //更新毫秒 4
input      [ 63: 0]         new_price          ; //�?新价 8
input      [ 31: 0]         turnover           ; //成交�? 4
input      [ 63: 0]         volume             ; //成交�? 8   
input      [ 63: 0]         position           ; //持仓�? 8
input      [ 63: 0]         purchase_price     ; //申买�? 8
input      [ 31: 0]         buy_quantity       ; //申买�? 4
input      [ 63: 0]         sell_price         ; //申买�? 8
input      [ 31: 0]         sell_quantity      ; //申卖�? 4
input                       market_rdy         ;

input                       params_filter_rst  ;
//input      [  23:0]         params_des_acnt    ;


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

input      [ 63: 0]         sq00_new_price          ; //�?新价 8
input      [ 63: 0]         sq01_new_price          ; //�?新价 8
input      [ 63: 0]         sq02_new_price          ; //�?新价 8
input      [ 63: 0]         sq03_new_price          ; //�?新价 8
input      [ 63: 0]         sq04_new_price          ; //�?新价 8
input      [ 63: 0]         sq05_new_price          ; //�?新价 8
input      [ 63: 0]         sq06_new_price          ; //�?新价 8
input      [ 63: 0]         sq07_new_price          ; //�?新价 8
input      [ 63: 0]         sq08_new_price          ; //�?新价 8
input      [ 63: 0]         sq09_new_price          ; //�?新价 8
input      [ 63: 0]         sq10_new_price          ; //�?新价 8
input      [ 63: 0]         sq11_new_price          ; //�?新价 8
input      [ 63: 0]         sq12_new_price          ; //�?新价 8
input      [ 63: 0]         sq13_new_price          ; //�?新价 8
input      [ 63: 0]         sq14_new_price          ; //�?新价 8
input      [ 63: 0]         sq15_new_price          ; //�?新价 8
input      [ 63: 0]         sq16_new_price          ; //�?新价 8
input      [ 63: 0]         sq17_new_price          ; //�?新价 8
input      [ 63: 0]         sq18_new_price          ; //�?新价 8
input      [ 63: 0]         sq19_new_price          ; //�?新价 8
input      [ 63: 0]         sq20_new_price          ; //�?新价 8
input      [ 63: 0]         sq21_new_price          ; //�?新价 8
input      [ 63: 0]         sq22_new_price          ; //�?新价 8
input      [ 63: 0]         sq23_new_price          ; //�?新价 8
input      [ 63: 0]         sq24_new_price          ; //�?新价 8
input      [ 63: 0]         sq25_new_price          ; //�?新价 8
input      [ 63: 0]         sq26_new_price          ; //�?新价 8
input      [ 63: 0]         sq27_new_price          ; //�?新价 8
input      [ 63: 0]         sq28_new_price          ; //�?新价 8
input      [ 63: 0]         sq29_new_price          ; //�?新价 8
input      [ 63: 0]         sq30_new_price          ; //�?新价 8
input      [ 63: 0]         sq31_new_price          ; //�?新价 8

input      [ 31: 0]         sq00_turnover           ; //成交�? 4
input      [ 31: 0]         sq01_turnover           ; //成交�? 4
input      [ 31: 0]         sq02_turnover           ; //成交�? 4
input      [ 31: 0]         sq03_turnover           ; //成交�? 4
input      [ 31: 0]         sq04_turnover           ; //成交�? 4
input      [ 31: 0]         sq05_turnover           ; //成交�? 4
input      [ 31: 0]         sq06_turnover           ; //成交�? 4
input      [ 31: 0]         sq07_turnover           ; //成交�? 4
input      [ 31: 0]         sq08_turnover           ; //成交�? 4
input      [ 31: 0]         sq09_turnover           ; //成交�? 4
input      [ 31: 0]         sq10_turnover           ; //成交�? 4
input      [ 31: 0]         sq11_turnover           ; //成交�? 4
input      [ 31: 0]         sq12_turnover           ; //成交�? 4
input      [ 31: 0]         sq13_turnover           ; //成交�? 4
input      [ 31: 0]         sq14_turnover           ; //成交�? 4
input      [ 31: 0]         sq15_turnover           ; //成交�? 4
input      [ 31: 0]         sq16_turnover           ; //成交�? 4
input      [ 31: 0]         sq17_turnover           ; //成交�? 4
input      [ 31: 0]         sq18_turnover           ; //成交�? 4
input      [ 31: 0]         sq19_turnover           ; //成交�? 4
input      [ 31: 0]         sq20_turnover           ; //成交�? 4
input      [ 31: 0]         sq21_turnover           ; //成交�? 4
input      [ 31: 0]         sq22_turnover           ; //成交�? 4
input      [ 31: 0]         sq23_turnover           ; //成交�? 4
input      [ 31: 0]         sq24_turnover           ; //成交�? 4
input      [ 31: 0]         sq25_turnover           ; //成交�? 4
input      [ 31: 0]         sq26_turnover           ; //成交�? 4
input      [ 31: 0]         sq27_turnover           ; //成交�? 4
input      [ 31: 0]         sq28_turnover           ; //成交�? 4
input      [ 31: 0]         sq29_turnover           ; //成交�? 4
input      [ 31: 0]         sq30_turnover           ; //成交�? 4
input      [ 31: 0]         sq31_turnover           ; //成交�? 4

input      [ 63: 0]         sq00_volume             ; //成交�? 8   
input      [ 63: 0]         sq01_volume             ; //成交�? 8   
input      [ 63: 0]         sq02_volume             ; //成交�? 8   
input      [ 63: 0]         sq03_volume             ; //成交�? 8   
input      [ 63: 0]         sq04_volume             ; //成交�? 8   
input      [ 63: 0]         sq05_volume             ; //成交�? 8   
input      [ 63: 0]         sq06_volume             ; //成交�? 8   
input      [ 63: 0]         sq07_volume             ; //成交�? 8
input      [ 63: 0]         sq08_volume             ; //成交�? 8   
input      [ 63: 0]         sq09_volume             ; //成交�? 8   
input      [ 63: 0]         sq10_volume             ; //成交�? 8   
input      [ 63: 0]         sq11_volume             ; //成交�? 8   
input      [ 63: 0]         sq12_volume             ; //成交�? 8   
input      [ 63: 0]         sq13_volume             ; //成交�? 8   
input      [ 63: 0]         sq14_volume             ; //成交�? 8   
input      [ 63: 0]         sq15_volume             ; //成交�? 8
input      [ 63: 0]         sq16_volume             ; //成交�? 8   
input      [ 63: 0]         sq17_volume             ; //成交�? 8   
input      [ 63: 0]         sq18_volume             ; //成交�? 8   
input      [ 63: 0]         sq19_volume             ; //成交�? 8   
input      [ 63: 0]         sq20_volume             ; //成交�? 8   
input      [ 63: 0]         sq21_volume             ; //成交�? 8   
input      [ 63: 0]         sq22_volume             ; //成交�? 8   
input      [ 63: 0]         sq23_volume             ; //成交�? 8
input      [ 63: 0]         sq24_volume             ; //成交�? 8   
input      [ 63: 0]         sq25_volume             ; //成交�? 8   
input      [ 63: 0]         sq26_volume             ; //成交�? 8   
input      [ 63: 0]         sq27_volume             ; //成交�? 8   
input      [ 63: 0]         sq28_volume             ; //成交�? 8   
input      [ 63: 0]         sq29_volume             ; //成交�? 8   
input      [ 63: 0]         sq30_volume             ; //成交�? 8   
input      [ 63: 0]         sq31_volume             ; //成交�? 8

input      [ 63: 0]         sq00_position           ; //持仓�? 8
input      [ 63: 0]         sq01_position           ; //持仓�? 8
input      [ 63: 0]         sq02_position           ; //持仓�? 8
input      [ 63: 0]         sq03_position           ; //持仓�? 8
input      [ 63: 0]         sq04_position           ; //持仓�? 8
input      [ 63: 0]         sq05_position           ; //持仓�? 8
input      [ 63: 0]         sq06_position           ; //持仓�? 8
input      [ 63: 0]         sq07_position           ; //持仓�? 8
input      [ 63: 0]         sq08_position           ; //持仓�? 8
input      [ 63: 0]         sq09_position           ; //持仓�? 8
input      [ 63: 0]         sq10_position           ; //持仓�? 8
input      [ 63: 0]         sq11_position           ; //持仓�? 8
input      [ 63: 0]         sq12_position           ; //持仓�? 8
input      [ 63: 0]         sq13_position           ; //持仓�? 8
input      [ 63: 0]         sq14_position           ; //持仓�? 8
input      [ 63: 0]         sq15_position           ; //持仓�? 8
input      [ 63: 0]         sq16_position           ; //持仓�? 8
input      [ 63: 0]         sq17_position           ; //持仓�? 8
input      [ 63: 0]         sq18_position           ; //持仓�? 8
input      [ 63: 0]         sq19_position           ; //持仓�? 8
input      [ 63: 0]         sq20_position           ; //持仓�? 8
input      [ 63: 0]         sq21_position           ; //持仓�? 8
input      [ 63: 0]         sq22_position           ; //持仓�? 8
input      [ 63: 0]         sq23_position           ; //持仓�? 8
input      [ 63: 0]         sq24_position           ; //持仓�? 8
input      [ 63: 0]         sq25_position           ; //持仓�? 8
input      [ 63: 0]         sq26_position           ; //持仓�? 8
input      [ 63: 0]         sq27_position           ; //持仓�? 8
input      [ 63: 0]         sq28_position           ; //持仓�? 8
input      [ 63: 0]         sq29_position           ; //持仓�? 8
input      [ 63: 0]         sq30_position           ; //持仓�? 8
input      [ 63: 0]         sq31_position           ; //持仓�? 8

input      [ 63: 0]         sq00_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq01_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq02_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq03_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq04_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq05_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq06_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq07_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq08_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq09_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq10_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq11_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq12_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq13_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq14_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq15_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq16_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq17_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq18_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq19_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq20_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq21_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq22_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq23_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq24_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq25_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq26_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq27_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq28_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq29_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq30_purchase_price     ; //申买�? 8
input      [ 63: 0]         sq31_purchase_price     ; //申买�? 8

input      [ 31: 0]         sq00_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq01_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq02_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq03_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq04_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq05_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq06_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq07_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq08_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq09_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq10_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq11_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq12_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq13_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq14_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq15_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq16_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq17_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq18_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq19_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq20_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq21_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq22_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq23_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq24_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq25_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq26_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq27_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq28_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq29_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq30_buy_quantity       ; //申买�? 4
input      [ 31: 0]         sq31_buy_quantity       ; //申买�? 4

input      [ 63: 0]         sq00_sell_price         ; //申买�? 8
input      [ 63: 0]         sq01_sell_price         ; //申买�? 8
input      [ 63: 0]         sq02_sell_price         ; //申买�? 8
input      [ 63: 0]         sq03_sell_price         ; //申买�? 8
input      [ 63: 0]         sq04_sell_price         ; //申买�? 8
input      [ 63: 0]         sq05_sell_price         ; //申买�? 8
input      [ 63: 0]         sq06_sell_price         ; //申买�? 8
input      [ 63: 0]         sq07_sell_price         ; //申买�? 8
input      [ 63: 0]         sq08_sell_price         ; //申买�? 8
input      [ 63: 0]         sq09_sell_price         ; //申买�? 8
input      [ 63: 0]         sq10_sell_price         ; //申买�? 8
input      [ 63: 0]         sq11_sell_price         ; //申买�? 8
input      [ 63: 0]         sq12_sell_price         ; //申买�? 8
input      [ 63: 0]         sq13_sell_price         ; //申买�? 8
input      [ 63: 0]         sq14_sell_price         ; //申买�? 8
input      [ 63: 0]         sq15_sell_price         ; //申买�? 8
input      [ 63: 0]         sq16_sell_price         ; //申买�? 8
input      [ 63: 0]         sq17_sell_price         ; //申买�? 8
input      [ 63: 0]         sq18_sell_price         ; //申买�? 8
input      [ 63: 0]         sq19_sell_price         ; //申买�? 8
input      [ 63: 0]         sq20_sell_price         ; //申买�? 8
input      [ 63: 0]         sq21_sell_price         ; //申买�? 8
input      [ 63: 0]         sq22_sell_price         ; //申买�? 8
input      [ 63: 0]         sq23_sell_price         ; //申买�? 8
input      [ 63: 0]         sq24_sell_price         ; //申买�? 8
input      [ 63: 0]         sq25_sell_price         ; //申买�? 8
input      [ 63: 0]         sq26_sell_price         ; //申买�? 8
input      [ 63: 0]         sq27_sell_price         ; //申买�? 8
input      [ 63: 0]         sq28_sell_price         ; //申买�? 8
input      [ 63: 0]         sq29_sell_price         ; //申买�? 8
input      [ 63: 0]         sq30_sell_price         ; //申买�? 8
input      [ 63: 0]         sq31_sell_price         ; //申买�? 8

input      [ 31: 0]         sq00_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq01_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq02_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq03_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq04_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq05_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq06_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq07_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq08_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq09_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq10_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq11_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq12_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq13_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq14_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq15_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq16_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq17_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq18_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq19_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq20_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq21_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq22_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq23_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq24_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq25_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq26_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq27_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq28_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq29_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq30_sell_quantity      ; //申卖�? 4
input      [ 31: 0]         sq31_sell_quantity      ; //申卖�? 4

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


// input      [ 15: 0]         requestor_id          ;
// input                       tlp_StReady_i         ;
// output     [255: 0]         tlp_StData_o          ;
// output                      tlp_StSop_o           ;
// output                      tlp_StEop_o           ;
// output     [  1: 0]         tlp_StEmpty_o         ;
// output                      tlp_StValid_o         ;         
// output                      st_fifo_hfull         ;
// output                      st_fifo_full          ;
// output                      st_fifo_empty         ;    
// input      [ 159:0]         rmem_descriptor_reg   ; 
//add  
output                       tlp_fifo_empty;
output   reg [255:0]         tlp_fifo_rdata ;
output   reg                 tlp_fifo_data_vld;
input                        fifo_ready;

// input                        pcie_clk              ;
// input                        pcie_clk_rstn         ;

/////////////////////////////////////////////////////////////////////////////////////
wire       [255:0]          rmem_data0 ;
wire       [255:0]          rmem_data1 ;
wire       [255:0]          rmem_data2 ;
wire       [ 31:0]          rmem_data3 ;
wire                        rmem_vld   ;


wire       [255:0]          rmem_data0_0 ;
wire       [255:0]          rmem_data0_1 ;
wire                        rmem_data0_0_vld ;
wire                        rmem_data0_1_vld ;
wire       [255:0]          rmem_data0_2 ;
wire       [255:0]          rmem_data0_3 ;
wire                        rmem_data0_2_vld ;
wire                        rmem_data0_3_vld ;




//////////////////////////////////////////////////////////////////////////////////////////////
filter_tlp_reg_gen   filter_tlp_reg_gen  (

.clk                  ( clk                    )   ,
.rst_n                ( rst_n                  )   ,

.params_filter_rst    (params_filter_rst       )   ,

.market_explain       ( market_explain         )   , //市场说明 3
.info_classify        ( info_classify          )   , //信息分类 1
.dialog_num           ( dialog_num             )   , //会话编号 4
.contract_flag        ( contract_flag          )   , //合约标志 1
.contract_num         ( contract_num           )   , //合约编号 4
.contract_code        ( contract_code          )   , //合约代码 22
.update_time          ( update_time            )   , //更新时间 9
.update_ms            ( update_ms              )   , //更新毫秒 4
.new_price            ( new_price              )   , //�?新价 8
.turnover             ( turnover               )   , //成交�? 4
.volume               ( volume                 )   , //成交�? 8   
.position             ( position               )   , //持仓�? 8
.purchase_price       ( purchase_price         )   , //申买�? 8
.buy_quantity         ( buy_quantity           )   , //申买�? 4
.sell_price           ( sell_price             )   , //申买�? 8
.sell_quantity        ( sell_quantity          )   , //申卖�? 4
.market_rdy           ( market_rdy             )   ,



.sq00_market_explain     ( sq00_market_explain      )   , //市场说明 3
.sq00_info_classify      ( sq00_info_classify       )   , //信息分类 1
.sq00_dialog_num         ( sq00_dialog_num          )   , //会话编号 4
.sq00_contract_flag      ( sq00_contract_flag       )   , //合约标志 1
.sq00_contract_num       ( sq00_contract_num        )   , //合约编号 4
.sq00_contract_code      ( sq00_contract_code       )   , //合约代码 22
.sq00_update_time        ( sq00_update_time         )   , //更新时间 9
.sq00_update_ms          ( sq00_update_ms           )   , //更新毫秒 4
.sq00_new_price          ( sq00_new_price           )   , //�?新价 8
.sq00_turnover           ( sq00_turnover            )   , //成交�? 4
.sq00_volume             ( sq00_volume              )   , //成交�? 8   
.sq00_position           ( sq00_position            )   , //持仓�? 8
.sq00_purchase_price     ( sq00_purchase_price      )   , //申买�? 8
.sq00_buy_quantity       ( sq00_buy_quantity        )   , //申买�? 4
.sq00_sell_price         ( sq00_sell_price          )   , //申买�? 8
.sq00_sell_quantity      ( sq00_sell_quantity       )   , //申卖�? 4
.sq00_market_rdy         ( sq00_market_rdy          )   ,

.sq01_market_explain     ( sq01_market_explain      )   , //市场说明 3
.sq01_info_classify      ( sq01_info_classify       )   , //信息分类 1
.sq01_dialog_num         ( sq01_dialog_num          )   , //会话编号 4
.sq01_contract_flag      ( sq01_contract_flag       )   , //合约标志 1
.sq01_contract_num       ( sq01_contract_num        )   , //合约编号 4
.sq01_contract_code      ( sq01_contract_code       )   , //合约代码 22
.sq01_update_time        ( sq01_update_time         )   , //更新时间 9
.sq01_update_ms          ( sq01_update_ms           )   , //更新毫秒 4
.sq01_new_price          ( sq01_new_price           )   , //�?新价 8
.sq01_turnover           ( sq01_turnover            )   , //成交�? 4
.sq01_volume             ( sq01_volume              )   , //成交�? 8   
.sq01_position           ( sq01_position            )   , //持仓�? 8
.sq01_purchase_price     ( sq01_purchase_price      )   , //申买�? 8
.sq01_buy_quantity       ( sq01_buy_quantity        )   , //申买�? 4
.sq01_sell_price         ( sq01_sell_price          )   , //申买�? 8
.sq01_sell_quantity      ( sq01_sell_quantity       )   , //申卖�? 4
.sq01_market_rdy         ( sq01_market_rdy          )   ,

.sq02_market_explain     ( sq02_market_explain      )   , //市场说明 3
.sq02_info_classify      ( sq02_info_classify       )   , //信息分类 1
.sq02_dialog_num         ( sq02_dialog_num          )   , //会话编号 4
.sq02_contract_flag      ( sq02_contract_flag       )   , //合约标志 1
.sq02_contract_num       ( sq02_contract_num        )   , //合约编号 4
.sq02_contract_code      ( sq02_contract_code       )   , //合约代码 22
.sq02_update_time        ( sq02_update_time         )   , //更新时间 9
.sq02_update_ms          ( sq02_update_ms           )   , //更新毫秒 4
.sq02_new_price          ( sq02_new_price           )   , //�?新价 8
.sq02_turnover           ( sq02_turnover            )   , //成交�? 4
.sq02_volume             ( sq02_volume              )   , //成交�? 8   
.sq02_position           ( sq02_position            )   , //持仓�? 8
.sq02_purchase_price     ( sq02_purchase_price      )   , //申买�? 8
.sq02_buy_quantity       ( sq02_buy_quantity        )   , //申买�? 4
.sq02_sell_price         ( sq02_sell_price          )   , //申买�? 8
.sq02_sell_quantity      ( sq02_sell_quantity       )   , //申卖�? 4
.sq02_market_rdy         ( sq02_market_rdy          )   ,

.sq03_market_explain     ( sq03_market_explain      )   , //市场说明 3
.sq03_info_classify      ( sq03_info_classify       )   , //信息分类 1
.sq03_dialog_num         ( sq03_dialog_num          )   , //会话编号 4
.sq03_contract_flag      ( sq03_contract_flag       )   , //合约标志 1
.sq03_contract_num       ( sq03_contract_num        )   , //合约编号 4
.sq03_contract_code      ( sq03_contract_code       )   , //合约代码 22
.sq03_update_time        ( sq03_update_time         )   , //更新时间 9
.sq03_update_ms          ( sq03_update_ms           )   , //更新毫秒 4
.sq03_new_price          ( sq03_new_price           )   , //�?新价 8
.sq03_turnover           ( sq03_turnover            )   , //成交�? 4
.sq03_volume             ( sq03_volume              )   , //成交�? 8   
.sq03_position           ( sq03_position            )   , //持仓�? 8
.sq03_purchase_price     ( sq03_purchase_price      )   , //申买�? 8
.sq03_buy_quantity       ( sq03_buy_quantity        )   , //申买�? 4
.sq03_sell_price         ( sq03_sell_price          )   , //申买�? 8
.sq03_sell_quantity      ( sq03_sell_quantity       )   , //申卖�? 4
.sq03_market_rdy         ( sq03_market_rdy          )   ,

.sq04_market_explain     ( sq04_market_explain      )   , //市场说明 3
.sq04_info_classify      ( sq04_info_classify       )   , //信息分类 1
.sq04_dialog_num         ( sq04_dialog_num          )   , //会话编号 4
.sq04_contract_flag      ( sq04_contract_flag       )   , //合约标志 1
.sq04_contract_num       ( sq04_contract_num        )   , //合约编号 4
.sq04_contract_code      ( sq04_contract_code       )   , //合约代码 22
.sq04_update_time        ( sq04_update_time         )   , //更新时间 9
.sq04_update_ms          ( sq04_update_ms           )   , //更新毫秒 4
.sq04_new_price          ( sq04_new_price           )   , //�?新价 8
.sq04_turnover           ( sq04_turnover            )   , //成交�? 4
.sq04_volume             ( sq04_volume              )   , //成交�? 8   
.sq04_position           ( sq04_position            )   , //持仓�? 8
.sq04_purchase_price     ( sq04_purchase_price      )   , //申买�? 8
.sq04_buy_quantity       ( sq04_buy_quantity        )   , //申买�? 4
.sq04_sell_price         ( sq04_sell_price          )   , //申买�? 8
.sq04_sell_quantity      ( sq04_sell_quantity       )   , //申卖�? 4
.sq04_market_rdy         ( sq04_market_rdy          )   ,

.sq05_market_explain     ( sq05_market_explain      )   , //市场说明 3
.sq05_info_classify      ( sq05_info_classify       )   , //信息分类 1
.sq05_dialog_num         ( sq05_dialog_num          )   , //会话编号 4
.sq05_contract_flag      ( sq05_contract_flag       )   , //合约标志 1
.sq05_contract_num       ( sq05_contract_num        )   , //合约编号 4
.sq05_contract_code      ( sq05_contract_code       )   , //合约代码 22
.sq05_update_time        ( sq05_update_time         )   , //更新时间 9
.sq05_update_ms          ( sq05_update_ms           )   , //更新毫秒 4
.sq05_new_price          ( sq05_new_price           )   , //�?新价 8
.sq05_turnover           ( sq05_turnover            )   , //成交�? 4
.sq05_volume             ( sq05_volume              )   , //成交�? 8   
.sq05_position           ( sq05_position            )   , //持仓�? 8
.sq05_purchase_price     ( sq05_purchase_price      )   , //申买�? 8
.sq05_buy_quantity       ( sq05_buy_quantity        )   , //申买�? 4
.sq05_sell_price         ( sq05_sell_price          )   , //申买�? 8
.sq05_sell_quantity      ( sq05_sell_quantity       )   , //申卖�? 4
.sq05_market_rdy         ( sq05_market_rdy          )   ,

.sq06_market_explain     ( sq06_market_explain      )   , //市场说明 3
.sq06_info_classify      ( sq06_info_classify       )   , //信息分类 1
.sq06_dialog_num         ( sq06_dialog_num          )   , //会话编号 4
.sq06_contract_flag      ( sq06_contract_flag       )   , //合约标志 1
.sq06_contract_num       ( sq06_contract_num        )   , //合约编号 4
.sq06_contract_code      ( sq06_contract_code       )   , //合约代码 22
.sq06_update_time        ( sq06_update_time         )   , //更新时间 9
.sq06_update_ms          ( sq06_update_ms           )   , //更新毫秒 4
.sq06_new_price          ( sq06_new_price           )   , //�?新价 8
.sq06_turnover           ( sq06_turnover            )   , //成交�? 4
.sq06_volume             ( sq06_volume              )   , //成交�? 8   
.sq06_position           ( sq06_position            )   , //持仓�? 8
.sq06_purchase_price     ( sq06_purchase_price      )   , //申买�? 8
.sq06_buy_quantity       ( sq06_buy_quantity        )   , //申买�? 4
.sq06_sell_price         ( sq06_sell_price          )   , //申买�? 8
.sq06_sell_quantity      ( sq06_sell_quantity       )   , //申卖�? 4
.sq06_market_rdy         ( sq06_market_rdy          )   ,

.sq07_market_explain     ( sq07_market_explain      )   , //市场说明 3
.sq07_info_classify      ( sq07_info_classify       )   , //信息分类 1
.sq07_dialog_num         ( sq07_dialog_num          )   , //会话编号 4
.sq07_contract_flag      ( sq07_contract_flag       )   , //合约标志 1
.sq07_contract_num       ( sq07_contract_num        )   , //合约编号 4
.sq07_contract_code      ( sq07_contract_code       )   , //合约代码 22
.sq07_update_time        ( sq07_update_time         )   , //更新时间 9
.sq07_update_ms          ( sq07_update_ms           )   , //更新毫秒 4
.sq07_new_price          ( sq07_new_price           )   , //�?新价 8
.sq07_turnover           ( sq07_turnover            )   , //成交�? 4
.sq07_volume             ( sq07_volume              )   , //成交�? 8   
.sq07_position           ( sq07_position            )   , //持仓�? 8
.sq07_purchase_price     ( sq07_purchase_price      )   , //申买�? 8
.sq07_buy_quantity       ( sq07_buy_quantity        )   , //申买�? 4
.sq07_sell_price         ( sq07_sell_price          )   , //申买�? 8
.sq07_sell_quantity      ( sq07_sell_quantity       )   , //申卖�? 4
.sq07_market_rdy         ( sq07_market_rdy          )   ,

.sq08_market_explain     ( sq08_market_explain      )   , //市场说明 3
.sq08_info_classify      ( sq08_info_classify       )   , //信息分类 1
.sq08_dialog_num         ( sq08_dialog_num          )   , //会话编号 4
.sq08_contract_flag      ( sq08_contract_flag       )   , //合约标志 1
.sq08_contract_num       ( sq08_contract_num        )   , //合约编号 4
.sq08_contract_code      ( sq08_contract_code       )   , //合约代码 22
.sq08_update_time        ( sq08_update_time         )   , //更新时间 9
.sq08_update_ms          ( sq08_update_ms           )   , //更新毫秒 4
.sq08_new_price          ( sq08_new_price           )   , //�?新价 8
.sq08_turnover           ( sq08_turnover            )   , //成交�? 4
.sq08_volume             ( sq08_volume              )   , //成交�? 8   
.sq08_position           ( sq08_position            )   , //持仓�? 8
.sq08_purchase_price     ( sq08_purchase_price      )   , //申买�? 8
.sq08_buy_quantity       ( sq08_buy_quantity        )   , //申买�? 4
.sq08_sell_price         ( sq08_sell_price          )   , //申买�? 8
.sq08_sell_quantity      ( sq08_sell_quantity       )   , //申卖�? 4
.sq08_market_rdy         ( sq08_market_rdy          )   ,

.sq09_market_explain     ( sq09_market_explain      )   , //市场说明 3
.sq09_info_classify      ( sq09_info_classify       )   , //信息分类 1
.sq09_dialog_num         ( sq09_dialog_num          )   , //会话编号 4
.sq09_contract_flag      ( sq09_contract_flag       )   , //合约标志 1
.sq09_contract_num       ( sq09_contract_num        )   , //合约编号 4
.sq09_contract_code      ( sq09_contract_code       )   , //合约代码 22
.sq09_update_time        ( sq09_update_time         )   , //更新时间 9
.sq09_update_ms          ( sq09_update_ms           )   , //更新毫秒 4
.sq09_new_price          ( sq09_new_price           )   , //�?新价 8
.sq09_turnover           ( sq09_turnover            )   , //成交�? 4
.sq09_volume             ( sq09_volume              )   , //成交�? 8   
.sq09_position           ( sq09_position            )   , //持仓�? 8
.sq09_purchase_price     ( sq09_purchase_price      )   , //申买�? 8
.sq09_buy_quantity       ( sq09_buy_quantity        )   , //申买�? 4
.sq09_sell_price         ( sq09_sell_price          )   , //申买�? 8
.sq09_sell_quantity      ( sq09_sell_quantity       )   , //申卖�? 4
.sq09_market_rdy         ( sq09_market_rdy          )   ,

.sq10_market_explain     ( sq10_market_explain      )   , //市场说明 3
.sq10_info_classify      ( sq10_info_classify       )   , //信息分类 1
.sq10_dialog_num         ( sq10_dialog_num          )   , //会话编号 4
.sq10_contract_flag      ( sq10_contract_flag       )   , //合约标志 1
.sq10_contract_num       ( sq10_contract_num        )   , //合约编号 4
.sq10_contract_code      ( sq10_contract_code       )   , //合约代码 22
.sq10_update_time        ( sq10_update_time         )   , //更新时间 9
.sq10_update_ms          ( sq10_update_ms           )   , //更新毫秒 4
.sq10_new_price          ( sq10_new_price           )   , //�?新价 8
.sq10_turnover           ( sq10_turnover            )   , //成交�? 4
.sq10_volume             ( sq10_volume              )   , //成交�? 8   
.sq10_position           ( sq10_position            )   , //持仓�? 8
.sq10_purchase_price     ( sq10_purchase_price      )   , //申买�? 8
.sq10_buy_quantity       ( sq10_buy_quantity        )   , //申买�? 4
.sq10_sell_price         ( sq10_sell_price          )   , //申买�? 8
.sq10_sell_quantity      ( sq10_sell_quantity       )   , //申卖�? 4
.sq10_market_rdy         ( sq10_market_rdy          )   ,

.sq11_market_explain     ( sq11_market_explain      )   , //市场说明 3
.sq11_info_classify      ( sq11_info_classify       )   , //信息分类 1
.sq11_dialog_num         ( sq11_dialog_num          )   , //会话编号 4
.sq11_contract_flag      ( sq11_contract_flag       )   , //合约标志 1
.sq11_contract_num       ( sq11_contract_num        )   , //合约编号 4
.sq11_contract_code      ( sq11_contract_code       )   , //合约代码 22
.sq11_update_time        ( sq11_update_time         )   , //更新时间 9
.sq11_update_ms          ( sq11_update_ms           )   , //更新毫秒 4
.sq11_new_price          ( sq11_new_price           )   , //�?新价 8
.sq11_turnover           ( sq11_turnover            )   , //成交�? 4
.sq11_volume             ( sq11_volume              )   , //成交�? 8   
.sq11_position           ( sq11_position            )   , //持仓�? 8
.sq11_purchase_price     ( sq11_purchase_price      )   , //申买�? 8
.sq11_buy_quantity       ( sq11_buy_quantity        )   , //申买�? 4
.sq11_sell_price         ( sq11_sell_price          )   , //申买�? 8
.sq11_sell_quantity      ( sq11_sell_quantity       )   , //申卖�? 4
.sq11_market_rdy         ( sq11_market_rdy          )   ,

.sq12_market_explain     ( sq12_market_explain      )   , //市场说明 3
.sq12_info_classify      ( sq12_info_classify       )   , //信息分类 1
.sq12_dialog_num         ( sq12_dialog_num          )   , //会话编号 4
.sq12_contract_flag      ( sq12_contract_flag       )   , //合约标志 1
.sq12_contract_num       ( sq12_contract_num        )   , //合约编号 4
.sq12_contract_code      ( sq12_contract_code       )   , //合约代码 22
.sq12_update_time        ( sq12_update_time         )   , //更新时间 9
.sq12_update_ms          ( sq12_update_ms           )   , //更新毫秒 4
.sq12_new_price          ( sq12_new_price           )   , //�?新价 8
.sq12_turnover           ( sq12_turnover            )   , //成交�? 4
.sq12_volume             ( sq12_volume              )   , //成交�? 8   
.sq12_position           ( sq12_position            )   , //持仓�? 8
.sq12_purchase_price     ( sq12_purchase_price      )   , //申买�? 8
.sq12_buy_quantity       ( sq12_buy_quantity        )   , //申买�? 4
.sq12_sell_price         ( sq12_sell_price          )   , //申买�? 8
.sq12_sell_quantity      ( sq12_sell_quantity       )   , //申卖�? 4
.sq12_market_rdy         ( sq12_market_rdy          )   ,

.sq13_market_explain     ( sq13_market_explain      )   , //市场说明 3
.sq13_info_classify      ( sq13_info_classify       )   , //信息分类 1
.sq13_dialog_num         ( sq13_dialog_num          )   , //会话编号 4
.sq13_contract_flag      ( sq13_contract_flag       )   , //合约标志 1
.sq13_contract_num       ( sq13_contract_num        )   , //合约编号 4
.sq13_contract_code      ( sq13_contract_code       )   , //合约代码 22
.sq13_update_time        ( sq13_update_time         )   , //更新时间 9
.sq13_update_ms          ( sq13_update_ms           )   , //更新毫秒 4
.sq13_new_price          ( sq13_new_price           )   , //�?新价 8
.sq13_turnover           ( sq13_turnover            )   , //成交�? 4
.sq13_volume             ( sq13_volume              )   , //成交�? 8   
.sq13_position           ( sq13_position            )   , //持仓�? 8
.sq13_purchase_price     ( sq13_purchase_price      )   , //申买�? 8
.sq13_buy_quantity       ( sq13_buy_quantity        )   , //申买�? 4
.sq13_sell_price         ( sq13_sell_price          )   , //申买�? 8
.sq13_sell_quantity      ( sq13_sell_quantity       )   , //申卖�? 4
.sq13_market_rdy         ( sq13_market_rdy          )   ,

.sq14_market_explain     ( sq14_market_explain      )   , //市场说明 3
.sq14_info_classify      ( sq14_info_classify       )   , //信息分类 1
.sq14_dialog_num         ( sq14_dialog_num          )   , //会话编号 4
.sq14_contract_flag      ( sq14_contract_flag       )   , //合约标志 1
.sq14_contract_num       ( sq14_contract_num        )   , //合约编号 4
.sq14_contract_code      ( sq14_contract_code       )   , //合约代码 22
.sq14_update_time        ( sq14_update_time         )   , //更新时间 9
.sq14_update_ms          ( sq14_update_ms           )   , //更新毫秒 4
.sq14_new_price          ( sq14_new_price           )   , //�?新价 8
.sq14_turnover           ( sq14_turnover            )   , //成交�? 4
.sq14_volume             ( sq14_volume              )   , //成交�? 8   
.sq14_position           ( sq14_position            )   , //持仓�? 8
.sq14_purchase_price     ( sq14_purchase_price      )   , //申买�? 8
.sq14_buy_quantity       ( sq14_buy_quantity        )   , //申买�? 4
.sq14_sell_price         ( sq14_sell_price          )   , //申买�? 8
.sq14_sell_quantity      ( sq14_sell_quantity       )   , //申卖�? 4
.sq14_market_rdy         ( sq14_market_rdy          )   ,

.sq15_market_explain     ( sq15_market_explain      )   , //市场说明 3
.sq15_info_classify      ( sq15_info_classify       )   , //信息分类 1
.sq15_dialog_num         ( sq15_dialog_num          )   , //会话编号 4
.sq15_contract_flag      ( sq15_contract_flag       )   , //合约标志 1
.sq15_contract_num       ( sq15_contract_num        )   , //合约编号 4
.sq15_contract_code      ( sq15_contract_code       )   , //合约代码 22
.sq15_update_time        ( sq15_update_time         )   , //更新时间 9
.sq15_update_ms          ( sq15_update_ms           )   , //更新毫秒 4
.sq15_new_price          ( sq15_new_price           )   , //�?新价 8
.sq15_turnover           ( sq15_turnover            )   , //成交�? 4
.sq15_volume             ( sq15_volume              )   , //成交�? 8   
.sq15_position           ( sq15_position            )   , //持仓�? 8
.sq15_purchase_price     ( sq15_purchase_price      )   , //申买�? 8
.sq15_buy_quantity       ( sq15_buy_quantity        )   , //申买�? 4
.sq15_sell_price         ( sq15_sell_price          )   , //申买�? 8
.sq15_sell_quantity      ( sq15_sell_quantity       )   , //申卖�? 4
.sq15_market_rdy         ( sq15_market_rdy          )   ,

.sq16_market_explain     ( sq16_market_explain      )   , //市场说明 3
.sq16_info_classify      ( sq16_info_classify       )   , //信息分类 1
.sq16_dialog_num         ( sq16_dialog_num          )   , //会话编号 4
.sq16_contract_flag      ( sq16_contract_flag       )   , //合约标志 1
.sq16_contract_num       ( sq16_contract_num        )   , //合约编号 4
.sq16_contract_code      ( sq16_contract_code       )   , //合约代码 22
.sq16_update_time        ( sq16_update_time         )   , //更新时间 9
.sq16_update_ms          ( sq16_update_ms           )   , //更新毫秒 4
.sq16_new_price          ( sq16_new_price           )   , //�?新价 8
.sq16_turnover           ( sq16_turnover            )   , //成交�? 4
.sq16_volume             ( sq16_volume              )   , //成交�? 8   
.sq16_position           ( sq16_position            )   , //持仓�? 8
.sq16_purchase_price     ( sq16_purchase_price      )   , //申买�? 8
.sq16_buy_quantity       ( sq16_buy_quantity        )   , //申买�? 4
.sq16_sell_price         ( sq16_sell_price          )   , //申买�? 8
.sq16_sell_quantity      ( sq16_sell_quantity       )   , //申卖�? 4
.sq16_market_rdy         ( sq16_market_rdy          )   ,

.sq17_market_explain     ( sq17_market_explain      )   , //市场说明 3
.sq17_info_classify      ( sq17_info_classify       )   , //信息分类 1
.sq17_dialog_num         ( sq17_dialog_num          )   , //会话编号 4
.sq17_contract_flag      ( sq17_contract_flag       )   , //合约标志 1
.sq17_contract_num       ( sq17_contract_num        )   , //合约编号 4
.sq17_contract_code      ( sq17_contract_code       )   , //合约代码 22
.sq17_update_time        ( sq17_update_time         )   , //更新时间 9
.sq17_update_ms          ( sq17_update_ms           )   , //更新毫秒 4
.sq17_new_price          ( sq17_new_price           )   , //�?新价 8
.sq17_turnover           ( sq17_turnover            )   , //成交�? 4
.sq17_volume             ( sq17_volume              )   , //成交�? 8   
.sq17_position           ( sq17_position            )   , //持仓�? 8
.sq17_purchase_price     ( sq17_purchase_price      )   , //申买�? 8
.sq17_buy_quantity       ( sq17_buy_quantity        )   , //申买�? 4
.sq17_sell_price         ( sq17_sell_price          )   , //申买�? 8
.sq17_sell_quantity      ( sq17_sell_quantity       )   , //申卖�? 4
.sq17_market_rdy         ( sq17_market_rdy          )   ,

.sq18_market_explain     ( sq18_market_explain      )   , //市场说明 3
.sq18_info_classify      ( sq18_info_classify       )   , //信息分类 1
.sq18_dialog_num         ( sq18_dialog_num          )   , //会话编号 4
.sq18_contract_flag      ( sq18_contract_flag       )   , //合约标志 1
.sq18_contract_num       ( sq18_contract_num        )   , //合约编号 4
.sq18_contract_code      ( sq18_contract_code       )   , //合约代码 22
.sq18_update_time        ( sq18_update_time         )   , //更新时间 9
.sq18_update_ms          ( sq18_update_ms           )   , //更新毫秒 4
.sq18_new_price          ( sq18_new_price           )   , //�?新价 8
.sq18_turnover           ( sq18_turnover            )   , //成交�? 4
.sq18_volume             ( sq18_volume              )   , //成交�? 8   
.sq18_position           ( sq18_position            )   , //持仓�? 8
.sq18_purchase_price     ( sq18_purchase_price      )   , //申买�? 8
.sq18_buy_quantity       ( sq18_buy_quantity        )   , //申买�? 4
.sq18_sell_price         ( sq18_sell_price          )   , //申买�? 8
.sq18_sell_quantity      ( sq18_sell_quantity       )   , //申卖�? 4
.sq18_market_rdy         ( sq18_market_rdy          )   ,

.sq19_market_explain     ( sq19_market_explain      )   , //市场说明 3
.sq19_info_classify      ( sq19_info_classify       )   , //信息分类 1
.sq19_dialog_num         ( sq19_dialog_num          )   , //会话编号 4
.sq19_contract_flag      ( sq19_contract_flag       )   , //合约标志 1
.sq19_contract_num       ( sq19_contract_num        )   , //合约编号 4
.sq19_contract_code      ( sq19_contract_code       )   , //合约代码 22
.sq19_update_time        ( sq19_update_time         )   , //更新时间 9
.sq19_update_ms          ( sq19_update_ms           )   , //更新毫秒 4
.sq19_new_price          ( sq19_new_price           )   , //�?新价 8
.sq19_turnover           ( sq19_turnover            )   , //成交�? 4
.sq19_volume             ( sq19_volume              )   , //成交�? 8   
.sq19_position           ( sq19_position            )   , //持仓�? 8
.sq19_purchase_price     ( sq19_purchase_price      )   , //申买�? 8
.sq19_buy_quantity       ( sq19_buy_quantity        )   , //申买�? 4
.sq19_sell_price         ( sq19_sell_price          )   , //申买�? 8
.sq19_sell_quantity      ( sq19_sell_quantity       )   , //申卖�? 4
.sq19_market_rdy         ( sq19_market_rdy          )   ,

.sq20_market_explain     ( sq20_market_explain      )   , //市场说明 3
.sq20_info_classify      ( sq20_info_classify       )   , //信息分类 1
.sq20_dialog_num         ( sq20_dialog_num          )   , //会话编号 4
.sq20_contract_flag      ( sq20_contract_flag       )   , //合约标志 1
.sq20_contract_num       ( sq20_contract_num        )   , //合约编号 4
.sq20_contract_code      ( sq20_contract_code       )   , //合约代码 22
.sq20_update_time        ( sq20_update_time         )   , //更新时间 9
.sq20_update_ms          ( sq20_update_ms           )   , //更新毫秒 4
.sq20_new_price          ( sq20_new_price           )   , //�?新价 8
.sq20_turnover           ( sq20_turnover            )   , //成交�? 4
.sq20_volume             ( sq20_volume              )   , //成交�? 8   
.sq20_position           ( sq20_position            )   , //持仓�? 8
.sq20_purchase_price     ( sq20_purchase_price      )   , //申买�? 8
.sq20_buy_quantity       ( sq20_buy_quantity        )   , //申买�? 4
.sq20_sell_price         ( sq20_sell_price          )   , //申买�? 8
.sq20_sell_quantity      ( sq20_sell_quantity       )   , //申卖�? 4
.sq20_market_rdy         ( sq20_market_rdy          )   ,

.sq21_market_explain     ( sq21_market_explain      )   , //市场说明 3
.sq21_info_classify      ( sq21_info_classify       )   , //信息分类 1
.sq21_dialog_num         ( sq21_dialog_num          )   , //会话编号 4
.sq21_contract_flag      ( sq21_contract_flag       )   , //合约标志 1
.sq21_contract_num       ( sq21_contract_num        )   , //合约编号 4
.sq21_contract_code      ( sq21_contract_code       )   , //合约代码 22
.sq21_update_time        ( sq21_update_time         )   , //更新时间 9
.sq21_update_ms          ( sq21_update_ms           )   , //更新毫秒 4
.sq21_new_price          ( sq21_new_price           )   , //�?新价 8
.sq21_turnover           ( sq21_turnover            )   , //成交�? 4
.sq21_volume             ( sq21_volume              )   , //成交�? 8   
.sq21_position           ( sq21_position            )   , //持仓�? 8
.sq21_purchase_price     ( sq21_purchase_price      )   , //申买�? 8
.sq21_buy_quantity       ( sq21_buy_quantity        )   , //申买�? 4
.sq21_sell_price         ( sq21_sell_price          )   , //申买�? 8
.sq21_sell_quantity      ( sq21_sell_quantity       )   , //申卖�? 4
.sq21_market_rdy         ( sq21_market_rdy          )   ,

.sq22_market_explain     ( sq22_market_explain      )   , //市场说明 3
.sq22_info_classify      ( sq22_info_classify       )   , //信息分类 1
.sq22_dialog_num         ( sq22_dialog_num          )   , //会话编号 4
.sq22_contract_flag      ( sq22_contract_flag       )   , //合约标志 1
.sq22_contract_num       ( sq22_contract_num        )   , //合约编号 4
.sq22_contract_code      ( sq22_contract_code       )   , //合约代码 22
.sq22_update_time        ( sq22_update_time         )   , //更新时间 9
.sq22_update_ms          ( sq22_update_ms           )   , //更新毫秒 4
.sq22_new_price          ( sq22_new_price           )   , //�?新价 8
.sq22_turnover           ( sq22_turnover            )   , //成交�? 4
.sq22_volume             ( sq22_volume              )   , //成交�? 8   
.sq22_position           ( sq22_position            )   , //持仓�? 8
.sq22_purchase_price     ( sq22_purchase_price      )   , //申买�? 8
.sq22_buy_quantity       ( sq22_buy_quantity        )   , //申买�? 4
.sq22_sell_price         ( sq22_sell_price          )   , //申买�? 8
.sq22_sell_quantity      ( sq22_sell_quantity       )   , //申卖�? 4
.sq22_market_rdy         ( sq22_market_rdy          )   ,

.sq23_market_explain     ( sq23_market_explain      )   , //市场说明 3
.sq23_info_classify      ( sq23_info_classify       )   , //信息分类 1
.sq23_dialog_num         ( sq23_dialog_num          )   , //会话编号 4
.sq23_contract_flag      ( sq23_contract_flag       )   , //合约标志 1
.sq23_contract_num       ( sq23_contract_num        )   , //合约编号 4
.sq23_contract_code      ( sq23_contract_code       )   , //合约代码 22
.sq23_update_time        ( sq23_update_time         )   , //更新时间 9
.sq23_update_ms          ( sq23_update_ms           )   , //更新毫秒 4
.sq23_new_price          ( sq23_new_price           )   , //�?新价 8
.sq23_turnover           ( sq23_turnover            )   , //成交�? 4
.sq23_volume             ( sq23_volume              )   , //成交�? 8   
.sq23_position           ( sq23_position            )   , //持仓�? 8
.sq23_purchase_price     ( sq23_purchase_price      )   , //申买�? 8
.sq23_buy_quantity       ( sq23_buy_quantity        )   , //申买�? 4
.sq23_sell_price         ( sq23_sell_price          )   , //申买�? 8
.sq23_sell_quantity      ( sq23_sell_quantity       )   , //申卖�? 4
.sq23_market_rdy         ( sq23_market_rdy          )   ,

.sq24_market_explain     ( sq24_market_explain      )   , //市场说明 3
.sq24_info_classify      ( sq24_info_classify       )   , //信息分类 1
.sq24_dialog_num         ( sq24_dialog_num          )   , //会话编号 4
.sq24_contract_flag      ( sq24_contract_flag       )   , //合约标志 1
.sq24_contract_num       ( sq24_contract_num        )   , //合约编号 4
.sq24_contract_code      ( sq24_contract_code       )   , //合约代码 22
.sq24_update_time        ( sq24_update_time         )   , //更新时间 9
.sq24_update_ms          ( sq24_update_ms           )   , //更新毫秒 4
.sq24_new_price          ( sq24_new_price           )   , //�?新价 8
.sq24_turnover           ( sq24_turnover            )   , //成交�? 4
.sq24_volume             ( sq24_volume              )   , //成交�? 8   
.sq24_position           ( sq24_position            )   , //持仓�? 8
.sq24_purchase_price     ( sq24_purchase_price      )   , //申买�? 8
.sq24_buy_quantity       ( sq24_buy_quantity        )   , //申买�? 4
.sq24_sell_price         ( sq24_sell_price          )   , //申买�? 8
.sq24_sell_quantity      ( sq24_sell_quantity       )   , //申卖�? 4
.sq24_market_rdy         ( sq24_market_rdy          )   ,

.sq25_market_explain     ( sq25_market_explain      )   , //市场说明 3
.sq25_info_classify      ( sq25_info_classify       )   , //信息分类 1
.sq25_dialog_num         ( sq25_dialog_num          )   , //会话编号 4
.sq25_contract_flag      ( sq25_contract_flag       )   , //合约标志 1
.sq25_contract_num       ( sq25_contract_num        )   , //合约编号 4
.sq25_contract_code      ( sq25_contract_code       )   , //合约代码 22
.sq25_update_time        ( sq25_update_time         )   , //更新时间 9
.sq25_update_ms          ( sq25_update_ms           )   , //更新毫秒 4
.sq25_new_price          ( sq25_new_price           )   , //�?新价 8
.sq25_turnover           ( sq25_turnover            )   , //成交�? 4
.sq25_volume             ( sq25_volume              )   , //成交�? 8   
.sq25_position           ( sq25_position            )   , //持仓�? 8
.sq25_purchase_price     ( sq25_purchase_price      )   , //申买�? 8
.sq25_buy_quantity       ( sq25_buy_quantity        )   , //申买�? 4
.sq25_sell_price         ( sq25_sell_price          )   , //申买�? 8
.sq25_sell_quantity      ( sq25_sell_quantity       )   , //申卖�? 4
.sq25_market_rdy         ( sq25_market_rdy          )   ,

.sq26_market_explain     ( sq26_market_explain      )   , //市场说明 3
.sq26_info_classify      ( sq26_info_classify       )   , //信息分类 1
.sq26_dialog_num         ( sq26_dialog_num          )   , //会话编号 4
.sq26_contract_flag      ( sq26_contract_flag       )   , //合约标志 1
.sq26_contract_num       ( sq26_contract_num        )   , //合约编号 4
.sq26_contract_code      ( sq26_contract_code       )   , //合约代码 22
.sq26_update_time        ( sq26_update_time         )   , //更新时间 9
.sq26_update_ms          ( sq26_update_ms           )   , //更新毫秒 4
.sq26_new_price          ( sq26_new_price           )   , //�?新价 8
.sq26_turnover           ( sq26_turnover            )   , //成交�? 4
.sq26_volume             ( sq26_volume              )   , //成交�? 8   
.sq26_position           ( sq26_position            )   , //持仓�? 8
.sq26_purchase_price     ( sq26_purchase_price      )   , //申买�? 8
.sq26_buy_quantity       ( sq26_buy_quantity        )   , //申买�? 4
.sq26_sell_price         ( sq26_sell_price          )   , //申买�? 8
.sq26_sell_quantity      ( sq26_sell_quantity       )   , //申卖�? 4
.sq26_market_rdy         ( sq26_market_rdy          )   ,

.sq27_market_explain     ( sq27_market_explain      )   , //市场说明 3
.sq27_info_classify      ( sq27_info_classify       )   , //信息分类 1
.sq27_dialog_num         ( sq27_dialog_num          )   , //会话编号 4
.sq27_contract_flag      ( sq27_contract_flag       )   , //合约标志 1
.sq27_contract_num       ( sq27_contract_num        )   , //合约编号 4
.sq27_contract_code      ( sq27_contract_code       )   , //合约代码 22
.sq27_update_time        ( sq27_update_time         )   , //更新时间 9
.sq27_update_ms          ( sq27_update_ms           )   , //更新毫秒 4
.sq27_new_price          ( sq27_new_price           )   , //�?新价 8
.sq27_turnover           ( sq27_turnover            )   , //成交�? 4
.sq27_volume             ( sq27_volume              )   , //成交�? 8   
.sq27_position           ( sq27_position            )   , //持仓�? 8
.sq27_purchase_price     ( sq27_purchase_price      )   , //申买�? 8
.sq27_buy_quantity       ( sq27_buy_quantity        )   , //申买�? 4
.sq27_sell_price         ( sq27_sell_price          )   , //申买�? 8
.sq27_sell_quantity      ( sq27_sell_quantity       )   , //申卖�? 4
.sq27_market_rdy         ( sq27_market_rdy          )   ,

.sq28_market_explain     ( sq28_market_explain      )   , //市场说明 3
.sq28_info_classify      ( sq28_info_classify       )   , //信息分类 1
.sq28_dialog_num         ( sq28_dialog_num          )   , //会话编号 4
.sq28_contract_flag      ( sq28_contract_flag       )   , //合约标志 1
.sq28_contract_num       ( sq28_contract_num        )   , //合约编号 4
.sq28_contract_code      ( sq28_contract_code       )   , //合约代码 22
.sq28_update_time        ( sq28_update_time         )   , //更新时间 9
.sq28_update_ms          ( sq28_update_ms           )   , //更新毫秒 4
.sq28_new_price          ( sq28_new_price           )   , //�?新价 8
.sq28_turnover           ( sq28_turnover            )   , //成交�? 4
.sq28_volume             ( sq28_volume              )   , //成交�? 8   
.sq28_position           ( sq28_position            )   , //持仓�? 8
.sq28_purchase_price     ( sq28_purchase_price      )   , //申买�? 8
.sq28_buy_quantity       ( sq28_buy_quantity        )   , //申买�? 4
.sq28_sell_price         ( sq28_sell_price          )   , //申买�? 8
.sq28_sell_quantity      ( sq28_sell_quantity       )   , //申卖�? 4
.sq28_market_rdy         ( sq28_market_rdy          )   ,

.sq29_market_explain     ( sq29_market_explain      )   , //市场说明 3
.sq29_info_classify      ( sq29_info_classify       )   , //信息分类 1
.sq29_dialog_num         ( sq29_dialog_num          )   , //会话编号 4
.sq29_contract_flag      ( sq29_contract_flag       )   , //合约标志 1
.sq29_contract_num       ( sq29_contract_num        )   , //合约编号 4
.sq29_contract_code      ( sq29_contract_code       )   , //合约代码 22
.sq29_update_time        ( sq29_update_time         )   , //更新时间 9
.sq29_update_ms          ( sq29_update_ms           )   , //更新毫秒 4
.sq29_new_price          ( sq29_new_price           )   , //�?新价 8
.sq29_turnover           ( sq29_turnover            )   , //成交�? 4
.sq29_volume             ( sq29_volume              )   , //成交�? 8   
.sq29_position           ( sq29_position            )   , //持仓�? 8
.sq29_purchase_price     ( sq29_purchase_price      )   , //申买�? 8
.sq29_buy_quantity       ( sq29_buy_quantity        )   , //申买�? 4
.sq29_sell_price         ( sq29_sell_price          )   , //申买�? 8
.sq29_sell_quantity      ( sq29_sell_quantity       )   , //申卖�? 4
.sq29_market_rdy         ( sq29_market_rdy          )   ,

.sq30_market_explain     ( sq30_market_explain      )   , //市场说明 3
.sq30_info_classify      ( sq30_info_classify       )   , //信息分类 1
.sq30_dialog_num         ( sq30_dialog_num          )   , //会话编号 4
.sq30_contract_flag      ( sq30_contract_flag       )   , //合约标志 1
.sq30_contract_num       ( sq30_contract_num        )   , //合约编号 4
.sq30_contract_code      ( sq30_contract_code       )   , //合约代码 22
.sq30_update_time        ( sq30_update_time         )   , //更新时间 9
.sq30_update_ms          ( sq30_update_ms           )   , //更新毫秒 4
.sq30_new_price          ( sq30_new_price           )   , //�?新价 8
.sq30_turnover           ( sq30_turnover            )   , //成交�? 4
.sq30_volume             ( sq30_volume              )   , //成交�? 8   
.sq30_position           ( sq30_position            )   , //持仓�? 8
.sq30_purchase_price     ( sq30_purchase_price      )   , //申买�? 8
.sq30_buy_quantity       ( sq30_buy_quantity        )   , //申买�? 4
.sq30_sell_price         ( sq30_sell_price          )   , //申买�? 8
.sq30_sell_quantity      ( sq30_sell_quantity       )   , //申卖�? 4
.sq30_market_rdy         ( sq30_market_rdy          )   ,

.sq31_market_explain     ( sq31_market_explain      )   , //市场说明 3
.sq31_info_classify      ( sq31_info_classify       )   , //信息分类 1
.sq31_dialog_num         ( sq31_dialog_num          )   , //会话编号 4
.sq31_contract_flag      ( sq31_contract_flag       )   , //合约标志 1
.sq31_contract_num       ( sq31_contract_num        )   , //合约编号 4
.sq31_contract_code      ( sq31_contract_code       )   , //合约代码 22
.sq31_update_time        ( sq31_update_time         )   , //更新时间 9
.sq31_update_ms          ( sq31_update_ms           )   , //更新毫秒 4
.sq31_new_price          ( sq31_new_price           )   , //�?新价 8
.sq31_turnover           ( sq31_turnover            )   , //成交�? 4
.sq31_volume             ( sq31_volume              )   , //成交�? 8   
.sq31_position           ( sq31_position            )   , //持仓�? 8
.sq31_purchase_price     ( sq31_purchase_price      )   , //申买�? 8
.sq31_buy_quantity       ( sq31_buy_quantity        )   , //申买�? 4
.sq31_sell_price         ( sq31_sell_price          )   , //申买�? 8
.sq31_sell_quantity      ( sq31_sell_quantity       )   , //申卖�? 4
.sq31_market_rdy         ( sq31_market_rdy          )   ,


.rmem_data0_0           (rmem_data0_0       )   ,
.rmem_data0_1           (rmem_data0_1       )   ,
.rmem_data0_0_vld       (rmem_data0_0_vld   )   ,
.rmem_data0_1_vld       (rmem_data0_1_vld   )   ,

.rmem_data0_2           (rmem_data0_2       )   ,
.rmem_data0_3           (rmem_data0_3       )   ,
.rmem_data0_2_vld       (rmem_data0_2_vld   )   ,
.rmem_data0_3_vld       (rmem_data0_3_vld   )   ,


.rmem_data0           ( rmem_data0             )   ,
.rmem_data1           ( rmem_data1             )   ,
.rmem_data2           ( rmem_data2             )   ,
.rmem_data3           ( rmem_data3             )   ,
.rmem_vld             ( rmem_vld               )   

);


/////////////////////////
//fifo output to pcie
reg            tlp_fifo_wr;
reg    [255:0] tlp_fifo_wdata;
reg    [255:0] tlp_fifo_data;
wire           tlp_fifo_rd;
wire           tlp_fifo_full;
wire   [255:0] tlp_fifo_data_out;
wire [255:0]   rmem_data0_0_wire =  { 
           rmem_data0_0[  7:  0], rmem_data0_0[ 15:  8],rmem_data0_0[ 23: 16],rmem_data0_0[ 31: 24],
           rmem_data0_0[ 39: 32], rmem_data0_0[ 47: 40],rmem_data0_0[ 55: 48],rmem_data0_0[ 63: 56],
           rmem_data0_0[ 71: 64], rmem_data0_0[ 79: 72],rmem_data0_0[ 87: 80],rmem_data0_0[ 95: 88],
           rmem_data0_0[103: 96], rmem_data0_0[111:104],rmem_data0_0[119:112],rmem_data0_0[127:120],
           rmem_data0_0[135:128], rmem_data0_0[143:136],rmem_data0_0[151:144],rmem_data0_0[159:152],
           rmem_data0_0[167:160], rmem_data0_0[175:168],rmem_data0_0[183:176],rmem_data0_0[191:184],
           rmem_data0_0[199:192], rmem_data0_0[207:200],rmem_data0_0[215:208],rmem_data0_0[223:216],
           rmem_data0_0[231:224], rmem_data0_0[239:232],rmem_data0_0[247:240],rmem_data0_0[255:248]
};

wire [255:0]   rmem_data0_1_wire =  { 
           rmem_data0_1[  7:  0], rmem_data0_1[ 15:  8],rmem_data0_1[ 23: 16],rmem_data0_1[ 31: 24],
           rmem_data0_1[ 39: 32], rmem_data0_1[ 47: 40],rmem_data0_1[ 55: 48],rmem_data0_1[ 63: 56],
           rmem_data0_1[ 71: 64], rmem_data0_1[ 79: 72],rmem_data0_1[ 87: 80],rmem_data0_1[ 95: 88],
           rmem_data0_1[103: 96], rmem_data0_1[111:104],rmem_data0_1[119:112],rmem_data0_1[127:120],
           rmem_data0_1[135:128], rmem_data0_1[143:136],rmem_data0_1[151:144],rmem_data0_1[159:152],
           rmem_data0_1[167:160], rmem_data0_1[175:168],rmem_data0_1[183:176],rmem_data0_1[191:184],
           rmem_data0_1[199:192], rmem_data0_1[207:200],rmem_data0_1[215:208],rmem_data0_1[223:216],
           rmem_data0_1[231:224], rmem_data0_1[239:232],rmem_data0_1[247:240],rmem_data0_1[255:248]
};

wire [255:0]   rmem_data0_2_wire =  { 
           rmem_data0_2[  7:  0], rmem_data0_2[ 15:  8],rmem_data0_2[ 23: 16],rmem_data0_2[ 31: 24],
           rmem_data0_2[ 39: 32], rmem_data0_2[ 47: 40],rmem_data0_2[ 55: 48],rmem_data0_2[ 63: 56],
           rmem_data0_2[ 71: 64], rmem_data0_2[ 79: 72],rmem_data0_2[ 87: 80],rmem_data0_2[ 95: 88],
           rmem_data0_2[103: 96], rmem_data0_2[111:104],rmem_data0_2[119:112],rmem_data0_2[127:120],
           rmem_data0_2[135:128], rmem_data0_2[143:136],rmem_data0_2[151:144],rmem_data0_2[159:152],
           rmem_data0_2[167:160], rmem_data0_2[175:168],rmem_data0_2[183:176],rmem_data0_2[191:184],
           rmem_data0_2[199:192], rmem_data0_2[207:200],rmem_data0_2[215:208],rmem_data0_2[223:216],
           rmem_data0_2[231:224], rmem_data0_2[239:232],rmem_data0_2[247:240],rmem_data0_2[255:248]
};


wire [255:0]   rmem_data0_3_wire =  { 
           rmem_data0_3[  7:  0], rmem_data0_3[ 15:  8],rmem_data0_3[ 23: 16],rmem_data0_3[ 31: 24],
           rmem_data0_3[ 39: 32], rmem_data0_3[ 47: 40],rmem_data0_3[ 55: 48],rmem_data0_3[ 63: 56],
           rmem_data0_3[ 71: 64], rmem_data0_3[ 79: 72],rmem_data0_3[ 87: 80],rmem_data0_3[ 95: 88],
           rmem_data0_3[103: 96], rmem_data0_3[111:104],rmem_data0_3[119:112],rmem_data0_3[127:120],
           rmem_data0_3[135:128], rmem_data0_3[143:136],rmem_data0_3[151:144],rmem_data0_3[159:152],
           rmem_data0_3[167:160], rmem_data0_3[175:168],rmem_data0_3[183:176],rmem_data0_3[191:184],
           rmem_data0_3[199:192], rmem_data0_3[207:200],rmem_data0_3[215:208],rmem_data0_3[223:216],
           rmem_data0_3[231:224], rmem_data0_3[239:232],rmem_data0_3[247:240],rmem_data0_3[255:248]
};

 wire  [255:0]  rmem_data1_wire = {
 rmem_data1[  7:  0], rmem_data1[ 15:  8],rmem_data1[ 23: 16],rmem_data1[ 31: 24],
 rmem_data1[ 39: 32], rmem_data1[ 47: 40],rmem_data1[ 55: 48],rmem_data1[ 63: 56],
 rmem_data1[ 71: 64], rmem_data1[ 79: 72],rmem_data1[ 87: 80],rmem_data1[ 95: 88],
 rmem_data1[103: 96], rmem_data1[111:104],rmem_data1[119:112],rmem_data1[127:120],
 rmem_data1[135:128], rmem_data1[143:136],rmem_data1[151:144],rmem_data1[159:152],
 rmem_data1[167:160], rmem_data1[175:168],rmem_data1[183:176],rmem_data1[191:184],
 rmem_data1[199:192], rmem_data1[207:200],rmem_data1[215:208],rmem_data1[223:216],
 rmem_data1[231:224], rmem_data1[239:232],rmem_data1[247:240],rmem_data1[255:248]
 };

 wire  [255:0]  rmem_data2_wire = {
 rmem_data2[  7:  0], rmem_data2[ 15:  8],rmem_data2[ 23: 16],rmem_data2[ 31: 24],
 rmem_data2[ 39: 32], rmem_data2[ 47: 40],rmem_data2[ 55: 48],rmem_data2[ 63: 56],
 rmem_data2[ 71: 64], rmem_data2[ 79: 72],rmem_data2[ 87: 80],rmem_data2[ 95: 88],
 rmem_data2[103: 96], rmem_data2[111:104],rmem_data2[119:112],rmem_data2[127:120],
 rmem_data2[135:128], rmem_data2[143:136],rmem_data2[151:144],rmem_data2[159:152],
 rmem_data2[167:160], rmem_data2[175:168],rmem_data2[183:176],rmem_data2[191:184],
 rmem_data2[199:192], rmem_data2[207:200],rmem_data2[215:208],rmem_data2[223:216],
 rmem_data2[231:224], rmem_data2[239:232],rmem_data2[247:240],rmem_data2[255:248]
 };

 wire  [31:0]  rmem_data3_wire = {
 rmem_data3[  7:  0], rmem_data3[ 15:  8],rmem_data3[ 23: 16],rmem_data3[ 31: 24]
 };
 

reg   [1:0]    rmem_vld_cnt = 2'b0;

always@ ( posedge clk)
   tlp_fifo_wr <= rmem_vld;
   
assign tlp_fifo_rd =  tlp_fifo_wr    ;  //fifo_ready && !tlp_fifo_empty;
   
always@ ( posedge clk)
   if(rmem_vld)
      rmem_vld_cnt   <= rmem_vld_cnt + 1'b1;  
   
always@ ( posedge clk)
  if(rmem_vld && (rmem_vld_cnt == 2'b0) ) begin
    if(rmem_data0_0_vld)
		tlp_fifo_wdata  <=  rmem_data0_0_wire;
	else if(rmem_data0_1_vld)
		tlp_fifo_wdata  <=  rmem_data0_1_wire;
	else if(rmem_data0_2_vld)
		tlp_fifo_wdata  <=  rmem_data0_2_wire;
	else if(rmem_data0_3_vld)
		tlp_fifo_wdata  <=  rmem_data0_3_wire;
   end
   else if(rmem_vld && (rmem_vld_cnt == 2'b1))
      tlp_fifo_wdata  <=  rmem_data1_wire;
   else if(rmem_vld && (rmem_vld_cnt == 2'd2))
      tlp_fifo_wdata  <=  rmem_data2_wire;
   else if(rmem_vld && (rmem_vld_cnt == 2'd3))
      tlp_fifo_wdata  <=  rmem_data3_wire;
 



 
 always@ ( posedge clk)		
    if(!rst_n)
      tlp_fifo_data_vld <= 1'b0;
    else
      tlp_fifo_data_vld <= tlp_fifo_rd;
	  
 always@ ( posedge clk)	
    tlp_fifo_rdata <=   tlp_fifo_wdata ;



assign tlp_fifo_empty = 1'd0 ;
	  
//tlp_fifo u_tlp_fifo (
//  .clk(clk),                  // input wire clk
//  .srst(~rst_n),                // input wire srst
//  .din(tlp_fifo_wdata),                  // input wire [255 : 0] din
//  .wr_en(tlp_fifo_wr),              // input wire wr_en
//  .rd_en(tlp_fifo_rd),              // input wire rd_en
//  .dout(tlp_fifo_data_out),                // output wire [255 : 0] dout
//  .full(tlp_fifo_full),                // output wire full
//  .empty(tlp_fifo_empty),              // output wire empty
//  .wr_rst_busy(),  // output wire wr_rst_busy
//  .rd_rst_busy()  // output wire rd_rst_busy
//);
		
//ila_tlp u_ila_tlp (
//	.clk(clk), // input wire clk


//	.probe0(tlp_fifo_rd), // input wire [0:0]  probe0  
//	.probe1(tlp_fifo_data_out), // input wire [255:0]  probe1 
//	.probe2(tlp_fifo_empty), // input wire [0:0]  probe2 
//	.probe3(tlp_fifo_full) // input wire [0:0]  probe3
//);		
  

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//TLP GEM STATE 

// reg     [3:0]     tlp_gen_cstate ;
// reg     [3:0]     tlp_gen_nstate ;
	
// reg     [3:0]     rmem_cnt       ;	
// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // tlp_gen_cstate  <=  4'd0 ;
  // end
  // else begin 
     // tlp_gen_cstate  <=  tlp_gen_nstate ;
  // end
// end

// always@ ( * )
// begin
  // tlp_gen_nstate = tlp_gen_cstate;
  // case(tlp_gen_cstate)
  // TLPG_IDLE : begin  
          // if (rmem_vld)  begin
	      // tlp_gen_nstate = TLPG_DA0;    
	  // end
  // end
  // TLPG_DA0 : begin
          // if (~rmem_vld) begin
              // tlp_gen_nstate = TLPG_IDLE;    
          // end
  // end
  // default : begin
     // tlp_gen_nstate = TLPG_IDLE;     
  // end
  // endcase
 // end

// wire   tlpg_idle_state = (tlp_gen_cstate==TLPG_IDLE);
// wire   tlpg_da0_state  = (tlp_gen_cstate==TLPG_DA0);

// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // rmem_cnt  <=  4'd0 ;
  // end
  // else if (tlpg_idle_state) begin
     // rmem_cnt  <=  4'd0 ;
  // end
  // else if (tlpg_da0_state)  begin 
     // rmem_cnt  <=  rmem_cnt + 1'd1  ;
  // end
// end

// reg            tlp_g_start ;
// reg            tlp_g_stop  ;
// reg   [255:0]  tlp_g_data  ;
// reg   [  1:0]  tlp_g_empty ;
// reg            tlp_g_vld   ;

// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // tlp_g_vld  <=  1'd0 ;
  // end
  // else if (rmem_vld)   begin 
     // tlp_g_vld  <=  1'd1  ;
  // end
  // else if (tlpg_da0_state&&~rmem_vld)   begin 
     // tlp_g_vld  <=  1'd1  ;
  // end
  // else begin
     // tlp_g_vld  <=  1'd0 ;     
  // end
// end


// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // tlp_g_start  <=  1'd0 ;
  // end
  // else if (tlpg_idle_state) begin
     // tlp_g_start  <=  rmem_vld ;
  // end
  // else   begin 
     // tlp_g_start  <=  1'd0  ;
  // end
// end


// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // tlp_g_stop  <=  1'd0 ;
  // end
  // else if (tlpg_da0_state) begin
   //// tlp_g_stop  <=  rmem_vld&&(rmem_cnt==4'd2 ) ;
     // tlp_g_stop  <=  ~rmem_vld ;     
  // end
  // else   begin 
     // tlp_g_stop  <=  1'd0  ;
  // end
// end

// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // tlp_g_empty  <=  2'd0 ;
  // end
  // else if (tlpg_da0_state) begin
   //// tlp_g_empty  <=  rmem_vld&&(rmem_cnt==rmem_descriptor_reg[128+9:128+3])  ?   2'd2  :  2'd0  ;
     // tlp_g_empty  <=  ~rmem_vld  ?   2'd2  :  2'd0  ;
	//// tlp_g_empty  <=  rmem_vld&&(rmem_cnt==4'd2 )  ?   2'd1  :  2'd0  ;
  // end
  // else   begin 
     // tlp_g_empty  <=  2'd0  ;
  // end
// end

/*  // assign tlp_hdr_dw0 = {cmd[7:0], 8'h0, 6'h0, sent_dw[9:0]};
 // assign tlp_hdr_dw1 = {requestor_id[15:0], 8'h0, lbe ,4'hF};
 // assign tlp_hdr_dw2     = hdr_mwr64_reg?  hdr_dest_addr_reg[63:32] : hdr_dest_addr_reg[31:0];
 // assign tlp_hdr_dw 3     = hdr_dest_addr_reg[31:0];
*/

// wire   [31:0]   tlp_hdr_dw0  ;
// wire   [31:0]   tlp_hdr_dw1  ;
// wire   [31:0]   tlp_hdr_dw2  ;
// wire   [31:0]   tlp_hdr_dw3  ;


// reg    [63:0]       des_aaddr2        ;
// reg    [63:0]       des_aaddr_dly     ;
// reg    [23:0]       des_acnt          ;
// always @(posedge clk or negedge rst_n)
// begin
    // if (~rst_n)
    // begin
        // des_aaddr_dly  <= 64'd0;
    // end
    // else 
    // begin
        // des_aaddr_dly  <= rmem_descriptor_reg[127:64];
    // end
// end

// always @(posedge clk or negedge rst_n)
// begin
    // if (~rst_n)
    // begin
        // des_aaddr2  <= 64'd0;
		// des_acnt      <= 24'd0;
    // end
	 // else if (params_filter_rst) begin
	   // des_aaddr2  <= rmem_descriptor_reg[127:64];
			// des_acnt    <=  24'd0;
	 // end
    // else  begin  //512*2=2k
       // if (des_aaddr_dly==rmem_descriptor_reg[127:64]) begin
         // des_aaddr2     <= (tlpg_idle_state&&rmem_vld)   ?   (des_acnt==params_des_acnt) ?  rmem_descriptor_reg[127:64] : (des_aaddr2+64'd128)      :   des_aaddr2 ;
	     // des_acnt       <= (tlpg_idle_state&&rmem_vld)    ?   (des_acnt==params_des_acnt) ?  24'd0                       :  (des_acnt + 24'd1)       :  des_acnt ;
	    // end
		 // else begin
		    // des_aaddr2  <= rmem_descriptor_reg[127:64];
			// des_acnt    <=  24'd0;
		 // end
    // end
// end

// wire   [9:0]    sent_dw   =   rmem_descriptor_reg[128+9:128]  ;
// wire   [7:0]    cmd       =   (des_aaddr2[63:32]!=32'd0)   ?    8'h60  :  8'h40 ;
////wire   [15:0]   requestor_id = 16'h0108 ;


  // assign tlp_hdr_dw0 = {cmd[7:0], 8'h0, 6'h0, sent_dw[9:0]};
  // assign tlp_hdr_dw1 = {requestor_id[15:0], 8'h0, 4'hF ,4'hF};
  
  // assign tlp_hdr_dw2     = (des_aaddr2[63:32]!=32'd0)   ?  des_aaddr2[63:32] :  des_aaddr2[31:0];
  // assign tlp_hdr_dw3     = (des_aaddr2[63:32]!=32'd0)   ?  des_aaddr2[31: 0]  :  32'd0 ;



///  wire  [255:0]  rx_writedata2_wire ;
// assign  rx_writedata2_wire = {
// rx_writedata2[  7:  0], rx_writedata2[ 15:  8],rx_writedata2[ 23: 16],rx_writedata2[ 31: 24],
// rx_writedata2[ 39: 32], rx_writedata2[ 47: 40],rx_writedata2[ 55: 48],rx_writedata2[ 63: 56],
// rx_writedata2[ 71: 64], rx_writedata2[ 79: 72],rx_writedata2[ 87: 80],rx_writedata2[ 95: 88],
// rx_writedata2[103: 96], rx_writedata2[111:104],rx_writedata2[119:112],rx_writedata2[127:120],
// rx_writedata2[135:128], rx_writedata2[143:136],rx_writedata2[151:144],rx_writedata2[159:152],
// rx_writedata2[167:160], rx_writedata2[175:168],rx_writedata2[183:176],rx_writedata2[191:184],
// rx_writedata2[199:192], rx_writedata2[207:200],rx_writedata2[215:208],rx_writedata2[223:216],
// rx_writedata2[231:224], rx_writedata2[239:232],rx_writedata2[247:240],rx_writedata2[255:248]

// };

// wire [127:0]  rmem_data0_0_wire = {
// rmem_data0_0[135:128], rmem_data0_0[143:136],rmem_data0_0[151:144],rmem_data0_0[159:152],
// rmem_data0_0[167:160], rmem_data0_0[175:168],rmem_data0_0[183:176],rmem_data0_0[191:184],
// rmem_data0_0[199:192], rmem_data0_0[207:200],rmem_data0_0[215:208],rmem_data0_0[223:216],
// rmem_data0_0[231:224], rmem_data0_0[239:232],rmem_data0_0[247:240],rmem_data0_0[255:248]
// };

// wire [127:0]  rmem_data0_1_wire = {
// rmem_data0_1[135:128], rmem_data0_1[143:136],rmem_data0_1[151:144],rmem_data0_1[159:152],
// rmem_data0_1[167:160], rmem_data0_1[175:168],rmem_data0_1[183:176],rmem_data0_1[191:184],
// rmem_data0_1[199:192], rmem_data0_1[207:200],rmem_data0_1[215:208],rmem_data0_1[223:216],
// rmem_data0_1[231:224], rmem_data0_1[239:232],rmem_data0_1[247:240],rmem_data0_1[255:248]
// };

// wire [127:0]  rmem_data0_2_wire = {
// rmem_data0_2[135:128], rmem_data0_2[143:136],rmem_data0_2[151:144],rmem_data0_2[159:152],
// rmem_data0_2[167:160], rmem_data0_2[175:168],rmem_data0_2[183:176],rmem_data0_2[191:184],
// rmem_data0_2[199:192], rmem_data0_2[207:200],rmem_data0_2[215:208],rmem_data0_2[223:216],
// rmem_data0_2[231:224], rmem_data0_2[239:232],rmem_data0_2[247:240],rmem_data0_2[255:248]
// };

// wire [127:0]  rmem_data0_3_wire = {
// rmem_data0_3[135:128], rmem_data0_3[143:136],rmem_data0_3[151:144],rmem_data0_3[159:152],
// rmem_data0_3[167:160], rmem_data0_3[175:168],rmem_data0_3[183:176],rmem_data0_3[191:184],
// rmem_data0_3[199:192], rmem_data0_3[207:200],rmem_data0_3[215:208],rmem_data0_3[223:216],
// rmem_data0_3[231:224], rmem_data0_3[239:232],rmem_data0_3[247:240],rmem_data0_3[255:248]
// };
  
// wire [127:0]  rmem_data0_wire = {
// rmem_data0[  7:  0], rmem_data0[ 15:  8],rmem_data0[ 23: 16],rmem_data0[ 31: 24],
// rmem_data0[ 39: 32], rmem_data0[ 47: 40],rmem_data0[ 55: 48],rmem_data0[ 63: 56],
// rmem_data0[ 71: 64], rmem_data0[ 79: 72],rmem_data0[ 87: 80],rmem_data0[ 95: 88],
// rmem_data0[103: 96], rmem_data0[111:104],rmem_data0[119:112],rmem_data0[127:120]
// };

// wire  [255:0]  rmem_data1_wire = {
// rmem_data1[  7:  0], rmem_data1[ 15:  8],rmem_data1[ 23: 16],rmem_data1[ 31: 24],
// rmem_data1[ 39: 32], rmem_data1[ 47: 40],rmem_data1[ 55: 48],rmem_data1[ 63: 56],
// rmem_data1[ 71: 64], rmem_data1[ 79: 72],rmem_data1[ 87: 80],rmem_data1[ 95: 88],
// rmem_data1[103: 96], rmem_data1[111:104],rmem_data1[119:112],rmem_data1[127:120],
// rmem_data1[135:128], rmem_data1[143:136],rmem_data1[151:144],rmem_data1[159:152],
// rmem_data1[167:160], rmem_data1[175:168],rmem_data1[183:176],rmem_data1[191:184],
// rmem_data1[199:192], rmem_data1[207:200],rmem_data1[215:208],rmem_data1[223:216],
// rmem_data1[231:224], rmem_data1[239:232],rmem_data1[247:240],rmem_data1[255:248]
// };

// wire  [255:0]  rmem_data2_wire = {
// rmem_data2[  7:  0], rmem_data2[ 15:  8],rmem_data2[ 23: 16],rmem_data2[ 31: 24],
// rmem_data2[ 39: 32], rmem_data2[ 47: 40],rmem_data2[ 55: 48],rmem_data2[ 63: 56],
// rmem_data2[ 71: 64], rmem_data2[ 79: 72],rmem_data2[ 87: 80],rmem_data2[ 95: 88],
// rmem_data2[103: 96], rmem_data2[111:104],rmem_data2[119:112],rmem_data2[127:120],
// rmem_data2[135:128], rmem_data2[143:136],rmem_data2[151:144],rmem_data2[159:152],
// rmem_data2[167:160], rmem_data2[175:168],rmem_data2[183:176],rmem_data2[191:184],
// rmem_data2[199:192], rmem_data2[207:200],rmem_data2[215:208],rmem_data2[223:216],
// rmem_data2[231:224], rmem_data2[239:232],rmem_data2[247:240],rmem_data2[255:248]
// };

// wire  [31:0]  rmem_data3_wire = {
// rmem_data3[  7:  0], rmem_data3[ 15:  8],rmem_data3[ 23: 16],rmem_data3[ 31: 24]
// };
  
// always@ ( negedge rst_n  or posedge clk)
// begin
  // if (~rst_n) begin
     // tlp_g_data  <=  256'd0 ;
  // end
  // else if (tlpg_idle_state&&rmem_vld && rmem_data0_0_vld) begin
       // tlp_g_data  <=  {rmem_data0_0_wire[127:0],tlp_hdr_dw3,tlp_hdr_dw2,tlp_hdr_dw1,tlp_hdr_dw0} ;
  // end
  // else if (tlpg_idle_state&&rmem_vld && rmem_data0_1_vld) begin
       // tlp_g_data  <=  {rmem_data0_1_wire[127:0],tlp_hdr_dw3,tlp_hdr_dw2,tlp_hdr_dw1,tlp_hdr_dw0} ;
  // end
  // else if (tlpg_idle_state&&rmem_vld && rmem_data0_2_vld) begin
       // tlp_g_data  <=  {rmem_data0_2_wire[127:0],tlp_hdr_dw3,tlp_hdr_dw2,tlp_hdr_dw1,tlp_hdr_dw0} ;
  // end
  // else if (tlpg_idle_state&&rmem_vld && rmem_data0_3_vld) begin
       // tlp_g_data  <=  {rmem_data0_3_wire[127:0],tlp_hdr_dw3,tlp_hdr_dw2,tlp_hdr_dw1,tlp_hdr_dw0} ;
  // end

  // else if (tlpg_da0_state&&rmem_vld&&(rmem_cnt==4'd0)) begin
       // tlp_g_data  <=  {rmem_data1_wire[127:0],rmem_data0_wire[127:0]} ;   
  // end
  // else if (tlpg_da0_state&&rmem_vld&&(rmem_cnt==4'd1)) begin
       // tlp_g_data  <=  {rmem_data2_wire[127:0],rmem_data1_wire[255:128]} ;       
  // end
  // else if (tlpg_da0_state&&rmem_vld&&(rmem_cnt==4'd2)) begin
       // tlp_g_data  <=  {64'd0, rmem_data0[159:152]  ,rmem_data0[167:160]  ,rmem_data0[175:168]  ,rmem_data0[183:176]  ,rmem_data3_wire[31:0],rmem_data2_wire[255:128]} ;       
  // end
 //else if (tlpg_da0_state&&rmem_vld&&(rmem_cnt==4'd7)) begin
   // else if (tlpg_da0_state&&~rmem_vld) begin
       ////tlp_g_data  <=  {128'd0,rmem_data7[255:128]} ; 
       // tlp_g_data  <=  {128'd0,128'd0} ;     	   
   // end
  
// end

/* 
// tlp_st_fifo  tlp_st_fifo (
               // .in_clk           (clk            )    ,
               // .in_reset_n       (rst_n        )    ,
					 
				// .pcie_clk                    (pcie_clk      ),
           // .pcie_clk_rstn               (pcie_clk_rstn       ),	 

					 
               // .in_data          ( tlp_g_data    )    ,           //            in.data
		// .in_valid         ( tlp_g_vld     )    ,          //              .valid
		// .in_ready         (               )    ,          //              .ready
		// .in_startofpacket ( tlp_g_start   )    ,  //              .startofpacket
		// .in_endofpacket   ( tlp_g_stop    )    ,    //              .endofpacket
		// .in_empty         ( tlp_g_empty   )    ,          //              .empty
		// .out_data         ( tlp_StData_o    )    ,          //           out.data
		// .out_valid        ( tlp_StValid_o   )    ,         //              .valid
		// .out_ready        ( tlp_StReady_i   )    ,         //              .ready
		// .out_startofpacket( tlp_StSop_o     )    , //              .startofpacket
		// .out_endofpacket  ( tlp_StEop_o     )    ,   //              .endofpacket
		// .out_empty        ( tlp_StEmpty_o   )    ,         //              .empty
               // .st_fifo_cnt      (    )    ,
               // .st_fifo_empty    ( st_fifo_empty   )    ,
               // .st_fifo_full     ( st_fifo_full    )    ,
               // .st_fifo_hfull    ( st_fifo_hfull   )    

                 
// );
 */

// reg      [ 7:0]           fifo_re_enable   ;


// wire   [259:0]  fifo_din  =  {tlp_g_start,tlp_g_stop,tlp_g_empty[1:0],tlp_g_data[255:0]};
// wire            fifo_we   =  tlp_g_vld ;
// wire            st_fifo_empty  ;
// wire            fifo_re   =  ~st_fifo_empty && tlp_StReady_i &&  fifo_re_enable ;
// wire   [259:0]  fifo_dout ;
            
// wire     [255: 0]         tlp_StData_o      =   fifo_dout[255:0]  ;
// wire                      tlp_StSop_o       =   fifo_dout[259]  ;
// wire                      tlp_StEop_o       =   fifo_dout[258]  ;
// wire     [  1: 0]         tlp_StEmpty_o     =   fifo_dout[257:256]  ;
// wire                      tlp_StValid_o     =   fifo_re ;      

// wire     [ 7:0]           rdusedw          ;




// always@ ( negedge pcie_clk_rstn  or posedge pcie_clk)
// begin
  // if (~pcie_clk_rstn) begin
     // fifo_re_enable  <=  1'd0 ;
  // end
  // else if ( tlp_StEop_o&&tlp_StValid_o   ) begin
      // fifo_re_enable  <=  1'd0 ;
  // end
  // else if ( (rdusedw>=8'd4) ) begin
      // fifo_re_enable  <=  1'd1 ;
  // end
// end
			
// tlp_my_fifo   tlp_st_fifo (
		// .data      (fifo_din)  ,    //  fifo_input.datain
		// .wrreq     (fifo_we)  ,   //            .wrreq
		// .rdreq     (fifo_re)  ,   //            .rdreq
		// .wrclk     (clk    )  ,   //            .wrclk
		// .rdclk     (pcie_clk )  ,   //            .rdclk
		// .q         (fifo_dout)  ,         // fifo_output.dataout
		// .rdempty   (st_fifo_empty)  ,   //            .rdempty
                // .rdusedw   (rdusedw),
		// .wrfull    ()      //            .wrfull
	// );







endmodule



