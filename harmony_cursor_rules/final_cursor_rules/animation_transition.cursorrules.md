# HarmonyOS 动画与转场 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- 优先使用系统原生动画API，确保性能和稳定性
- 动画设计需符合用户心理预期和真实物理运动规律
- 转场动画要保持视觉连续性，避免突兀切换
- 合理控制动画时长，避免过度动效影响用户体验

## 推荐做法

### 代码结构
- 使用状态变量控制动画触发，避免硬编码动画逻辑
- 将动画参数（时长、曲线）抽离为可配置常量
- 采用声明式UI组件（如`animateTo`、`SharedTransition`）实现动效

### 最佳实践
- **共享元素转场**：使用`geometryTransition`接口实现图片、图标等元素的平滑过渡
- **容器转场**：通过`Navigation`自定义动画处理卡片、列表等容器的形变
- **层级转场**：列表展开用左右位移动效，单体卡片用一镜到底动效
- **搜索转场**：固定搜索区用淡入淡出，非固定区用共享元素转场

### 性能优化
- 优先使用`transform`和`opacity`属性动画，避免布局属性变化
- 复用相同参数的`animateTo`动画，减少对象创建开销
- 使用`renderGroup(true)`优化复杂组件的渲染性能
- 及时释放动画资源，防止内存泄漏

## 禁止做法

- 频繁修改`width`、`height`等布局属性实现动画
- 滥用复杂动效，影响页面响应速度
- 忽略动效的无障碍访问性设计
- 在动画中使用高耗性能的复杂计算

## 代码示例

### 推荐写法
```arkts
@State isExpanded: boolean = false;

build() {
  Column() {
    Image($r('app.media.icon'))
      .width(this.isExpanded ? 200 : 100)
      .animateTo({
        duration: 300,
        curve: SpringCurve()
      })
  }
  .onClick(() => {
    this.isExpanded = !this.isExpanded;
  })
}
```

### 避免写法
```arkts
// 错误：频繁修改布局属性
Column() {
  Text('Content')
    .width(this.isExpanded ? '100%' : '50%') // 触发重新布局
    .height(this.isExpanded ? 200 : 100)    // 性能较差
}
```

## 注意事项

- 动画时长建议控制在150-300ms之间，过长会降低响应感
- 使用弹簧曲线（SpringCurve）可提供更自然的动画效果
- 转场前后保持元素ID一致，便于`geometryTransition`匹配
- 开发过程中使用DevEco Studio的动画预览功能进行调试
- 关注动效的无障碍适配，确保视障用户也能感知状态变化

---

**总字数：约750字**  
**整合说明**：本规则集整合了三个核心文档的关键实践，聚焦于动画性能、用户体验和开发效率，提供可直接应用的开发指导。