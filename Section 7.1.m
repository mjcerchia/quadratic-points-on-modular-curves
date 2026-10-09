//16.96.3.fj.1

P<x,y,z>:=ProjectiveSpace(Rationals(),2);
C:=Curve(P,[x^4 + 4*x^2*z^2 + 2*y^4 + 2*z^4]);

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
assert #l eq 3; 

//16.96.3.fc.1
P<x,y,z>:=ProjectiveSpace(Rationals(),2);
C:=Curve(P,[x^4 + 4*x^2*y^2 + 2*y^4 + 2*z^4]);

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
assert #l eq 3; 


//16.96.3.bo.1

level := 16;
// Elements that, together with Gamma(level), generate the group
gens := [[3, 14, 6, 5], [7, 0, 8, 15], [13, 4, 0, 13], [13, 9, 10, 3]];

GL2:=GL(2,Integers(level));
SL2:=SL(2,Integers(level));

G:=sub<GL2|gens>;
H:=G meet SL2;
assert #quo<Normalizer(SL2,H)|H> eq 32;
assert #quo<Normalizer(GL2,G)|G> eq 8;

//16.96.3.bf.1

level := 16;
// Elements that, together with Gamma(level), generate the group
gens := [[1, 11, 10, 11], [3, 1, 14, 1], [13, 7, 8, 11], [13, 12, 2, 7]];

GL2:=GL(2,Integers(level));
SL2:=SL(2,Integers(level));

G:=sub<GL2|gens>;
H:=G meet SL2;
assert #quo<Normalizer(SL2,H)|H> eq 32;
assert #quo<Normalizer(GL2,G)|G> eq 8;

//16.96.3.dm.1

level := 16;
// Elements that, together with Gamma(level), generate the group
gens := [[3, 5, 10, 5], [5, 8, 10, 3], [7, 8, 6, 1], [7, 12, 8, 15]];
GL2:=GL(2,Integers(level));
SL2:=SL(2,Integers(level));

G:=sub<GL2|gens>;
H:=G meet SL2;
assert #quo<Normalizer(SL2,H)|H> eq 32;
assert #quo<Normalizer(GL2,G)|G> eq 8;

//16.96.3.cz.1

level := 16;
// Elements that, together with Gamma(level), generate the group
gens := [[3, 3, 2, 9], [9, 8, 14, 15], [13, 12, 8, 5], [15, 15, 8, 13]];
GL2:=GL(2,Integers(level));
SL2:=SL(2,Integers(level));

G:=sub<GL2|gens>;
H:=G meet SL2;
assert #quo<Normalizer(SL2,H)|H> eq 32;
assert #quo<Normalizer(GL2,G)|G> eq 8;
load "LMFDB Data/Genus 1 data_LMFDB.m";
load "LMFDB Data/LMFDB data on genus 2-11.m";
data211 := data;

Genus1LMFDBSubgroup := recformat<label:MonStgElt, gens:SeqEnum, H:GrpMat>;
Genus1LMFDBlist:=AssociativeArray();

for r in data1 do
    Genus1LMFDBlist[r[1]]:= rec<Genus1LMFDBSubgroup  | label:=r[1], gens:=r[3]>;
end for;

