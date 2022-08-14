
-- 导入employee的数据（全量方式）

--仅新增  报名课程表itcast_clazz   事实表
-- 开启动态分区
set hive.exec.dynamic.partition = true;
-- 开启动态分区为非严格模式
set hive.exec.dynamic.partition.mode = nonstrict;

set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;

--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


--首日上线

