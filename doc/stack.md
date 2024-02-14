Stacking converts lengths into contiguous position intervals. For example, a bar chart of monthly sales might be broken down into a multi-series bar chart by category, stacking bars vertically and applying a categorical color encoding. Stacked charts can show overall value and per-category value simultaneously; however, it is typically harder to compare across categories as only the bottom layer of the stack is aligned. So, chose the [stack order](https://pub.dev/documentation/d4_shape/latest/d4_shape/Stack/order.html) carefully, and consider a [streamgraph](https://pub.dev/documentation/d4_shape/latest/d4_shape/stackOffsetWiggle.html). (See also [grouped charts](https://observablehq.com/@d3/grouped-bar-chart/2?intent=fork).)

Like the [pie generator](https://pub.dev/documentation/d4_shape/latest/topics/Pies-topic.html), the stack generator does not produce a shape directly. Instead it computes positions which you can then pass to an [area generator](https://pub.dev/documentation/d4_shape/latest/topics/Areas-topic.html) or use directly, say to position bars.