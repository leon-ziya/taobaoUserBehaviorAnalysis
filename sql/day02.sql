-- 创建user_behavior
create database taobao;
use taobao;
create external table user_behavior (
                                        user_id bigint comment "用户id",
                                        item_id bigint comment "商品id",
                                        behavior_type int comment "用户行为类型",
                                        user_geohash String comment "地理位置",
                                        item_category bigint comment "商品类别id",
                                        date_str String comment "时间"
)
    row format delimited
        fields terminated by ","
        NULL DEFINED AS "";

-- 创建user_behavior01
create table user_behavior01
as select
       user_id,
       item_id,
       behavior_type,
       item_category,
       split(date_str," ")[0] as ymd,
       split(date_str," ")[1] as hour
   from user_behavior
   group by user_id,item_id,behavior_type,user_geohash,item_category,date_str;


-- 查看user_behavior01的重复数据
select
    sum(t1.num) as `重复记录数量`
from (
         select
             count(*) num
         from user_behavior01
         group by user_id,item_id,behavior_type,item_category,ymd,hour
     ) t1;

-- 查看user_behavior01中的NULL值
select
    sum(if(user_id is NULL,1,0)) as `用户id的NULL个数`,
    sum(if(item_id is NULL,1,0)) as `商品id的NULL个数`,
    sum(if(behavior_type is NULL,1,0)) as `用户行为类型的NULL个数`,
    sum(if(item_category is NULL,1,0)) as `商品类别id的NULL个数`,
    sum(if(ymd is NULL,1,0)) as `日期的NULL个数`,
    sum(if(hour is NULL,1,0)) as `小时的NULL个数`
from user_behavior01;


-- 计算每天pu/uv--人均访问量
select
    round((    select
                   count(user_id)
               from user_behavior01
               group by ymd
          ) /
          (    select
                   count(distinct user_id)
               from user_behavior01
               group by ymd
          ),3) as `人均访问量`;

select
    ymd,
    round(count(user_id) / count(distinct user_id),3) as `计算人均访问量`
from user_behavior01
group by ymd;

-- 统计用户数量和成交用户数量
select
    count(distinct user_id) as `用户数量`
from user_behavior01;
-- 支付类型用4表示
select
    count(distinct user_id) as `支付用户数量`
from user_behavior01 where behavior_type=4;


-- 计算成交用户占比
select
    concat(round((
              select
                  count(distinct user_id) as `支付用户数量`
              from user_behavior01 where behavior_type=4
          ) / (
              select
                  count(distinct user_id) as `用户数量`
              from user_behavior01
          ),4)*100,"%") as `成交用户占比`;

select
    round(
        select

        from (
            select
                sum(if(behavior_type=4,1,0)) as userBy,
                sum(1) as user
            from user_behavior01
            ) t1
        )
