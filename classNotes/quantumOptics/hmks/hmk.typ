// this file is for the first home work.

#import "@preview/quick-maths:0.2.0":shorthands
#import "@preview/physica:0.9.4": *
#import "@preview/equate:0.3.0": equate

#set page(
    paper :"us-letter",
    margin: 1.75in,
    numbering: "1",
    header: align(right)[Quantumm Optics Homeworks/exercises]
)

#set par(
        spacing: 0.55em,
        justify: true
    )
#set text(
    font: "New Computer Modern", 
    size: 11pt
)
#set heading(numbering: "1.")

/* Equate modification */
#show: equate.with(breakable: true, sub-numbering: true)
//#set math.equation(numbering: "(1.1)")

/*
Start of the document
*/

#align(center, text(17pt)[*Homeworks*])

= Homework for February 12

consider the following operators on a Hilbert space $bb(V)^3(C):$
$
    L_x = 1/2^(1/2)
    mat(
        0,1,0; 1,0,1; 0,1,0
    ),
    quad
    L_y = 1/2^(1/2)
    mat(
        0,-i,0; i,0,-i; 0,i,0
    ),
    quad
    L_z = 1/2^(1/2)
    mat(
        1,0,0; 0,0,0; 0,0,-1
    )
$

+ What are the possible values one can obtain if $L_z$ is measured?
+ Take the state in which $L_z=1$. In this state what are $expval(L_x)$, $expval(L_x^2)$, and $Delta L_x$?
+ Find the normalized eigenstates and the eigenvalues of $L_x$ in the $L_z$ basis.
+ If the particle is in the state with $L_z=-1$, and $L_x$ is measured, what are the possible outcomes and their probabilities?


==

Since the possible values from an operator are there eigenvalues, looking that the operator $L_z$ is diagonalized, the possible values at a measurement are $0,+1,-1$, hence,
$
    ket(L_z=1), quad ket(L_z=0), quad ket(L_z=-1).
$
Finally, tacking advantage that the operator is already diagonalized, there eigenvectors are, 
$
    ket(L_z=1) = mat(1;0;0), quad 
    ket(L_z=0) = mat(0;1;0), quad 
    ket(L_z=-1) = mat(0;0;1)
$

== 

Now to compute the expected values of $expval(L_x)$, $expval(L_x^2)$, and $Delta L_x$ when $ket(L_z=1)$ we do as follows,

$
expval(L_x) &= expval(L_x,L_z=1) \
    &= mat(1,0,0)1/sqrt(2)mat(0,1,0;1,0,1;0,1,0)mat(1;0;0) \
    &= 1/sqrt(2) mat(1,0,0)mat(0;1;0) \
    &= 0.
$

Now, to compute $expval(L_x^2)$,

$
expval(L_x^2) &= expval(L_x^2,L_z=1) \
    &= mat(1,0,0)1/2 mat(1,0,1;0,2,0;1,0,1)mat(1;0;0) \
    &= 1/2 mat(1,0,0)mat(1;0;1) \
    &= 1/2.
$

Finally, the previous results help us to compute $Delta L_x$ as follows,
$
Delta L_x   &=sqrt(expval(L_x^2)-expval(L_x)^2) \
            &=sqrt((1/2)^2-0^2) \
            &=sqrt((1/2)^2) \
            &= 1/sqrt(2)
$

==

To get the normalized eigenstates and the eigenvalues of $L_x$ in the $L_z$ basis.
For the eigenvalues we are going to use the determinant method,
$
mdet(-lambda,1/sqrt(2),0;1/sqrt(2),-lambda,1/sqrt(2);0,1/sqrt(2),-lambda)
    &=  -lambda^3 
        -(-lambda dot 1/sqrt(2) dot 1/sqrt(2))
        +(1/sqrt(2) dot 1/sqrt(2) dot 0)
        -(1/sqrt(2) dot 1/sqrt(2) dot -lambda)
        +(0 dot 1/sqrt(2) dot 1/sqrt(2))
        -(0 dot -lambda dot  0)
    \
    &=  -lambda^3 
        -(-lambda 1/2 )
        +(0)
        -(1/2 dot -lambda)
        +(0)
        -(0)
    \
    &=  -lambda^3 
        -(-lambda 1/2 )
        -(1/2 dot -lambda)
    \
    &=  -lambda^3 
        +lambda/2 
        +lambda/2
    \
    &=  -lambda^3 
        +lambda
$
therefore, to get the eigenvalues we need to find the roots of $-lambda^3+lambda = 0$ wich are $lambda={0,+1,-1}$.
Once we know the eigenvalues, we start to compute the eigenvectors with the follwoing property,
$
(L_x-lambda I)ket(L_x=lambda)=0,
$
where we define $ket(L_x=lambda)$ as,
$
ket(L_x=lambda)=mat(a;b;c),
$
therefore,
$
(L_x-lambda I)ket(L_x=lambda) &= (mat(0,1/sqrt(2),0; 1/sqrt(2),0,1/sqrt(2); 0,1/sqrt(2),0) - mat(lambda,0,0;0,lambda,0;0,0,lambda)) mat(a;b;c) \
    &= mat(-lambda,1/sqrt(2),0;1/sqrt(2),-lambda,1/sqrt(2);0,1/sqrt(2),-lambda) mat(a;b;c) \
    &= mat(
        -lambda dot a + 1/sqrt(2) dot b + 0;
        1/sqrt(2) dot a -lambda dot b + 1/sqrt(2) dot c;
        0 dot a + 1/sqrt(2) dot b -lambda dot c
    ) \
    &= mat(
        -a lambda  + b/sqrt(2) ;
        a/sqrt(2)  -b lambda + c/sqrt(2) ;
        b/sqrt(2) -c lambda, 
    ) \
$
and we equate it to $ket(0)$,
$
(L_x-lambda I)ket(L_x=lambda) &=ket(0) \
mat(
        -a lambda  + b/sqrt(2) ;
        a/sqrt(2)  -b lambda + c/sqrt(2) ;
        b/sqrt(2) -c lambda, 
    )
    =
mat(0;0;0).
$

Now we need to solve that system of equations for each eigenvalue.

(Later I will add the procedure)

$
ket(L_x=1) &= 1/2 mat(1;sqrt(2);1), quad
ket(L_x=0) &= 1/sqrt(2) mat(1;0;-1), quad
ket(L_x=-1) &= 1/2 mat(1;-sqrt(2);1)
$

== 

Finally, to measure the operator $L_x$ when $L_z=-1$



https://physicsisbeautiful.com/resources/principles-of-quantum-mechanics/problems/4.2.1/solutions/shankar20exercises2004.02.01.pdf/9tVFTcE7Xy4WdP74UD8m2S/
