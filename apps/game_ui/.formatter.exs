[
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"]
  line_length: 120,
  locals_without_parens: [
    # Phoenix

    ## router
    plug: :*,
    pipeline: :*,
    scope: :*,
    resources: :*,
    get: :*,
    post: :*,
    delete: :*,
    pipe_through: :*,
    forward: :*,
    match: :*,
    live: :*,

    ## channel
    channel: :*,
    socket: :*
  ]
]