g9:=[<"16.192.9.ba.1","8.96.1.b.2">,<"16.192.9.ba.2","8.96.1.b.2">,<"16.192.9.ba.3","8.96.1.b.1">,
<"16.192.9.ba.4","8.96.1.b.1">,<"16.192.9.bc.1","8.96.1.c.2">,
<"16.192.9.bc.2","8.96.1.c.1">,<"16.192.9.bf.1","8.96.1.d.1">,
<"16.192.9.bf.2","8.96.1.d.1">,<"16.192.9.bq.1","8.96.1.g.2">,
<"16.192.9.bq.2","8.96.1.g.2">,<"16.192.9.bq.3","8.96.1.g.1">,
<"16.192.9.bq.4","8.96.1.g.1">,<"16.192.9.bw.1","8.96.1.h.2">,
<"16.192.9.bw.2","8.96.1.h.1">,<"16.192.9.ck.1","16.96.1.k.1">,
<"16.192.9.dg.1","16.96.1.k.1">,<"16.192.9.ei.1","8.96.1.m.1">, 
<"16.192.9.ei.2","8.96.1.m.1">,<"16.192.9.ey.1","16.96.1.t.1">, 
<"16.192.9.fc.1","16.96.1.t.1">,<"32.192.9.bh.1","16.96.1.m.2">,
<"32.192.9.bh.2","16.96.1.m.2">,<"32.192.9.bh.3","16.96.1.m.1">,
<"32.192.9.bh.4","16.96.1.m.1">,<"32.192.9.bo.1","16.96.1.o.2">, 
<"32.192.9.bo.2","16.96.1.o.2">,<"32.192.9.bo.3","16.96.1.o.1">,
<"32.192.9.bo.4","16.96.1.o.1">,<"32.192.9.br.1","16.96.1.r.2">, 
<"32.192.9.br.2","16.96.1.r.1">,<"32.192.9.bs.1","16.96.1.s.2">, 
<"32.192.9.bs.2","16.96.1.s.1">,<"32.192.9.i.1","16.96.1.b.2">,
<"32.192.9.i.2","16.96.1.b.1">,<"32.192.9.i.3","16.96.1.b.2">, 
<"32.192.9.i.4","16.96.1.b.1">,<"32.192.9.l.1","16.96.1.d.2">, 
<"32.192.9.l.2","16.96.1.d.2">,<"32.192.9.l.3","16.96.1.d.1">,
<"32.192.9.l.4","16.96.1.d.1">,<"32.192.9.o.1","16.96.1.f.2">, 
<"32.192.9.o.2","16.96.1.f.2">,<"32.192.9.o.3","16.96.1.f.1">, 
<"32.192.9.o.4","16.96.1.f.1">,<"32.192.9.t.1","16.96.1.i.2">, 
<"32.192.9.t.2","16.96.1.i.1">,<"32.192.9.u.1","16.96.1.j.2">,
<"32.192.9.u.2","16.96.1.j.1">,<"64.192.9.q.1","32.96.1.a.1">, 
<"64.192.9.q.2","32.96.1.a.1">,<"64.192.9.q.3","32.96.1.a.2">, 
<"64.192.9.q.4","32.96.1.a.2">,<"64.192.9.r.1","32.96.1.d.1">, 
<"64.192.9.r.2","32.96.1.d.1">,<"64.192.9.r.3","32.96.1.d.2">, 
<"64.192.9.r.4","32.96.1.d.2">,<"64.192.9.s.1","32.96.1.f.1">, 
<"64.192.9.s.2","32.96.1.f.1">,<"64.192.9.s.3","32.96.1.f.2">,
<"64.192.9.s.4","32.96.1.f.2">,<"64.192.9.t.1","32.96.1.g.1">,
<"64.192.9.t.2","32.96.1.g.1">,<"64.192.9.t.3","32.96.1.g.2">, <"64.192.9.t.4","32.96.1.g.2">];

/* verifying that first entry in g9 is an index 2 subgroup of second entry*/

for tuple in g9 do;

level1:=StringToInteger(Split(tuple[1],".")[1]);
GL21:=GL(2,Integers(level1));
for x in data211 do;
if x[1] eq tuple[1] then
G1:=sub<GL21|x[4]>;
end if;
end for;

level2:=StringToInteger(Split(tuple[2],".")[1]);
GL22:=GL(2,Integers(level2));
G2:=sub<GL22|Genus1LMFDBlist[tuple[2]]`gens>;

pi:=hom<GL21->GL22|[GL22!GL21.i:i in [1..#Generators(GL21)]]>;
G2red:=G2@@pi;
m:=Integers()!(Order(G2red)/2);
bool:=[];
        for H in Subgroups(G2red:OrderEqual:=m) do;
        
        b,_:=IsConjugate(GL21,H`subgroup,G1);
        bool:=bool cat [b];
        
        end for;
assert true in bool;

end for;

//verifying that Jacobian of second tuple is an elliptic curve of rank 0

for tuple in g9 do;

level2:=StringToInteger(Split(tuple[2],".")[1]);
GL22:=GL(2,Integers(level2));
G2:=sub<GL22|Genus1LMFDBlist[tuple[2]]`gens>;
G2t:=sub<GL22|[Transpose(GL22!g):g in Generators(G2)]>;
X:=CreateModularCurveRec(G2t);
XG:=FindModelOfXG(X);
D := Curve(ProjectiveSpace(Rationals(), Rank(Parent((XG`psi)[1]))-1),XG`psi);

E:=Jacobian(D);
assert Rank(E) eq 0;

end for;



