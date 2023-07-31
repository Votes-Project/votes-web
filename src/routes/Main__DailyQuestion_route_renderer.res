module DailyQuestion = %relay.deferredComponent(DailyQuestion.make)

let renderer = Routes.Main.DailyQuestion.Route.makeRenderer(
  ~prepareCode=_ => [DailyQuestion.preload()],
  // prepare let's your preload your data. It's fed a bunch of things (more on that later). In the example below, we're using the Relay environment, as well as the slug, that's a path parameter defined in the route definition, like `/campaigns/:slug`.
  ~prepare=_ => (),
  // HINT: This returns a single query ref, but remember you can return _anything_ from here - objects, arrays, tuples, whatever. A hot tip is to return an object that doesn't require a type definition, to leverage type inference.

  // Render receives all the config `prepare` receives, and whatever `prepare` returns itself. It also receives `childRoutes`, which is any rendered route nested inside of it. So, if the route definition of this route has `children` and they match, the rendered output is in `childRoutes`. Each route with children is responsible for rendering its children. This makes layouting easy.

  ~render=_ => {
    <DailyQuestion />
  },
)
