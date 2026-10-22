# 证件照美颜识别（C++版）— 使用说明

解压后即可使用，无需安装 Python。

## 一、解压

把压缩包解压到任意目录，例如 `D:\face_detect_cpp`。  
请保持本文件夹内文件结构不变（程序、DLL、`models` 目录要在一起）。

## 二、识别一个文件夹

在解压目录打开 PowerShell 或命令提示符，执行：

```powershell
cd D:\face_detect_cpp
.\face_retouch_detect.exe --models .\models --src "待识别图片文件夹" --out "结果输出文件夹"
```

示例：

```powershell
.\face_retouch_detect.exe --models .\models --src "C:\Users\张三\Desktop\证件照" --out "C:\Users\张三\Desktop\识别结果"
```

也可双击运行同目录下的 `batch_detect.bat`，按提示输入路径。

> 说明：本文件由原 `使用说明.md` 重命名保留；英文说明见 `README.md`。脚本已更名为 `batch_detect.bat`。

## 三、识别单张图片

```powershell
.\face_retouch_detect.exe --models .\models --image "C:\Users\张三\Desktop\a.jpg"
```

## 四、结果说明

批量识别后，输出目录中会有：

| 内容 | 含义 |
|------|------|
| `原图\` | 判为未修图 |
| `美颜\` | 判为美颜/修图 |
| `检测失败\` | 读图失败或未检测到人脸 |
| `识别结果.csv` | 每张图的结果明细 |

不会修改你的原图，只是复制后分类存放。

## 五、注意

- 适合白底/浅底证件照；生活照、多人、侧脸可能不准或失败
- 需要 64 位 Windows
- 若提示缺少 DLL，请安装 [Microsoft Visual C++ 可再发行组件包](https://learn.microsoft.com/zh-cn/cpp/windows/latest-supported-vc-redist)（x64）
- 第一次运行可能稍慢，属于正常情况
