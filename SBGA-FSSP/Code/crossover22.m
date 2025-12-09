function  cpop=crossover22(cpop,pop,ncross,npop,data,w)

for i=1:npop
f(i)=[pop(i).value(3)];
end
f=1./f;
f=f./sum(f);
f=cumsum(f);
nvar=size(pop(1).position,2);
for k=1:2:ncross
    
    i1=find(rand<=f,1,'first');
    i2=find(rand<=f,1,'first');
    
    
pc1=pop(i1).position;
pc2=pop(i2).position;
%w1=ww(i1);
%w2=ww(i2);

j=randi([1 nvar-1]);

o1=[pc1(:,1:j) pc2(:,j+1:end)];
o2=[pc2(:,1:j) pc1(:,j+1:end)];

x11=o1(1,1:j);
x12=o1(1,j+1:end);
    
x21=o2(1,1:j);
x22=o2(1,j+1:end);
    
r1=intersect(x12,x11);
r2=intersect(x22,x21);

x12(ismember(x12,r1))=r2;
x22(ismember(x22,r2))=r1;

o1(1,:)=[x11 x12];
o2(1,:)=[x21 x22];

%w=(w1+w2)/2;

cpop(k).position=o1;
[a1,a2,a3]=fitness(cpop(k).position,data,w);
cpop(k).value=[a1,a2,a3];

cpop(k+1).position=o2;
[b1,b2,b3]=fitness(cpop(k+1).position,data,w);
cpop(k+1).value=[b1,b2,b3];
end

end
