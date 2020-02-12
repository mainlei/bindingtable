# bindingtable

## lua实现的简单数据绑定模型
* 单向绑定
* 一对多绑定
* 支持单次绑定
* 占不支持内嵌table 例如 ```data = {id = 'mainlei',pos = {x=0,y=0}}``` data.pos.x,data.pos.y目前无法被绑定，可以自己手动将pos转换为bindingtable

## Example：

```
local bindingtable =  require("bindingtable")

local data = bindingtable.create({x = 0,y = 0})

local tag = bindingtable.watch(data,"x",function ( value_new ,value_old, key)
    print(value_new,value_old,key)
end)


bindingtable.watchonce(data,"y",function ( value_new ,value_old, key)
    print(value_new, value_old, key)
end)

data.x = 10
data.y = 9

data.x = 11
data.y = 110
bindingtable.unwatch(data,"x",tag)
data.x = 0

```