# HarmonyOS 布局与弹窗 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- 优先使用系统组件，减少自定义实现
- 确保交互流畅，避免布局重计算
- 合理管理弹窗生命周期，避免内存泄漏
- 适配多设备形态，特别是折叠屏场景

## 推荐做法

### 代码结构
- 使用LazyForEach替代ForEach处理长列表
- 为Grid组件设置editMode和supportAnimation实现拖拽
- 通过Navigation Dialog实现评论回复弹窗

### 最佳实践
- 图片预览器使用matrix4和translate实现跟手效果
- 瀑布流采用虚拟列表优化性能
- 文本展开折叠使用measureTextSize精确计算
- 布局优化：减少组件嵌套，设置固定宽高创建布局边界

### 性能优化
- 使用if/else而非visibility控制组件显示
- 为List组件设置固定宽高，特别是在Scroll嵌套场景
- 关闭Swiper自带指示器，自定义进度条

## 禁止做法

- 避免CustomDialog用于评论回复，因其软键盘适配问题
- 不要过度嵌套布局组件增加计算开销
- 禁止在富文本中随意截断，需考虑图片等元素影响
- 避免弹窗与页面生命周期不同步导致的内存泄漏

## 代码示例

### 推荐写法
```arkts
// 图片预览器跟手效果
Swiper(this.controller) {
  Image($r(`app.media.${item.id}`))
}.matrix4($r('app.matrix.scale'))
  .translate({ x: $r('app.offset.x'), y: $r('app.offset.y') })

// 长列表懒加载
List() {
  LazyForEach(this.data, (item: ItemData) => {
    ListItem() {
      Text(item.content)
    }
  })
}
```

### 避免写法
```arkts
// 过度嵌套的布局结构
Stack() {
  Column() {
    Row() {
      Text('content')
    }
  }
}

// 频繁的布局计算
ForEach(this.data, (item) => Column() { Text(item) })
```

## 注意事项

- 图片预览器手势冲突需合理处理PanGesture与Swiper事件
- 瀑布流数据加载需防抖处理避免重复请求
- 弹窗焦点管理需考虑软键盘避让
- 使用measureTextSize时确保参数完整准确
- 折叠屏适配需监听设备状态变化并动态调整布局

（总字数：798）