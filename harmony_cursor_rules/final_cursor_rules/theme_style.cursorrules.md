# HarmonyOS 主题与样式 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- 使用系统资源而非硬编码颜色值
- 遵循深色/浅色模式的自动切换机制
- 优先使用SVG图标并利用fillColor()属性
- 确保状态栏与应用主题保持一致

## 推荐做法

### 代码结构
- 在`base`和`dark`资源目录下分别定义同名颜色资源
- 使用`$('app.color.your_color_name')`引用颜色资源
- 通过`Map<string, number>`维护页面亮度映射表

### 最佳实践
- 利用HarmonyOS资源目录机制实现主题自动切换
- 视频播放页面实现亮度动态管理与恢复
- 将屏幕常亮与Video组件生命周期绑定
- 使用Slider组件提供用户可调节亮度UI

## 禁止做法

- 直接在代码中硬编码颜色值
- 忘记在深色模式下提供对应的资源文件
- 播放结束后不关闭屏幕常亮状态
- 混乱的页面亮度状态管理

## 代码示例

### 推荐写法
```arkts
// 颜色资源定义
// base/element/color.json
{
  "text_color": "#FF000000"
}

// dark/element/color.json
{
  "text_color": "#FFFFFFFF"
}

// 使用系统颜色
Text($r('app.color.text_color'))

// 亮度管理
private brightnessMap: Map<string, number> = new Map()
private currentBrightness: number = 1.0

aboutToAppear() {
  this.currentBrightness = this.brightnessMap.get(this.navDestination) || 1.0
  window.setWindowBrightness(this.currentBrightness)
}
```

### 避免写法
```arkts
// 硬编码颜色
Text().fillColor('#FF000000') // 错误

// 忘记深色模式资源
// 只在base目录定义颜色，dark目录为空

// 不管理屏幕常亮
window.setWindowKeepScreenOn(true) // 播放结束后不关闭
```

## 注意事项

- 亮度设置仅在当前应用内生效，退出应用后系统亮度自动恢复
- 确保页面路径(navDestination)的唯一性以正确匹配亮度
- SVG图标使用fillColor()可减少资源包大小和维护成本
- 状态栏适配需确保用户在不同模式下都能清晰看到系统信息
- 定期测试深色/浅色模式切换的流畅性

**总字数：798字**