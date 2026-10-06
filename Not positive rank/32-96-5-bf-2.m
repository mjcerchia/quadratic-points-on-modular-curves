/****************************************************************************** 
Here is a summary of the argument.

Let C be the modular curve with lmfdb label 32.96.5.bf.2.
We compute the automorphism group over Q and find there are three genus one quotients by an involution. Mod 7, the first and third have 8 and 4 points,
respectively, while the single rank one newform -- call it E -- has 12 points. 
This leaves us with the second curve. We construct a new model of this quotient curve using Riemann-Roch and find that it 
fails local solubility. 
NOT bielliptic. 
******************************************************************************/
P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[-x*t + y^2, x*t + y^2 + z*w, 16*x^2 + 4*z^2 + w^2 + 2*t^2]);
/*****************************Optional code to verify that model taken from LMFDB matches with that obtained from Zywina's code

for tuple in data211 do;
          if tuple[1] eq "32.96.5.bf.2" then
                      level:=Split(tuple[1],".")[1];
                      level:=StringToInteger(level);
                      GL2:=GL(2,Integers(level));
                      G:=sub<GL2|tuple[4]>;
                      Gt:=sub<GL2|[Transpose(GL2!g):g in Generators(G)]>;
                      IsConjugate(GL2,G,Gt);//false
                      X:=CreateModularCurveRec(Gt);
                      XG:=FindModelOfXG(X);
                      D := Curve(ProjectiveSpace(Rationals(), Rank(Parent((XG`psi)[1]))-1),XG`psi);
           end if;
end for;

P<x,y,z,w,t>:=ProjectiveSpace(Rationals(),4);
C := Curve(P,[-x*t + y^2, x*t + y^2 + z*w, 16*x^2 + 4*z^2 + w^2 + 2*t^2]);


assert IsIsomorphic(C,D);

******************************************************************/
S := AutomorphismGroup(C); 

auts := [];
Stemp := Automorphisms(C);
for s in Stemp do
auts := Append(auts, S!s);
end for;
assert #auts eq #S;


//There are three genus one quotients by an involution
l := []; //list of genus 1 quotients by involutions
m:= []; //in case Magma complains that genus 1 curves and elliptic curves can't be in the same list.
for g in auts do
if Order(g) eq 2 then
AG := AutomorphismGroup(C,[g]);
CG,prj := CurveQuotient(AG);
if Genus(CG) eq 1 then
try
l := Append(l,CG);
catch e
m := Append(m,CG);
end try;
end if;

end if;

end for;

#l;


#EllipticCurve(Curve(Reduction(l[1],7))); //8
#EllipticCurve(Curve(Reduction(l[3],7))); //4

Qx<x> := PolynomialRing(Rationals());
E := EllipticCurve(x^3+x^2+x+1);
#EllipticCurve(Curve(Reduction(E,7))); //12

C1 := l[2];

//Search for degree 2 divisors on C1
P<[X]> := AmbientSpace(C1);
deg := 2;
tups := {};
d := Dimension(P);
ideals := {@@};
tupsOld := tups;
coeffs := [ 0, 1 ];
    tups   :=
        [ P![ tup[i] : i in [1..#tup] ] :
          tup in CartesianPower(coeffs, d+1) |
          not tup eq < 0 : i in [1..d+1] >  
          and not P![tup[i] : i in [1..#tup]] in tupsOld
        ];
    for c in tups  do  
            L := Scheme(P,&+[c[i]*X[i] : i in [1..Dimension(AmbientSpace(C1)) + 1]]);
              irr := IrreducibleComponents(L meet C1);
              degs := [Degree(ReducedSubscheme(i)) : i in irr];
              if  deg in degs then
        for cpt in irr do  
         if  Degree(ReducedSubscheme(cpt)) eq deg
             and not Basis(Ideal(ReducedSubscheme(cpt))) in ideals then      
               ideals := ideals join {@Basis(Ideal(ReducedSubscheme(cpt)))@}; 
        end if;
    end for;
    end if;
    end for;
    

//build a new model
gens := ideals[1];
P7 := AmbientSpace(C1);
R  := CoordinateRing(P7);
I := ideal< R | gens >;
Pl := Place(C1, I);
D  := Divisor(Pl);
a,b := RiemannRochSpace(D);
x1 := b(a.1); 
x2 := b(a.2); 
a,b := RiemannRochSpace(2*D);
y := b(a.1);
F := BaseField(C1);
P := PolynomialRing( F, [2,1,1], "grevlexw", [2,1,1] );
vars := ["yv","x1v", "x2v"]; //(calling them yv and xv so magma doesn't confuse the functions with x and y)
P := ProjectiveSpace(P);
AssignNames(~P, vars);
phi := map<C1 -> P | [y,x1,x2]>;
C2:=Image(phi);


/*
Curve over Rational Field defined by
yv^2 + 32*x1v^4 + 8*x1v^2*x2v^2 + x2v^4
*/

//We complete the square to get the model:
P<x> := PolynomialRing(Rationals());
 f := -(32*x^4+8*x^2+1);
 
H := HyperellipticCurve(f);
assert not HasPointsEverywhereLocally(f,2);


    
