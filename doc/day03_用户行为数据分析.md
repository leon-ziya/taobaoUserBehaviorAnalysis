# 淘宝用户行为分析_day03_用户行为数据分析
## 1. pv和uv
① **PV**(访问量)：即Page View, 具体是指网站的是页面浏览量或者点击量，页面被刷新一次就计算一次。  
② **UV**(独立访客)：即Unique Visitor,访问您网站的一台电脑客户端为一个访客。  
## 2. 分析思路
从用户、商品、平台三个维度分析，解决如下问题：  
① 流量的数量和质量如何？  
② 付费用户的数量和比例如何？  
③ 用户活跃情况  
④ 那些用户是高价值用户，哪些用户是可以引导消费  
⑤ 用户活动时间规律  
⑥ 用户商品偏好
⑦ 商品成交量贡献情况  
⑧ 交易环节转化率、跳失率，流程及页面是否合理  
## 3. 分析
### 1. 用户分析
#### 1）用户数量、成交用户数量
① 统计用户数量
```sql
select
    count(distinct user_id) as `用户数量`
from user_behavior01;
```
![用户数量](../img/用户数量.png)
② 统计成交用户数量
```sql
select
    count(distinct user_id) as `支付用户数量`
from user_behavior01 where behavior_type=4;
```
![支付用户数量](../img/支付用户数量.png)
③ 计算成交用户占比
```sql
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
```
![成交用户比例](../img/成交用户比例.png)
**总结**：用户数量为10000，成交用户数量为8886，成交用户占比为88.86%，即有大约有88%的用户进行了交易。  
#### 2）用户PV,UV,日活,成交转化率
> 日活：基于电商购物场景，我们将用户活跃定义为购买行为，所以日活就是每一天中有购买行为的用户数量
> 成交转化率：指一段时间所有到达店铺并产生购买行为的人数和所有到达店铺的人数的比率，即有购买行为人数/UV  

① 创建表day_PV统计每日PV  

```sql
create table day_PV as
select
    ymd as ymd,
    count(user_id) as PV
from user_behavior01
group by ymd
order by ymd ;    
```

























