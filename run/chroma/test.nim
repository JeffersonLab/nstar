
type
  Fred = object
    hello:  string
    there:  int
    again:  float


proc sample(fred: Fred) =
  ## do something with it
  echo $fred


# Do somethin
#let person = 
sample(Fred(hello: "what", there: 0, again: 0.1))
