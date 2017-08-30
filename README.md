# haskell-playground

`stack` is the dependecy management for haskell, kinda like `npm`

To run project in atom:
`stack exec atom`

To run project in `ghci`:
`stack ghci`

To install a new package:
- Add package to the `build-depends` key under your `library`
- Run `stack build`

To view project dependencies:
`stack list-dependencies`

To view stacks paths:
`stack path`
