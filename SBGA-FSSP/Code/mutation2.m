function  mpop=mutation2(mpop,pop,nmut,nspop,data,w)

nvar=size(pop(1).position,2);

for n=1:nmut
    
i=randi([1 nspop]);  

pm=pop(i).position;
%w=ww(i);

j1=randi([1 nvar-1]);
j2=randi([j1+1 nvar]);

nj1=pm(:,j1);
nj2=pm(:,j2);

pm(:,j1)=nj2;
pm(:,j2)=nj1;

mpop(n).position=pm;
[c1,c2,c3]=fitness(mpop(n).position,data,w);
mpop(n).value=[c1,c2,c3];

end

end