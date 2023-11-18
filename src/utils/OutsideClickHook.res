module Element = {
  @send external contains: (Dom.element, 'a) => bool = "contains"
}
/**
 * Hook that alerts clicks outside of the passed ref
 */
let use = (ref: React.ref<Nullable.t<Dom.element>>) => {
  let (isOutside, setIsOutside) = React.useState(_ => false)

  React.useEffect1(() => {
    /**
     * Alert if clicked on outside of element
     */
    let handleClickOutside = event => {
      let target = event->ReactEvent.Mouse.target

      switch ref.current->Nullable.toOption {
      | Some(current) if current->Element.contains(target) => setIsOutside(_ => false)
      | _ =>
        setIsOutside(_ => true)
        setTimeout(() => setIsOutside(_ => false), 0)->ignore
      }
    }

    // Bind the event listener
    document->Document.addEventListener(Click, handleClickOutside)

    Some(
      () => {
        // Unbind the event listener on clean up
        document->Document.removeEventListener(Click, handleClickOutside)
      },
    )
  }, [ref])

  isOutside
}
