从地址到环境暴露：教学代码与数据

1. 本包只包含模拟数据，不包含患者地址、真实空气质量或API密钥。
2. 将ZIP解压到独立的练习文件夹，用RStudio建立R项目并打开该目录。
3. 按教程安装缺少的包，然后打开geocoding-exposure.R按顺序运行。
   也可以在R控制台运行：
   source("geocoding-exposure.R", echo = TRUE, encoding = "UTF-8")
4. 脚本会创建geocoding-output/保存教学结果，创建figure/保存封面地图。
   相同输出文件会被重新生成，请勿向这些目录放入原始研究数据。
5. query_tencent只定义函数，不自动联网。需密钥的调用和真实NetCDF
   文件模板在网页中另行说明，不属于已经联网或读取真实产品验证的部分。
6. example-output/提供一次已验证运行的CSV、GeoPackage和GeoTIFF结果，
   供对照使用。复现脚本无需先读这些文件，输入会由脚本生成。
7. 所有按步骤生成的R对象存在于同一会话。中途重启后应从头运行。
8. 网页提供每一步的原理、结果解释、图件、练习和来源。

验证环境：R 4.5.2；sf 1.0-23；terra 1.8-86；dplyr 1.1.4；
tidyr 1.3.2；purrr 1.2.0；ggplot2 4.0.1；knitr 1.51。
图形优先使用Times New Roman，中文由当前系统可用字体显示。
