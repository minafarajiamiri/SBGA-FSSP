close all
clear
clc 

n=100; %number of jobs
m=10; %number of machine

for s=1:3
    if s==1 %processing with high speed
        v(s)=1.2;
    elseif s==2 %processing with normal speed
        v(s)=1;
    else %processing with low speed
        v(s)=0.8;
    end
end

e=zeros(m,s); %energu consumption of machine i on speed s
b1=e(:,1);
b2=e(:,2);
b3=e(:,3);
for i=1:m
b1(i)=1.2+0.3*rand;
b2(i)=0.9+0.3*rand;
b3(i)=0.6+0.3*rand;
end
e=[b1,b2,b3];

fi=0.5; %energy consumption while idle
u=1; %cost

save data