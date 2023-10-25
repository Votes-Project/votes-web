type config<'a> = {
  allowedAttributes: 'a,
  allowedTags: array<string>,
}
@module("sanitize-html") external make: (string, config<'a>) => string = "default"
