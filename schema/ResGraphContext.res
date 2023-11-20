module Request = {
  include Fetch.Request
  @get external cookieStore: t => option<CookieStore.t> = "cookieStore"
}

type context = {dataLoaders: DataLoaders.t, request: Request.t}
