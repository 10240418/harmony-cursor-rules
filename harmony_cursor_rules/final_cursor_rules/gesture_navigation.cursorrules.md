# HarmonyOS 手势与导航 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- 手势事件默认冒泡，需主动控制响应链
- 导航结构清晰，避免复杂嵌套导致冲突
- 页面跳转参数化，支持返回结果传递

## 推荐做法

### 代码结构
- 使用`TabsController`统一管理页签状态
- 通过`@HMRouter`注解注册页面路由
- 采用`Stack`布局实现底部导航栏

### 最佳实践
- **手势冲突处理**：优先使用`hitTestBehavior`控制触摸测试，其次用`stopPropagation()`阻止冒泡
- **底部导航**：设置`barPosition: BarPosition.End`，`barMode: Fixed`，合理分配页签宽度
- **页面跳转**：通过`HMRouterMgr.push()`传递参数，使用`onResult`回调接收返回数据

## 禁止做法

- 避免在复杂嵌套组件中同时绑定多种手势
- 不要滥用`HitTestMode.Block`导致事件完全阻断
- 禁止在路由参数中传递敏感数据

## 代码示例

### 推荐写法
```arkts
// 底部导航
Tabs({ barPosition: BarPosition.End, barMode: Fixed }) {
  this.tabContentBuilder("消息", 0, $r('app.media.activeMessage'), $r('app.media.message'))
}.backgroundColor('#FFFFFF')

// 手势冲突控制
Stack() {
  ChildComponent()
}.hitTestBehavior(HitTestMode.Transparent)

// 页面跳转
@HMRouter({ pageUrl: '/pages/Detail' })
@Component
struct DetailPage {
  aboutToAppear() {
    const params = HMRouterMgr.getCurrentParam()
  }
}
```

### 避免写法
```arkts
// 错误：多个组件同时响应同一手势
Stack() {
  SwipeGesture().onAction(() => {})
  ChildComponent().SwipeGesture().onAction(() => {})
}

// 错误：过度使用事件阻断
Component().hitTestBehavior(HitTestMode.Block).onClick(() => {})
```

## 注意事项

- `hitTestBehavior`需结合组件树结构谨慎使用
- 导航栏页签数量建议控制在3-5个，避免拥挤
- 路由参数大小限制20KB，大文件使用全局状态管理
- 使用`onAnimationStart`回调优化切换动画体验
- 定期测试手势响应在不同屏幕尺寸下的表现