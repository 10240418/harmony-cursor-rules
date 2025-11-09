# HarmonyOS 声明式语法 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- 状态变量改变驱动UI刷新，避免非必要状态装饰器使用  
- 组件状态管理遵循单向数据流，确保可预测性  
- 优先使用工具定位性能问题，如hidumper和Code Linter  

## 推荐做法

### 代码结构
- 使用@State、@Prop、@Link等装饰器时，确保变量直接影响UI渲染  
- 多组件共享状态时，采用StateStore实现解耦管理  
- 业务数据模型必须用@Observed或@ObservedV2修饰以支持UI观测  

### 最佳实践
- 状态更新逻辑集中在Reducer函数中，避免在build方法中执行副作用  
- 父子组件数据共享优先考虑@Prop（单向）而非@Link（双向）  
- 定期使用Code Linter检查@performance/hp-arkui-remove-redundant-state-var规则  

### 性能优化
- 减少状态变量数量，仅对需触发UI刷新的变量使用装饰器  
- 避免在build方法或其直接调用函数中修改非状态变量  
- 使用hidumper分析状态变量变化和UI刷新范围  

## 禁止做法

- 在build方法中执行副作用操作或修改非状态变量  
- 将未关联UI组件的变量定义为状态变量  
- 将仅读取未修改的变量定义为状态变量  

## 代码示例

### 推荐写法
```arkts
@Entry
@Component
struct MyComponent {
  @State count: number = 0
  @State isVisible: boolean = true

  build() {
    Column() {
      Button(`Count: ${this.count}`)
        .onClick(() => {
          this.count++ // 明确的用户交互触发状态更新
        })
      Text('Visible content')
        .visibility(this.isVisible ? Visibility.Visible : Visibility.Hidden)
    }
  }
}
```

### 避免写法
```arkts
@Entry
@Component
struct BadComponent {
  @State unusedState: string = 'unused' // 未关联UI的状态变量
  @State readonlyData: number = 100     // 仅读取未修改的状态变量

  build() {
    // 在build中执行副作用
    const temp = this.readonlyData + 1 // 修改非状态变量
    Column() {
      Text('Simple text') // unusedState和readonlyData均未被使用
    }
  }
}
```

## 注意事项

- 状态管理遵循MVVM模式，UI是状态的函数，避免状态与UI逻辑耦合  
- 使用StateStore时，UI通过dispatch Action更新状态，而非直接修改  
- 开发调试阶段启用Code Linter性能检查，及时发现冗余状态变量  
- 生产环境使用hidumper监控实际运行时的刷新行为和性能瓶颈