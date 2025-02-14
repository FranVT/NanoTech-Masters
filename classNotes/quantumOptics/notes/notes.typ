// Class notes

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

align(center, text(17pt)[*Class Notes*])

= February 12  

== Hmk solution

The eigen values and eiggen values are $lambda={1,2,-1}$ with the following eigen vectors, $ket(1)=mat(1,0,0),quad ket(2)=mat(0,1,0), quad ket(3)=mat(0,0,1)$.

Now, for the matrix 
$
    mat(0,0,1;0,0,0;1,0,0)
$
the eigenvectors and values are,
$ket(1)=1/sqrt(2)mat(1;0;1), quad ket(2)=1/sqrt(2)mat(1;0;-1) quad ket(3)=mat(0;1;0)$

Now we have a state $beta$, $ket(beta)=1/sqrt(2)mat(1;0;1)$

In an observable all possible values are the eigenvalues.

So when we multiple two vectors together $braket(V_Q,beta)$

Now, when we measure $Q$ we get $-1$.

After the measure the state is $ket(-1)$ in $Q$. 
Sow now we can get $1$ or $-1$ from the eigen states of R.

== Hermitian conjugate and hermitian operator

The *hermitian conjugate* of and operator $hat(Q)$ is the operator $hat(Q)^dagger$ such that 
$
braket(f,hat(Q)g) = braket(hat(Q)^dagger f,g) forall f and g
$
An hermitian operator, then, is equal to its hermitian conjugate: $hat(Q)=hat(Q)^dagger$.

Every observable is represented with an hermitian operator.
A hamiltonina is an hermitian operator.

Observale are represented by hermitian operators.

Useful facts:
- Hermitian operator have *real* eigenvalues.
- Eigenfunction of an hermitian operator are orthogonal to each other. (They are a good basis)
- Hermitian conjugate on an operator in a matrix is the same as conjugate trnaspose.


== Harmonic oscilator

Near a minimum of any potential a good approximation is using a quadratic potential (harmonic oscilation).

$1\2 k x^2$

Normally in quantum we use the letter $omega$, where represent the resonance frequency.

$V=1/2 m omega^2 x^2$

Since we are dealing quantum mechanics,
$
hat(H) &= p^2\2m + 1\2 m omega^2 hat(x)^2 \
    &= -hbar^2/(2m)pdv(,x,2) \
    &= 1/(2m)(hat(p)^2 + (m omega x)^2)
$

So now we are going to factorize the squared terms.
To do that we are going to introduce an operator $hat(a) = 1/sqrt(2m hbar omega) (m omega hat(x) + i hat(p))$ and its hermitian conjugate, $hat(a)^dagger = 1/sqrt(2m hbar omega) (m omega hat(x) - i hat(p))$.

Now as an excersise we compute the multipication of the operators,
$
hat(a)^dagger hat(a) &= 1/(2m hbar omega) [(m omega x)^2 + hat(p)^2 + i m omega hat(x) hat(p) - im omega hat(p)hat(x)]
$

So, when we change the order of the operator, the signs changes.
$
hat(a)hat(a)^dagger  &= 1/(2m hbar omega) [(m omega x)^2 + hat(p)^2 - i m omega hat(x) hat(p) + im omega hat(p)hat(x)]
$


The commutator is important $[hat(x),hat(p)]=i hbar$.



So
$
a^dagger a &= 1/(1m hbar omega) [(m omega hat(x))^2+hat(p)^2+i m omega i hbar] \
&= 1/(1m hbar omega) [(m omega hat(x))^2+hat(p)^2+ m omega  hbar] \
$

Sow, we can we re-write the hamiltonian as,
$
H = hbar omega (hat(a)^dagger hat(a)+1/2) = hbar omega (hat(a)hat(a)^dagger-1/2)
$


Now we explore (how much the operator changes when the order is changed.)
$
[hat(a),hat(a)^dagger] &= hat(a)hat(a)^dagger - hat(a)^dagger hat(a) \
&= 1/(2m hbar omega) (m omega hat(x)^2 + hat(p)^2 + i m omega(hat(x)hat(p)-hat(p)hat(x))) - ...  
$

$[hat(a),hat(a)^dagger] = 1$


=== Now we solve the time independet

We are going to solve $hat(H)Psi=E Psi$

If $Psi$ is a solution, then $hat(a)Psi$ is a solution and the corresponding energy ($H(hat(a)Psi))=(E-hbar omega)(hat(a)Psi)$).
t is also true that $H(hat(a)Psi))=(E+hbar omega)(hat(a)^dagger Psi)$

Now we are going to proof:

We start that $psi$ is a solution,
$
hat(H)(hat(a)psi) &= hbar omega(hat(a)hat(a)^dagger-1/2)(hat(a)psi) \
&= hbar omega( hat(a)hat(a)^dagger hat(a)-1/2 hat(a))psi \
&= hat(a)( hbar omega (hat(a)^dagger hat(a) -1/2) )psi \
&= hat(a)(hat(H)-hbar omega)psi \
&= hat(a)( E -hbar omega)psi \
&= (E-hbar omega)hat(a)psi
$


We are going to compute a lot $hat(a)$ and $hat(a)^dagger$.

We know that the energy needs to be greater than zero.
Lets name a state $psi_o$ that when we apply $hat(a)$ to lower the energy at a minimum value.

$
hat(a)psi_o(x) &=0 \
(m omega hat(x)+i hat(p))psi_o(x) &=0 \
m omega x psi_o(x) + hbar pdv(,psi_o) &=0
$
and the solution of that is a gaussian.

We wnat to knwo the energy of that state,
$
hat(H)psi_o &= hbar omega/2 psi_o
$
which is $hbar omega/2$

The analytic solution can be not take into account.

We are going to deal with algebraic operators.

=== New operator 

Now we are going to define a new operator: $hat(n) = hat(a) + hat(a)^dagger$.
Which represent the exitations,
The hamiltonian can be re-writed as,
$
hat(H) = hbar omega (hat(n)+1\2).
$

=== Notation

It common to use the following notaiton: $ket(0)=psi_o$, $ket(1)=psi_1$.

The functions can be normilize,
$
hat(a)ket(n) = c_n ket(n-1)
$
The constant $c_n$ is to normalize the state.
$
braket(psi,psi) &= 1 \
expval(hat(a)^dagger hat(a),n) &= |c_n|^2 braket(n-1,n-1)=|c_n|^2 \
n braket(n,n) &= |c_n|^2 \
n &= |c_n|^2
$

Hence,
$
hat(a)ket(n) = sqrt(n) ket(n-1)
$

$hat(a)^dagger hat(a)$ is hermitian?

Monday from 11 after class.


=== Examples?

We start we the ground state,
$
hat(a)^dagger ket(0) &= ket(1) \
hat(a)^(dagger 2) ket(o) &= sqrt(2) ket(2) \
hat(a)^(dagger 3) ket(o) &= sqrt(2)sqrt(3) ket(2) \
ket(n) &= 1/(n!) hat(a)^(dagger N)hat(0)
$

=== Infinity independent oscilators
We can get all the oscilators with a bif state $ket((n_1,n_2))$

$[hat(a)_i,hat(a)_j]=0$ and $[hat(a)_1,hat(a)_j^dagger]=delta_12$

Problems 2.13 and 3.5 of the Griffiths.
Just the algebraic method.



