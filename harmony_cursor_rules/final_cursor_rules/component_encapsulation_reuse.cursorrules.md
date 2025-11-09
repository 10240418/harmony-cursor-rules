# HarmonyOS 组件封装与复用 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- **最大化复用**：通过组件缓存池减少重复创建，提升性能
- **统一封装**：保持与系统组件一致的使用方式，降低学习成本
- **按需创建**：动态创建组件以优化加载速度和内存占用
- **状态隔离**：确保复用组件的数据更新不互相影响

## 推荐做法

### 代码结构
- 使用`@Reusable`装饰器标记可复用组件
- 通过`attributeModifier`扩展系统组件能力
- 创建组件工厂类统一管理组件实例

### 最佳实践
- 在`aboutToReuse()`中刷新组件数据，而非构造函数
- 使用`reuseId`精细化分组不同类型的复用组件
- 优先使用`@Link`/`@ObjectLink`而非`@Prop`传递复杂数据
- 利用`FrameNode`处理复杂动态布局场景

## 禁止做法

- 避免将函数直接作为复用组件的入参
- 不要在`aboutToReuse()`中重复赋值状态变量
- 避免通过重新渲染整个组件树操作局部组件
- 不要过度依赖声明式范式处理高频动态布局

## 代码示例

### 推荐写法
```arkts
@Reusable
@Component
struct ListItem {
  @Prop itemData: ItemModel;
  
  aboutToReuse(params: { itemData: ItemModel }) {
    this.itemData = params.itemData;
  }
  
  build() {
    Column() {
      Text(this.itemData.title)
    }
  }
}
```

### 避免写法
```arkts
// 错误：函数作为入参
@Reusable
@Component
struct BadItem {
  @State clickHandler: () => void; // 避免这样做
  
  build() {
    Button('Click').onClick(this.clickHandler)
  }
}
```

## 注意事项

- `aboutToReuse()`回调确保在组件从缓存取出时正确更新数据
- 合理设置`reuseId`以提升缓存命中率
- 监控内存使用，避免缓存池过大导致OOM
- 使用`NodeController`管理动态组件生命周期
- 复杂列表场景考虑预创建机制优化用户体验