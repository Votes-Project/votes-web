module ImageResponse = {
  type t
  type options = {width: string, height: string}
  @module("@vercel/og") @new
  external make: (React.element, options) => t = "ImageResponse"
}
type config = {runtime: string}

let config = {runtime: "edge"}

let default = async () => {
  ImageResponse.make(
    <div
      style={{
        fontSize: "40",
        color: "black",
        background: "white",
        width: "100%",
        height: "100%",
        padding: "50px 200px",
        textAlign: "center",
        justifyContent: "center",
        alignItems: "center",
      }}>
      {"👋 Hello"->React.string}
    </div>,
    {
      width: "1200",
      height: "630",
    },
  )
}
