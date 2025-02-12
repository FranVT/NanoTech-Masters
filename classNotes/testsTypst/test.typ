#import "@preview/quick-maths:0.2.0":shorthands
#import "@preview/physica:0.9.4": *
#import "@preview/equate:0.3.0": equate

#set page(
    paper :"us-letter",
    numbering: "1",
    header: align(center)[*This is the header*]
)

#set par(justify: true)
#set text(
    font: "New Computer Modern", 
    size: 11pt
)
#set heading(numbering: "1.")

/* Equate modification */
#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")

= First document of Typst stuff

This are words that are creating a sentence that hopefully are going to turn into a paragraph.
As 

+ Some points
+ More points
    - Sub-points
    - More points
+ Don't know what I'm doing

Now here are some maths: $Q= rho a v + C$.
Now a vector $arrow(v) := vec(x_1, x_2, x_3)$.


