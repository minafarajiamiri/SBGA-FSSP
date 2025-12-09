clear
close all
clc
tic
%% problem definition
data=load('data.mat');
m=data.m; 
n=data.n; 
%% parameters setting
npop=100;
ns=10; %number of sub-population
nspop=npop/ns; %number of  individuals in each sub-population
pc=0.7;   
pm=0.5; 
maxiter1=50; 
maxiter2=80; 
%% initial population
randsol.position=[];
randsol.value=[];
pop=repmat(randsol,npop,1);
w1=0.5;
for i=1:npop
    x=zeros(m+1,n);
    x(1,:)=randperm(n);
    for j=2:m+1
    x(j,:)=randi([1,3],1,n);
    end
    pop(i).position=x;
    [y1,y2,y3]=fitness(pop(i).position,data,w1);
    pop(i).value=[y1,y2,y3];
end
%% divide to sub-population
spop=repmat(randsol,nspop,1);
sprand.w=[];
sprand.pop=[];
sprand.nums=[];
s=repmat(sprand,ns,1);
for k=1:ns
    if k==1
        spop=pop(k:nspop);
    else
        spop=pop((k-1)*nspop+1:k*nspop);
    end
    s(k).w=k/(ns+1);
    s(k).pop=spop;
    for d=1:nspop
    [z1,z2,z3]=fitness(s(k).pop(d).position,data,s(k).w);
    s(k).pop(d).value=[z1,z2,z3];
    end
    s(k).nums=k;
end
%% first phase loop
fs=repmat(sprand,ns,1);
nc1=2*round((nspop*pc)/2); 
nm1=round(nspop*pm);
for f=1:ns
    for iter1=1:maxiter1
   %crossover
   cspop=repmat(randsol,nc1,1);
   cspop=crossover(cspop,s(f).pop,nc1,nspop,data,s(f).w);
   %mutation
   mspop=repmat(randsol,nm1,1);   
   mspop=mutation(mspop,s(f).pop,nm1,nspop,data,s(f).w); 
   %selection
    [mate1]=[s(f).pop;cspop;mspop];
    for t=1:nspop+nc1+nm1
         v(t)=mate1(t).value(3);
     end
    [sv,so]=sort(v);
    q1=mate1(so);
    fs(f).pop=q1(1:nspop);
    fs(f).nums=f;
    fs(f).w=s(f).w;
    end
end
%% second phase loop
best=repmat(randsol,maxiter2,1);
nc2=2*round((npop*pc)/2); 
nm2=round(npop*pm);
fpop=[fs(1).pop(1:end);fs(2).pop(1:end);fs(3).pop(1:end);fs(4).pop(1:end);...
    fs(5).pop(1:end);fs(6).pop(1:end);fs(7).pop(1:end);fs(8).pop(1:end);...
    fs(9).pop(1:end);fs(10).pop(1:end)];
wp=100;
pareto=repmat(randsol,wp,1);
for l=1:wp
        ww=unique(rand);
for a=1:npop
    fpop(a).w=ww;
    [u1,u2,u3]=fitness(fpop(a).position,data,fpop(a).w);
    fpop(a).value=[u1,u2,u3];
end
fp=repmat(randsol,npop,1);
for x=1:npop
fp(x).position=fpop(x).position;
fp(x).value=fpop(x).value;
end
for iter2=1:maxiter2
   %crossover
   cpop=repmat(randsol,nc2,1);
   cpop=crossover22(cpop,fp,nc2,npop,data,ww);
   %mutation
   mpop=repmat(randsol,nm2,1);   
   mpop=mutation2(mpop,fp,nm2,npop,data,ww); 
   %selection
   [mate2]=[fp;cpop;mpop];
   for o=1:npop+nc2+nm2
         h(o)=mate2(o).value(3);
   end
   [sv,so]=sort(h);
   q2=mate2(so);
   final=q2(1:npop);
   gpop=final(1);
%% results   
best(iter2).value=gpop.value;
best(iter2).position=gpop.position;
bst=best(maxiter2);
end
pareto(l)=bst;
f1(l)=pareto(l).value(1);
f2(l)=pareto(l).value(2);
disp(['l=' num2str(l)  ' w=' num2str(ww)  '  f1=' num2str(f1(l))  ' f2=' num2str(f2(l))  ' pareto=' num2str(pareto(l).value(3))])
end
disp([ ' Time = '  num2str(toc)])
figure(1)
plot(f1,f2,'-r*')
xlabel('f1')
ylabel('f2')
title('SPGA pareto fronte')